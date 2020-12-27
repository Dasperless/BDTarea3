USE [ProyectoBD1]
GO
/****** Object:  Table [dbo].[Beneficiarios]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beneficiarios](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Personaid] [int] NOT NULL,
	[CuentaAhorroid] [int] NOT NULL,
	[NumeroCuenta] [int] NOT NULL,
	[ValorDocumentoIdentidadBeneficiario] [int] NOT NULL,
	[ParentezcoId] [int] NOT NULL,
	[Porcentaje] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
	[FechaDesactivacion] [date] NULL,
 CONSTRAINT [PK_Beneficiarios] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaAhorro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Personaid] [int] NOT NULL,
	[TipoCuentaId] [int] NOT NULL,
	[NumeroCuenta] [int] NOT NULL,
	[FechaCreacion] [date] NOT NULL,
	[Saldo] [money] NOT NULL,
 CONSTRAINT [PK_CuentaAhorro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaObjetivo]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaObjetivo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NOT NULL,
	[Costo] [money] NOT NULL,
	[Objetivo] [varchar](100) NOT NULL,
	[Saldo] [money] NOT NULL,
	[InteresesAcumulados] [money] NOT NULL,
	[CuentaAhorroid] [int] NOT NULL,
 CONSTRAINT [PK_CuentaObjetivo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiaMesDeposito]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiaMesDeposito](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NumDia] [int] NOT NULL,
	[CuentaObjetivoid] [int] NOT NULL,
 CONSTRAINT [PK_DiaMesDeposito] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Errores]    Script Date: 8/12/2020 22:12:49 ******/
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
/****** Object:  Table [dbo].[EstadoCuenta]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoCuenta](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CuentaAhorroid] [int] NOT NULL,
	[NumeroCuenta] [int] NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NOT NULL,
	[SaldoInicial] [money] NOT NULL,
	[SaldoFinal] [money] NOT NULL,
 CONSTRAINT [PK_EstadoCuenta] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovCuentaObj]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovCuentaObj](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[TipoMovObjid] [int] NOT NULL,
	[CuentaObjetivoid] [int] NOT NULL,
 CONSTRAINT [PK_MovCuentaObj] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovCuentaObjIntereses]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovCuentaObjIntereses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[TipoMovObjid] [int] NOT NULL,
	[CuentaObjetivoid] [int] NOT NULL,
 CONSTRAINT [PK_MovCuentaObjIntereses] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCuentaAhorro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoSaldo] [money] NOT NULL,
	[EstadoCuentaid] [int] NOT NULL,
	[TipoMovimientoCuentaAhorroid] [int] NOT NULL,
	[CuentaAhorroid] [int] NOT NULL,
	[Descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MovimientoCuentaAhorro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Parentezco]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parentezco](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Parentezco] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Persona]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[ValorDocIdentidad] [int] NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[Telefono1] [int] NOT NULL,
	[Telefono2] [int] NOT NULL,
	[TipoDocIdentidadid] [int] NOT NULL,
	[Usuarioid] [int] NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCuentaAhorro](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[IdTipoMoneda] [int] NOT NULL,
	[SaldoMinimo] [money] NOT NULL,
	[MultaSaldoMin] [float] NOT NULL,
	[CargoAnual] [float] NOT NULL,
	[NumRetirosHumano] [int] NOT NULL,
	[NumRetirosAutomatico] [int] NOT NULL,
	[ComisionHumano] [int] NOT NULL,
	[ComisionAutomatico] [int] NOT NULL,
	[Interes] [int] NOT NULL,
 CONSTRAINT [PK_TipoCuentaAhorro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocIdentidad]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocIdentidad](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TipoDocIdentidad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMoneda]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMoneda](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Simbolo] [char](10) NOT NULL,
 CONSTRAINT [PK_TipoMoneda] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoCuentaAhorro](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[TipoOperacion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoMovimientoCuentaAhorro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TMovCuentaObj]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMovCuentaObj](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TMovCuentaObj] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TMovCuentaObjIntereses]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMovCuentaObjIntereses](
	[id] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TMovCuentaObjIntereses] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NombreUsuario] [varchar](50) NOT NULL,
	[Pass] [varchar](50) NOT NULL,
	[ValorDocIdentidad] [int] NOT NULL,
	[EsAdmi] [bit] NOT NULL,
 CONSTRAINT [PK_Usuario_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuarioPuedeVer]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuarioPuedeVer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NombreUsuario] [varchar](50) NOT NULL,
	[NumeroCuenta] [int] NOT NULL,
	[Usuarioid] [int] NOT NULL,
 CONSTRAINT [PK_UsuarioPuedeVer_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Beneficiarios]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiarios_CuentaAhorro] FOREIGN KEY([CuentaAhorroid])
REFERENCES [dbo].[CuentaAhorro] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Beneficiarios] CHECK CONSTRAINT [FK_Beneficiarios_CuentaAhorro]
GO
ALTER TABLE [dbo].[Beneficiarios]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiarios_Parentezco] FOREIGN KEY([ParentezcoId])
REFERENCES [dbo].[Parentezco] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Beneficiarios] CHECK CONSTRAINT [FK_Beneficiarios_Parentezco]
GO
ALTER TABLE [dbo].[Beneficiarios]  WITH NOCHECK ADD  CONSTRAINT [FK_Beneficiarios_Persona] FOREIGN KEY([Personaid])
REFERENCES [dbo].[Persona] ([id])
GO
ALTER TABLE [dbo].[Beneficiarios] NOCHECK CONSTRAINT [FK_Beneficiarios_Persona]
GO
ALTER TABLE [dbo].[CuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_CuentaAhorro_Persona] FOREIGN KEY([Personaid])
REFERENCES [dbo].[Persona] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CuentaAhorro] CHECK CONSTRAINT [FK_CuentaAhorro_Persona]
GO
ALTER TABLE [dbo].[CuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_CuentaAhorro_TipoCuentaAhorro] FOREIGN KEY([TipoCuentaId])
REFERENCES [dbo].[TipoCuentaAhorro] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CuentaAhorro] CHECK CONSTRAINT [FK_CuentaAhorro_TipoCuentaAhorro]
GO
ALTER TABLE [dbo].[CuentaObjetivo]  WITH CHECK ADD  CONSTRAINT [FK_CuentaObjetivo_CuentaAhorro] FOREIGN KEY([CuentaAhorroid])
REFERENCES [dbo].[CuentaAhorro] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CuentaObjetivo] CHECK CONSTRAINT [FK_CuentaObjetivo_CuentaAhorro]
GO
ALTER TABLE [dbo].[DiaMesDeposito]  WITH CHECK ADD  CONSTRAINT [FK_DiaMesDeposito_CuentaObjetivo] FOREIGN KEY([CuentaObjetivoid])
REFERENCES [dbo].[CuentaObjetivo] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiaMesDeposito] CHECK CONSTRAINT [FK_DiaMesDeposito_CuentaObjetivo]
GO
ALTER TABLE [dbo].[EstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_EstadoCuenta_CuentaAhorro] FOREIGN KEY([CuentaAhorroid])
REFERENCES [dbo].[CuentaAhorro] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EstadoCuenta] CHECK CONSTRAINT [FK_EstadoCuenta_CuentaAhorro]
GO
ALTER TABLE [dbo].[MovCuentaObj]  WITH CHECK ADD  CONSTRAINT [FK_MovCuentaObj_CuentaObjetivo] FOREIGN KEY([CuentaObjetivoid])
REFERENCES [dbo].[CuentaObjetivo] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MovCuentaObj] CHECK CONSTRAINT [FK_MovCuentaObj_CuentaObjetivo]
GO
ALTER TABLE [dbo].[MovCuentaObj]  WITH CHECK ADD  CONSTRAINT [FK_MovCuentaObj_TMovCuentaObj] FOREIGN KEY([TipoMovObjid])
REFERENCES [dbo].[TMovCuentaObj] ([id])
GO
ALTER TABLE [dbo].[MovCuentaObj] CHECK CONSTRAINT [FK_MovCuentaObj_TMovCuentaObj]
GO
ALTER TABLE [dbo].[MovCuentaObjIntereses]  WITH CHECK ADD  CONSTRAINT [FK_MovCuentaObjIntereses_CuentaObjetivo] FOREIGN KEY([CuentaObjetivoid])
REFERENCES [dbo].[CuentaObjetivo] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MovCuentaObjIntereses] CHECK CONSTRAINT [FK_MovCuentaObjIntereses_CuentaObjetivo]
GO
ALTER TABLE [dbo].[MovCuentaObjIntereses]  WITH CHECK ADD  CONSTRAINT [FK_MovCuentaObjIntereses_TMovCuentaObjIntereses] FOREIGN KEY([TipoMovObjid])
REFERENCES [dbo].[TMovCuentaObjIntereses] ([id])
GO
ALTER TABLE [dbo].[MovCuentaObjIntereses] CHECK CONSTRAINT [FK_MovCuentaObjIntereses_TMovCuentaObjIntereses]
GO
ALTER TABLE [dbo].[MovimientoCuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCuentaAhorro_CuentaAhorro] FOREIGN KEY([CuentaAhorroid])
REFERENCES [dbo].[CuentaAhorro] ([id])
GO
ALTER TABLE [dbo].[MovimientoCuentaAhorro] CHECK CONSTRAINT [FK_MovimientoCuentaAhorro_CuentaAhorro]
GO
ALTER TABLE [dbo].[MovimientoCuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCuentaAhorro_EstadoCuenta] FOREIGN KEY([EstadoCuentaid])
REFERENCES [dbo].[EstadoCuenta] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MovimientoCuentaAhorro] CHECK CONSTRAINT [FK_MovimientoCuentaAhorro_EstadoCuenta]
GO
ALTER TABLE [dbo].[MovimientoCuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCuentaAhorro_TipoMovimientoCuentaAhorro] FOREIGN KEY([TipoMovimientoCuentaAhorroid])
REFERENCES [dbo].[TipoMovimientoCuentaAhorro] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MovimientoCuentaAhorro] CHECK CONSTRAINT [FK_MovimientoCuentaAhorro_TipoMovimientoCuentaAhorro]
GO
ALTER TABLE [dbo].[Persona]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_TipoDocIdentidad1] FOREIGN KEY([TipoDocIdentidadid])
REFERENCES [dbo].[TipoDocIdentidad] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Persona] CHECK CONSTRAINT [FK_Cliente_TipoDocIdentidad1]
GO
ALTER TABLE [dbo].[Persona]  WITH CHECK ADD  CONSTRAINT [FK_Persona_Usuario] FOREIGN KEY([Usuarioid])
REFERENCES [dbo].[Usuario] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Persona] CHECK CONSTRAINT [FK_Persona_Usuario]
GO
ALTER TABLE [dbo].[TipoCuentaAhorro]  WITH CHECK ADD  CONSTRAINT [FK_TipoCuentaAhorro_TipoMoneda] FOREIGN KEY([IdTipoMoneda])
REFERENCES [dbo].[TipoMoneda] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TipoCuentaAhorro] CHECK CONSTRAINT [FK_TipoCuentaAhorro_TipoMoneda]
GO
ALTER TABLE [dbo].[UsuarioPuedeVer]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioPuedeVer_Usuario] FOREIGN KEY([Usuarioid])
REFERENCES [dbo].[Usuario] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsuarioPuedeVer] CHECK CONSTRAINT [FK_UsuarioPuedeVer_Usuario]
GO
/****** Object:  StoredProcedure [dbo].[BuscarMovimientoEspecifico]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BuscarMovimientoEspecifico]
	 @inDescripcion VARCHAR(100)
	,@inEstadoCuentaid INT
	--
	,@outMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0,
			@inDescripcion = '%'+@inDescripcion+'%';
			IF NOT EXISTS(SELECT 1 FROM dbo.EstadoCuenta E WHERE E.id=@inEstadoCuentaid)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TBuscarMovimiento
				SELECT * FROM dbo.MovimientoCuentaAhorro
				WHERE Descripcion LIKE @inDescripcion and EstadoCuentaid = @inEstadoCuentaid
				Set @outMovimientoId = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 

			COMMIT TRANSACTION TBuscarMovimiento; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TBuscarMovimiento; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[CerrarEstadoCuenta]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CerrarEstadoCuenta] 
	@inCuentaCierra INT
	,@inFechaInicio DATE
	,@inFechaFin DATE
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- Se declaran variables
		DECLARE @SaldoFinal MONEY = 0
		DECLARE @TipoCuentaAhorroId INT
		DECLARE @CuentaId INT, @EstadoCuentaId INT
		DECLARE @MultaSaldoMin MONEY, @SaldoMin MONEY

		-- Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @CuentaId = Id FROM CuentaAhorro WHERE NumeroCuenta = @inCuentaCierra
		SELECT @TipoCuentaAhorroId = TipoCuentaId FROM CuentaAhorro CA WHERE CA.id = @CuentaId
		SELECT @EstadoCuentaId = id FROM EstadoCuenta EC WHERE EC.CuentaAhorroid = @CuentaId AND EC.FechaInicio = @inFechaInicio
		SELECT @MultaSaldoMin = T.MultaSaldoMin, @SaldoMin = T.SaldoMinimo FROM TipoCuentaAhorro T WHERE T.id = @TipoCuentaAhorroId 
		

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveCerrEst

			DECLARE @EstadoDeCuentaID INT
					,@OutNumRetirosHumano INT
					,@OutNumRetirosCajero INT
					,@OutSaldoFinal MONEY
					,@OutMovimientoECId INT
					,@OutResultCodeEC INT

			EXEC [dbo].[ProcesarMovimientos] 
					@inCuentaCierra
					,@inFechaInicio
					,@inFechaFin
					,@OutNumRetirosHumano OUTPUT
					,@OutNumRetirosCajero OUTPUT
					,@OutSaldoFinal OUTPUT
					,@OutMovimientoECId OUTPUT
					,@OutResultCodeEC OUTPUT

			SELECT  @SaldoFinal = @OutSaldoFinal

			IF(@OutNumRetirosHumano > (SELECT NumRetirosHumano FROM TipoCuentaAhorro TC WHERE TC.id = @TipoCuentaAhorroId) )
				BEGIN
					SELECT @SaldoFinal = @SaldoFinal - (SELECT ComisionHumano FROM TipoCuentaAhorro TC WHERE TC.id = @TipoCuentaAhorroId)
				END;

			IF(@OutNumRetirosCajero > (SELECT NumRetirosAutomatico FROM TipoCuentaAhorro TC WHERE TC.id = @TipoCuentaAhorroId) )
				BEGIN
					SELECT @SaldoFinal = @SaldoFinal - (SELECT ComisionAutomatico FROM TipoCuentaAhorro TC WHERE TC.id = @TipoCuentaAhorroId)
				END;
			IF(@SaldoFinal < @SaldoMin) -- Multa por saldo minimo
				BEGIN
					SELECT @SaldoFinal = @SaldoFinal - @MultaSaldoMin
				END;

			--Se actualiza el movimiento en la base de datos
			UPDATE dbo.EstadoCuenta
			SET SaldoFinal = @SaldoFinal
			WHERE Id = @EstadoCuentaId

			SET @outMovimientoId = SCOPE_IDENTITY();

		COMMIT TRANSACTION TSaveCerrEst;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION TSaveCerrEst;

		INSERT INTO dbo.Errores
		VALUES (
			SUSER_SNAME()
			,ERROR_NUMBER()
			,ERROR_STATE()
			,ERROR_SEVERITY()
			,ERROR_LINE()
			,ERROR_PROCEDURE()
			,ERROR_MESSAGE()
			,GETDATE()
			);

		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultaEstadoCuenta]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultaEstadoCuenta] @inNumeroCuenta INT
AS
BEGIN
	SET NOCOUNT ON

	SELECT TOP (8) id
		,NumeroCuenta
		,FechaInicio
		,FechaFin
		,SaldoInicial
		,SaldoFinal
	FROM EstadoCuenta
	WHERE NumeroCuenta = @inNumeroCuenta
	ORDER BY FechaInicio ASC

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[CrearCuentaObjetivo]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CrearCuentaObjetivo]
	@inFechaInicio DATE
	, @inFechaFin DATE
	, @inCosto MONEY
	, @inObjetivo VARCHAR(100)
	, @inSaldo MONEY
	, @inInteresesAcumulados MONEY
	, @inCuentaAhorroid INT
	--
	, @outCuentaObjetivoId INT OUTPUT
	, @OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0;
			IF NOT EXISTS(SELECT 1 FROM dbo.CuentaAhorro C WHERE C.id=@inCuentaAhorroid)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TCrearCuentaObjetivo
				INSERT INTO CuentaObjetivo(FechaInicio, FechaFin, Costo, Objetivo, Saldo,InteresesAcumulados,CuentaAhorroid)
				VALUES (@inFechaInicio, @inFechaFin, @inCosto, @inObjetivo, @inSaldo,@inInteresesAcumulados,@inCuentaAhorroid)
				Set @outCuentaObjetivoId = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 

			COMMIT TRANSACTION TCrearCuentaObjetivo; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TCrearCuentaObjetivo; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[DesactivacionCuentaObjetivo]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DesactivacionCuentaObjetivo]
	@id INT
	--
	, @outCuentaObjetivoId INT OUTPUT
	, @OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0;
			IF NOT EXISTS(SELECT id FROM dbo.CuentaObjetivo C WHERE C.id=@id)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TDesactivacion
				DELETE FROM CuentaObjetivo 
				WHERE id = @id
				Set @outCuentaObjetivoId = SCOPE_IDENTITY(); --Retorna el id Eliminado
			COMMIT TRANSACTION TDesactivacion; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TDesactivacion; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[EditarBeneficiario]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EditarBeneficiario]
	@inId int 
	,@inNumeroCuenta int 
	,@inValorDocumentoIdentidadBeneficiario int 
	,@inParentezcoId int 
	,@inPorcentaje int 
	--
	,@outBeneficiarioId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			DECLARE
			@inActivo bit,
			@inFechaDesactivacion date 
			-- se inicializan variables
			SELECT
			@inActivo=1,
			@OutResultCode=0;
			IF NOT EXISTS (SELECT 1 FROM dbo.Persona P WHERE P.ValorDocIdentidad = @inValorDocumentoIdentidadBeneficiario )
				SET @OutResultCode = 5002	--El beneficiario no existe en la tabla persona

			IF NOT EXISTS(SELECT 1 FROM dbo.Parentezco PA WHERE PA.id = @inParentezcoId)
				SET @OutResultCode = 5003	--El parentezco no existe

			IF (CONVERT(INT,(SELECT SUM(Porcentaje) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1 AND ValorDocumentoIdentidadBeneficiario != @inValorDocumentoIdentidadBeneficiario ))+@inPorcentaje)>100
				SET @OutResultCode = 5007	--La suma es mayor al 100	

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TEditarB
				UPDATE Beneficiarios
				SET ValorDocumentoIdentidadBeneficiario = @inValorDocumentoIdentidadBeneficiario 
					,ParentezcoId = @inParentezcoId
					,Porcentaje = @inPorcentaje
					,Activo = 1
					,FechaDesactivacion = null
				WHERE id = @inId
				Set @outBeneficiarioId = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 
			COMMIT TRANSACTION TEditarB; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TEditarB; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[EliminarRecords]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EliminarRecords]
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM Cliente
	DELETE FROM Usuario
	DELETE FROM UsuarioPuedeVer
	DELETE FROM CuentaObjetivo
	DELETE FROM TipoMoneda
	DELETE FROM TipoCuentaAhorro
	DELETE FROM TipoDocIdentidad
	DELETE FROM MovimientoCuentaAhorro
	DELETE FROM Parentezco

	SELECT * FROM Cliente
	SELECT * FROM Usuario
	SELECT * FROM UsuarioPuedeVer
	SELECT * FROM CuentaObjetivo
	SELECT * FROM TipoMoneda
	SELECT * FROM TipoCuentaAhorro
	SELECT * FROM TipoDocIdentidad
	SELECT * FROM MovimientoCuentaAhorro
	SELECT * FROM Parentezco

	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[InsertarBeneficiarios]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarBeneficiarios] 
	@inPersonaId INT
	,@inCuentaAhorroId INT
	,@inNumeroCuenta INT
	,@inValorDocumentoIdentidadBeneficiario INT
	,@inParentezcoId INT
	,@inPorcentaje INT
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		--Se declaran las variables 
		DECLARE @Activo BIT, @FechaDesactivacion DATE

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @FechaDesactivacion = NULL
		SELECT @Activo = 1

		-- Validacion de paramentros de entrada
		IF NOT EXISTS (SELECT 1 FROM dbo.Parentezco P WHERE P.id = @inParentezcoId)
		BEGIN
			SET @OutResultCode = 50008;	--No existe el tipo parentezco
			RETURN
		END;

		IF  EXISTS (SELECT 1 FROM dbo.Beneficiarios B WHERE B.Personaid = @inPersonaId AND B.CuentaAhorroid = @inCuentaAhorroId)
		BEGIN
			SET @OutResultCode = 50009;-- Ya existe el beneficiario
			RETURN
		END;

		IF (SELECT COUNT(*) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1) >= 3
		BEGIN
			SET @OutResultCode = 50010;	--Posee más de 3 beneficiarios
			RETURN
		END;

		IF (CONVERT(INT,(SELECT SUM(Porcentaje) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1))+@inPorcentaje)>100
		BEGIN
			SET @OutResultCode = 50011; --La suma de los porcentajes es mayor al 100	
			RETURN
		END;

		IF NOT EXISTS (SELECT 1 FROM CuentaAhorro WHERE id = @inCuentaAhorroId)
		BEGIN
			SET @OutResultCode = 50012; --La cuenta no existe
			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveBen
			INSERT INTO Beneficiarios(
					Personaid
					,CuentaAhorroid
					,NumeroCuenta
					,ValorDocumentoIdentidadBeneficiario
					,ParentezcoId
					,Porcentaje
					,Activo
					,FechaDesactivacion
				)
			VALUES (
				@inPersonaId
				,@inCuentaAhorroId
				,@inNumeroCuenta
				,@inValorDocumentoIdentidadBeneficiario
				,@inParentezcoId
				,@inPorcentaje
				,@Activo
				,@FechaDesactivacion
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSaveBen;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSaveBen;	-- Asegura el Nada, deshace las actualizaciones previas al error

			INSERT INTO dbo.Errores
			VALUES (
				SUSER_SNAME()
				,ERROR_NUMBER()
				,ERROR_STATE()
				,ERROR_SEVERITY()
				,ERROR_LINE()
				,ERROR_PROCEDURE()
				,ERROR_MESSAGE()
				,GETDATE()
				);

			SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarCuentaAhorro] 
	@inPersonaId INT
	,@inTipoCuentaId INT
	,@inNumeroCuenta INT
	,@inFechaCreacion DATE
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		--Se declaran las variables 
		DECLARE @Saldo MONEY

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @Saldo = 0

		-- Validacion de paramentros de entrada
		IF NOT EXISTS (SELECT 1 FROM dbo.Persona P WHERE P.id = @inPersonaId)
		BEGIN
			SET @OutResultCode = 50013;	--No existe la persona
			RETURN
		END;

		IF  EXISTS (SELECT 1 FROM dbo.TipoCuentaAhorro TC WHERE TC.id = @inTipoCuentaId)
		BEGIN
			SET @OutResultCode = 50014;	--No existe el tipo de cuenta
			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveCuen
			INSERT INTO CuentaAhorro(
					Personaid
					,TipoCuentaId
					,NumeroCuenta
					,FechaCreacion
					,Saldo
				)
			VALUES (
				@inPersonaId
				,@inTipoCuentaId
				,@inNumeroCuenta
				,@inFechaCreacion
				,@Saldo
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSaveCuen;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSaveCuen;	-- Asegura el Nada, deshace las actualizaciones previas al error

			INSERT INTO dbo.Errores
			VALUES (
				SUSER_SNAME()
				,ERROR_NUMBER()
				,ERROR_STATE()
				,ERROR_SEVERITY()
				,ERROR_LINE()
				,ERROR_PROCEDURE()
				,ERROR_MESSAGE()
				,GETDATE()
				);

			SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarEstadosCuenta]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarEstadosCuenta] 
	@inCuentaAhorroId INT
	,@inNumeroCuenta INT
	,@inFechaInicio DATE
	,@inSaldoInicial MONEY
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		--Se declaran las variables 
		DECLARE @SaldoFinal MONEY
		DECLARE @FechaFin DATE

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @SaldoFinal = 0
		SELECT @FechaFin = DATEADD(month, 1, @inFechaInicio)

		-- Validacion de paramentros de entrada
		IF NOT EXISTS (SELECT 1 FROM dbo.CuentaAhorro C WHERE C.id = @inCuentaAhorroId)
		BEGIN
			SET @OutResultCode = 50001;	--No existe la cuenta
			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveEst
			INSERT INTO EstadoCuenta(
					CuentaAhorroid
					,NumeroCuenta
					,FechaInicio
					,FechaFin
					,SaldoInicial
					,SaldoFinal
				)
			VALUES (
				@inCuentaAhorroId
				,@inNumeroCuenta
				,@inFechaInicio
				,@FechaFin
				,@inSaldoInicial
				,@SaldoFinal
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSaveEst;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSaveEst;	-- Asegura el Nada, deshace las actualizaciones previas al error

			INSERT INTO dbo.Errores
			VALUES (
				SUSER_SNAME()
				,ERROR_NUMBER()
				,ERROR_STATE()
				,ERROR_SEVERITY()
				,ERROR_LINE()
				,ERROR_PROCEDURE()
				,ERROR_MESSAGE()
				,GETDATE()
				);

			SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarMovimientos]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarMovimientos] 
	@inCuentaId INT
	,@inTipoMovimientoId INT
	,@inMonto MONEY
	,@inFecha DATE
	,@inDescripcion VARCHAR(200)
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- se declaran variables
		DECLARE @nuevoSaldo MONEY

		-- se inicializan variables
		SELECT @OutResultCode = 0

		-- Validacion de paramentros de entrada
		IF NOT EXISTS (SELECT 1 FROM dbo.CuentaAhorro C WHERE C.iD = @inCuentaId)
		BEGIN
			SET @OutResultCode = 50001;-- cuenta no existe
			RETURN
		END;

		IF NOT EXISTS (SELECT 1 FROM dbo.TipoMovimientoCuentaAhorro M WHERE M.ID = @inTipoMovimientoId)
		BEGIN
			SET @OutResultCode = 50002;-- tipo de movimiento no existe
			RETURN
		END;

		SELECT @NuevoSaldo = CA.Saldo + @inMoNTO
		FROM dbo.CuentaAhorro CA
		WHERE CA.Id = @inCuentaId;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveMov

		DECLARE @EstadoDeCuentaID INT
		SELECT @EstadoDeCuentaID = EC.id FROM EstadoCuenta INNER JOIN EstadoCuenta EC ON EC.CuentaAhorroid = @inCuentaId

		INSERT INTO MovimientoCuentaAhorro(
				Fecha
				,Monto
				,NuevoSaldo
				,EstadoCuentaid
				,TipoMovimientoCuentaAhorroid
				,CuentaAhorroid
				,Descripcion
			)
		VALUES (
			@inFecha
			,@inMonto
			,@NuevoSaldo
			,@EstadoDeCuentaID
			,@inTipoMovimientoId
			,@inCuentaId
			,@inDescripcion
			)

		SET @outMovimientoId = SCOPE_IDENTITY();

		IF (SELECT TipoOperacion From TipoMovimientoCuentaAhorro TM Where TM.id = @inTipoMovimientoId) = 'Credito'
			BEGIN
				UPDATE dbo.CuentaAhorro
				SET Saldo = Saldo + @inMonto
				WHERE Id = @inCuentaId
			END;
		ELSE
			BEGIN
				UPDATE dbo.CuentaAhorro
				SET Saldo = Saldo - @inMonto
				WHERE Id = @inCuentaId
			END;


		COMMIT TRANSACTION TSaveMov;-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0 -- chequeo que el errror sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSaveMov;-- asegura el Nada, deshace las actualizaciones previas al error

		INSERT INTO dbo.Errores
		VALUES (
			SUSER_SNAME()
			,ERROR_NUMBER()
			,ERROR_STATE()
			,ERROR_SEVERITY()
			,ERROR_LINE()
			,ERROR_PROCEDURE()
			,ERROR_MESSAGE()
			,GETDATE()
			);

		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarPersonas]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarPersonas] 
	@inNombre VARCHAR(100)
	,@inValorDocIdentidad INT
	,@inEmail VARCHAR(100)
	,@inFechaNacimiento DATE
	,@inTelefono1 INT
	,@inTelefono2 INT
	,@inTipoDocIdentidadId int
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		--Se declaran las variables 
		DECLARE @UsuarioID INT

		--Se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @UsuarioID = U.id FROM Usuario INNER JOIN Usuario U ON U.ValorDocIdentidad = @inValorDocIdentidad

		-- Validacion de paramentros de entrada
		IF EXISTS (SELECT 1 FROM dbo.Persona P WHERE P.ValorDocIdentidad = @inValorDocIdentidad)
		BEGIN
			SET @OutResultCode = 50006;-- La persona ya existe
			RETURN
		END;

		IF NOT EXISTS (SELECT 1 FROM dbo.TipoDocIdentidad TD WHERE TD.ID = @inTipoDocIdentidadId)
		BEGIN
			SET @OutResultCode = 50007;-- tipo de movimiento no existe
			RETURN
		END;

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSavePer
			INSERT INTO Persona(
					Nombre
					,ValorDocIdentidad
					,Email
					,FechaNacimiento
					,Telefono1
					,Telefono2
					,TipoDocIdentidadid
					,Usuarioid
				)
			VALUES (
				@inNombre
				,@inValorDocIdentidad
				,@inEmail
				,@inFechaNacimiento
				,@inTelefono1
				,@inTelefono2
				,@inTipoDocIdentidadId
				,@UsuarioID
				)

			SET @outMovimientoId = SCOPE_IDENTITY();
		COMMIT TRANSACTION TSavePer;	-- asegura el TODO, que las todas actualizaciones "quedan"en la BD.
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0					-- Chequeo que el error sucedio dentro de la transaccion
			ROLLBACK TRANSACTION TSavePer;	-- Asegura el Nada, deshace las actualizaciones previas al error

			INSERT INTO dbo.Errores
			VALUES (
				SUSER_SNAME()
				,ERROR_NUMBER()
				,ERROR_STATE()
				,ERROR_SEVERITY()
				,ERROR_LINE()
				,ERROR_PROCEDURE()
				,ERROR_MESSAGE()
				,GETDATE()
				);

			SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarUsuarioJacob]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[InsertarUsuarioJacob]
AS
BEGIN 

--faltan los usuarios y usuarios ver
	INSERT INTO Usuarios(Usuario, Contrasena, EsAdministrador)
	SELECT 
		MY_XML.Datos.value('@Usuario', 'VARCHAR(100)'),
		MY_XML.Datos.value('@Contrasena', 'VARCHAR(100)'),
		MY_XML.Datos.value('@EsAdministrador', 'bit')

	FROM (SELECT CAST(MY_XML AS xml)
			FROM OPENROWSET(BULK 'C:\Users\yeico\Desktop\BaseDeDatos-Proyecto1\no-catalogos.xml', SINGLE_BLOB) AS T(MY_XML)) AS T(MY_XML)
			CROSS APPLY MY_XML.nodes('Usuarios/Usuario') AS MY_XML (Datos);

END;
GO
/****** Object:  StoredProcedure [dbo].[ModificarDescripcionCuentaObjetivo]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ModificarDescripcionCuentaObjetivo]
	@id INT
	, @inObjetivo VARCHAR(100)
	--
	, @outCuentaObjetivoId INT OUTPUT
	, @OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0;
			IF NOT EXISTS(SELECT id FROM dbo.CuentaObjetivo C WHERE C.id=@id)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TModDesObjetivo
				UPDATE CuentaObjetivo SET Objetivo = @inObjetivo
				WHERE id = @id
				Set @outCuentaObjetivoId = @id; --Retorna el id modificado
			COMMIT TRANSACTION TModDesObjetivo; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TModDesObjetivo; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerUsuario]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ObtenerUsuario]	@inUser varchar(50),
								@inPass varchar(50)
AS
BEGIN 
	SELECT * 
	FROM [dbo].[Usuario]
	WHERE [user] = @inUser and pass = @inPass
END 
GO
/****** Object:  StoredProcedure [dbo].[ProcesarMovimientos]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcesarMovimientos] 
	@inCuentaId INT
	,@inFechaInicio DATE
	,@inFechaFin DATE
	,@OutNumRetirosHumano INT OUTPUT
	,@OutNumRetirosCajero INT OUTPUT
	,@OutSaldoFinal MONEY OUTPUT
	,@OutMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- se declaran variables
		DECLARE @nuevoSaldo MONEY = 0
		DECLARE @Movimientos TABLE(Sec INT IDENTITY(1,1),MovimientoId INT, Tipo VARCHAR (20), Nombre VARCHAR (20), Monto MONEY)	--Tabla con los movimientos del mes
		DECLARE @MovimientoId INT
		DECLARE @CuentaId INT

		IF NOT EXISTS (SELECT 1 FROM CuentaAhorro WHERE NumeroCuenta = @inCuentaId)
			BEGIN 
				SET @OutResultCode = 50016; --El numero de cuenta no existe
				RETURN 
			END;
			
		--Se Inicializa la tabla con los movimientos
		SELECT @CuentaId = Id FROM CuentaAhorro WHERE NumeroCuenta = @inCuentaId

		INSERT INTO @Movimientos(MovimientoId, Tipo, Nombre, Monto)
		SELECT	MC.id
				,TM.TipoOperacion
				,TM.Nombre
				,MC.Monto
		FROM MovimientoCuentaAhorro MC
		INNER JOIN TipoMovimientoCuentaAhorro TM ON TM.id = MC.TipoMovimientoCuentaAhorroid
		WHERE  MC.CuentaAhorroid = @CuentaId

		-- se inicializan variables
		SELECT @OutResultCode = 0
		SELECT @OutNumRetirosCajero = COUNT(M.Nombre) FROM @Movimientos M Where M.Nombre = 'Retiro ATM'
		SELECT @OutNumRetirosHumano = COUNT(M.Nombre) FROM @Movimientos M Where M.Nombre = 'Retiro Ventana'

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION TSaveProcMov

			DECLARE @lo int = 1, @hi int
			SELECT @hi = max(sec) FROM @Movimientos
			--INICIO WHILE 	
			WHILE @lo <= @hi
				BEGIN 
					SELECT @MovimientoId  = M.MovimientoId FROM @Movimientos M WHERE M.sec = @lo	--Id del movimiento que se esta iterando
					IF (SELECT Tipo From @Movimientos M Where M.Sec = @lo) = 'Credito'				--Si el tipo de movimiento actual es un credito
						BEGIN
							SELECT @nuevoSaldo = @nuevoSaldo + M.Monto FROM @Movimientos M WHERE M.sec = @lo	--Se suma el credito al nuevo saldo
						END;
					ELSE
						BEGIN
							SELECT @nuevoSaldo = @nuevoSaldo - M.Monto FROM @Movimientos M WHERE M.sec = @lo	--Se resta el debito al nuevo saldo
						END;

					--Se actualiza el movimiento en la base de datos
					UPDATE dbo.CuentaAhorro
					SET Saldo = @nuevoSaldo
					WHERE NumeroCuenta = @inCuentaId

					UPDATE dbo.MovimientoCuentaAhorro
					SET NuevoSaldo = @nuevoSaldo
					WHERE Id = @MovimientoId


					SET @lo = @lo + 1 --Contador
				END
			--FIN WHILE

			SET @OutSaldoFinal = @nuevoSaldo
			SET @outMovimientoId = SCOPE_IDENTITY()
		COMMIT TRANSACTION TSaveProcMov;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION TSaveProcMov;

		INSERT INTO dbo.Errores
		VALUES (
			SUSER_SNAME()
			,ERROR_NUMBER()
			,ERROR_STATE()
			,ERROR_SEVERITY()
			,ERROR_LINE()
			,ERROR_PROCEDURE()
			,ERROR_MESSAGE()
			,GETDATE()
			);

		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[selCO]    Script Date: 8/12/2020 22:12:49 ******/
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
GO
/****** Object:  StoredProcedure [dbo].[SeleccionarCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SeleccionarCuentaAhorro]
	@inPersonaid INT
	--
	, @outCuentaAhorroId INT OUTPUT
	, @OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0;
			IF NOT EXISTS(SELECT 1 FROM dbo.Persona P WHERE P.id=@inPersonaid)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TSeleccionarCA
				SELECT * FROM dbo.CuentaAhorro 
				WHERE Personaid = @inPersonaid
				SET @outCuentaAhorroId = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 

			COMMIT TRANSACTION TSeleccionarCA; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TSeleccionarCA; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[SeleccionarMovimientos]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SeleccionarMovimientos]
	@inEstadoCuentaid INT
	--
	,@outMovimientoId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0;
			IF NOT EXISTS(SELECT 1 FROM dbo.EstadoCuenta E WHERE E.id=@inEstadoCuentaid)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TSeleccionarMovimiento
				SELECT * FROM dbo.MovimientoCuentaAhorro
				WHERE EstadoCuentaid = @inEstadoCuentaid
				Set @outMovimientoId = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 

			COMMIT TRANSACTION TSeleccionarMovimiento; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TSeleccionarMovimiento; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[SeleccionarPersona]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SeleccionarPersona]
	@inValorDocIdentidad INT
	--
	, @outPersonaId INT OUTPUT
	, @OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@outPersonaId=0,
			@OutResultCode=0;
			--IF NOT EXISTS(SELECT 1 FROM dbo.Usuario U WHERE U.id=@inUsuarioid)
			--	BEGIN
			--		Set @OutResultCode=50001; -- Validacion
			--		RETURN
			--	END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TSeleccionarP
				SELECT * FROM dbo.Persona
				WHERE ValorDocIdentidad = @inValorDocIdentidad
				SET @outPersonaId = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 

			COMMIT TRANSACTION TSeleccionarP; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TSeleccionarP; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_AgregarBeneficiario]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AgregarBeneficiario]
(
	-- Add the parameters for the stored procedure here
	 @inNumeroCuenta INT
	,@inValorDocIdentidadBeneficiario INT
	,@inParentezcoId INT
	,@inPorcentaje INT
)
AS
DECLARE @outErrorCode int = 0
BEGIN
	IF NOT EXISTS (SELECT NumeroCuenta FROM CuentaAhorro WHERE NumeroCuenta = @inNumeroCuenta)
		SET @outErrorCode = 5001	--El numero de cuenta no existe
	
	ELSE IF NOT EXISTS (SELECT ValorDocIdentidad FROM Cliente WHERE ValorDocIdentidad = @inValorDocIdentidadBeneficiario )
		SET @outErrorCode = 5002	--El beneficiario no existe

	ELSE IF (SELECT COUNT(*) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1) >= 3
		Set @outErrorCode = 5005	--Posee más de 3 beneficiarios

	ELSE IF EXISTS(SELECT ValorDocumentoIdentidadBeneficiario from Beneficiarios WHERE NumeroCuenta = @inNumeroCuenta and  ValorDocumentoIdentidadBeneficiario = @inValorDocIdentidadBeneficiario AND Activo = 1)
		SET @outErrorCode = 5006	--El Beneficiario ya existe

	ELSE IF (CONVERT(INT,(SELECT SUM(Porcentaje) FROM Beneficiarios where NumeroCuenta = @inNumeroCuenta AND Activo = 1))+@inPorcentaje)>100
		SET @outErrorCode = 5007	--La suma es mayor al 100	

	ELSE
			INSERT INTO Beneficiarios (
				NumeroCuenta
				,ValorDocumentoIdentidadBeneficiario
				,ParentezcoId
				,Porcentaje
				,Activo
				,FechaDesactivacion
				)
			VALUES (
				@inNumeroCuenta
				,@inValorDocIdentidadBeneficiario
				,@inParentezcoId
				,@inPorcentaje
				,1
				,NULL
				)
	RETURN @outErrorCode;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BeneficiarioPorID]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_BeneficiarioPorID]
(
	-- Add the parameters for the stored procedure here
	@ValorDocumentoIdentidadBeneficiario int = 0
)
AS
BEGIN
	SELECT * FROM Beneficiarios 
	WHERE ValorDocumentoIdentidadBeneficiario = @ValorDocumentoIdentidadBeneficiario
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CompararUsuario]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CompararUsuario]
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
GO
/****** Object:  StoredProcedure [dbo].[SP_EliminarBeneficiario]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EliminarBeneficiario]
(
	-- Add the parameters for the stored procedure here
	@inId int = 0
)
AS
BEGIN
	UPDATE Beneficiarios SET Activo = 0,FechaDesactivacion = GETDATE()
	WHERE id = @inId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ObtenerBeneficiarios]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ObtenerBeneficiarios]
(
	-- Add the parameters for the stored procedure here
	@NumeroCuenta int = 0
)
AS
BEGIN
	SELECT * FROM Beneficiarios 
	WHERE NumeroCuenta = @NumeroCuenta and Activo = 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ObtenerParentezco]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ObtenerParentezco]
(
	-- Add the parameters for the stored procedure here
	@ParentezcoId int = 0
)
AS
BEGIN
	SELECT Nombre FROM Parentezco 
	WHERE id = @ParentezcoId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SeleccionarCuentasAhorroUsuarioPuedeVer]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Darío Vargas>
-- Create date: <Create Date,15/11/2020>
-- Description:	<Description, Procedimiento que obtiene las cuentas de un UsuarioPuedeVer>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SeleccionarCuentasAhorroUsuarioPuedeVer]
(
	@inUser varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * 
	FROM CuentaAhorro
	INNER JOIN UsuarioPuedeVer 
	ON CuentaAhorro.NumeroCuenta = UsuarioPuedeVer.NumeroCuenta
	--WHERE @inUser = UsuarioPuedeVer.[User]
	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TipoCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TipoCuentaAhorro] (@inTipoCuentaAhorroId INT)
AS
BEGIN
	SELECT *
	FROM TipoCuentaAhorro
	WHERE id = @inTipoCuentaAhorroId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TipoMoneda]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TipoMoneda] (@inTipoMonedaId INT)
AS
BEGIN
	SELECT	Nombre
			,Simbolo
	FROM TipoMoneda
	WHERE id = @inTipoMonedaId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TodoCuentaAhorro]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TodoCuentaAhorro]
AS
BEGIN
	SELECT *
	FROM CuentaAhorro
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioPuedeVer]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UsuarioPuedeVer] 
(
	@inUsuario varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT cuentaAhorro.*
	FROM CuentaAhorro AS cuentaAhorro
	INNER JOIN UsuarioPuedeVer AS usuarioVer ON usuarioVer.NumeroCuenta =  cuentaAhorro.NumeroCuenta
	WHERE usuarioVer.[User] = @inUsuario

	SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_VerificarPorcentajeBeneficiarios]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_VerificarPorcentajeBeneficiarios] (@inNumeroCuenta INT)
AS
DECLARE @outErrorCode INT;
DECLARE @porcentajeBeneficiarios INT = convert(INT, (
			SELECT SUM(Porcentaje)
			FROM Beneficiarios
			WHERE NumeroCuenta = @inNumeroCuenta
				AND Activo = 1
			))
BEGIN
	IF @porcentajeBeneficiarios < 100
		SET @outErrorCode = 5007;--El porcentaje es menor a 100
	ELSE IF @porcentajeBeneficiarios > 100
		SET @outErrorCode = 5008;--El porcentaje es MAYOR a 100
	ELSE
		SET @outErrorCode = 0;

	RETURN @outErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[VerCuentaObj]    Script Date: 8/12/2020 22:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VerCuentaObj]
	@inCuentaAhorroid INT
	--
	, @outCuentaObjId INT OUTPUT
	, @OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
			-- se declaran variables
			--DECLARE
			--@nuevoSaldo money
			-- se inicializan variables
			SELECT
			@OutResultCode=0;
			IF NOT EXISTS(SELECT 1 FROM dbo.CuentaAhorro CA WHERE CA.id=@inCuentaAhorroid)
				BEGIN
					Set @OutResultCode=50001; -- Validacion
					RETURN
				END;

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION TVerCuentaObj
				SELECT * FROM dbo.CuentaObjetivo
				WHERE CuentaAhorroid = @inCuentaAhorroid
				SET @outCuentaObjId  = SCOPE_IDENTITY(); --Retorna el ultimo id insertado 

			COMMIT TRANSACTION TVerCuentaObj; -- asegura el TODO, que las todas actualizaciones "quedan" en la BD.
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT>0 -- chequeo que el errror sucedio dentro de la transaccion
				ROLLBACK TRANSACTION TVerCuentaObj; -- asegura el Nada, deshace las actualizaciones previas al error
				INSERT INTO dbo.Errores VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @OutResultCode=50005;
	END CATCH
	SET NOCOUNT OFF
END;
GO
