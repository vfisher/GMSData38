SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LRecDDsE] WITH VIEW_METADATA AS
SELECT * FROM ( SELECT m.ChID,
m.DocID,
IntDocID,
m.OurID,
m.DocDate,
m.KursMC,
m.CodeID1,
m.CodeID2,
m.CodeID3,
m.CodeID4,
m.CodeID5,
d.EmpID,
d.DetSubID,
d.DetDepID,
a.SubID,
a.DepID,
a.PayTypeID,
a.SumCC,
a.IsDeduction,
a.GOperID,
a.GTranID
FROM (p_LRec AS m INNER JOIN p_LRecD AS d ON d.ChID=m.ChID) INNER JOIN p_LRecDD AS a ON a.AChID=d.AChID
) GMSView
GO
