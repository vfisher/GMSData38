SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_CRRets] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, 
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC, TRealSum, TLevySum, 
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode,
  m.CRID, r_CRs.CRName
FROM r_CRs INNER JOIN t_CRRet m ON r_Crs.CrID=m.CrID
) GMSView
GO