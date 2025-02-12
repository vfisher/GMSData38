SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleRetList](@DocID bigint, @OurID int)
/* Возвращает список проданных товаров доступных для возврата */
AS
BEGIN
  SELECT sd.SrcPosID, mq.UM, p.ProdID, p.ProdName, sd.EmpID, e.EmpName, (sd.Qty / mq.Qty -
    ISNULL((
      SELECT SUM(rd.Qty)
      FROM t_CRRet r, t_CRRetD rd
      WHERE r.ChID = rd.ChID AND rd.BarCode = sd.BarCode AND
        r.SrcDocID = s.DocID AND r.OurID = s.OurID AND rd.SaleSrcPosID = sd.SrcPosID), 0)) Qty,
    sd.RealPrice * mq.Qty PriceCC_wt, sd.RealSum SumCC_wt, mq.BarCode, sd.LevyMark
  FROM t_Sale s, t_SaleD sd, r_ProdMQ mq, r_Prods p, r_Emps e
  WHERE s.ChID = sd.ChID AND sd.ProdID = mq.ProdID AND sd.BarCode = mq.BarCode AND
    sd.ProdID = p.ProdID AND sd.EmpID = e.EmpID AND s.OurID = @OurID AND s.DocID = @DocID 
    AND NOT EXISTS(SELECT TOP 1 1 FROM t_SaleM sm WHERE sm.ChID = s.ChID AND sd.SrcPosID = sm.SaleSrcPosID)
  ORDER BY sd.SrcPosID
END
GO