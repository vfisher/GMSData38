SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_SDeps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.DocID, m.IntDocID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, 
  m.EmpID, TSumCC_wt  AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC  AS TSumMC, TSumCC_nt/KursMC  AS TSumMC_nt
FROM b_SDep AS m
) GMSView
GO
