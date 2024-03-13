SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_EORecs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  (m.TSumAC/KursMC) AS TSumMC, (m.TSumAC*KursCC) AS TSumCC,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.InDocID, m.StateCode
  FROM (r_Comps c INNER JOIN t_EORec m ON c.CompID = m.CompID)
) GMSView
GO
