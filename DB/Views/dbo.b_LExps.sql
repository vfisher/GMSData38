SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_LExps] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.DocID, m.IntDocID, m.DocDate, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  Sum(SumCC) AS TSumCC, Sum(SumCC/KursMC) AS TSumMC, d.EmpID, EmpName, m.AccDate, m.LExpPrc
FROM r_Emps AS r INNER JOIN (b_LExp AS m INNER JOIN b_LExpD AS d ON m.ChID = d.ChID) ON r.EmpID = d.EmpID
GROUP BY 
  m.ChID, m.OurID, m.DocID, m.IntDocID, m.DocDate, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  d.EmpID, r.EmpName, m.AccDate, m.LExpPrc
) GMSView
GO
