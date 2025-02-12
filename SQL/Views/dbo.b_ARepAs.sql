SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_ARepAs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_ARepAa.ChID, b_ARepAa.OurID, b_ARepAa.DocDate, b_ARepAa.DocID, IntDocID,
  b_ARepAa.EmpID, b_ARepAa.EmpName, b_ARepAa.CompID,
  Sum(b_ARepAa.SumAC) AS TSumAC, Sum(b_ARepAa.SumCC) AS TSumCC, Sum(b_ARepAa.SumMC) AS TSumMC
FROM b_ARepAa
GROUP BY 
  b_ARepAa.ChID, b_ARepAa.OurID, b_ARepAa.DocDate, b_ARepAa.DocID, IntDocID, b_ARepAa.EmpID,
  b_ARepAa.EmpName, b_ARepAa.CompID
) GMSView
GO