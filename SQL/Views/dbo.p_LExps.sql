SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LExps] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT m.ChID,
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
 m.AccDate,
 m.LExpType,
 m.LExpForm,
 m.LExpPrc,
 Sum(LArrSumCC) AS TLArrSumCC,
 Sum(LRecSumCC) AS TLRecSumCC,
 Sum(LExpSumCC) AS TLExpSumCC,
 Sum(LDepSumCC) AS TLDepSumCC
FROM p_LExp AS m INNER JOIN p_LExpD AS d ON m.ChID=d.ChID
GROUP BY m.ChID,
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
 m.AccDate,
 m.LExpType,
 m.LExpForm,
 m.LExpPrc) GMSView
GO