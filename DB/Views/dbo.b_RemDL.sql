SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RemDL] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_RemD.OurID, b_RemD.StockID, b_RemD.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID,
  r_Prods.PGrID, r_ProdMPs.PriceMC, r_ProdMPs.PriceCC, Sum(b_RemD.Qty) AS TRem, Sum(Qty*PriceMC) AS TRemSumMC,
  Sum(Qty*PriceCC) AS TRemSumCC, Sum(b_RemD.Qty) AS TAcc, Sum(b_RemD.Qty) AS TQty, Sum((Qty)*PriceMC) AS SumMC,
  Sum((Qty)*PriceCC) AS SumCC, r_ProdMPs.PLID, r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID
FROM (b_RemD INNER JOIN r_Prods ON b_RemD.ProdID = r_Prods.ProdID) INNER JOIN r_ProdMPs ON r_Prods.ProdID = r_ProdMPs.ProdID
GROUP BY 
  b_RemD.OurID, b_RemD.StockID, b_RemD.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID, r_ProdMPs.PriceMC,
  r_ProdMPs.PriceCC, r_ProdMPs.PLID, r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID
) GMSView
GO
