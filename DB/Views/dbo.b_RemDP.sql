SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RemDP] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_RemD.OurID, b_RemD.StockID, b_RemD.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  b_PInP.PriceCC_In, Sum(b_RemD.Qty) AS TQty, Sum(Qty*PriceCC_In) AS SumCC, b_RemD.PPID, r_Prods.PGrID1,
  r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID, b_PInP.CompID
FROM (b_RemD INNER JOIN b_PInP ON (b_RemD.PPID = b_PInP.PPID) AND (b_RemD.ProdID = b_PInP.ProdID)) INNER JOIN r_Prods ON b_PInP.ProdID = r_Prods.ProdID
GROUP BY 
  b_RemD.OurID, b_RemD.StockID, b_RemD.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  b_PInP.PriceCC_In, b_RemD.PPID, r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID,
  b_PInP.CompID
) GMSView
GO
