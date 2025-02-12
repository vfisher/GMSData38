SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vc_CompRec] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName, m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName 
FROM 
  c_CompRec m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID) GMSView
GO