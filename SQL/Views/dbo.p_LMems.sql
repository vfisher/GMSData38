SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LMems] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
 m.OurID,
 m.DocID,
 IntDocID,
 SubID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.VacTotal) AS TVacTotal,
 Sum(d.VacOcc) AS TVacOcc,
 Sum(d.VacTotal-d.VacOcc) AS TVacFree
FROM p_LMem AS m,
 p_LMemD AS d
WHERE m.ChID=d.ChID
GROUP BY m.ChID,
 m.OurID,
 SubID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView
GO