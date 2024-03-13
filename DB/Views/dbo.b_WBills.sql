SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_WBills] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocID, IntDocID, m.DocDate, m.KursMC, m.EmpID, re.EmpName, m.CodeID1, m.CodeID2, m.CodeID3,
  m.CodeID4, m.CodeID5, m.CarrID, r.CarrName, m.TrailerID1, m.TrailerID2, m.RaceLength, m.RaceTime, Count(d.SrcPosID) AS JobCount,
  Sum(a.Qty) AS TQty, Sum(a.SumCC_wt) AS TSumCC, Sum(a.SumCC_wt/m.KursMC) AS TSumMC, Sum(a.SumCC_nt) AS TSumCC_nt,
  Sum(a.TaxSum) AS TTaxSum 
FROM (((b_WBill AS m INNER JOIN r_Emps AS re ON m.EmpID = re.EmpID) INNER JOIN r_Carrs AS r ON m.CarrID = r.CarrID) LEFT JOIN b_WBillA AS a ON m.ChID = a.ChID) LEFT JOIN b_WBillD AS d ON m.ChID = d.ChID
GROUP BY 
  m.ChID, m.OurID, m.DocID, IntDocID, m.DocDate, m.KursMC, m.EmpID, re.EmpName, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4,
  m.CodeID5, m.CarrID, r.CarrName, m.TrailerID1, m.TrailerID2, m.RaceLength, m.RaceTime
) GMSView
GO
