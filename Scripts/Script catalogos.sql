USE ProyectoBD1
--Se lee el archivo XML   Ruta: C:\Users\yeico\Desktop\BDTarea2\XML\catalogos.xml jacob
DECLARE @xmlData XML

SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\dvarg\Desktop\TEC\2020\Segundo Semestre\Bases de datos\Proyectos\Proyecto 2\BDTarea2\XML\Datos_Tarea_2_Catalogos.xml', SINGLE_BLOB) AS xmlData
		)


--Inserta el tipo de documento de indentidad de los xml
INSERT INTO TipoDocIdentidad (id, Nombre )
SELECT	ref.value('@Id', 'int')
		,ref.value('@Nombre', 'VARCHAR(100)')
FROM @xmlData.nodes('Catalogos/Tipo_Doc/TipoDocuIdentidad') xmlData(ref)
LEFT JOIN TipoDocIdentidad TD on TD.id =  ref.value('@Id', 'int')
WHERE TD.id IS NULL

--Inserta los tipos de moneda
INSERT INTO TipoMoneda (id, Nombre, Simbolo)
SELECT	ref.value('@Id', 'int')
		,ref.value('@Nombre', 'VARCHAR(100)')
		,ref.value('@Simbolo', 'char(10)')
FROM @xmlData.nodes('Catalogos/Tipo_Moneda/TipoMoneda') xmlData(ref)
LEFT JOIN TipoMoneda TM on TM.id =  ref.value('@Id', 'int')
WHERE TM.id IS NULL

--Inserta los Catalogos del parentezco
INSERT INTO Parentezco (ID, NOMBRE)
SELECT	ref.value('@Id', 'int')
		,ref.value('@Nombre', 'VARCHAR(100)')
FROM @xmlData.nodes('Catalogos/Parentezcos/Parentezco') xmlData(ref)
LEFT JOIN Parentezco P on P.id =  ref.value('@Id', 'int')
WHERE P.id IS NULL

--Inserta los datos de tipo de cuenta ahorro
INSERT INTO TipoCuentaAhorro (
	id
	,Nombre
	,IdTipoMoneda
	,SaldoMinimo
	,MultaSaldoMin
	,CargoAnual
	,NumRetirosHumano
	,NumRetirosAutomatico
	,ComisionHumano
	,ComisionAutomatico
	,Interes
	)
SELECT	ref.value('@Id', 'int')
		,ref.value('@Nombre', 'varchar(100)')
		,ref.value('@IdTipoMoneda', 'int')
		,ref.value('@SaldoMinimo', 'money')
		,ref.value('@MultaSaldoMin', 'float')
		,ref.value('@CargoMensual', 'float')
		,ref.value('@NumRetirosHumano', 'int')
		,ref.value('@NumRetirosAutomatico', 'int')
		,ref.value('@ComisionHumano', 'int')
		,ref.value('@ComisionAutomatico', 'int')
		,ref.value('@Interes', 'int')
FROM @xmlData.nodes('Catalogos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') xmlData(ref)
LEFT JOIN TipoCuentaAhorro TC on TC.id =  ref.value('@Id', 'int')
WHERE TC.id IS NULL

INSERT INTO TipoMovimientoCuentaAhorro(
		id
		,Nombre
		,TipoOperacion
	)
SELECT	ref.value('@Id', 'int')
		,ref.value('@Nombre', 'varchar(50)')
		,ref.value('@Tipo', 'varchar(50)')
FROM @xmlData.nodes('Catalogos/Tipo_Movimientos/Tipo_Movimiento ') xmlData(ref)
LEFT JOIN TipoMovimientoCuentaAhorro TM ON TM.id = ref.value('@Id', 'int')
WHERE TM.id IS NULL

SELECT * FROM TipoDocIdentidad
SELECT * FROM TipoMoneda
SELECT * FROM Parentezco
SELECT * FROM TipoCuentaAhorro
SELECT * FROM TipoMovimientoCuentaAhorro