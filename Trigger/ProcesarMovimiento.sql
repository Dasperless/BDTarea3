USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[ProcesarMovimiento] ON [dbo].[MovimientoCuentaAhorro]
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	--Variables para el ultimo movimiento insertado
	DECLARE @CuentaId INT,
			@TipoDeMovimientoID INT,
			@Monto MONEY,
			@Fecha DATE,
			@Descripcion VARCHAR(100),
			@OutMovimientoId INT,
			@OutResultCode INT

	--Se Asignan los valores de el ultimo movimiento insertado a las variables
	SELECT	TOP(1)
			@CuentaId = id,
			@TipoDeMovimientoID = TipoMovimientoCuentaAhorroid,
			@Monto = Monto,
			@Fecha = Fecha,
			@Descripcion = Descripcion
	FROM MovimientoCuentaAhorro
	ORDER BY id DESC

	--StoredProcedure para insertar el movimiento.
	EXEC [dbo].[InsertarMovimientos] 
		@CuentaId,
		@TipoDeMovimientoID,
		@Monto,
		@Fecha,
		@Descripcion,
		@OutMovimientoId OUTPUT,
		@OutResultCode OUTPUT
	SET NOCOUNT OFF;
END