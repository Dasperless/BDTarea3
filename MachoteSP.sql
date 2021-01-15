USE [NombreBD] --Colocar Nombre de la Base de Datos 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[NombreSP] --Nombre del procedimiento
	@inVariables INT,   --Variables de entrada del SP
	@OutId INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	--Se declaran variables
	DECLARE 
			 @variablesLogica1 DATE  
			,@variablesLogica2 DATE  
	--Validaciones
	IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[tabla]
		WHERE id = @inid
		)
		BEGIN
			SET @OutResultCode = 50017 --Codigo de retorno si la cuenta no existe.
			RETURN
		END;

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION nombreDeLatransaccion

		--Logica del SP
		-- ....
		-- ....
		-- ....

		SET @OutId = SCOPE_IDENTITY();
		SET @OutResultCode = 0;

		COMMIT TRANSACTION nombreDeLatransaccion; --Finaliza la transacción
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION nombreDeLatransaccion;

		INSERT INTO dbo.Errores    --Tabla de Errores
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