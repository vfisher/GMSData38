SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_LastZRep](@CRID int)
/* Возвращает время последнего Z-отчета */
RETURNS datetime AS
BEGIN
  DECLARE @CashType INT, @DocTime DATETIME

  SET @CashType =  ISNULL((SELECT TOP 1 CashType FROM r_Crs WHERE CRID = @CRID),0)  
  IF @CashType = 39 AND EXISTS(SELECT TOP 1 1 FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11951)
    SET @DocTime = ISNULL((SELECT TOP 1 DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11951 ORDER BY DocTime DESC), CAST('1900-01-01T00:00:00' AS datetime))
  ELSE
    SET @DocTime = ISNULL((SELECT TOP 1 DocTime FROM t_zRep WHERE CRID = @CRID ORDER BY DocTime DESC), CAST('1900-01-01T00:00:00' AS datetime))	    
  RETURN @DocTime 
END
GO