SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ETrps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT ChID,
 DocID,
 IntDocID,
 WOrderID,
 DocDate,
 OurID,
 SubID,
 DepID,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 CompID,
 EmpID,
 Notes,
 TripBDate,
 TripEDate,
 TripDays,
 TripPurpose,
 TripAdv
FROM p_ETrp) GMSView
GO
