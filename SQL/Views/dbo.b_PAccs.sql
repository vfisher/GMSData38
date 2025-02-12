SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_PAccs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, 
  m.EmpID, m.DocID, IntDocID, m.PayDelay, TSumCC_wt  AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC  AS TSumMC, TSumCC_wt/KursMC  AS TSumMC_nt
FROM r_Comps AS c INNER JOIN b_PAcc AS m ON c.CompID = m.CompID
) GMSView
GO