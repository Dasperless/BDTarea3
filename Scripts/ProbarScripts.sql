DECLARE
 @outPersonaId INT
 , @OutResultCode INT
EXEC dbo.SeleccionarPersona
6,

@outPersonaId OUTPUT,
@OutResultCode OUTPUT

SELECT @outPersonaId, @OutResultCode
select * from errores 