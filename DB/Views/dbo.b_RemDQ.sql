SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RemDQ] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_RemD.OurID, b_RemD.StockID, b_RemD.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  Sum(b_RemD.Qty) AS TQty, r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID
FROM b_RemD INNER JOIN r_Prods ON b_RemD.ProdID = r_Prods.ProdID
GROUP BY 
  b_RemD.OurID, b_RemD.StockID, b_RemD.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID
) GMSView
GO
