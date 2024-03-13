SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_RemResPL] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(AccQty) AccQty,
  pp.PriceMC, Sum(AccQty * PriceMC) AccSumMC,
  pp.PriceCC, Sum(AccQty * PriceCC) AccSumCC,
  pp.PLID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID
  AND AccQty <> 0
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID) GMSView
GO
