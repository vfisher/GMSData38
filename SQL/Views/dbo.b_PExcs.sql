SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_PExcs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.DocID, IntDocID, m.CompID, c.CompName, c.City, m.StockID, m.NewStockID, m.CodeID1,
  m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, TSumCC_wt AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC AS TSumMC,
  TSumCC_nt/KursMC AS TSumMC_nt, TSumCC_In
FROM r_Comps AS c INNER JOIN b_PExc AS m ON c.CompID = m.CompID
) GMSView
GO