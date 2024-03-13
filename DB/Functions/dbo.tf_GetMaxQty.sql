SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetMaxQty](@OurID int, @StockID int, @SecID int, @ProdID int, @DocAutoPP int)
/* Возвращает максимальное с учетом настроек (@DocAutoPP - возмножность использовать автосписание с разный партий) */
RETURNS numeric(21, 9) AS
Begin
  RETURN
    ISNULL(
      CASE
        WHEN dbo.zf_Var('t_AutoPP') = '1' AND @DocAutoPP = 1 THEN
          (SELECT SUM(Qty - AccQty) FROM t_Rem WHERE OurID = @OurID AND StockID = @StockID AND SecID = @SecID AND ProdID = @ProdID)
        ELSE 0
      END
    , 0)
End 
GO
