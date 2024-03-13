SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_Accs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  ReserveProds, ReserveDayCount, m.StateCode
FROM r_Comps c INNER JOIN t_Acc m ON c.CompID = m.CompID 
) GMSView
GO
