SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_EDiss] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT ChID,
 DocID,
 IntDocID,
 WOrderID,
 DocDate,
 DisDate,
 OurID,
 SubID,
 DepID,
 KursMC,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 EmpID,
 Notes,
 DisReason,
 DisBasis,
 DisPayCC,
 AvrSalPres,
 SaveAvrSal,
 AvrSalDate,
 AvrNLeaCC,
 NLeaDays,
 NLeaBDate,
 NLeaEDate
FROM p_EDis) GMSView
GO