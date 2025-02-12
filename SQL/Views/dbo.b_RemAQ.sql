SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RemAQ] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_Rem.OurID, b_Rem.StockID, b_Rem.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID, 
  Sum(b_Rem.Qty) AS TQty, r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID
FROM b_Rem INNER JOIN r_Prods ON b_Rem.ProdID = r_Prods.ProdID
GROUP BY 
  b_Rem.OurID, b_Rem.StockID, b_Rem.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID
) GMSView
GO