SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Ests] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID,
  m.TSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var('t_UseMultiCurrencies') = '1' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.TNewSumCC_wt AS TNewSumCC,
  CASE WHEN dbo.zf_Var('t_UseMultiCurrencies') = '1' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC ELSE 0 END
	 END AS TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, c.StockName, m.StateCode
FROM t_Est m, r_Stocks c
WHERE m.StockID = c.StockID
) GMSView
GO