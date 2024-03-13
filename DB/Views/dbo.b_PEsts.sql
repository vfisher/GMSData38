SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_PEsts] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.StockID, m.DocID, IntDocID, m.CodeID1, m.CodeID2, m.CodeID3,
  m.CodeID4, m.CodeID5, TSumCC_wt AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC AS TSumMC,
  TSumCC_nt/KursMC AS TSumMC_nt, TNewSumCC_wt  AS TNewSumCC, TNewSumCC_nt,
  TNewSumCC_wt/KursMC AS TNewSumMC, TNewSumCC_nt/KursMC  AS TNewSumMC_nt 
FROM b_PEst AS m
) GMSView
GO
