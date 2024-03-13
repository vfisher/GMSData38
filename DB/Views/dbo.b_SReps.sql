SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_SReps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  ChID, OurID, CompID, DocDate, RepType, AssID, DocID, IntDocID, EmpID, EmpName, CompName,
  SUM(FSumCC_wt) AS TSumCC, SUM(FSumMC_wt) AS TSumMC, SUM(FSumCC_nt) AS TSumCC_nt,
  SUM(FSumMC_nt) AS TSumMC_nt, SUM(FTaxSumCC) AS TTaxSumCC, SUM(FTaxSumMC) AS TTaxSumMC
FROM b_SRepAa
GROUP BY 
  ChID, OurID, CompID, DocDate, RepType, AssID, DocID, IntDocID, EmpID, EmpName, CompName
) GMSView
GO
