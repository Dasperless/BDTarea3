USE [ProyectoBD1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarPersonas] 
	@inNombre VARCHAR(100)
	,@inValorDocIdentidad INT
	,@inEmail VARCHAR(100)
	,@inFechaNacimiento DATE
	,@inTelefono1 INT
	,@inTelefono2 INT
	,@inTipoDocIdentidadId int
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		--Se declaran las variables 
		DECLARE @UsuarioID INT

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @UsuarioID = U.id FROM Usuario INNER JOIN Usuario U ON U.ValorDocIdentidad = @inValorDocIdentidad

		-- Validacion de paramentros de entrada
		IF EXISTS (SELECT 1 FROM dbo.Persona P WHERE P.ValorDocIdentidad = @inValorDocIdentidad)
		BEGIN
			SET @OutResultCode = 50006;-- La persona ya existe
			RETURN
		END;

		IF NOT EXISTS (SELECT 1 FROM dbo.TipoDocIdentidad TD WHERE TD.ID = @inTipoDocIdentidadId)
		BEGIN
			SET @OutResultCode = 50007;-- tipo de movimiento no existe
			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSavePer
			INSERT INTO Persona(
					Nombre
					,ValorDocIdentidad
					,Email
					,FechaNacimiento
					,Telefono1
					,Telefono2
					,TipoDocIdentidadid
					,Usuarioid
				)
			VALUES (
				@inNombre
				,@inValorDocIdentidad
				,@inEmail
				,@inFechaNacimiento
				,@inTelefono1
				,@inTelefono2
				,@inTipoDocIdentidadId
				,@UsuarioID
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSavePer;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSavePer;	-- Asegura el Nada, deshace las actualizaciones previas al error

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
