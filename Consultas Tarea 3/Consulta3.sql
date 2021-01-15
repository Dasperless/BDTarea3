USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE [dbo].[Consulta3] -- Lista Beneficiarios si los ahorrantes Mueren   
	@OutListadoBeneficiariosId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	--Se declaran variables
	DECLARE @listadoBeneficiarios TABLE (
		id INT IDENTITY(1, 1)
		,BeneficiarioId INT
		,ValorDocIdentidad INT
		,CreditoRecibido MONEY
		,CreditoTotalRecibido MONEY
		,MayorAporte INT
		,--Aqui nos referimos al numero de cuenta que aporto más dinero entre todos los ahorrantes
		CantidadDeAportes INT
		)
	DECLARE @inBeneficiarioId INT
		,@inValorDocIdentidad INT
		,@inCreditoRecibido MONEY
		,@inCreditoTotalRecibido MONEY
		,@inMayorAporte INT
		,@inCantidadDeAportes INT
	DECLARE @lo INT
		,@hi INT

	SELECT @lo = MIN(id)
		,@hi = MAX(id)
	FROM dbo.Beneficiarios

	--Validaciones
	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[Beneficiarios]
			)
	BEGIN
		SET @OutResultCode = 50017 --No hay beneficiarios 
		RETURN
	END;

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION transaccionListadoBeneficiario

		WHILE @lo <= @hi
		BEGIN
			IF (
					(
						SELECT Activo
						FROM dbo.Beneficiarios
						WHERE id = @lo
						) = 1
					) --Validacion: Revisa que el beneficiario no este eliminado 
			BEGIN
				SET @inBeneficiarioId = @lo --id del beneficiario
				SET @inValorDocIdentidad = (
						SELECT ValorDocumentoIdentidadBeneficiario
						FROM dbo.Beneficiarios
						WHERE id = @lo
						)
				SET @inCreditoRecibido = (
						(
							SELECT Saldo
							FROM dbo.CuentaAhorro
							WHERE id = (
									SELECT CuentaAhorroid
									FROM dbo.Beneficiarios
									WHERE id = @lo
									)
							) * (
							SELECT Porcentaje
							FROM dbo.Beneficiarios
							WHERE id = @lo
							)
						) / 100
				SET @inCreditoTotalRecibido = 0
				SET @inMayorAporte = - 1
				SET @inCantidadDeAportes = 0

				INSERT INTO @listadoBeneficiarios (
					BeneficiarioId
					,ValorDocIdentidad
					,CreditoRecibido
					,CreditoTotalRecibido
					,MayorAporte
					,CantidadDeAportes
					)
				VALUES (
					@inBeneficiarioId
					,@inValorDocIdentidad
					,@inCreditoRecibido
					,@inCreditoTotalRecibido
					,@inMayorAporte
					,@inCantidadDeAportes
					)
			END;

			SET @lo = @lo + 1
		END;

		SELECT @lo = MIN(id)
		FROM dbo.Beneficiarios

		WHILE @lo <= @hi
		BEGIN
			IF (
					(
						SELECT Activo
						FROM dbo.Beneficiarios
						WHERE id = @lo
						) = 1
					) --Validacion: Revisa que el beneficiario no este eliminado 
			BEGIN
				SET @inCreditoTotalRecibido = (
						SELECT SUM(CreditoRecibido)
						FROM @listadoBeneficiarios
						WHERE ValorDocIdentidad = (
								SELECT ValorDocIdentidad
								FROM @listadoBeneficiarios
								WHERE BeneficiarioId = @lo
								)
						)
				SET @inMayorAporte = (
						SELECT NumeroCuenta
						FROM dbo.Beneficiarios
						WHERE id = (
								SELECT BeneficiarioId
								FROM @listadoBeneficiarios
								WHERE CreditoRecibido = (
										SELECT TOP 1 MAX(CreditoRecibido)
										FROM @listadoBeneficiarios
										WHERE ValorDocIdentidad = (
												SELECT ValorDocIdentidad
												FROM @listadoBeneficiarios
												WHERE BeneficiarioId = @lo
												)
										)
								)
						)
				SET @inCantidadDeAportes = (
						SELECT COUNT(ValorDocIdentidad)
						FROM @listadoBeneficiarios
						WHERE ValorDocIdentidad = (
								SELECT ValorDocIdentidad
								FROM @listadoBeneficiarios
								WHERE BeneficiarioId = @lo
								)
						)

				UPDATE @listadoBeneficiarios
				SET CreditoTotalRecibido = @inCreditoTotalRecibido
					,MayorAporte = @inMayorAporte
					,CantidadDeAportes = @inCantidadDeAportes
				WHERE BeneficiarioId = @lo
			END;

			SET @lo = @lo + 1
		END;
		SELECT * FROM @listadoBeneficiarios
		SET @OutListadoBeneficiariosId = SCOPE_IDENTITY();
		SET @OutResultCode = 0;

		COMMIT TRANSACTION transaccionListadoBeneficiario;--Finaliza la transacción
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION transaccionListadoBeneficiario;

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