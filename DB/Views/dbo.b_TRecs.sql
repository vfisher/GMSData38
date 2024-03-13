SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TRecs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  ChID, DocID, IntDocID, DocDate, KursMC, OurID, CompID, SumCC_nt, TaxSum, SumCC_wt, Notes, CodeID1,
  CodeID2, CodeID3, CodeID4, CodeID5, SumCC_wt AS TSumCC, SumCC_wt/KursMC AS TSumMC, SumCC_nt AS TSumCC_nt,
  SumCC_nt/KursMC AS TSumMC_nt, SrcDocID, SrcDocDate, TakeTotalCosts
FROM b_TRec
) GMSView
GO
