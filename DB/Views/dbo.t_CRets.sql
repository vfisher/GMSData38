SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_CRets] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, 
  CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID) AS RateCC) <> 0) AND (KursMC <> 0) THEN  
  	            m.TSumCC_wt / KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID) AS RateCC) ELSE 0 
             END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate
  FROM (r_Comps c INNER JOIN t_CRet m ON c.CompID = m.CompID)
) GMSView
GO
