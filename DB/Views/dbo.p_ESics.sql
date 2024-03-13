SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ESics] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT     m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OurID, m.SubID, m.DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.EmpID, m.SickType,
                      m.SickDocID, m.SickDept, m.Diagnosis, m.SickBDate, m.SickEDate, m.SickWDays, m.TillFiveSickWDays, m.TillFiveSickWHours, m.SickWHours, m.PrimSickDocID,
                      m.AvrSalary, m.AvrGrantCC, m.GrantSumCC, SUM(d.DaysNorm) AS TDaysNorm, SUM(d.DaysFact) AS TDaysFact, SUM(d.FactSalary) AS TFactSalary
FROM         dbo.p_ESic AS m LEFT OUTER JOIN
                      dbo.p_ESicD AS d ON m.ChID = d.ChID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OurID, m.SubID, m.DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.EmpID, m.SickType,
                      m.SickDocID, m.SickDept, m.Diagnosis, m.SickBDate, m.SickEDate, m.SickWDays, m.TillFiveSickWDays, m.TillFiveSickWHours, m.SickWHours, m.PrimSickDocID,
                      m.AvrSalary, m.AvrGrantCC, m.GrantSumCC) GMSView
GO
