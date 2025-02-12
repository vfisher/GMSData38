SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[r_ProdMPs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT r_ProdMP.PLID,
 r_ProdMP.ProdID,
 r_ProdMP.CurrID,
 r_Currs.CurrName,
 r_ProdMP.PriceMC AS PriceAC,
 r_ProdMP.PriceMC*KursCC AS PriceCC,
 r_ProdMP.PriceMC/KursMC AS PriceMC
FROM r_Currs INNER JOIN r_ProdMP ON r_Currs.CurrID = r_ProdMP.CurrID) GMSView
GO