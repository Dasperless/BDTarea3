USE [ProyectoBD1]
GO

/****** Object:  StoredProcedure [dbo].[Consulta1]    Script Date: 21/1/2021 20:27:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Consulta1] --Nombre del procedimiento
	@OutCuentasObjetivosIncompletasId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	--Se declaran variables
	DECLARE @cuentasObjetivosIncompletas TABLE (
		id INT IDENTITY(1, 1)
		,COId INT
		,CACodigo INT
		,descripción VARCHAR(100)
		,cantDepositosR INT
		,cantDepositosT INT
		,montoDebitadoReal MONEY
		,montoDebitadoTotal MONEY
		)
	DECLARE @varCOId INT
		,@varCACodigo INT
		,@vardescripción VARCHAR(100)
		,@varcantDepositosR INT
		,@varcantDepositosT INT
		,@varmontoDebitadoReal MONEY
		,@varmontoDebitadoTotal MONEY
	DECLARE @creditoEsperado MONEY
		,@meses INT
		,@fecha1 DATE
		,@fecha2 DATE
		,@lo INT
		,@hi INT

	SELECT @lo = MIN(id)
		,@hi = MAX(id)
	FROM dbo.MovCuentaObj

	----Validaciones
	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].CuentaObjetivo
			)
	BEGIN
		SET @OutResultCode = 5025 --Codigo de retorno si la cuenta no existe.

		RETURN
	END;

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TCuentasObjetivosIncompletas

		WHILE @lo <= @hi
		BEGIN
			SET @varCOId = (
					SELECT IdCuentaObjetivo
					FROM dbo.MovCuentaObj
					WHERE id = @lo
					)
			SET @varcantDepositosR = (
					SELECT COUNT(id)
					FROM dbo.MovCuentaObj
					WHERE IdCuentaObjetivo = @varCOId and IdTipoMovObj = 1
					)
			SET @vardescripción = (
					SELECT Objetivo
					FROM dbo.CuentaObjetivo
					WHERE id = @varCOId
					)
			SET @varCACodigo = (
					SELECT NumeroCuentaPrimaria
					FROM dbo.CuentaObjetivo
					WHERE id = @varCOId
					)
			SET @varmontoDebitadoReal = (
					SELECT MontoAhorro
					FROM dbo.CuentaObjetivo
					WHERE id = @varCOId
					) * @varcantDepositosR
			SET @fecha1 = (
					SELECT FechaInicio
					FROM dbo.CuentaObjetivo
					WHERE id = @varCOId
					)
			SET @fecha2 = (
					SELECT FechaFin
					FROM dbo.CuentaObjetivo
					WHERE id = @varCOId
					)
			SET @meses = DATEDIFF(MONTH, @fecha1, @fecha2)
			SET @varmontoDebitadoTotal = (
					SELECT MontoAhorro
					FROM dbo.CuentaObjetivo
					WHERE id = @varCOId
					) * @meses
			SET @varcantDepositosT = @meses

			IF (@varmontoDebitadoReal != @varmontoDebitadoTotal)
			BEGIN
				INSERT INTO @cuentasObjetivosIncompletas (
					COId
					,CACodigo
					,descripción
					,cantDepositosR
					,cantDepositosT
					,montoDebitadoReal
					,montoDebitadoTotal
					)
				VALUES (
					@varCOId
					,@varCACodigo
					,@vardescripción
					,@varcantDepositosR
					,@varcantDepositosT
					,@varmontoDebitadoReal
					,@varmontoDebitadoTotal
					)
			END;

			SET @lo = @lo + 1
		END;
		SELECT * FROM @cuentasObjetivosIncompletas

		SET @OutCuentasObjetivosIncompletasId = SCOPE_IDENTITY();
		SET @OutResultCode = 0;

		COMMIT TRANSACTION TCuentasObjetivosIncompletas;--Finaliza la transacción
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION TCuentasObjetivosIncompletas;

		INSERT INTO dbo.Errores --Tabla de Errores
		VALUES (
			SUSER_SNAME()
			,ERROR_NUMBER()
			,ERROR_STATE()
			,ERROR_SEVERITY()
			,ERROR_LINE()
			,ERROR_PROCEDURE()
			,ERROR_MESSAGE()
			,GETDATE()
			);

		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;