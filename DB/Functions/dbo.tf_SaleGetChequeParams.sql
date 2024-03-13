SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_SaleGetChequeParams](@ChID bigint)
/* Возвращает параметры чека */
RETURNS @out table(OurID int, StockID int, SecID int, CRID int)
Begin
  INSERT INTO @OUT
  SELECT TOP 1 s.OurID, c.StockID, c.SecID, m.CRID 
  FROM t_SaleTemp m WITH(NOLOCK), r_CRs c WITH(NOLOCK), r_CRSrvs s  WITH(NOLOCK) 
  WHERE m.ChID = @ChID
  AND   m.CRID = c.CRID
  AND   c.SrvID = s.SrvID 
  RETURN
End
GO
