SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_OPWrks] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.OrderNotes,
 m.Notes,
 Count(*) AS TRewCount
FROM p_OPWrk AS m,
 p_OPWrkD AS d
WHERE m.ChID=d.ChID
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.OrderNotes,
 m.Notes) GMSView
GO
