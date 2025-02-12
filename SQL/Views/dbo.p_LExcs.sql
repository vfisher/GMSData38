SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LExcs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.ExcDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Count(d.EmpID) AS TEmpCount
FROM p_LExc AS m LEFT JOIN p_LExcD AS d ON m.ChID=d.ChID
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.ExcDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView
GO