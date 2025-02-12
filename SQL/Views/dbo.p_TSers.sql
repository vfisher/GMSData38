SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_TSers] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT m.ChID,
m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, SubID, DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, t.EmpID, t.CompID, t.TripPurpose, t.TripBDate, t.TripEDate, t.TripDays, Count(d.ChID) AS PlaceCount
FROM p_TSer AS m, p_TSerD AS d, p_ETrp AS t
WHERE m.ChID=d.ChID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, SubID, DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, t.EmpID, t.CompID, t.TripPurpose, t.TripBDate, t.TripEDate, t.TripDays) GMSView
GO