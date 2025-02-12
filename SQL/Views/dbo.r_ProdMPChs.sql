SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[r_ProdMPChs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT m.ChID, ChDate, ChTime, m.ProdID, p.ProdName, PLID, OldCurrID, OldPriceMC, CurrID, PriceMC, m.UserID, u.UserName FROM r_ProdMPCh m, r_Prods p, r_Users u WHERE p.ProdID = m.ProdID AND u.UserID = m.UserID) GMSView
GO