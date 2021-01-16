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
			@inIdTipoMovimientoCO INT,
			@inNuevoIntAcumuladoInt MONEY,
			@inIdTipoMovObjInt INT

	DECLARE	@OutMovimientoCuentaObjId INT, 
			@OutNuevoSaldo INT


	--SE LES ASIGNAN VALORES
	SELECT @MontoTotalIntereses = SUM(Monto)
	FROM [dbo].[MovCuentaObj]
	WHERE IdCuentaObjetivo = @inIdCuentaObjetivo

	SELECT @MontoTotalCuentaObjetivo = Saldo + @MontoTotalIntereses
	FROM [dbo].[CuentaObjetivo]
	WHERE id = @inIdCuentaObjetivo

	SET @inNuevoIntAcumuladoInt = 0
	SET @inIdTipoMovObjInt = 2 -- DEBITO POR REDENCION DE INTERESES

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

	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveRedCuentaObj
		--SE RETIRAN LOS INTERESES
		EXEC [dbo].[InsertarMovimientoCOIntereses]
			@inIdCuentaObjetivo, 
			@inIdTipoMovObjInt,
			@inFecha,
			@MontoTotalIntereses, 
			@inNuevoIntAcumuladoInt, 
			@OutMovimientoCuentaObjId OUTPUT, 
			@OutResultCode OUTPUT

		--SE DEPOSITAN LOS INTERESES EN LA CO
		EXEC [dbo].[InsertarMovimientoCuentaObjetivo]
			@inIdCuentaObjetivo, 
			2,									--DEPOSITO POR REDENCION DE INTERESES
			@inFecha, 
			@MontoTotalIntereses, 
			@OutMovimientoCuentaObjId OUTPUT, 
			@OutNuevoSaldo OUTPUT, 
			@OutResultCode OUTPUT

		--SE DEPOSITAN EL SALDO DE LA CO EN LA CUENTA
		EXEC [dbo].[InsertarMovimientoCuentaObjetivo]
			@inIdCuentaObjetivo, 
			3,									--REDENCION DE LA CO
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