SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_CInvs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CurrID, m.KursMC, m.KursAC,
  m.KursCC, c.City, m.DocID, IntDocID, m.PayDelay, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4,
  m.CodeID5, m.DtyCC, m.PrcCC, m.TaxPercent, m.TranCC, m.MoreCC,
  TSumAC, TSumCC_nt, TTaxSum, TSumCC_wt, TSumCC_In,  TSumCC_wt  AS TSumCC, TSumCC_wt / KursMC AS TSumMC
FROM r_Comps AS c INNER JOIN b_CInv AS m ON c.CompID = m.CompID
) GMSView
GO