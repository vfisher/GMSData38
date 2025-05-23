﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_SVens] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.DocID, IntDocID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4,
  m.CodeID5, m.EmpID, TSumCC_wt AS TSumCC, TSumCC_nt, TSumCC_wt/KursMC AS TSumMC,
  TSumCC_nt/KursMC AS TSumMC_nt
FROM b_SVen AS m
) GMSView
GO