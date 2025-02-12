SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LStrs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.OurID,
 DepID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.SubID,
 m.Notes,
 Sum(d.EmpCount) AS TEmpCount
FROM p_LStr AS m,
 p_LStrD AS d
WHERE m.ChID=d.ChID
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.SubID,
 DepID,
 m.Notes) GMSView
GO