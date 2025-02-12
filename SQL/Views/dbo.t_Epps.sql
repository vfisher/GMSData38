SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Epps] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.SrcDocID, m.SrcDocDate
FROM (r_Comps AS c INNER JOIN t_Epp AS m ON c.CompID = m.CompID)
) GMSView
GO