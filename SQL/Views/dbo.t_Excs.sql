SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Excs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.NewStockID,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode,
  m.SrcDocID, m.SrcDocDate, s1.StockName AS StockName , s2.StockName AS NewStockName
FROM t_Exc m, r_Stocks s1, r_Stocks s2
WHERE s1.StockID = m.StockID AND s2.StockID = m.NewStockID
) GMSView
GO