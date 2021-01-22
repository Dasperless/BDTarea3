	USE ProyectoBD1
	DECLARE @xmlData XML
	--Path Jacob: C:\Users\yeico\Desktop\BDTarea3\XML\Datos-Tarea3.xml
	--Path Dario: C:\Users\dvarg\Desktop\TEC\2020\Segundo Semestre\Bases de datos\Proyectos\Proyecto 3\BDTarea3\XML\Datos-Tarea3.xml
	SET @xmlData = (
			SELECT *
			FROM OPENROWSET(BULK 'C:\Users\yeico\Desktop\BDTarea3\XML\Datos-Tarea3.xml', SINGLE_BLOB) AS xmlData
			)

	--Se declaran las tablas.
	DECLARE @TablaFechasOperacion TABLE (	
		Sec INT identity(1, 1),
		Fecha DATE
		) 

	DECLARE @TablaCuentaCierran TABLE (
		Sec INT identity(1, 1),
		EstadoCuentaId INT
	)

	DECLARE @TablaMovimientos TABLE(
		Sec INT identity(1,1),
		TipoMovimiento INT,
		Monto MONEY,
		Fecha DATE,
		Descripcion VARCHAR(200),
		CuentaAhorroId INT
		)

	DECLARE @TablaCuentaObjetivo TABLE(
		Sec INT IDENTITY(1,1),
		IdCuentaObjetivo INT,
		FechaInicio DATE,
		FechaFin DATE,
		Monto MONEY,
		DiaAhorro INT,
		Saldo MONEY,
		InteresesAcumulados MONEY
	)

	--Se declaran variables.
	DECLARE @CuentaAhorra INT,
			@DiaFechaOperacion INT,
			@DiaAhorro INT,
			@FechaInicioCO DATE,
			@FechaFinalCO DATE,
			@OutMovimientoCuentaObjId INT, 
			@OutNuevoSaldo INT,
			@OutResultCode INT,
			@OutRedimirCuentaObjetivoId INT,
			@OutResultCodeCORedm INT

	DECLARE @fechaOperacion DATE,
			@fechaFinal DATE

	DECLARE @DatosFechaOperacion XML,		--Nodo XML de la fecha de operacion actual
			@CuentaCierra INT			
	DECLARE   --Variables intereses jacob
		@inIdCuentaObjetivoInt INT,    
		@inIdTipoMovObjInt INT,
		@inFechaInt DATE,
		@inMontoInt MONEY,
		@inNuevoIntAcumuladoInt MONEY,
		@OutMovimientoCOInteresesId INT 

	DECLARE	@CuentaId INT,
			@TipoMovimientos INT,
			@Monto MONEY,
			@Fecha DATE,
			@Descripcion VARCHAR(200),
			@OutMovimientoIdMov INT,
			@OutResultCodeMov INT,
			@OutNuevoSaldoMov INT

	DECLARE	@OutMovimientoIdCerrarCuenta INT, 
			@OutResultCodeCerrarCuenta INT

	DECLARE @FechaInicioEC DATE

	--Contadores insertar movimientos
	DECLARE @lo INT,
			@hi INT

	--Contadores cerrar cuentas.
	Declare @lo1 INT,
			@hi1 INT

	--Contadores cerrar cuentas.
	Declare @lo2 INT,
			@hi2 INT

	--Se inicializan las variables.
	INSERT @TablaFechasOperacion (Fecha)
	SELECT ref.value('@Fecha', 'date')
	FROM @xmlData.nodes('Operaciones/FechaOperacion') fechaOperacion(ref)

	SELECT @fechaOperacion = MIN(Fecha)
	FROM @TablaFechasOperacion 

	SELECT @fechaFinal = MAX(Fecha)
	FROM @TablaFechasOperacion

	SELECT @hi = max(Sec)
	FROM @TablaFechasOperacion
	
