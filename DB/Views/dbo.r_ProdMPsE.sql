SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[r_ProdMPsE] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT r_ProdMPs.PLID,
 r_PLs.PLName,
 r_ProdMPs.ProdID,
 r_Prods.ProdName,
 r_ProdMPs.CurrID,
 r_ProdMPs.CurrName,
 r_ProdMPs.PriceAC,
 r_ProdMPs.PriceCC,
 r_ProdMPs.PriceMC,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID
FROM (r_ProdMPs INNER JOIN r_Prods ON r_ProdMPs.ProdID = r_Prods.ProdID) INNER JOIN r_PLs ON r_ProdMPs.PLID = r_PLs.PLID) GMSView
GO
