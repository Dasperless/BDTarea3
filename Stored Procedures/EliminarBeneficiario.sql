USE [ProyectoBD1]
GO
/****** Object:  StoredProcedure [dbo].[SP_EliminarBeneficiario]    Script Date: 2/12/2020 08:47:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EliminarBeneficiario]
(
	-- Add the parameters for the stored procedure here
	@inId int = 0
)
AS
BEGIN
	UPDATE Beneficiarios SET Activo = 0,FechaDesactivacion = GETDATE()
	WHERE id = @inId
END
