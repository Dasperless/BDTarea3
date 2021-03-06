USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[BitacoraInsertarCO] ON [dbo].[CuentaObjetivo]
AFTER INSERT
AS
BEGIN
	IF (ROWCOUNT_BIG() = 0) --Evita que el trigger se inicie si no se hizo ningun cambio.
		RETURN;

	SET NOCOUNT ON;
	
	--Se declaran variables
	DECLARE @idTipoEvento INT = 4,
			@idUser INT,
			@XMLAntes XML  =  '',
			@XMLDespues XML,
			@Ip VARCHAR(255)

	--Se le asignan valores 
	SELECT @idUser = P.Usuarioid
	FROM inserted i
	INNER JOIN [dbo].[CuentaAhorro] C
		ON C.NumeroCuenta = i.NumeroCuentaPrimaria
	INNER JOIN [dbo].[Persona] P
		ON C.Personaid  = P.id

		--Se obtiene la ip de la pc
	SELECT @Ip = CASE 
			WHEN client_net_address = '<local machine>'
				THEN '127.0.0.1'
			ELSE client_net_address
			END
	FROM sys.dm_exec_connections
	WHERE session_id = @@SPID;

	--Se transforma la fila en XMl
	SET @XMLDespues = (
			SELECT *
			FROM inserted
			FOR XML RAW('CuentaObjectivo'),
				ROOT('CuentasObjetivo')
			)

	--Se insertan el evento
	INSERT INTO [dbo].[Eventos] (
		idTipoEvento,
		idUser,
		[IP],
		Fecha,
		XMLAntes,
		XMLDespues
		)
	SELECT @IdTipoEvento,
		@idUser,
		@Ip,
		CO.FechaInicio,
		@XMLAntes,
		@XMLDespues
	FROM inserted CO

	SET NOCOUNT OFF;
END