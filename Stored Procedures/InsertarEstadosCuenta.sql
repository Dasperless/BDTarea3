USE [ProyectoBD1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo] 
	@inCuentaAhorroId INT
	,@inNumeroCuenta INT
	,@inFechaInicio DATE
	,@inSaldoInicial MONEY
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		--Se declaran las variables 
		DECLARE @SaldoFinal MONEY
		DECLARE @FechaFin DATE

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @SaldoFinal = 0
		SELECT @FechaFin = DATEADD(DAY, -1,DATEADD(MONTH, 1, @inFechaInicio))

		-- Validacion de paramentros de entrada
		IF NOT EXISTS (SELECT 1 FROM dbo.CuentaAhorro C WHERE C.id = @inCuentaAhorroId)
			BEGIN
				SET @OutResultCode = 50001;	--No existe la cuenta
				RETURN
			END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveEst
			INSERT INTO EstadoCuenta(
					CuentaAhorroid
					,NumeroCuenta
					,FechaInicio
					,FechaFin
					,SaldoInicial
					,SaldoFinal
				)
			VALUES (
				@inCuentaAhorroId
				,@inNumeroCuenta
				,@inFechaInicio
				,@FechaFin
				,@inSaldoInicial
				,@SaldoFinal
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSaveEst;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSaveEst;	-- Asegura el Nada, deshace las actualizaciones previas al error

			INSERT INTO dbo.Errores
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
