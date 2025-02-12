SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_IORecs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var('t_UseMultiCurrencies') = '1' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.TNewSumCC_wt,
  CASE WHEN dbo.zf_Var('t_UseMultiCurrencies') = '1' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC ELSE 0 END
	 END AS TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3,  m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, m.StateCode
FROM r_Comps c INNER JOIN t_IORec m ON c.CompID = m.CompID
) GMSView
GO