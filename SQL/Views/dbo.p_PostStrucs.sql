SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_PostStrucs]
AS
SELECT
  m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode, COUNT(d.ChID) AS TPostCount
FROM p_PostStruc AS m INNER JOIN
     p_PostStrucD AS d ON m.ChID = d.ChID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode
GO