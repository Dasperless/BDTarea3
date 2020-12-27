  USE ProyectoBD1
  GO
  CREATE OR ALTER FUNCTION [dbo].[CalcularInteres] (@inSaldo MONEY, @inInteres INT)         
    RETURNS  MONEY
    BEGIN 
		--Se declaran las variables
		DECLARE @Resultado MONEY
		DECLARE @InteresMensual FLOAT
		DECLARE @PorcentajeInteres FLOAT

		SET @InteresMensual  = @inInteres/12.00
		SET @PorcentajeInteres = @InteresMensual/100.00

		SET @Resultado =  @inSaldo * @PorcentajeInteres
    RETURN @Resultado; 
  END 
