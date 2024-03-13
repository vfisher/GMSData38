SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_EOExps] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  CASE WHEN m.KursMC <> 0 THEN (m.TSumAC / m.KursMC) ELSE 0 END TSumMC, 
  (m.TSumAC * m.KursCC) TSumCC,
  (m.TNewSumAC * m.KursCC) TNewSumCC,
  CASE WHEN m.KursMC <> 0 THEN (m.TNewSumAC / m.KursMC) ELSE 0 END TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.OrdBDate, m.OrdEDate, m.OrdDayCount, m.StateCode
FROM (r_Comps c INNER JOIN t_EOExp m ON c.CompID = m.CompID)
) GMSView
GO
