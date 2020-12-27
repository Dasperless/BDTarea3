CREATE TRIGGER NombreDelTrigger  
on concepto 
FOR UPDATE 
AS
	DECLARE @idVenta int = (SELECT idVenta FROM INSERTED)
	UPDATE venta SET total = (SELECT SUM(precio)FROM concepto WHERE idVenta = @idVenta)
	where id=@idVenta