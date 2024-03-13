SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ELeavCors] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT
  m.ChID, m.DocID, m.IntDocID, m.WOrderID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode, COUNT(d.ChID) AS TEmpCount
FROM p_ELeavCor AS m INNER JOIN
     p_ELeavCorD AS d ON m.ChID = d.ChID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.WOrderID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode) GMSView
GO
