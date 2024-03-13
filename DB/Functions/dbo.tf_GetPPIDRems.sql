SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetPPIDRems](@PP int, @OurID int, @StockID int, @SecID int, @ProdID int)
/* 
  Возвращает в порядке, соответсвующем методу списания КЦП и остатки на нем /
  Для методов FIFO, LIFO разбивает количество остатка по приходам
*/
RETURNS @out table(SrcPosID int, DocDate datetime, PPID int, Qty numeric(21,9), RemQty numeric(21, 9))
Begin
INSERT INTO @out
SELECT * FROM
(  
SELECT p.*, 
(SELECT 
  CASE 
    WHEN r.Qty - ISNULL(SUM(p1.Qty), 0) -  r.AccQty > p.Qty THEN p.Qty
    WHEN r.Qty - ISNULL(SUM(p1.Qty), 0) -  r.AccQty < 0 THEN 0
    ELSE r.Qty - ISNULL(SUM(p1.Qty), 0) -  r.AccQty
  END  
FROM dbo.tf_GetPPIDs(@PP, @OurID, @StockID, @SecID, @ProdID) p1 WHERE p1.SrcPosID > p.SrcPosID AND r.PPID = p1.PPID) AS RemQty
FROM dbo.tf_GetPPIDs(@PP, @OurID, @StockID, @SecID, @ProdID) p, 
(SELECT SUM(Qty) Qty, SUM(AccQty) AccQty, PPID FROM t_Rem
WHERE 
  OurID = @OurID AND
  StockID = @StockID AND
  SecID = @SecID AND
  ProdID = @ProdID
GROUP BY PPID
) r
WHERE p.PPID = r.PPID
) q WHERE RemQty > 0 
ORDER BY SrcPosID
RETURN
End 
GO
