USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[PrimerEstadoCuenta] ON [dbo].[CuentaAhorro]
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO EstadoCuenta (
		CuentaAhorroid,
		NumeroCuenta,
		FechaInicio,
		FechaFin,
		SaldoInicial,
		SaldoFinal,
		SaldoMinimo,
		RetirosCH,
		RetirosCA
		)
	SELECT C.id,
		C.NumeroCuenta,
		C.FechaCreacion,
		DATEADD(DAY, - 1, DATEADD(MONTH, 1, FechaCreacion)),
		C.Saldo,
		0,
		0,
		0,
		0
	FROM CuentaAhorro C
	LEFT JOIN EstadoCuenta EC ON EC.FechaInicio = C.FechaCreacion
		AND EC.CuentaAhorroid = C.id
	WHERE EC.id IS NULL

	SET NOCOUNT OFF;
END