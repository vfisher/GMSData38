SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TExps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  ChID, DocID, IntDocID, DocDate, KursMC, OurID, CompID, SumCC_nt, TaxSum, SumCC_wt, Notes, CodeID1,
  CodeID2, CodeID3, CodeID4, CodeID5, SumCC_wt AS TSumCC, SumCC_wt/KursMC AS TSumMC,
  SumCC_nt AS TSumCC_nt, SumCC_nt/KursMC AS TSumMC_nt
FROM b_TExp
) GMSView
GO