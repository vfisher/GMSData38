SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetSpecListSubs] (@ChID bigint)
/* Возвращает список составляющих для калькуляционной карты с учетом рекурсии */
RETURNS @out TABLE(ProdID int, Qty numeric(21, 9), PriceCC numeric(21, 9), SumCC numeric(21, 9))
BEGIN
  DECLARE
    @DocDate smalldatetime, 
    @ProdID int, 
    @OurID int, 
    @StockID int, 
    @SubStockID int

  SELECT @OurID = OurID,@ProdID = ProdID
  FROM t_Spec WITH (NOLOCK)
  WHERE ChID = @ChID 

  SELECT @StockID = StockID, @DocDate = ProdDate
  FROM t_SpecParams WITH (NOLOCK)
  WHERE ChID = @ChID

  SELECT @SubStockID = SubStockID
  FROM r_StockSubs ss WITH (NOLOCK)
  INNER JOIN r_Stocks s WITH (NOLOCK) ON ss.StockID = @StockID AND s.StockID = @StockID
  INNER JOIN r_ProdMP mp WITH (NOLOCK) ON mp.ProdID = @ProdID AND ss.DepID = mp.DepID

  INSERT INTO @out
  SELECT 
     ProdID, Qty, 
     dbo.tf_GetDateCostCC(@OurID, @SubStockID, @DocDate, ProdID, 0) PriceCC, 
     Qty * dbo.tf_GetDateCostCC(@OurID, @SubStockID, @DocDate, ProdID, 0) SumCC   
  FROM dbo.tf_GetSpecSubs(@OurID, @SubStockID, @DocDate, @ProdID, 1)
  RETURN
END
GO
