SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Recs] WITH VIEW_METADATA AS
SELECT ChID, OurID, CurrID, DocID, IntDocID, DocDate, StockID, CompID, CompName, TSumCC, TSumMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, 
       EmpID, StateCode, PayDelay,PayDocDate, SrcDocID, SrcDocDate, ChildDocID
FROM (
      SELECT m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName, m.TSumCC_wt AS TSumCC, 
             CASE WHEN dbo.zf_Var('t_UseMultiCurrencies') = '1' THEN 
	  	          CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
             ELSE CASE WHEN (KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	            END AS TSumMC,
             m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.EmpID, m.StateCode, m.PayDelay, m.DocDate + m.PayDelay  AS PayDocDate, m.SrcDocID,
             m.SrcDocDate, ISNULL((SELECT TOP(1) ChildDocID 
                                   FROM dbo.z_DocLinks AS l
                                   WHERE (ParentDocCode = 11002) AND (ParentChID = m.ChID)), '') AS ChildDocID
      FROM dbo.r_Comps AS c INNER JOIN dbo.t_Rec AS m ON  c.CompID = m.CompID
      ) AS GMSView
GO