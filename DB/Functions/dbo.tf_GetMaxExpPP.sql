SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetMaxExpPP](@DocDate smalldatetime, @OurID int, @StockID int, @CompID int, @ProdID int, @SecID int)
/* Возвращает последний КЦП продажи */
RETURNS int AS
Begin
  RETURN ISNULL((
    SELECT TOP 1 d.PPID 
    FROM t_Exp m WITH(NOLOCK), t_ExpD d WITH(NOLOCK) 
    WHERE m.ChID = d.ChID AND m.OurID = @OurID AND m.StockID = @StockID AND m.CompID = @CompID AND m.DocDate <= @DocDate AND d.ProdID = @ProdID AND d.SecID = @SecID
    ORDER BY m.DocDate DESC, m.DocID DESC, d.SrcPosID DESC
   ), 0)  
End 
GO
