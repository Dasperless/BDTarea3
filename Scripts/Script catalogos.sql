USE ProyectoBD1
--Se lee el archivo XML   Ruta: C:\Users\yeico\Desktop\BDTarea2\XML\catalogos.xml jacob
DECLARE @xmlData XML

SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\dvarg\Desktop\TEC\2020\Segundo Semestre\Bases de datos\Proyectos\Proyecto 3\BDTarea3\XML\Datos-Tarea3-Catalogos.xml', SINGLE_BLOB) AS xmlData
		)

--Inserta el tipo de documento de indentidad de los xml
INSERT INTO TipoDocIdentidad (
	id,
	Nombre
	)
SELECT ref.value('@Id', 'int'),
	ref.value('@Nombre', 'VARCHAR(100)')
FROM @xmlData.nodes('Catalogos/TipoDoc/TipoDocuIdentidad') xmlData(ref)
LEFT JOIN TipoDocIdentidad TD
	ON TD.id = ref.value('@Id', 'int')
WHERE TD.id IS NULL

--Inserta los tipos de moneda
INSERT INTO TipoMoneda (
	id,
	Nombre,
	Simbolo
	)
SELECT ref.value('@Id', 'int'),
	ref.value('@Nombre', 'VARCHAR(100)'),
	ref.value('@Simbolo', 'char(10)')
FROM @xmlData.nodes('Catalogos/TipoMoneda/TipoMoneda') xmlData(ref)
LEFT JOIN TipoMoneda TM
	ON TM.id = ref.value('@Id', 'int')
WHERE TM.id IS NULL

--Inserta los datos de parentezco.
INSERT INTO Parentezco (
	ID,
	NOMBRE
	)
SELECT ref.value('@Id', 'int'),
	ref.value('@Nombre', 'VARCHAR(100)')
FROM @xmlData.nodes('Catalogos/Parentezcos/Parentezco') xmlData(ref)
LEFT JOIN Parentezco P
	ON P.id = ref.value('@Id', 'int')
WHERE P.id IS NULL

--Crea el catalogo de los tipos de cuenta de ahorro.
INSERT INTO TipoCuentaAhorro (
	id,
	Nombre,
	IdTipoMoneda,
	SaldoMinimo,
	MultaSaldoMin,
	CargoAnual,
	NumRetirosHumano,
	NumRetirosAutomatico,
	ComisionHumano,
	ComisionAutomatico,
	Interes
	)
SELECT ref.value('@Id', 'int'),
	ref.value('@Nombre', 'varchar(100)'),
	ref.value('@IdTipoMoneda', 'int'),
	ref.value('@SaldoMinimo', 'money'),
	ref.value('@MultaSaldoMin', 'float'),
	ref.value('@CargoMensual', 'float'),
	ref.value('@NumRetiroHumano', 'int'),
	ref.value('@NumRetirosAutomatico', 'int'),
	ref.value('@ComisionHumano', 'int'),
	ref.value('@ComisionAutomatico', 'int'),
	ref.value('@Interes', 'int')
FROM @xmlData.nodes('Catalogos/Tipo_Cuenta_Ahorro/TipoCuentaAhorro') xmlData(ref)
LEFT JOIN TipoCuentaAhorro TC
	ON TC.id = ref.value('@Id', 'int')
WHERE TC.id IS NULL

--Crea el catalogo de los tipos de movimientos de una cuenta de ahorro
INSERT INTO TipoMovimientoCuentaAhorro (
	id,
	Nombre,
	TipoOperacion
	)
SELECT ref.value('@Id', 'int'),
	ref.value('@Nombre', 'varchar(50)'),
	ref.value('@Tipo', 'varchar(50)')
FROM @xmlData.nodes('Catalogos/TipoMovimientos/TipoMovimiento ') xmlData(ref)
LEFT JOIN TipoMovimientoCuentaAhorro TM
	ON TM.id = ref.value('@Id', 'int')
WHERE TM.id IS NULL

INSERT INTO TMovCuentaObjIntereses(
		id,
		Descripcion
	)
SELECT ref.value('@Id', 'INT'),
	ref.value('@Nombre', 'varchar(50)')
FROM @xmlData.nodes('Catalogos/TiposMovimientoCuentaAhorro/Tipo_Movimiento ') xmlData(ref)
LEFT JOIN TMovCuentaObjIntereses TMCuentaObjInt
	ON TMCuentaObjInt.id = ref.value('@Id', 'int')
WHERE TMCuentaObjInt.id IS NULL

--Crea el catalogo con los tipos de movimiento de las cuentas objetivo. 
INSERT INTO TMovCuentaObj (
	id,
	Descripcion
	)
SELECT ref.value('@Id', 'INT'),
	ref.value('@Nombre', 'varchar(50)')
FROM @xmlData.nodes('Catalogos/TiposMovimientoCuentaAhorro/Tipo_Movimiento ') xmlData(ref)
LEFT JOIN TMovCuentaObj TMCuentaObj
	ON TMCuentaObj.id = ref.value('@Id', 'int')
WHERE TMCuentaObj.id IS NULL

--Crea el catalgo con los tipos de eventos 
INSERT INTO TiposEvento (
	Id,
	Nombre
	)
SELECT ref.value('@Id', 'INT'),
	ref.value('@Nombre', 'varchar(50)')
FROM @xmlData.nodes('Catalogos/TiposEvento/TipoEvento') xmlData(ref)
LEFT JOIN TiposEvento TEventos
	ON TEventos.id = ref.value('@Id', 'int')
WHERE TEventos.id IS NULL

SELECT * FROM TipoDocIdentidad
SELECT * FROM TipoMoneda
SELECT * FROM Parentezco
SELECT * FROM TipoCuentaAhorro
SELECT * FROM TipoMovimientoCuentaAhorro
SELECT * FROM TMovCuentaObjIntereses
SELECT * FROM TMovCuentaObj
SELECT * FROM TiposEvento

--DELETE TipoDocIdentidad
--DELETE TipoMoneda
--DELETE Parentezco
--DELETE TipoCuentaAhorro
--DELETE TipoMovimientoCuentaAhorro
--DELETE TMovCuentaObj
--DELETE TiposEvento