SET NOCOUNT ON
WHILE @fechaOperacion <= @fechaFinal
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM [dbo].[FechaOperacion]
			WHERE Fecha = @fechaOperacion
			)
		BEGIN
			INSERT INTO [dbo].[FechaOperacion] (Fecha)
			VALUES (@fechaOperacion)
		END;

	--Guardo los datos de un nodo xml si la fecha es igual a la fecha de operacion actual
	SELECT @DatosFechaOperacion = fecha.ref.query('.')
	FROM @xmlData.nodes('Operaciones/FechaOperacion') AS fecha(ref)
	WHERE ref.value('@Fecha', 'date') = @fechaOperacion

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
	FROM @DatosFechaOperacion.nodes('FechaOperacion/Usuario') AS datosUsuario(ref)

	--Se insertan los usuarios puede ver.
	INSERT INTO UsuarioPuedeVer (
		NombreUsuario,
		NumeroCuenta,
		Usuarioid
		)
	SELECT ref.value('@User', 'varchar(100)'),
		ref.value('@Cuenta', 'varchar(100)'),
		U.id
	FROM @DatosFechaOperacion.nodes('FechaOperacion/UsuarioPuedeVer') AS datosUsuarioPuedeVer(ref)
	INNER JOIN Usuario U
		ON U.ValorDocIdentidad = ref.value('@User', 'int')

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
	FROM @DatosFechaOperacion.nodes('FechaOperacion/Persona') AS datosPersona(ref)
	LEFT JOIN Usuario U
		ON U.ValorDocIdentidad = ref.value('@ValorDocumentoIdentidad', 'int')

	--Se insertan las cuentas de ahorro. [Nota]: Un trigger crea el primer estado de cuenta.
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
		@fechaOperacion,
		0
	FROM @DatosFechaOperacion.nodes('FechaOperacion/Cuenta') AS datosCuenta(ref)
	INNER JOIN Persona P
		ON P.ValorDocIdentidad = ref.value('@ValorDocumentoIdentidadDelCliente', 'int')
	
	--Se insertan las cuentas objetivo.
	INSERT INTO CuentaObjetivo (
		IdCuentaAhorro,
		NumeroCuentaPrimaria,
		NumeroCuentaObjetivo,
		MontoAhorro,
		DiaAhorro,
		FechaInicio,
		FechaFin,
		Objetivo,
		Saldo,
		InteresesAcumulados,
		Estado
		)
	SELECT CA.id,
		ref.value('@NumeroCuentaPrimaria', 'int'),
		ref.value('@NumeroCuentaAhorro', 'int'),
		ref.value('@MontoAhorro', 'money'),
		ref.value('@DiaAhorro', 'int'),
		@fechaOperacion,
		ref.value('@FechaFinal', 'date'),
		ref.value('@Descripcion', 'varchar(50)'),
		0,
		0,
		1
	FROM @DatosFechaOperacion.nodes('FechaOperacion/CuentaAhorro') AS datosCuentaObj(ref)
	INNER JOIN CuentaAhorro CA ON CA.NumeroCuenta = ref.value('@NumeroCuentaPrimaria', 'int')

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
	FROM @DatosFechaOperacion.nodes('FechaOperacion/Beneficiario') xmlData(ref)
	INNER JOIN Persona P
		ON P.ValorDocIdentidad = ref.value('@ValorDocumentoIdentidadBeneficiario', 'int')
	INNER JOIN CuentaAhorro C
		ON C.NumeroCuenta = ref.value('@NumeroCuenta', 'int')

	--Se insertan en la tabla movimientos los movimientos de la fecha operacion actual.
	INSERT INTO @TablaMovimientos (
		TipoMovimiento,
		Monto,
		Fecha,
		Descripcion,
		CuentaAhorroId
		)
	SELECT ref.value('@Tipo', 'int'),
		ref.value('@Monto', 'money'),
		@fechaOperacion,
		ref.value('@Descripcion', 'varchar(100)'),
		E.CuentaAhorroid
	FROM @DatosFechaOperacion.nodes('FechaOperacion/Movimientos') AS datosMovimientos(ref)
	JOIN EstadoCuenta E
		ON @fechaOperacion BETWEEN E.FechaInicio AND E.FechaFin
			AND E.NumeroCuenta = ref.value('@CodigoCuenta', 'int')

	--Se inicializa los contadores de la tabla de movimientos.
	SELECT	@lo = MIN(sec),
			@hi = MAX(Sec)
	FROM @TablaMovimientos

	--Se insertan los movimientos 
	WHILE @lo <= @hi
		BEGIN
			--Se asignan los valores a la variables que hay en la tabla de movimientos.
			SELECT	@CuentaId = CuentaAhorroId,
					@TipoMovimientos = TipoMovimiento,
					@Monto = Monto,
					@Fecha = Fecha,
					@Descripcion = Descripcion
			FROM @TablaMovimientos
			WHERE Sec = @lo

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

			SET @lo = @lo + 1
		END;
	-- Se elimina los datos de la tabla movimientos para no insertar movimientos repetidos.
	DELETE @TablaMovimientos 

	--Se insertan los estados de cuenta que cierran el día de la operacion actual en la tabla de @TablaCuentaCierran
	INSERT @TablaCuentaCierran (EstadoCuentaId)
	SELECT id
	FROM EstadoCuenta
	WHERE FechaFin = @fechaOperacion

	--Se inicializan los contadores.
	SELECT	@lo1 = MIN(Sec),
			@hi1 = MAX(sec)
	FROM @TablaCuentaCierran

	--Cierra los estados de cuenta que cierran en la fecha de operacion actual.
	WHILE @lo1 <= @hi1
		BEGIN
			SELECT @CuentaCierra = EstadoCuentaId
			FROM @TablaCuentaCierran
			WHERE sec = @lo1	

			EXEC	[dbo].[CerrarEstadoCuenta]
					@CuentaCierra,
					@OutMovimientoIdCerrarCuenta OUTPUT, 
					@OutResultCodeCerrarCuenta OUTPUT
	
			SELECT @FechaInicioEC = DATEADD(DAY, 1, FechaFin)
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
			
			SET @Lo1 = @Lo1 + 1
		END;
	--Se eliminan las cuentas que cierran para evitar insertar repetidas.
	DELETE @TablaCuentaCierran

	--Se ingresan los datos de las cuentas objetivo que se crean o es el día de ahorro.
	INSERT INTO @TablaCuentaObjetivo (
		IdCuentaObjetivo,
		FechaInicio,
		FechaFin,
		Monto,
		DiaAhorro,
		Saldo,
		InteresesAcumulados
		)
	SELECT CO.id,
		CO.FechaInicio,
		CO.FechaFin,
		CO.MontoAhorro,
		CO.DiaAhorro,
		CO.Saldo,
		CO.InteresesAcumulados
	FROM [dbo].[CuentaObjetivo] CO
	WHERE @fechaOperacion BETWEEN CO.FechaInicio
			AND CO.FechaFin 

	--Se inicializan los contadores de las cuentas objetivo.
	SELECT	@lo2 = MIN(Sec),
			@hi2 = MAX(sec)
	FROM @TablaCuentaObjetivo
	
	WHILE @lo2 <= @hi2
	BEGIN
		SELECT @inIdCuentaObjetivoInt = IdCuentaObjetivo
			,@inIdTipoMovObjInt = 5
			,@inFechaInt = @fechaOperacion
			,@inMontoInt = 0
			,@inNuevoIntAcumuladoInt = InteresesAcumulados
		FROM @TablaCuentaObjetivo
		WHERE Sec = @lo2

		EXEC [dbo].[InsertarMovimientoCOIntereses] @inIdCuentaObjetivoInt
			,@inIdTipoMovObjInt
			,@inFechaInt
			,@inMontoInt
			,@inNuevoIntAcumuladoInt
			,@OutMovimientoCOInteresesId OUTPUT
			,@OutResultCode OUTPUT

		SET @Lo2 = @Lo2 + 1
	END;

	--Se inicializan los contadores de las cuentas objetivo.
	SELECT	@lo2 = MIN(Sec),
			@hi2 = MAX(sec)
	FROM @TablaCuentaObjetivo

	--Se Procesan las cuentas objetivo.
	WHILE @lo2 <= @hi2
		BEGIN
			SELECT	@CuentaAhorra = IdCuentaObjetivo,
					@FechaInicioCO = FechaInicio,
					@FechaFinalCO = FechaFin,
					@Monto = Monto,
					@DiaAhorro = DiaAhorro
			FROM @TablaCuentaObjetivo
			WHERE Sec = @lo2

			SET @DiaFechaOperacion = DATEPART(DAY, @fechaOperacion)

			IF(@fechaOperacion = @FechaFinalCO) --SI LA FECHA DE OPERACION ES IGUAL A LA FECHA FINAL DE LA CO SE REDIME.
				BEGIN
					EXEC [dbo].[RedimirCuentaObjetivo] 
						@CuentaAhorra,
						@fechaOperacion, 
						@OutRedimirCuentaObjetivoId OUTPUT,
						@OutResultCodeCORedm OUTPUT
				END;

			--INSERTA MOVIMIENTOS EN LA CUENTA OBJETIVO SI ES EL DIA DE AHORRO O ES EL ULTIMO DIA DEL MES Y EL DIA DE AHORRO ES MAYOR.
			IF(@DiaFechaOperacion = @DiaAhorro OR (@fechaOperacion = EOMONTH(@fechaOperacion) AND @DiaAhorro > @DiaFechaOperacion))
				BEGIN
					EXEC [dbo].[InsertarMovimientoCuentaObjetivo]
							@CuentaAhorra, 
							1, 
							@fechaOperacion, 
							@Monto, 
							@OutMovimientoCuentaObjId OUTPUT, 
							@OutNuevoSaldo OUTPUT, 
							@OutResultCode OUTPUT
				END;
			SET @Lo2 = @Lo2 + 1
		END;
	DELETE @TablaCuentaObjetivo

	SET @fechaOperacion  = DATEADD(DAY, 1, @fechaOperacion)
