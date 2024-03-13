SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_Accs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  m.ChID, m.OurID, m.DocDate, m.CompID, c.CompName, TSumCC_nt, m.DocID, m.IntDocID, 
  TSumCC_wt AS TSumCC, TSumCC_wt/KursMC AS TSumMC, TSumCC_nt/KursMC AS TSumMC_nt
FROM r_Comps AS c INNER JOIN b_Acc AS m ON c.CompID = m.CompID
) GMSView
GO
