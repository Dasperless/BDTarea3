USE [ProyectoBD1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[selCO]
(
	-- Add the parameters for the stored procedure here
	@id int = 0
)
AS
BEGIN
	SELECT * FROM dbo.CuentaObjetivo
	WHERE id = @id
END
