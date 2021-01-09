USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[InsertarMovimientoCuentaObjetivo]    Script Date: 1/8/2021 2:54:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [dbo].[InsertarMovimientoCOIntereses] 
	@inIdCuentaObjetivoIntereses INT,
	@inIdTipoMovimientoCOIntereses INT,
	@inFecha DATE,
	@inMonto MONEY,
	@OutMovimientoCOInteresesId INT OUTPUT,
	@OutNuevoSaldoCOIntereses INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	--Se declaran variables
	DECLARE @NuevoSaldoCuentaObjetivoIntereses MONEY  = 0 --[NOTA] : Provicional por divergencia.

	--Verifica si no existe la cuenta objetivo
	IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[CuentaObjetivo]
		WHERE id = @inIdCuentaObjetivoIntereses
		)
		BEGIN
			SET @OutResultCode = 50017 --Codigo de retorno si la cuenta no existe.
			RETURN
		END;

	--Verifica si no existe el tipo de movimiento.
	IF NOT EXISTS(
			SELECT 1
			FROM [dbo].[TMovCuentaObjIntereses]
			WHERE id = @inIdTipoMovimientoCOIntereses
		)
		BEGIN
			SET @OutResultCode = 50018 --Codigo de retorno si el tipo de movimiento no existe
			RETURN;
		END;

	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMovCuentaObj

		INSERT INTO [dbo].[MovCuentaObjIntereses] (
			IdCuentaObjetivo,
			IdTipoMovObj,
			Fecha,
			Monto,
			NuevoIntAcumulado
			)
		SELECT @inIdCuentaObjetivoIntereses,
			@inIdTipoMovimientoCOIntereses,
			@inFecha,
			@inMonto,
			@NuevoSaldoCuentaObjetivoIntereses

		SET @OutMovimientoCOInteresesId = SCOPE_IDENTITY();
		SET @OutNuevoSaldoCOIntereses = @NuevoSaldoCuentaObjetivoIntereses;
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