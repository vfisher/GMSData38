SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_SPuts] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.DocID, IntDocID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.CompID, r.CompName, TSumCC_wt AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC AS TSumMC,
  TSumCC_nt/KursMC AS TSumMC_nt
FROM b_SPut AS m  INNER JOIN r_Comps AS r ON r.CompID=m.CompID
) GMSView
GO