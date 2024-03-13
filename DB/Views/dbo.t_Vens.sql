SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Vens] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT DISTINCT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, c.StocKName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.TNewSumCC_wt AS TNewSumCC, (m.TNewSumCC_wt / KursMC) AS TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode
FROM t_Ven m LEFT JOIN t_VenA a ON m.ChID = a.ChID, r_Stocks c
WHERE m.StockID= c.StockID 
) GMSView
GO
