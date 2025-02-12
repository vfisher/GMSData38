SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_RemPP] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty - AccQty) RemQty,
  pp.PriceMC, Sum((Qty - AccQty) * PriceMC) RemSumMC,
  pp.PriceCC_In PriceCC, Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, t_PInPs pp, r_Prods p
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID) GMSView
GO