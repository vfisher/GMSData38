SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_SubStrucs]
AS
SELECT
  m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode, COUNT(d.ChID) AS TSubCount
FROM p_SubStruc AS m INNER JOIN
     p_SubStrucD AS d ON m.ChID = d.ChID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode
GO
