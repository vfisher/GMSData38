SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_CRepAs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_CRepAa.ChID, b_CRepAa.OurID, b_CRepAa.DocDate, 
  Sum(b_CRepAa.SumCC) AS TSumCC, Sum(b_CRepAa.SumMC) AS TSumMC, 
  b_CRepAa.DocID, IntDocID, b_CRepAa.EmpID, b_CRepAa.EmpName, b_CRepAa.CompID
FROM b_CRepAa 
GROUP BY 
  b_CRepAa.ChID, b_CRepAa.OurID, b_CRepAa.DocDate, b_CRepAa.DocID, IntDocID, b_CRepAa.EmpID, b_CRepAa.EmpName,
  b_CRepAa.CompID
) GMSView
GO
