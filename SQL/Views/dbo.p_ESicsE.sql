﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ESicsE] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID, m.DocID, IntDocID, m.DocDate, m.OurID, SubID, DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.EmpID, m.SickType, m.SickDocID, m.SickDept,
       m.Diagnosis, m.SickBDate, m.SickEDate, m.SickWDays, m.TillFiveSickWDays, m.TillFiveSickWHours, m.SickWHours, m.PrimSickDocID, m.AvrSalary, m.AvrGrantCC, m.GrantSumCC,
       m.TillFiveSumCC, m.AfterFiveSumCC
FROM p_ESic AS m) GMSView
GO