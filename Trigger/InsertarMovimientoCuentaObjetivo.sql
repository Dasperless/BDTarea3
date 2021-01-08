USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[CerrarEstadoCuenta]    Script Date: 1/7/2021 4:32:14 PM ******/
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
			@IdCuenta INT

	--Se les asignan valores
	SELECT @SaldoActualCuentaObjetivo = CO.Saldo,
		@IdCuenta = C.id,
		@SaldoCuenta = C.Saldo
	FROM [dbo].[CuentaObjetivo] CO
	INNER JOIN [dbo].[CuentaAhorro] C
	ON C.NumeroCuenta = Co.NumeroCuentaPrimaria
	WHERE CO.id = @inIdCuentaObjetivo

	SELECT @NuevoSaldoCuentaObjetivo = (	CASE 
											WHEN @inIdTipoMovimientoCO = 1 OR @inIdTipoMovimientoCO = 2
											THEN @SaldoActualCuentaObjetivo + @inMonto
											ELSE @SaldoActualCuentaObjetivo - @inMonto
											END
										)

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
			FROM [dbo].[TMovCuentaObjIntereses]
			WHERE id = @inIdTipoMovimientoCO
		)
		BEGIN
			SET @OutResultCode = 50018 --Codigo de retorno si el tipo de movimiento no existe
		END;

	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMovCuentaObj

		INSERT INTO [dbo].[MovCuentaObj](
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
		
		--Actualiza el saldo en la cuenta.
		UPDATE [dbo].[CuentaAhorro]
		SET Saldo = (	CASE 
						WHEN @inIdTipoMovimientoCO = 1 OR @inIdTipoMovimientoCO = 2
						THEN @SaldoCuenta - @inMonto
						ELSE @SaldoCuenta + @inMonto
						END
					)
		WHERE id = @IdCuenta

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