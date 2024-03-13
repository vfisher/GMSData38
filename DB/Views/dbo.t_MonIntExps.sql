SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_MonIntExps] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CRID, cr.CRName, m.DocDate, m.DocID, m.SumCC, m.Notes, m.OperID,
  m.DocTime, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.StateCode, m.IntDocID
FROM t_MonIntExp m, r_CRs cr
WHERE cr.CRID = m.CRID) GMSView
GO
