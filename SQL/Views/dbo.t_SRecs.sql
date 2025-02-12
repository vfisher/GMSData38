SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_SRecs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.SubStockID,
  m.TNewSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var('t_UseMultiCurrencies') = '1' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, s1.StockName AS StockName , s2.StockName AS SubStockName
FROM t_SRec m, r_Stocks s1, r_Stocks s2
WHERE s1.StockID = m.StockID AND s2.StockID = m.SubStockID
) GMSView
GO