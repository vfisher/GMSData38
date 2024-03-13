SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_Exps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.DocID,
  m.IntDocID, m.CompID, c.CompName, c.City, m.StockID, TSumCC_wt AS TSumCC, TSumCC_nt, TRealSum, TLevySum, 
  TSumCC_wt/KursMC  AS TSumMC, TSumCC_nt/KursMC AS TSumMC_nt
FROM r_Comps AS c INNER JOIN b_Exp AS m ON c.CompID = m.CompID
) GMSView
GO
