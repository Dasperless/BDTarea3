USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[InsertarMovimientoCOIntereses]    Script Date: 14/1/2021 17:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[InsertarMovimientoCOIntereses] 
	@inIdCuentaObjetivoInt INT,
	@inIdTipoMovObjInt INT,
	@inFechaInt DATE,
	@inMontoInt MONEY,
	@inNuevoIntAcumuladoInt MONEY,
	@OutMovimientoCOInteresesId INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	--Se declaran variables
	DECLARE 
			 @Fecha1 DATE
			,@Fecha2 DATE  
			,@Meses int = 0 
	--Verifica si no existe la cuenta objetivo
	IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[CuentaObjetivo]
		WHERE id = @inIdCuentaObjetivoInt
		)
		BEGIN
			SET @OutResultCode = 50017 --Codigo de retorno si la cuenta no existe.
			RETURN
		END;
	--Verifica si no existe el tipo de movimiento.
	IF NOT EXISTS(
			SELECT 1
			FROM [dbo].[TMovCuentaObjIntereses]
			WHERE id = @inIdTipoMovObjInt 
		)
		BEGIN
			SET @OutResultCode = 50018 --Codigo de retorno si el tipo de movimiento no existe
			RETURN;
		END;

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMovCuentaObj

		SET @Fecha1 = (
				SELECT FechaInicio
				FROM [dbo].CuentaObjetivo
				WHERE [dbo].CuentaObjetivo.id = @inIdCuentaObjetivoInt
				)
		SET @Fecha2 = (
				SELECT FechaFin
				FROM [dbo].CuentaObjetivo
				WHERE [dbo].CuentaObjetivo.id = @inIdCuentaObjetivoInt
				)
		SET @Meses = DATEDIFF(MONTH, @Fecha1, @Fecha2)
		SET @inMontoInt = (
				(
					(
						SELECT Saldo
						FROM [dbo].CuentaObjetivo
						WHERE id = @inIdCuentaObjetivoInt
						) * 0.5 * @Meses
					) / 100
				) / 365
		SET @inNuevoIntAcumuladoInt = @inMontoInt + (
				SELECT InteresesAcumulados
				FROM [dbo].CuentaObjetivo
				WHERE id = @inIdCuentaObjetivoInt
				)
		UPDATE [dbo].CuentaObjetivo
		SET InteresesAcumulados = @inNuevoIntAcumuladoInt
		WHERE id = @inIdCuentaObjetivoInt

		INSERT INTO [dbo].[MovCuentaObjIntereses] (
			IdCuentaObjetivo
			,IdTipoMovObj
			,Fecha
			,Monto
			,NuevoIntAcumulado
			)
		SELECT @inIdCuentaObjetivoInt
			,@inIdTipoMovObjInt
			,@inFechaInt
			,@inMontoInt
			,@inNuevoIntAcumuladoInt

		SET @OutMovimientoCOInteresesId = SCOPE_IDENTITY();
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


-- calcular interes diario 