SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_WExcs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT ChID,
 DocID,
 IntDocID,
 WOrderID,
 DocDate,
 KursMC,
 OurID,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 ExcBDate,
 ExcEDate,
 EmpID,
 SubID,
 DepID,
 PostID,
 EmpClass
FROM p_WExc) GMSView
GO