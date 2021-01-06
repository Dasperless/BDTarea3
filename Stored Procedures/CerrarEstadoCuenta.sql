USE [ProyectoBD1]
GO

/****** Object:  StoredProcedure [dbo].[InsertarMovimientos]    Script Date: 12/1/2020 2:43:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CerrarEstadoCuenta] @inEstadoCuentaId INT,
	@OutMovimientoId INT OUTPUT,
	@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- Se declaran variables
		DECLARE @SaldoFinal MONEY = 0			--Saldo final de la cuenta.
		DECLARE @CuentaAhorroId INT,			--Id cuenta ahorros.
				@MultaSaldoMin MONEY,			--Multa por el saldo minimo.
				@SaldoMinEC MONEY,				--Saldo minimo en la cuenta.
				@Interes MONEY,					--Intereses.
				@SaldoMinTC MONEY,				--Saldo minimo tipo de cuenta de ahorro.
				@FechaMov DATE,					--Fecha del movimiento al cerrar el estado de cuenta
				@OutMovimientoIdMov INT,		--Output del id del movimiento del SP de Insertar Movimiento
				@OutResultCodeMov INT,			--Output codigo de retorno del SP de insertar movimiento.
				@OutNuevoSaldoMov INT			--Output Nuevo saldo del SP insertar movimiento.

		--Se guarda en las variables los valores relacionados con el estado de cuenta.
		SELECT	@CuentaAhorroId = C.id,
				@MultaSaldoMin = TC.MultaSaldoMin,
				@Interes = TC.Interes,
				@SaldoFinal = C.Saldo,
				@FechaMov = EC.FechaFin,
				@SaldoMinTC = TC.SaldoMinimo
		FROM [dbo].[EstadoCuenta] EC
		INNER JOIN [dbo].[CuentaAhorro] C ON C.id = EC.CuentaAhorroid
		INNER JOIN [dbo].[TipoCuentaAhorro] TC ON TC.id = C.TipoCuentaId
		WHERE EC.id = @inEstadoCuentaId

		--Se obtiene el saldo minimo 
		SELECT @SaldoMinEC = (
				CASE 
					WHEN MIN(NuevoSaldo) IS NULL
						THEN @SaldoFinal
					ELSE MIN(NuevoSaldo)
					END
				)
		FROM MovimientoCuentaAhorro
		WHERE EstadoCuentaid = @inEstadoCuentaId

		--Valida si la cuenta no existe
		IF NOT EXISTS (
				SELECT 1
				FROM [dbo].[CuentaAhorro]
				WHERE id = @CuentaAhorroId
				)
			BEGIN
				SET @OutResultCode = 50017 --Codigo de retorno si la cuenta no existe.

				RETURN
			END;
		
		--Calcular los intereses 
		IF(@SaldoMinEC > @SaldoMinTC )
			BEGIN
				DECLARE @InteresCalculado MONEY = [dbo].[CalcularInteres](@SaldoFinal, @Interes)
				EXEC [dbo].[InsertarMovimientos]
						@CuentaAhorroId, 
						7, 
						@InteresCalculado, 
						@FechaMov, 
						'Intereses del mes sobre saldo MInimo',
						@OutMovimientoIdMov OUTPUT, 
						@OutResultCodeMov OUTPUT,
						@OutNuevoSaldoMov OUTPUT
			END;
		IF(@SaldoMinEC < @SaldoMinTC AND (@SaldoFinal - @MultaSaldoMin) > 0)
			BEGIN
				EXEC [dbo].[InsertarMovimientos]
						@CuentaAhorroId, 
						10, 
						@MultaSaldoMin, 
						@FechaMov, 
						'Multa por incuplimiento saldo minimo',
						@OutMovimientoIdMov OUTPUT, 
						@OutResultCodeMov OUTPUT,
						@OutNuevoSaldoMov OUTPUT
			END;
		SET @SaldoFinal = @OutNuevoSaldoMov	--Se modifica el saldo final si hay multa o intereses

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveCerrEst

		--Se actualiza El saldo final y el saldo minimo.
		UPDATE [dbo].[EstadoCuenta]
		SET SaldoMinimo = @SaldoMinEC,
			SaldoFinal = @SaldoFinal
		WHERE Id = @inEstadoCuentaId

		SET @outMovimientoId = SCOPE_IDENTITY();
		SET @OutResultCode = 0;

		COMMIT TRANSACTION TSaveCerrEst;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION TSaveCerrEst;

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