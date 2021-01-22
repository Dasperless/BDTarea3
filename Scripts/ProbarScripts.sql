DECLARE
 @OutCuentasObjetivosIncompletasId INT
 ,@OutResultCode INT
EXEC [dbo].[Consulta1]
@OutCuentasObjetivosIncompletasId OUTPUT,
@OutResultCode OUTPUT

SELECT @OutCuentasObjetivosIncompletasId, @OutResultCode
select * from errores 