END;
SELECT * FROM Errores ORDER BY GETDATE DESC
--SELECT * FROM Usuario
--SELECT * FROM UsuarioPuedeVer
--SELECT * FROM Persona
--SELECT * FROM Beneficiarios
--SELECT * FROM CuentaAhorro CA
--Join [dbo].[MovimientoCuentaAhorro] MCA
--ON MCA.CuentaAhorroid = Ca.id
--WHERE CA.NumeroCuenta = 86073678 
--SELECT * FROM MovCuentaObj

--CUENTA OBJETIVO, MOVIMIENTOS DE LA CUENTA OBJETIVO, MOVIMIENTOS DE LA CUENTA OBJETIVO INTERESES, TIPO DE MOVIMIENTO OBJ INT
SELECT * FROM CuentaObjetivo CO
JOIN MovCuentaObj M 
	ON M.IdCuentaObjetivo = CO.id
JOIN TMovCuentaObj TM
	ON TM.id = M.IdTipoMovObj 
--JOIN MovCuentaObjIntereses MCI
--	ON MCI.IdCuentaObjetivo = Co.id
--JOIN TMovCuentaObjIntereses TMI
--	ON TMi.id = MCI.IdTipoMovObj
--WHERE MCI.Monto > 0
ORDER BY IdCuentaAhorro ASC

