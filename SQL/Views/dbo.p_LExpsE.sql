SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LExpsE] WITH VIEW_METADATA AS
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
d.SubID,
d.DepID,
m.AccDate,
m.LExpType,
m.LExpForm,
m.LExpPrc,
d.EmpID,
LArrSumCC,
LRecSumCC,
LExpSumCC,
LDepSumCC,
GOperID,
GTranID
FROM p_LExp AS m INNER JOIN p_LExpD AS d ON m.ChID=d.ChID
) GMSView
GO