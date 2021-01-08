USE [ProyectoBD1]
GO

/****** Object:  Trigger [dbo].[PrimerEstadoCuenta]    Script Date: 1/7/2021 2:55:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[PrimerDebitoCuentaObjetivo] 
ON [dbo].[CuentaObjetivo]
AFTER INSERT
AS
IF (ROWCOUNT_BIG() = 0) --Evita que el trigger se inicie si no se hizo ningun cambio.
	RETURN;

BEGIN
	SET NOCOUNT ON;

	--Se declaran variables
	DECLARE @IdUltimaCOInsertada INT,
			@NumCuentaPrimaria INT,
			@Costo MONEY

	--Se asignan valores a las variables.
	SELECT @IdUltimaCOInsertada = MAX(ID)
	FROM [dbo].[CuentaObjetivo]

	SELECT @Costo = Costo,
		@NumCuentaPrimaria = NumeroCuentaPrimaria
	FROM [dbo].[CuentaObjetivo]
	WHERE id = @IdUltimaCOInsertada

	--Se le resta el saldo a la cuenta
	UPDATE [dbo].[CuentaAhorro]
	SET Saldo = Saldo - @Costo
	WHERE NumeroCuenta = @NumCuentaPrimaria


	--[NOTA]: ES provisional, se necesita un store procedure
	UPDATE [dbo].[CuentaObjetivo]
	SET Saldo = Saldo + @Costo
	WHERE id = @IdUltimaCOInsertada

	SET NOCOUNT OFF;
END