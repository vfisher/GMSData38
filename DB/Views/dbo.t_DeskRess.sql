SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_DeskRess] WITH VIEW_METADATA
AS
SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, m.EmpID, e.EmpName, m.DeskCode,
  m.ResTime, p.PersonName, m.Visitors, m.SumPrePay,
  m.TSumCC_wt AS TSumCC, (CASE WHEN KursMC <> 0 THEN m.TSumCC_wt / KursMC ELSE 0 END) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5 
FROM t_DeskRes m
  JOIN r_Emps e ON m.EmpID = e.EmpID
  JOIN r_Persons p ON m.PersonID = p.PersonID
) GMSView
GO
