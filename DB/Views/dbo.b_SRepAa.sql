SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_SRepAa] WITH VIEW_METADATA AS
SELECT SelType, ChID, OurID, CompID, DocDate, RepType, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
AssID, DocID, IntDocID, EmpID, EmpName, CompName, FSumCC_wt, FSumMC_wt, FSumCC_nt, FSumMC_nt, FTaxSumCC, FTaxSumMC
FROM
  (SELECT
     1 AS SelType, m.ChID, m.OurID, m.CompID, m.DocDate, m.RepType,
     d.VCodeID1 AS CodeID1, d.VCodeID2 AS CodeID2, d.VCodeID3 AS CodeID3, d.VCodeID4 AS CodeID4, d.VCodeID5 AS CodeID5,
     m.AssID, m.DocID, m.IntDocID, m.EmpID, e.EmpName, r.CompName, SUM(d.CostSumCC_wt) AS FSumCC_wt, SUM(d.CostSumCC_wt / m.KursMC) AS FSumMC_wt,
     SUM(d.CostSumCC_nt) AS FSumCC_nt, SUM(d.CostSumCC_nt / m.KursMC) AS FSumMC_nt, SUM(d.CostTaxSum) AS FTaxSumCC, SUM(d.CostTaxSum / m.KursMC) AS FTaxSumMC
   FROM dbo.b_SRep AS m INNER JOIN
     dbo.r_Emps AS e ON m.EmpID = e.EmpID LEFT JOIN
     dbo.b_SRepDV AS d ON m.ChID = d.ChID INNER JOIN
     dbo.r_Comps AS r ON m.CompID = r.CompID
   GROUP BY m.ChID, m.OurID, m.CompID, m.DocDate, m.RepType, d.VCodeID1, d.VCodeID2, d.VCodeID3, d.VCodeID4, d.VCodeID5, m.AssID, m.DocID, m.IntDocID, m.EmpID, e.EmpName, r.CompName
  UNION
  SELECT
    2 AS SelType, m.ChID, m.OurID, m.CompID, m.DocDate, m.RepType, d.PCodeID1 AS CodeID1, d.PCodeID2 AS CodeID2, d.PCodeID3 AS CodeID3, d.PCodeID4 AS CodeID4, d.PCodeID5 AS CodeID5,
    m.AssID, m.DocID, m.IntDocID, m.EmpID, e.EmpName, r.CompName, SUM(d.SumCC_wt) AS FSumCC_wt,SUM(d.SumCC_wt / m.KursMC) AS FSumMC_wt, SUM(d.SumCC_nt) AS FSumCC_nt, SUM(d.SumCC_nt / m.KursMC) AS FSumMC_nt,
    SUM(d.TaxSum) AS FTaxSumCC, SUM(d.TaxSum / m.KursMC) AS FTaxSumMC
  FROM  dbo.b_SRep AS m INNER JOIN
    dbo.r_Emps AS e ON m.EmpID = e.EmpID LEFT JOIN
    dbo.b_SRepDP AS d ON m.ChID = d.ChID INNER JOIN
    dbo.r_Comps AS r ON m.CompID = r.CompID
  GROUP BY m.ChID, m.OurID, m.CompID, m.DocDate, m.RepType, d.PCodeID1, d.PCodeID2, d.PCodeID3, d.PCodeID4, d.PCodeID5, m.AssID, m.DocID, m.IntDocID, m.EmpID, e.EmpName, r.CompName) AS GMSView
GO
