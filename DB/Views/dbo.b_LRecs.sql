SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_LRecs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_LRec.ChID, b_LRec.OurID, b_LRec.DocID, IntDocID, b_LRec.DocDate, b_LRec.CodeID1, b_LRec.CodeID2, b_LRec.CodeID3,
  b_LRec.CodeID4, b_LRec.CodeID5, b_LRecD.EmpID, r_Emps.EmpName, 
  Sum(ChargeCC+SickCC+InsureCC+LeaveCC+NLeaveCC+MHelpCC+PregCC+MChargeCC+MChargeCC1+MChargeCC2) AS TCharge,
  Sum(AdvanceCC+AlimonyCC+PensionTaxCC+IncomeTaxCC+InsureTaxCC+UnionCC+LoanCC+EmpTaxCC+MoreCC+MoreCC2+MoreCC1) AS TUnCharge,
  Sum((ChargeCC+SickCC+InsureCC+LeaveCC+NLeaveCC+MHelpCC+PregCC+MChargeCC+MChargeCC1+MChargeCC2)-(AdvanceCC+AlimonyCC+PensionTaxCC+IncomeTaxCC+InsureTaxCC+UnionCC+CRateCC+LoanCC+EmpTaxCC+MoreCC+MoreCC2+MoreCC1)) AS TSumCC,
  Sum(((ChargeCC+SickCC+InsureCC+LeaveCC+NLeaveCC+MHelpCC+PregCC+MChargeCC+MChargeCC1+MChargeCC2)-(AdvanceCC+AlimonyCC+PensionTaxCC+IncomeTaxCC+InsureTaxCC+UnionCC+CRateCC+LoanCC+EmpTaxCC+MoreCC+MoreCC2+MoreCC1))/KursMC) AS TSumMC
FROM b_LRec INNER JOIN (r_Emps INNER JOIN b_LRecD ON r_Emps.EmpID = b_LRecD.EmpID) ON b_LRec.ChID = b_LRecD.ChID
GROUP BY 
  b_LRec.ChID, b_LRec.OurID, b_LRec.DocID, IntDocID, b_LRec.DocDate, b_LRec.CodeID1, b_LRec.CodeID2,
  b_LRec.CodeID3, b_LRec.CodeID4, b_LRec.CodeID5, b_LRecD.EmpID, r_Emps.EmpName
) GMSView
GO
