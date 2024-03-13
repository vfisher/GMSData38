SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_CRepAa] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT
  m.ChID, m.OurID, DocDate, VCodeID1 As CodeID1, VCodeID2 As CodeID2, VCodeID3 As CodeID3, VCodeID4 As CodeID4,
  VCodeID5 As CodeID5, SUM(SumCC_wt) AS SumCC, SUM(SumCC_wt/KursMC) AS SumMC,
  DocID,  IntDocID, m.EmpID, EmpName, m.CompID 
FROM b_CRepA m, b_CRepADV d,  r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY 
  m.ChID, m.OurID, DocID, IntDocID, DocDate, m.EmpID, EmpName, m.CompID, KursMC, VCodeID1, VCodeID2, VCodeID3,
  VCodeID4, VCodeID5
UNION ALL
SELECT
  m.ChID, m.OurID, DocDate, PCodeID1 As CodeID1, PCodeID2 As CodeID2, PCodeID3 As CodeID3, PCodeID4 As CodeID4,
  PCodeID5 As CodeID5, SUM(SumCC_wt) AS SumCC, SUM(SumCC_wt/KursMC) AS SumMC,
  DocID, IntDocID, m.EmpID, EmpName, m.CompID
FROM b_CRepA m, b_CRepADP d, r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY 
  m.ChID, m.OurID, DocID, IntDocID, DocDate, m.EmpID, EmpName, m.CompID, KursMC, PCodeID1, PCodeID2, PCodeID3,
  PCodeID4,  PCodeID5
UNION ALL
SELECT
  m.ChID, m.OurID, DocDate, ACodeID1 As CodeID1, ACodeID2 As CodeID2, ACodeID3 As CodeID3, ACodeID4 As CodeID4,
  ACodeID5 As CodeID5, SUM(SumCC_wt) AS SumCC, SUM(SumCC_wt/KursMC) AS SumMC,
  DocID, IntDocID, m.EmpID, EmpName, m.CompID
FROM b_CRepA m,  b_CRepADS d, r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY 
  m.ChID, m.OurID, DocID, IntDocID, DocDate, m.EmpID, EmpName, m.CompID, KursMC, ACodeID1, ACodeID2, ACodeID3,
  ACodeID4, ACodeID5
) GMSView
GO
