SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_CWTimes] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.ChargeCC) AS TChargeCC,
 Sum(d.TWorkHours) AS TTWorkHours,
 Sum(d.TruanDaysCount) AS TTruanDaysCount,
 Sum(d.TWorkDays) AS TTWorkDays,
 Sum(d.HolDaysCount) AS THolDaysCount,
 Sum(d.SickDaysCount) AS TSickDaysCount,
 Sum(d.BLeaveDaysCount) AS TBLeaveDaysCount,
 Sum(d.PLeaveDaysCount) AS TPLeaveDaysCount,
 Sum(d.NonAppDaysCount) AS TNonAppDaysCount
FROM p_CWTime AS m,
 p_CWTimeD AS d
WHERE m.ChID=d.ChID
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView
GO
