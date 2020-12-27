USE [ProyectoBD1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarBeneficiarios] 
	@inPersonaId INT
	,@inCuentaAhorroId INT
	,@inNumeroCuenta INT
	,@inValorDocumentoIdentidadBeneficiario INT
	,@inParentezcoId INT
	,@inPorcentaje INT
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		--Se declaran las variables 
		DECLARE @Activo BIT, @FechaDesactivacion DATE

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @FechaDesactivacion = NULL
		SELECT @Activo = 1

		-- Validacion de paramentros de entrada
		IF NOT EXISTS (SELECT 1 FROM dbo.Parentezco P WHERE P.id = @inParentezcoId)
		BEGIN
			SET @OutResultCode = 50008;	--No existe el tipo parentezco
			RETURN
		END;

		IF  EXISTS (SELECT 1 FROM dbo.Beneficiarios B WHERE B.Personaid = @inPersonaId AND B.CuentaAhorroid = @inCuentaAhorroId)
		BEGIN
			SET @OutResultCode = 50009;-- Ya existe el beneficiario
			RETURN
		END;

		IF (SELECT COUNT(*) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1) >= 3
		BEGIN
			SET @OutResultCode = 50010;	--Posee más de 3 beneficiarios
			RETURN
		END;

		IF (CONVERT(INT,(SELECT SUM(Porcentaje) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1))+@inPorcentaje)>100
		BEGIN
			SET @OutResultCode = 50011; --La suma de los porcentajes es mayor al 100	
			RETURN
		END;

		IF NOT EXISTS (SELECT 1 FROM CuentaAhorro WHERE id = @inCuentaAhorroId)
		BEGIN
			SET @OutResultCode = 50012; --La cuenta no existe
			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveBen
			INSERT INTO Beneficiarios(
					Personaid
					,CuentaAhorroid
					,NumeroCuenta
					,ValorDocumentoIdentidadBeneficiario
					,ParentezcoId
					,Porcentaje
					,Activo
					,FechaDesactivacion
				)
			VALUES (
				@inPersonaId
				,@inCuentaAhorroId
				,@inNumeroCuenta
				,@inValorDocumentoIdentidadBeneficiario
				,@inParentezcoId
				,@inPorcentaje
				,@Activo
				,@FechaDesactivacion
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSaveBen;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSaveBen;	-- Asegura el Nada, deshace las actualizaciones previas al error

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
