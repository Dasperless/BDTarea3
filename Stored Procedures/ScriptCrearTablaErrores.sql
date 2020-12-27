USE [ProyectoBD1]
GO

/****** Object:  Table [dbo].[Errores]    Script Date: 30/11/2020 18:57:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Errores](
	[SUSER_SNAME] [nvarchar](128) NULL,
	[ERROR_NUMBER] [int] NULL,
	[ERROR_STATE] [int] NULL,
	[ERROR_SEVERITY] [int] NULL,
	[ERROR_LINE] [int] NULL,
	[ERROR_PROCEDURE] [nvarchar](128) NULL,
	[ERROR_MESSAGE] [nvarchar](4000) NULL,
	[GETDATE] [datetime] NULL
) ON [PRIMARY]
GO


