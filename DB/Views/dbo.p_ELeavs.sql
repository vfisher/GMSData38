SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ELeavs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 SubID,
 DepID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(LeavSumCC) AS TLeavSumCC,
 Count(d.ChID) AS TEmpCount
FROM p_ELeav AS m,
 p_ELeavD AS d
WHERE m.ChID=d.ChID
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 SubID,
 DepID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView
GO
