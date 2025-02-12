SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_ELeavsDPE] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT  m.ChID, DocID, DocDate, KursMC, OurID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes, WOrderID, IntDocID, StateCode, SrcPosID, EmpID, SubID, LeavType, AgeBDate, AgeEDate, BDate, EDate, LeavAvrSalary, LeavSumCC, d.AChID, DepID, SrcDate, dd.LeavDays , PLeavSumCC
FROM    p_ELeav m
        JOIN p_ELeavD d ON m.ChID = d.ChID
        JOIN p_ELeavDP dd ON d.AChID = dd.AChID) GMSView
GO