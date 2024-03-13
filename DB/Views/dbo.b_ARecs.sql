SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_ARecs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.DocID, 
  m.IntDocID, m.CompID, r.CompName, r.City, m.Subject,
  m.SumCC_wt AS TSumCC, m.SumCC_nt AS TSumCC_nt, SumCC_wt/KursMC AS TSumMC, SumCC_nt/KursMC AS TSumMC_nt
FROM b_ARec AS m INNER JOIN r_Comps AS r ON m.CompID = r.CompID
) GMSView
GO
