SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetLastCRTime](@CRID int, @UseZRep bit)
/* Возвращает время последнего документа фискального регистратора */
RETURNS datetime
AS
BEGIN
  DECLARE @CashType INT, @DocTime DATETIME
  SET @DocTime =
  (SELECT MAX(DocTime) FROM
      (
        SELECT MAX(DocTime) AS DocTime FROM t_Sale WHERE CRID = @CRID
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_ZRep WHERE CRID = @CRID AND @UseZRep = 1
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_CRRet WHERE CRID = @CRID
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_MonIntRec WHERE CRID = @CRID
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_MonIntExp WHERE CRID = @CRID
      ) q
  )

  SET @CashType =  ISNULL((SELECT TOP 1 CashType FROM r_Crs WHERE CRID = @CRID),0)  
  IF @CashType = 39
    SET @DocTime =	
   (
    SELECT MAX(DocTime) FROM
      (
      	SELECT MAX(DocTime) AS DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11035
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11951 AND @UseZRep = 1
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11004
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11051
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 11052
        UNION ALL
        SELECT MAX(DocTime) AS DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 1
      ) q
   )	

  RETURN @DocTime
END
GO