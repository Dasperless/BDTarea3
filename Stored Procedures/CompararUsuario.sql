USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[SP_CompararUsuario]    Script Date: 1/12/2020 20:18:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CompararUsuario]
(
	-- Add the parameters for the stored procedure here
	@Usuario VARCHAR(50) = '',
	@Pass VARCHAR(50) = ''
)
AS
BEGIN
	SELECT * FROM Usuario 
	WHERE NombreUsuario = @Usuario and Pass = @Pass
END
