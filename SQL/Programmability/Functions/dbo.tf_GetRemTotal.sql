SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetRemTotal](@OurID int, @StockID int, @SecID int, @ProdID int)
/* Возвращает общий остаток товара */
RETURNS numeric(21, 9) AS
Begin
  RETURN 
    (SELECT ISNULL(
      (SELECT SUM(Qty) FROM t_Rem WHERE OurID = @OurID AND StockID = @StockID AND SecID = @SecID AND ProdID = @ProdID)
    , 0))                    
End 
GO