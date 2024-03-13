SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RepAa] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT
  1 AS SelType, m.ChID, m.OurID, DocDate, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
  SUM(SumCC_wt) AS SumCC, SUM(SumCC_wt/KursMC) AS SumMC, DocID, IntDocID, m.EmpID, EmpName, m.CompID
FROM b_RepA m, b_RepADV d, r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY 
  m.ChID, m.OurID, DocID, IntDocID, DocDate, m.EmpID, EmpName, m.CompID, KursMC, CodeID1, CodeID2, CodeID3,
  CodeID4, CodeID5 
UNION
SELECT
  2 AS SelType, m.ChID, m.OurID, DocDate, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
  SUM(SumCC_wt) AS SumCC, SUM(SumCC_wt/KursMC) AS SumMC, DocID, IntDocID, m.EmpID, EmpName, m.CompID
FROM b_RepA m, b_RepADP d, r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY 
  m.ChID, m.OurID, DocID, IntDocID, DocDate, m.EmpID, EmpName, m.CompID, KursMC, CodeID1, CodeID2, CodeID3, 
  CodeID4, CodeID5
UNION 
SELECT
  3 AS SelType, m.ChID, m.OurID, DocDate, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
  SUM(SumCC_wt) AS SumCC, SUM(SumCC_wt/KursMC) AS SumMC, DocID, IntDocID, m.EmpID, EmpName, m.CompID
FROM b_RepA m, b_RepADS d, r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY 
  m.ChID, m.OurID, DocID, IntDocID, DocDate, m.EmpID, EmpName, m.CompID, KursMC, CodeID1, CodeID2, CodeID3,
  CodeID4, CodeID5
) GMSView
GO
