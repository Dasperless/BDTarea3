USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarCuentaAhorro] @inPersonaId INT,
	@inTipoCuentaId INT,
	@inNumeroCuenta INT,
	@inFechaCreacion DATE,
	@OutMovimientoId INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		--Se declaran las variables 
		DECLARE @Saldo MONEY

		--Se inicializan variables
		SELECT @OutResultCode = 0

		SELECT @Saldo = 0

		-- Verifica si no existe la persona
		IF NOT EXISTS (
				SELECT 1
				FROM dbo.Persona P
				WHERE P.id = @inPersonaId
				)
		BEGIN
			SET @OutResultCode = 50013;--No existe la persona

			RETURN
		END;
		
		--Verfica si no existe el tipo de cuenta.
		IF EXISTS (
				SELECT 1
				FROM dbo.TipoCuentaAhorro TC
				WHERE TC.id = @inTipoCuentaId
				)
		BEGIN
			SET @OutResultCode = 50014;--No existe el tipo de cuenta

			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveCuen

		INSERT INTO CuentaAhorro (
			Personaid,
			TipoCuentaId,
			NumeroCuenta,
			FechaCreacion,
			Saldo
			)
		VALUES (
			@inPersonaId,
			@inTipoCuentaId,
			@inNumeroCuenta,
			@inFechaCreacion,
			@Saldo
			)

		SET @outMovimientoId = SCOPE_IDENTITY();

		COMMIT TRANSACTION TSaveCuen;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION TSaveCuen;

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