﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_OPWrksE] WITH VIEW_METADATA AS
SELECT * FROM ( SELECT m.ChID,
m.DocID,
IntDocID,
m.WOrderID,
m.DocDate,
d.BDate,
d.EDate,
m.KursMC,
m.OurID,
m.CodeID1,
m.CodeID2,
m.CodeID3,
m.CodeID4,
m.CodeID5,
m.OrderNotes,
m.Notes,
SrcPosID,
EmpID,
SubID,
DepID,
SumExpE,
SumExpR
FROM p_OPWrk AS m,
p_OPWrkD AS d
WHERE m.ChID=d.ChID
) GMSView
GO