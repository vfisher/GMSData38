SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_Csts] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CurrID, c.City, 
  TSumAC_In  AS TSumAC, TSumCC_In AS TSumCC, TSumCC_In/KursMC/KursCC  AS TSumMC,
  m.DocID, IntDocID, m.PayDelay, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.KursCC, m.TSumAC_In
FROM r_Comps AS c INNER JOIN b_Cst AS m ON c.CompID = m.CompID
) GMSView
GO