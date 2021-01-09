USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[InsertarMovimientoCuentaObjetivo]    Script Date: 1/8/2021 2:54:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[RedimirCuentaObjetivo] 
	@inIdCuentaObjetivo INT,
	@inFecha DATE,
	@OutRedimirCuentaObjetivoId INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	--Se declaran variables
	DECLARE @MontoTotalIntereses MONEY,
			@MontoTotalCuentaObjetivo MONEY,
			@inIdTipoMovimientoCO INT

	DECLARE	@OutMovimientoCuentaObjId INT, 
			@OutNuevoSaldo INT


	--Se les asignan valores
	SELECT @MontoTotalIntereses = SUM(Monto)
	FROM [dbo].[MovCuentaObj]
	WHERE IdCuentaObjetivo = @inIdCuentaObjetivo

	SELECT @MontoTotalCuentaObjetivo = Saldo + @MontoTotalIntereses
	FROM [dbo].[CuentaObjetivo]
	WHERE id = @inIdCuentaObjetivo

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

	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveRedCuentaObj

		--Se depositan los intereses en la CO
		EXEC [dbo].[InsertarMovimientoCuentaObjetivo]
			@inIdCuentaObjetivo, 
			2,									--Deposito por redencion de intereses
			@inFecha, 
			@MontoTotalIntereses, 
			@OutMovimientoCuentaObjId OUTPUT, 
			@OutNuevoSaldo OUTPUT, 
			@OutResultCode OUTPUT

		--Se depositan el saldo de la CO en la Cuenta
		EXEC [dbo].[InsertarMovimientoCuentaObjetivo]
			@inIdCuentaObjetivo, 
			3,									--Redencion de la CO"
			@inFecha, 
			@MontoTotalCuentaObjetivo, 
			@OutMovimientoCuentaObjId OUTPUT, 
			@OutNuevoSaldo OUTPUT, 
			@OutResultCode OUTPUT

		UPDATE [dbo].[CuentaObjetivo]
		SET Estado = 0
		WHERE id = @inIdCuentaObjetivo

		COMMIT TRANSACTION TSaveRedCuentaObj;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION TSaveRedCuentaObj;

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