USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[BitacoraBorrarCO] ON [dbo].[CuentaObjetivo]
AFTER UPDATE
AS
BEGIN
	IF (ROWCOUNT_BIG() = 0) --Evita que el trigger se inicie si no se hizo ningun cambio.
		RETURN;
	SET NOCOUNT ON;
	IF UPDATE(Estado)
		BEGIN 
		--Se declaran variables
		DECLARE @idTipoEvento INT = 6,
				@idUser INT,
				@XMLAntes XML,
				@XMLDespues XML = '',
				@Ip VARCHAR(255),
				@Fecha DATE

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
		SET @XMLAntes = (
				SELECT *
				FROM inserted
				FOR XML RAW('CuentaObjetivo'),
					ROOT('CuentasObjetivo')
				)

		SET @Fecha = (
				SELECT TOP (1) Fecha
				FROM [dbo].[FechaOperacion]
				ORDER BY id DESC
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
		SELECT	@IdTipoEvento,
				@idUser,
				@Ip,
				@Fecha, -- [NOTA]: No se como obtener la fecha de operacion
				@XMLAntes,
				@XMLDespues
		FROM inserted B
		END
	


	SET NOCOUNT OFF;
END