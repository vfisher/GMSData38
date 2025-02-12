SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_CRecs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_CRec.ChID, b_CRec.OurID, b_CRec.DocDate, b_CRec.CodeID1, b_CRec.CodeID2, b_CRec.CodeID3, b_CRec.CodeID4,
  b_CRec.CodeID5, SumCC_nt, TaxSum, SumCC_wt, SumAC AS TSumAC, SumCC_wt AS TSumCC, SumCC_nt AS TSumCC_nt,
  SumAC/KursMC AS TSumMC, b_CRec.DocID, IntDocID, b_CRec.CompID, r_Comps.CompName, r_Comps.City, b_CRec.Subject,
  b_CRec.EmpID, CashEmpID, r_Emps.EmpName, b_CRec.CurrID, b_CRec.GOperID, b_CRec.GTranID
FROM r_Emps INNER JOIN (b_CRec INNER JOIN r_Comps ON b_CRec.CompID = r_Comps.CompID) ON r_Emps.EmpID = b_CRec.EmpID
) GMSView
GO