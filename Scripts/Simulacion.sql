USE ProyectoBD1
--Se guarda en xmlData el .XML
DECLARE @xmlData XML
-- Nota: cambiar el path del from C:\Users\yeico\Desktop\BDTarea2\XML\catalogos.xml
SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\dvarg\Desktop\TEC\2020\Segundo Semestre\Bases de datos\Proyectos\Proyecto 2\BDTarea2\XML\Datos_Tarea_2.xml', SINGLE_BLOB) AS xmlData
		)

--Tabla con las fechas que se van a procesar
DECLARE @FechasProcesar TABLE (
	Sec INT identity(1, 1),
	Fecha DATE
	) 

INSERT @FechasProcesar (Fecha)
SELECT ref.value('@Fecha', 'date')
FROM @xmlData.nodes('Operaciones/FechaOperacion') xmlData(ref)

DECLARE @fechaOperacionActual DATE	
DECLARE @FechaOperacionXML XML		--Nodo XML de la fecha de operacion actual
DECLARE @CuentaCierra INT			--Cuenta que cierra en la fecha de operacion

--Tablas con cierre de las cuentas.
DECLARE @CuentasCierran TABLE (
	Sec INT identity(1, 1),
	EstadoCuentaId INT
	)

--Tabla de movimientos
DECLARE @TablaMovimientos TABLE(
	Sec INT identity(1,1),
	TipoMovimiento INT,
	Monto MONEY,
	Fecha DATE,
	Descripcion VARCHAR(200),
	CuentaAhorroId INT
	)

--Variables para insertar movimientos
DECLARE	@CuentaId INT,
		@TipoMovimientos INT,
		@Monto MONEY,
		@Fecha DATE,
		@Descripcion VARCHAR(200),
		@OutMovimientoIdMov INT,
		@OutResultCodeMov INT,
		@OutNuevoSaldoMov INT

--Output del SP de cerrar cuenta. 
DECLARE	@OutMovimientoIdCerrarCuenta INT, 
		@OutResultCodeCerrarCuenta INT

--Fecha fin estado de cuenta anterior.
DECLARE @FechaInicioEC DATE

--Contadores insertar datos XML
DECLARE @lo INT = 1,
		@hi INT	

--Contadores insertar movimientos
DECLARE @lo1 INT,
		@hi1 INT

--Contadores cerrar cuentas
Declare @lo2 INT,
		@hi2 INT

--Se le inicializa el contador @hi
SELECT @hi = max(Sec)
FROM @FechasProcesar

