SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Cst2s]
AS
SELECT
  m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CurrID, c.City,
  SUM(d.SumAC_In) AS TSumAC, SUM(d.SumCC_In) AS TSumCC, SUM(d.TaxSum) AS TTaxSum, SUM(d.SumCC_In/m.KursMC/m.KursCC)  AS TSumMC,
  m.TTrtAC, m.TTrtCC, m.DocID, IntDocID, m.PayDelay, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.KursCC, m.TSumAC_In
FROM r_Comps AS c INNER JOIN
  t_Cst2 AS m ON c.CompID = m.CompID INNER JOIN
  t_Cst2D AS d ON m.ChID = d.ChID
WHERE m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin('t') AND dbo.zf_GetUserWorkAgeEnd('t')
GROUP BY
  m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CurrID, c.City,
  m.TTrtAC, m.TTrtCC, m.DocID, IntDocID, m.PayDelay, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.KursCC, m.TSumAC_In
GO