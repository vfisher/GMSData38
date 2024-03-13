SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_SExcs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, DocID, IntDocID, DocDate, KursMC, OurID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, NewEmpID, 
  Notes, TSumCC_wt AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC AS TSumMC, TSumCC_nt/KursMC AS TSumMC_nt
FROM b_SExc AS m
) GMSView
GO
