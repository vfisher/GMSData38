SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_RemDatePLRes] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  pp.PriceMC, pp.PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC) RemSumCC,
  pp.PLID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID) GMSView
GO
