SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_RepAs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_RepAa.ChID, b_RepAa.OurID, b_RepAa.DocDate, b_RepAa.CodeID1, b_RepAa.CodeID2, b_RepAa.CodeID3,
  b_RepAa.CodeID4, b_RepAa.CodeID5, Sum(b_RepAa.SumCC) AS TSumCC, Sum(b_RepAa.SumMC) AS TSumMC,
  b_RepAa.DocID, IntDocID, b_RepAa.EmpID, b_RepAa.CompID
FROM b_RepAa
GROUP BY 
  b_RepAa.ChID, b_RepAa.OurID,  b_RepAa.DocDate, b_RepAa.CodeID1, b_RepAa.CodeID2, b_RepAa.CodeID3,
  b_RepAa.CodeID4,  b_RepAa.CodeID5, b_RepAa.DocID, IntDocID, b_RepAa.EmpID, b_RepAa.CompID
) GMSView
GO