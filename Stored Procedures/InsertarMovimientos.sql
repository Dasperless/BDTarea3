USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE [dbo].[InsertarMovimientos]
	@inCuentaId INT,
	@inTipoMovimientoId INT,
	@inMonto MONEY,
	@inFecha DATE,
	@inDescripcion VARCHAR(200),
	@OutMovimientoId INT OUTPUT,
	@OutResultCode INT OUTPUT,
	@OutNuevoSaldo INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- SE DECLARAN VARIABLES
		DECLARE @nuevoSaldo MONEY			--Nuevo saldo.
		DECLARE @EstadoDeCuentaID INT		--Estado de cuenta.
		DECLARE @TipoMovimiento VARCHAR(20)	--Tipo de movimiento

		DECLARE @ComisionCH MONEY,			--Comision cajero humano (Tipo de cuenta)
				@ComisionCA MONEY,			--Comision cajero automatico (Tipo de cuenta)
				@NumRetirosCH INT,			--Numero de retiros cajero humano (Tipo de cuenta) 
				@NumRetirosCA INT,			--Numero de retiros cajero automatico (Tipo de cuenta)
				@NumRetirosCHEC INT,		--Contador de retiros cajero humano (Estado Cuenta)
				@NumRetirosCAEC INT			--Contador de retiros cajero automatico (Estado Cuenta)

		--OUTPUT SP MULTAS POR CA Y CH 
		DECLARE @OutMovimientoIdMov INT,
				@OutResultCodeMov INT,
				@OutNuevoSaldoMov INT


		--SE INICIALIZAN VARIABLES		
		SET @OutResultCode = 0	--Codigo de retorno.

		--OBTIENE EL ID DEL ESTADO DE CUENTA
		SELECT	@EstadoDeCuentaID = EC.id,
				@NumRetirosCAEC = EC.RetirosCA,
				@NumRetirosCHEC = EC.RetirosCH
		FROM EstadoCuenta
		INNER JOIN EstadoCuenta EC ON EC.CuentaAhorroid = @inCuentaId
		WHERE @inFecha BETWEEN EC.FechaInicio
				AND EC.FechaFin

		--NUMERO DE RETIROS Y COMISIONES DE CAJERO AUTOMATICO Y CAJERO HUMANO.
		SELECT	@ComisionCA = TC.ComisionAutomatico,
				@ComisionCH = TC.ComisionHumano,
				@NumRetirosCH = TC.NumRetirosHumano,
				@NumRetirosCA = Tc.NumRetirosAutomatico
		FROM  [dbo].[CuentaAhorro] C
		INNER JOIN TipoCuentaAhorro TC ON C.TipoCuentaId = TC.id
		WHERE C.id = @inCuentaId

	
		--SE OBTIENE EL NOMBRE DEL TIPO DE MOVIMIENTO
		SELECT	@TipoMovimiento = TipoOperacion
		FROM TipoMovimientoCuentaAhorro TM
		WHERE TM.id = @inTipoMovimientoId

		-- VERIFICA SI LA CUENTA EXISTE.
		IF NOT EXISTS (
				SELECT 1
				FROM dbo.CuentaAhorro C
				WHERE C.iD = @inCuentaId
				)
		BEGIN
			SET @OutResultCode = 50001;-- Cuenta no existe

			RETURN
		END;

		-- VERIFICA SI NO EXISTE EL TIPO DE MOVIMIENTO.
		IF NOT EXISTS (
				SELECT 1
				FROM dbo.TipoMovimientoCuentaAhorro M
				WHERE M.ID = @inTipoMovimientoId
				)
		BEGIN
			SET @OutResultCode = 50002;-- Tipo de movimiento no existe

			RETURN
		END;

		--CALCULA EL NUEVO SALDO DEPENDIENDO DEL TIPO DE MOVIMIENTO.
		SELECT @nuevoSaldo = (
				CASE 
					WHEN @TipoMovimiento = 'Credito'
						THEN CA.Saldo + @inMoNTO
					ELSE CA.Saldo - @inMonto
					END
				)
		FROM dbo.CuentaAhorro CA
		WHERE CA.Id = @inCuentaId;

		--VERIFICA SI HAY UN RETIRO POR CAJERO AUTOMATICO Y VERIFICA SI SE APLICA MULTA
		IF(@inTipoMovimientoId = 2)
			BEGIN
				SET @NumRetirosCAEC = @NumRetirosCAEC + 1

				UPDATE [dbo].[EstadoCuenta]
				SET RetirosCA = @NumRetirosCAEC
				WHERE id =  @EstadoDeCuentaID	

				--SE APLICA LA MULTA
				IF(@NumRetirosCAEC >  @NumRetirosCA)
					BEGIN
						EXEC	[dbo].[InsertarMovimientos]
								@inCuentaId, 
								9, 
								@ComisionCA, 
								@inFecha, 
								'Comision exceso de operacion en CA', 
								@OutMovimientoIdMov OUTPUT, 
								@OutResultCodeMov OUTPUT,
								@OutNuevoSaldoMov OUTPUT
					END				
			END;

		--VERIFICA SI HAY UN RETIRO POR CAJERO HUMANO Y VERIFICA SI SE APLICA MULTA
		IF(@inTipoMovimientoId = 3)
			BEGIN 
				SET @NumRetirosCHEC = @NumRetirosCHEC + 1

				UPDATE [dbo].[EstadoCuenta]
				SET RetirosCH = @NumRetirosCHEC
				WHERE id =  @EstadoDeCuentaID

				--SE APLICA LA MULTA
				IF(@NumRetirosCHEC >  @NumRetirosCH)
					BEGIN
						EXEC	[dbo].[InsertarMovimientos]
								@inCuentaId, 
								8, 
								@ComisionCH, 
								@inFecha, 
								'Comision exceso de operacion en CH', 
								@OutMovimientoIdMov OUTPUT, 
								@OutResultCodeMov OUTPUT,
								@OutNuevoSaldoMov OUTPUT
					END

			END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMov

			--SE INSERTA EL MOVIMIENTO EN LA CUENTA DE AHORRO.
			INSERT INTO MovimientoCuentaAhorro (
				Fecha,
				Monto,
				NuevoSaldo,
				EstadoCuentaid,
				TipoMovimientoCuentaAhorroid,
				CuentaAhorroid,
				Descripcion
				)
			VALUES (
				@inFecha,
				@inMonto,
				@NuevoSaldo,
				@EstadoDeCuentaID,
				@inTipoMovimientoId,
				@inCuentaId,
				@inDescripcion
				)


			--SE ACTUALIZA EL CREDITO EN LA CUENTA DE AHORRO
			UPDATE dbo.CuentaAhorro
			SET Saldo = @nuevoSaldo
			WHERE Id = @inCuentaId

			SET @outMovimientoId = SCOPE_IDENTITY();
			SET @OutNuevoSaldo = @nuevoSaldo

		COMMIT TRANSACTION TSaveMov;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION TSaveMov;

		INSERT INTO dbo.Errores
		VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			);

		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;