--CUENTA AHORRO, MOVIMIENTOS CUENTA AHORRO, TIPO DE MOVIMIENTO CUENTA AHORRO
SELECT * FROM CuentaAhorro CA
JOIN MovimientoCuentaAhorro MCA
	ON MCA.CuentaAhorroid = CA.id
JOIN TipoMovimientoCuentaAhorro TM
	ON TM.id = MCA.TipoMovimientoCuentaAhorroid
--WHERE MCA.TipoMovimientoCuentaAhorroid = 11 OR MCA.TipoMovimientoCuentaAhorroid = 10
ORDER BY CA.id ASC

--SELECT * FROM EstadoCuenta
--SELECT * FROM MovimientoCuentaAhorro 
--SELECT * FROM MovCuentaObjIntereses
--SELECT * FROM FechaOperacion

SELECT * FROM Eventos E
Where idTipoEvento = 5


--DELETE Eventos
--DELETE Usuario	
--DELETE CuentaObjetivo
--DELETE UsuarioPuedeVer
--DELETE EstadoCuenta
--DELETE MovimientoCuentaAhorro
--DELETE MovCuentaObj
--DELETE CuentaAhorro
--DELETE Persona
--DELETE Beneficiarios
--DELETE FechaOperacion
--DELETE MovCuentaObjIntereses
	
--SELECT * FROM [dbo].[Errores]
--SELECT * FROM TMovCuentaObj