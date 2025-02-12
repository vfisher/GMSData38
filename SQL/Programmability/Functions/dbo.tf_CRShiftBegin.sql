SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_CRShiftBegin](@CRID int)
/* Возвращает время начала смены */
RETURNS datetime AS
BEGIN
  DECLARE @LastZRep DATETIME, @CashType int
  SELECT @LastZRep = dbo.tf_LastZRep(@CRID)

  SET @CashType = ISNULL((SELECT CashType FROM r_Crs WITH(NOLOCK) WHERE CRID = @CRID),0)
  IF @CashType = 39 AND EXISTS(SELECT TOP 1 1 FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode = 2)
    SELECT @LastZRep = ISNULL((SELECT TOP 1 DocTime FROM t_CashRegInetCheques WHERE CRID = @CRID AND DocCode IN (2) ORDER BY DocTime DESC), CAST('1900-01-01T00:00:00' AS datetime))

  RETURN 
  (
    SELECT  MIN(DocTime) FROM
    (
      SELECT TOP 1 DocTime FROM t_Sale WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep ORDER BY DocTime ASC
      UNION ALL
      SELECT TOP 1 DocTime FROM t_CRRet WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep ORDER BY DocTime ASC
      UNION ALL
      SELECT TOP 1 DocTime FROM t_MonIntRec WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep ORDER BY DocTime ASC
      UNION ALL
      SELECT TOP 1 DocTime FROM t_MonIntExp WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep ORDER BY DocTime ASC
      UNION ALL
      SELECT TOP 1 DocTime FROM t_CashRegInetCheques WITH(NOLOCK) WHERE CRID = @CRID AND DocTime >= @LastZRep AND DocCode IN (1) ORDER BY DocTime ASC
    ) q
  )
END
GO