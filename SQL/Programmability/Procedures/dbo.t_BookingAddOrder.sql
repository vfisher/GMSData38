SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_BookingAddOrder](@AXML XML)
AS
BEGIN
 /*
<?xml version="1.0"?>
<datapack version="1">
		<order id="123" date="2014-10-23 12:30">
			<client id="1" email="test@test.com" phone="380123456789"  name="Коля"/> 
  	        <service id="7" bdate="2014-10-23 12:30" edate="2014-10-23 13:30"  executor="1" resource="2"  stock="1"/>  
			<service id="7" bdate="2014-10-23 14:30" edate="2014-10-23 15:30"  executor="2" resource="9"  stock="2"/>  
			<service id="6" bdate="2014-10-23 18:30" edate="2014-10-23 19:30" />  
		</order> 
</datapack>'
 */
  DECLARE @OrderID INT
  DECLARE @OrderDate DATETIME
  DECLARE @id INT
  DECLARE @email nvarchar(50)  
  DECLARE @phone nvarchar(50)  
  DECLARE @name nvarchar(50)   
  DECLARE @ChID bigint
  DECLARE @SrcPosID int

  DECLARE Cur CURSOR FAST_FORWARD FOR
  SELECT 
    client.value('../@id', 'int') as OrderID,
    client.value('../@date', 'datetime') as OrderDate, 
    client.value('@id', 'int') as id,
    client.value('@email', 'nvarchar(50)') as email,
    client.value('@phone', 'nvarchar(50)') as phone,
    client.value('@name', 'nvarchar(50)') as name
  FROM @AXML.nodes('/datapack/order/client') col(client)

  OPEN Cur
  IF @@ERROR <> 0 GOTO Error  

  FETCH NEXT FROM Cur INTO @OrderID, @OrderDate, @id, @email, @phone, @name
  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF NOT (EXISTS(SELECT * FROM t_BookingTemp WHERE OrderID = @OrderID) OR EXISTS(SELECT * FROM t_Booking WHERE OrderID = @OrderID))
        BEGIN
    		  BEGIN TRAN      
    		  EXEC z_NewChID 't_BookingTemp', @ChID OUTPUT
    		  IF @@ERROR <> 0 GOTO ERROR

    		  INSERT INTO t_BookingTemp (ChID, DocID, OrderID, DocCreateTime, EMail, Phone, PersonName)
    		  VALUES (@ChID, @ChID, @OrderID, @OrderDate, @email, @phone, @name)
    		  IF @@ERROR <> 0 GOTO Error      

    		  INSERT INTO t_BookingTempD (ChID, SrcPosID, StockID, SrvcID, BTime, ETime, ExecutorID, ResourceID)
    		  SELECT 
    			@ChID,
    			rank() over (order by service.value('@bdate', 'datetime') desc) as RANK,
    			service.value('@stock', 'int') as StockId,
    			service.value('@id', 'int') as id,
    			service.value('@bdate', 'datetime') as BTime,
    			service.value('@edate', 'datetime') as ETime,
    			service.value('@executor', 'int') as ExecutorId,
    			service.value('@resource', 'int') as ResourceId	
    		  FROM @AXML.nodes('/datapack/order/service') col(service)
    		  WHERE service.value('../@id', 'int') = @OrderID	  
    		  IF @@ERROR <> 0 GOTO Error     

    		  COMMIT
    		  IF @@ERROR <> 0 GOTO Error
        END

      FETCH NEXT FROM Cur INTO @OrderID, @OrderDate, @id, @email, @phone, @name
    END

  CLOSE Cur
  DEALLOCATE Cur
  RETURN

Error:
  ROLLBACK
  CLOSE Cur
  DEALLOCATE Cur
END
GO