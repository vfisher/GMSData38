SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vb_BankRecAC] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT  m.ChID,   m.OurID, m.CurrID, m.DocDate, m.DocID, m.StockID, StockName, m.CompID, CompName,   
	m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, 
	m.CodeID5, CodeName5, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, 
	m.SumAC * m.KursCC SumCC, Subject, m.EmpID, e.EmpName 
FROM    b_BankRecAC m,  r_Ours, r_Stocks, r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,   
	r_Comps,  r_Emps e  
WHERE   r_Ours.OurID = m.OurID  AND r_Stocks.StockID = m.StockID   
	AND r_Codes1.CodeID1 = m.CodeID1   AND r_Codes2.CodeID2 = m.CodeID2   AND r_Codes3.CodeID3 = m.CodeID3   
	AND r_Codes4.CodeID4 = m.CodeID4   AND r_Codes5.CodeID5 = m.CodeID5   AND r_Comps.CompID = m.CompID   
	AND e.EmpID = m.EmpID) GMSView
GO