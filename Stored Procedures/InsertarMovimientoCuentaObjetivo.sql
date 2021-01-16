USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[InsertarMovimientoCuentaObjetivo]    Script Date: 1/8/2021 2:54:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[InsertarMovimientoCuentaObjetivo] 
	@inIdCuentaObjetivo INT,
	@inIdTipoMovimientoCO INT,
	@inFecha DATE,
	@inMonto MONEY,
	@OutMovimientoCuentaObjId INT OUTPUT,
	@OutNuevoSaldo INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	--SE DECLARAN VARIABLES
	DECLARE @SaldoActualCuentaObjetivo MONEY,
			@NuevoSaldoCuentaObjetivo MONEY,
			@SaldoCuenta MONEY,
			@IdCuenta INT,
			@IdTipoMovimiento INT

	DECLARE @TipoMovimientoId INT,
			@Descripcion VARCHAR(50),
			@OutMovimientoIdIM INT, 
			@OutResultCodeIM INT, 
			@OutNuevoSaldoIM INT


	--SE LES ASIGNAN VALORES
	SELECT @SaldoActualCuentaObjetivo = CO.Saldo,
		@IdCuenta = C.id,
		@SaldoCuenta = C.Saldo
	FROM [dbo].[CuentaObjetivo] CO
	INNER JOIN [dbo].[CuentaAhorro] C
		ON C.NumeroCuenta = Co.NumeroCuentaPrimaria
	WHERE CO.id = @inIdCuentaObjetivo

	SELECT @NuevoSaldoCuentaObjetivo = (
			CASE 
				WHEN @inIdTipoMovimientoCO = 1
					OR @inIdTipoMovimientoCO = 2
					THEN @SaldoActualCuentaObjetivo + @inMonto
				ELSE @SaldoActualCuentaObjetivo - @inMonto
				END
			)

	SELECT @TipoMovimientoId = (
			CASE 
				WHEN @inIdTipoMovimientoCO = 1 --DEPOSITO POR AHORRO
					THEN 10
				WHEN @inIdTipoMovimientoCO = 3 --REDENCION DE LA CO
					THEN 11
				END
			)

	SELECT @Descripcion =  Descripcion
	FROM [dbo].[TMovCuentaObj]
	WHERE id  = @inIdTipoMovimientoCO

	--VERIFICA SI NO EXISTE LA CUENTA OBJETIVO
	IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[CuentaObjetivo]
		WHERE id = @inIdCuentaObjetivo
		)
		BEGIN
			SET @OutResultCode = 50017 --CODIGO DE RETORNO SI LA CUENTA NO EXISTE.
			RETURN
		END;

	--VERIFICA SI NO EXISTE EL TIPO DE MOVIMIENTO.
	IF NOT EXISTS(
			SELECT 1
			FROM [dbo].[TMovCuentaObj]
			WHERE id = @inIdTipoMovimientoCO
		)
		BEGIN
			SET @OutResultCode = 50018 --CODIGO DE RETORNO SI EL TIPO DE MOVIMIENTO NO EXISTE
			RETURN;
		END;

	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMovCuentaObj

		--SI EL MOVIMIENTO NO ES UN DEPÓSITO POR REDENCIÓN DE INTERESES SE REALIZA EL DEBITO O CREDITO EN LA CUENTA
		IF(@inIdTipoMovimientoCO != 3) 
			BEGIN
				EXEC [dbo].[InsertarMovimientos]
					@IdCuenta, 
					@TipoMovimientoId, 
					@inMonto, 
					@inFecha, 
					@Descripcion,
					@OutMovimientoIdIM OUTPUT, 
					@OutResultCodeIM OUTPUT, 
					@OutNuevoSaldoIM OUTPUT
			END;

		--SE INSERTA EL MOVIMIENTO DE LA CUENTA OBJETIVO SI EL SALDO NO ES NEGATIVO
		IF (@SaldoCuenta - @inMonto < 0)
			BEGIN

			INSERT INTO [dbo].[MovCuentaObj] (
				IdCuentaObjetivo,
				IdTipoMovObj,
				Fecha,
				Monto,
				NuevoSaldo
				)
			SELECT @inIdCuentaObjetivo,
				@inIdTipoMovimientoCO,
				@inFecha,
				@inMonto,
				@NuevoSaldoCuentaObjetivo
			

			--ACTUALIZA EL SALDO DE LA CUENTA OBJETIVO.
			UPDATE [dbo].[CuentaObjetivo]
			SET Saldo = @NuevoSaldoCuentaObjetivo
			WHERE id = @inIdCuentaObjetivo

			END;

		SET @OutMovimientoCuentaObjId = SCOPE_IDENTITY();
		SET @OutNuevoSaldo = @NuevoSaldoCuentaObjetivo;
		SET @OutResultCode = 0;

		COMMIT TRANSACTION TSaveMovCuentaObj;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION TSaveMovCuentaObj;

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