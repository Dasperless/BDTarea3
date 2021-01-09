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
	--Se declaran variables
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


	--Se les asignan valores
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
				WHEN @inIdTipoMovimientoCO = 1 --Deposito por ahorro
					THEN 10
				WHEN @inIdTipoMovimientoCO = 3 --Redencion de la CO
					THEN 11
				END
			)

	SELECT @Descripcion =  Descripcion
	FROM [dbo].[TMovCuentaObj]
	WHERE id  = @inIdTipoMovimientoCO

	--Verifica si no existe la cuenta objetivo
	IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[CuentaObjetivo]
		WHERE id = @inIdCuentaObjetivo
		)
		BEGIN
			SET @OutResultCode = 50017 --Codigo de retorno si la cuenta no existe.
			RETURN
		END;

	--Verifica si no existe el tipo de movimiento.
	IF NOT EXISTS(
			SELECT 1
			FROM [dbo].[TMovCuentaObj]
			WHERE id = @inIdTipoMovimientoCO
		)
		BEGIN
			SET @OutResultCode = 50018 --Codigo de retorno si el tipo de movimiento no existe
			RETURN;
		END;

	--Verifica si tiene saldo suficiente
	IF (@SaldoCuenta - @inMonto < 0)
		BEGIN
			SET @OutResultCode = 50019 --La cuenta no tiene saldo suficiente.
			RETURN;
		END;
	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMovCuentaObj

		--Si el movimiento no es un depósito por redención de intereses se realiza el debito o credito en la Cuenta
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

		--Se inserta el movimiento de la cuenta objetivo
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

		--Actualiza el saldo de la cuenta objetivo.
		UPDATE [dbo].[CuentaObjetivo]
		SET Saldo = @NuevoSaldoCuentaObjetivo
		WHERE id = @inIdCuentaObjetivo

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