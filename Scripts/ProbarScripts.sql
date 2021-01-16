DECLARE
 @OutListadoBeneficiariosId INT
 ,@OutResultCode INT
EXEC [dbo].[Consulta3]
@OutListadoBeneficiariosId OUTPUT,
@OutResultCode OUTPUT

SELECT @OutListadoBeneficiariosId, @OutResultCode
select * from errores 
