# BDTarea3
<h1>Página web .NET</h1>

Pagina web sobre cuenta bancaria. Hay un usuario que puede crear una cuenta bancaria
realziar movimientos como actualizar beneficiarios, eliminar cuenta, ver estado de cuenta.
Para esta etapa del proyecto se debía hacer lo siguiente:
El script de simulación debe calcular intereses diarios a las cuentas de CO.
Procesar intereses de CO: los intereses se acumulan, diariamente, hasta la finalización
de la CO, debe crearse una tabla de MovimientosInteresCO, con créditos todos los
días, el interés en dia que corresponde al ahorro, se calcula previo a depósito de CO (el
ahorro del mes). Se calcula el interés, se crea crédito y se acumula el monto (intereses
acumulados).
En la simulación, su script, cuando procesa un día, antes de realizar el proceso de
estados de cuenta, debe agregar código para ’procesar CO’, el cual tiene 2 partes:
procesar depósitos en CO y procesar redención de CO.
Procesar depósitos en CO: si el día del mes la fecha de operación coincide con el día el
día para ahorrar en CO, debe realizar un débito por retiro de la cuenta de ahorro y por
ese mismo monto, debe realizar un depósito en la CO, el saldo en cuenta de ahorro se
disminuye y el saldo en CO se incrementa. La CO, tendrá su propia tabla de
movimientos (MovimientoCO) y su propia tabla de TipoMovimientoCO, con 3 tipos de
movimientos 1: Depósito por ahorro, 2: Deposito por redención de intereses y, 3:
Redención de la CO. Si el saldo en la cuenta ahorro va a quedar negativo después del
depósito en CO, entonces no se realiza.

Procesar Redención de CO: si la fecha de proceso es igual a la fecha final de la CO. Se
redimen los intereses, esto es, se crea un débito por el monto total de los intereses en
la tabla de movimientos de Intereses (de manera que los intereses acumulados quedan
en cero) y se genera un crédito por el mismo monto en tabla de movimientosCO,
aumentado el saldo. Luego se redime la CO, lo cual consiste en realizar un débito en
MovimientosCO por todo el ahorro (más los intereses) de manera que su saldo queda
en 0, y por ese mismo monto de realiza en depósito en cuenta de ahorro, por el monto
del ahorro total realizado en la CO (más los intereses). La CO se desactiva.
La tabla de movimientosCO tiene la siguiente estructura (id int identity(1,1) primary key,
idTipoMovimiento int, fecha date, monto money, descripción varchar (100)
La tabla de movimientosInteresCO tiene la siguiente estructura (id int identity(1,1)
primary key, idTipoMovimiento int, fecha date, monto money, descripción varchar (100))...