SET NOCOUNT ON
WHILE @lo <= @hi
BEGIN
	--Se le asigna la fecha actual a procesar a @fechaOperacionACtual
	SELECT @fechaOperacionActual = F.Fecha
	FROM @FechasProcesar F
	WHERE F.sec = @lo

	--Guardo los datos de un nodo xml si la fecha es igual a la fecha de operacion actual
	SELECT @FechaOperacionXML = xmlData.ref.query('.')
	FROM @xmlData.nodes('Operaciones/FechaOperacion') AS xmlData(ref)
	WHERE ref.value('@Fecha', 'date') = @fechaOperacionActual

	--Se insertan los usuarios
	INSERT INTO Usuario (
		NombreUsuario,
		Pass,
		ValorDocIdentidad,
		EsAdmi
		)
	SELECT ref.value('@User', 'varchar(50)'),
		ref.value('@Pass', 'varchar(50)'),
		ref.value('@ValorDocumentoIdentidad', 'int'),
		ref.value('@EsAdministrador', 'bit')
	FROM @FechaOperacionXML.nodes('FechaOperacion/Usuario') xmlData(ref)

	--Se insertan los usuarios puede ver.
	INSERT INTO UsuarioPuedeVer (
		NombreUsuario,
		NumeroCuenta,
		Usuarioid
		)
	SELECT ref.value('@User', 'varchar(100)'),
		ref.value('@NumeroCuenta', 'varchar(100)'),
		U.id
	FROM @FechaOperacionXML.nodes('FechaOperacion/UsuarioPuedeVer') xmlData(ref)
	INNER JOIN Usuario U
		ON U.NombreUsuario = ref.value('@User', 'varchar(100)')

	--Se insertan las personas.
	INSERT INTO Persona (
		Nombre,
		ValorDocIdentidad,
		Email,
		FechaNacimiento,
		Telefono1,
		Telefono2,
		TipoDocIdentidadid,
		Usuarioid
		)
	SELECT ref.value('@Nombre', 'varchar(100)'),
		ref.value('@ValorDocumentoIdentidad', 'int'),
		ref.value('@Email', 'varchar(100)'),
		ref.value('@FechaNacimiento', 'date'),
		ref.value('@Telefono1', 'int'),
		ref.value('@Telefono2', 'int'),
		ref.value('@TipoDocuIdentidad', 'int'),
		U.id
	FROM @FechaOperacionXML.nodes('FechaOperacion/Persona') xmlData(ref)
	LEFT JOIN Usuario U
		ON U.ValorDocIdentidad = ref.value('@ValorDocumentoIdentidad', 'int')

	--Se insertan las cuentas de ahorro y el trigger crea el primer estado de cuenta.
	INSERT INTO CuentaAhorro (
		Personaid,
		TipoCuentaId,
		NumeroCuenta,
		FechaCreacion,
		Saldo
		)
	SELECT P.id,
		ref.value('@TipoCuentaId', 'int'),
		ref.value('@NumeroCuenta', 'int'),
		@fechaOperacionActual,
		0
	FROM @FechaOperacionXML.nodes('FechaOperacion/Cuenta') xmlData(ref)
	INNER JOIN Persona P
		ON P.ValorDocIdentidad = ref.value('@ValorDocumentoIdentidadDelCliente', 'int')

	--Se insertan los beneficiarios.
	INSERT INTO Beneficiarios (
		Personaid,
		CuentaAhorroid,
		NumeroCuenta,
		ValorDocumentoIdentidadBeneficiario,
		ParentezcoId,
		Porcentaje,
		Activo,
		FechaDesactivacion
		)
	SELECT P.id,
		C.id,
		C.NumeroCuenta,
		P.ValorDocIdentidad,
		ref.value('@ParentezcoId', 'int'),
		ref.value('@Porcentaje', 'int'),
		1,
		NULL
	FROM @FechaOperacionXML.nodes('FechaOperacion/Beneficiario') xmlData(ref)
	INNER JOIN Persona P
		ON P.ValorDocIdentidad = ref.value('@ValorDocumentoIdentidadBeneficiario', 'int')
	INNER JOIN CuentaAhorro C
		ON C.NumeroCuenta = ref.value('@NumeroCuenta', 'int')

	--Se insertan en la tabla movimientos los datos de la fecha operacion actual.
	INSERT INTO @TablaMovimientos (
		TipoMovimiento,
		Monto,
		Fecha,
		Descripcion,
		CuentaAhorroId
		)
	SELECT ref.value('@Tipo', 'int'),
		ref.value('@Monto', 'money'),
		@fechaOperacionActual,
		ref.value('@Descripcion', 'varchar(100)'),
		E.CuentaAhorroid
	FROM @FechaOperacionXML.nodes('FechaOperacion/Movimientos') xmlData(ref)
	JOIN EstadoCuenta E
		ON E.FechaInicio = @fechaOperacionActual
			AND E.NumeroCuenta = ref.value('@CodigoCuenta', 'int')

	--Se inicializa los contadores para 
	SELECT	@lo1 = MIN(sec),
			@hi1 = MAX(Sec)
	FROM @TablaMovimientos

	--Se insertan los movimientos 
	WHILE @lo1 <= @hi1
		BEGIN
			--Se asignan los valores a la variables que hay en la tabla de movimientos.
			SELECT	@CuentaId = CuentaAhorroId,
					@TipoMovimientos = TipoMovimiento,
					@Monto = Monto,
					@Fecha = Fecha,
					@Descripcion = Descripcion
			FROM @TablaMovimientos
			WHERE Sec = @lo1

			--Procedimiento que inserta los movimientos.
			EXEC	[dbo].[InsertarMovimientos]
					@CuentaId, 
					@TipoMovimientos, 
					@Monto, 
					@Fecha, 
					@Descripcion, 
					@OutMovimientoIdMov OUTPUT, 
					@OutResultCodeMov OUTPUT,
					@OutNuevoSaldoMov OUTPUT

			SET @Lo1 = @Lo1 + 1
		END;
	DELETE @TablaMovimientos -- Se elimina los datos de la tabla movimientos.

	--Se insertan los estados de cuenta que cierran el día de la operacion actual en la tabla de @CuentasCierran
	INSERT @CuentasCierran (EstadoCuentaId)
	SELECT id
	FROM EstadoCuenta
	WHERE FechaFin = @fechaOperacionActual

	--Se inicializan los contadores.
	SELECT	@lo2 = MIN(Sec),
			@hi2 = max(sec)
	FROM @CuentasCierran

	--Cierra los estados de cuenta que cierran en la fecha de operacion actual.
	WHILE @lo2 <= @hi2
		BEGIN
			--Id del estado de cuenta que cierra la fecha de operacion actual.
			SELECT @CuentaCierra = EstadoCuentaId
			FROM @CuentasCierran
			WHERE sec = @lo2	

			--Cierra los estados de cuenta que cierran la fecha de operacion actual.
			EXEC	[dbo].[CerrarEstadoCuenta]
					@CuentaCierra,
					@OutMovimientoIdCerrarCuenta OUTPUT, 
					@OutResultCodeCerrarCuenta OUTPUT
			
			--SELECT @OutResultCodeCerrarCuenta

			SELECT @FechaInicioEC = DATEADD(DAY,1,FechaFin)
			FROM [dbo].[EstadoCuenta]
			WHERE id = @CuentaCierra

			--Inserta el estado de cuenta del mes siguiente.	
			INSERT INTO [dbo].[EstadoCuenta](
				CuentaAhorroid
				,NumeroCuenta
				,FechaInicio
				,FechaFin
				,SaldoInicial
				,SaldoFinal
				,SaldoMinimo
				,RetirosCA
				,RetirosCH
			)
			SELECT	CA.id
					,CA.NumeroCuenta
					,@FechaInicioEC
					,DATEADD(DAY,-1, DATEADD(month, 1, @FechaInicioEC))
					,CA.Saldo
					,0
					,Ca.Saldo
					,0
					,0
			FROM [dbo].[CuentaAhorro] CA
			INNER JOIN [dbo].[EstadoCuenta] EC ON EC.id = @CuentaCierra
			WHERE CA.id = EC.CuentaAhorroid
			
			SET @Lo2 = @Lo2 + 1
		END;
	DELETE @CuentasCierran

	SET @lo = @lo + 1
END;

--SELECT * FROM Usuario
--SELECT * FROM UsuarioPuedeVer
--SELECT * FROM Persona
--SELECT * FROM Beneficiarios
SELECT * FROM CuentaAhorro WHERE id = 7993
SELECT * FROM EstadoCuenta WHERE CuentaAhorroid = 7993
SELECT * FROM MovimientoCuentaAhorro Where CuentaAhorroid =7993

--DELETE Usuario
--DELETE UsuarioPuedeVer
--DELETE EstadoCuenta
--DELETE MovimientoCuentaAhorro
--DELETE CuentaAhorro
--DELETE Persona
--DELETE Beneficiarios