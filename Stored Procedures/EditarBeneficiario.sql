USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[EditarBeneficiario] @inId INT = 0,
	@inNumeroCuenta INT = 0,
	@inValorDocumentoIdentidadBeneficiario INT = 0,
	@inParentezcoId INT = 0,
	@inPorcentaje INT = 0
	--
	,
	@outBeneficiarioId INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- se declaran variables
		DECLARE @inActivo BIT,
			@inFechaDesactivacion DATE

		-- se inicializan variables
		SELECT @inActivo = 1,
			@OutResultCode = 0;

		IF NOT EXISTS (
				SELECT 1
				FROM dbo.Persona P
				WHERE P.ValorDocIdentidad = @inValorDocumentoIdentidadBeneficiario
				)
			SET @OutResultCode = 5002 --El beneficiario no existe en la tabla persona

		IF NOT EXISTS (
				SELECT 1
				FROM dbo.Parentezco PA
				WHERE PA.id = @inParentezcoId
				)
			SET @OutResultCode = 5003 --El parentezco no existe

		IF (
				CONVERT(INT, (
						SELECT SUM(Porcentaje)
						FROM Beneficiarios
						WHERE NumeroCuenta = @inNumeroCuenta
							AND Activo = 1
							AND ValorDocumentoIdentidadBeneficiario != @inValorDocumentoIdentidadBeneficiario
						)) + @inPorcentaje
				) > 100
			SET @OutResultCode = 5007 --La suma es mayor al 100	
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TEditarB

		UPDATE Beneficiarios
		SET ValorDocumentoIdentidadBeneficiario = @inValorDocumentoIdentidadBeneficiario,
			ParentezcoId = @inParentezcoId,
			Porcentaje = @inPorcentaje,
			Activo = 1,
			FechaDesactivacion = NULL
		WHERE id = @inId

		SET @outBeneficiarioId = SCOPE_IDENTITY();--Retorna el ultimo id insertado 

		COMMIT TRANSACTION TEditarB;-- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0 -- chequeo que el errror sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TEditarB;-- asegura el Nada, deshace las actualizaciones previas al error

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