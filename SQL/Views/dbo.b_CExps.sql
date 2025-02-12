SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_CExps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_CExp.ChID, b_CExp.OurID, b_CExp.DocDate, b_CExp.CodeID1, b_CExp.CodeID2, b_CExp.CodeID3,
  b_CExp.CodeID4, b_CExp.CodeID5, SumCC_nt, TaxSum, SumCC_wt, 
  SumAC AS TSumAC, SumCC_wt AS TSumCC, SumCC_nt AS TSumCC_nt, SumAC/KursMC AS TSumMC,
  b_CExp.DocID, IntDocID, b_CExp.CompID, r_Comps.CompName, r_Comps.City, b_CExp.Subject, b_CExp.EmpID,
  CashEmpID, r_Emps.EmpName, b_CExp.CurrID, b_CExp.GOperID, b_CExp.GTranID
FROM r_Emps INNER JOIN (b_CExp INNER JOIN r_Comps ON b_CExp.CompID = r_Comps.CompID) ON r_Emps.EmpID = b_CExp.EmpID
) GMSView
GO