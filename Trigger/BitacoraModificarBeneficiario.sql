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
	IF (ROWCOUNT_BIG() = 0) --Evita que el trigger se inicie si no se hizo ningun cambio.
		RETURN;

	SET NOCOUNT ON;
	--Se declaran variables
	DECLARE @idTipoEvento INT = 5,
			@idUser INT,
			@XMLAntes XML,
			@XMLDespues XML = '',
			@Ip VARCHAR(255),
			@Fecha DATE

	--Se le asignan valores 
	SELECT @idUser = P.Usuarioid
	FROM [dbo].[Persona] P
	INNER JOIN [dbo].[CuentaAhorro] C
		ON C.Personaid = P.id

	--Se obtiene la ip de la pc
	SELECT @Ip = client_net_address
	FROM sys.dm_exec_connections
	WHERE Session_id = @@SPID;

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
			SELECT TOP (1) *
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
	FROM inserted B
	


	SET NOCOUNT OFF;
END