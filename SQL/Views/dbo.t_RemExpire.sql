SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_RemExpire] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM, 
  pp.PriceMC, pp.PriceCC_In PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC_In) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC_In) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, t_PInPs pp
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID 
  AND pp.ProdDate >= GETDATE() AND DATEDIFF(dd, GETDATE(), pp.ProdDate ) <= 10
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID) GMSView
GO