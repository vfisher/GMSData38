SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RemAP] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_Rem.OurID, b_Rem.StockID, b_Rem.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  b_PInP.PriceCC_In, Sum(b_Rem.Qty) AS TQty, Sum(Qty*PriceCC_In) AS SumCC, b_Rem.PPID, r_Prods.PGrID1,
  r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID, b_PInP.CompID
FROM (b_Rem INNER JOIN b_PInP ON (b_Rem.ProdID = b_PInP.ProdID) AND (b_Rem.PPID = b_PInP.PPID)) INNER JOIN r_Prods ON b_PInP.ProdID = r_Prods.ProdID
GROUP BY 
  b_Rem.OurID, b_Rem.StockID, b_Rem.ProdID, r_Prods.ProdName, r_Prods.UM, r_Prods.PCatID, r_Prods.PGrID,
  b_PInP.PriceCC_In, b_Rem.PPID, r_Prods.PGrID1, r_Prods.PGrID2, r_Prods.PGrID3, r_Prods.PGrAID, r_Prods.PBGrID,
  b_PInP.CompID
) GMSView
GO