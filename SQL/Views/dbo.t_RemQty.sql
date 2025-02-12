SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_RemQty] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty-AccQty) RemQty,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r WITH(NOLOCK) INNER JOIN r_Prods p WITH(NOLOCK) ON r.ProdID = p.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID) GMSView
GO