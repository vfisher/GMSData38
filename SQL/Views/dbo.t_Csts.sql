SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Csts] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumAC_In AS TSumAC, (m.TSumAC_In / KursMC) AS TSumMC, (m.TSumAC_In * KursCC) AS TSumCC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.CurrID, m.KursCC, m.TSumAC_In
FROM r_Comps c INNER JOIN t_Cst m ON c.CompID = m.CompID
) GMSView
GO