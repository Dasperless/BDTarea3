	USE [ProyectoBD1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[BitacoraModificarBeneficiario] ON [dbo].[Beneficiarios]
AFTER UPDATE
AS
BEGIN
	IF (SELECT T1.id
		FROM (
				SELECT *
				FROM inserted
			
				EXCEPT
			
				SELECT *
				FROM deleted
				) AS T1
			) IS NULL --Evita que el trigger se inicie si no se hizo ningun cambio.
		BEGIN
			RETURN;
		END;

	SET NOCOUNT ON;
	--Se declaran variables
	DECLARE @idTipoEvento INT = 5,
			@idUser INT,
			@XMLAntes XML,
			@XMLDespues XML,
			@Ip VARCHAR(255),
			@Fecha DATE

	--Se le asignan valores 
	SELECT @idUser = P.Usuarioid
	FROM inserted i 
	INNER JOIN [dbo].[CuentaAhorro] C
		ON C.NumeroCuenta = i.NumeroCuenta
	INNER JOIN [dbo].[Persona] P
		ON P.id = C.Personaid

	--Se obtiene la ip de la pc
	SELECT @Ip = CASE 
			WHEN client_net_address = '<local machine>'
				THEN '127.0.0.1'
			ELSE client_net_address
			END
	FROM sys.dm_exec_connections
	WHERE session_id = @@SPID;

	--Se genera el XMLAntes
	SET @XMLAntes = (
			SELECT *
			FROM deleted
			FOR XML RAW('Beneficiario'),
				ROOT('Beneficiarios')
			)

	--Se genera el XMLDespues
	SET @XMLDespues = (
			SELECT *
			FROM inserted
			FOR XML RAW('Beneficiario'),
				ROOT('Beneficiarios')
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
			@Fecha,
			@XMLAntes,
			@XMLDespues
	FROM inserted 
	


	SET NOCOUNT OFF;
END