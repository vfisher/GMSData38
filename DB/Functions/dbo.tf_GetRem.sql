SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetRem](@OurID int, @StockID int, @SecID int, @ProdID int, @PPID int)
/* Возвращает остаток товара */
RETURNS numeric(21, 9) AS
Begin
  RETURN 
    (SELECT ISNULL(
      (SELECT SUM(Qty - AccQty) FROM t_Rem WHERE OurID = @OurID AND StockID = @StockID AND SecID = @SecID AND ProdID = @ProdID AND (PPID = @PPID OR @PPID IS NULL))
    , 0))                    
End 
GO
