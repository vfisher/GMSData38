SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_CWTimesEE] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, m.CWTimeType, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, d.SubID, d.DepID, d.AChID,        d.EmpID, dd.DayPosID, dd.WorkHours, dd.WTSignID, dd.EveningHours, dd.NightHours, dd.DayShiftCount,       dd.DayPayFactor, dd.OverTime, dd.OverPayFactor, dd.DaySaleSumCC, dd.EvenSaleSumCC, dd.NightSaleSumCC, dd.OverSaleSumCC, dd.OneHourSumCC
FROM   p_CWTime AS m
       INNER JOIN dbo.p_CWTimeD AS d ON m.ChID = d.ChID
       INNER JOIN dbo.p_CWTimeDDExt AS dd ON d.AChID = dd.AChID) GMSView
GO