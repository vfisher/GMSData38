SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_SEsts] WITH VIEW_METADATA AS
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
 Sum(Qty) AS TQty,
 Sum(PriceAC) AS TPriceAC,
 Sum(NewPriceAC) AS TNewPriceAC,
 Avg(Extra) AS AExtra
FROM t_SEst AS m INNER JOIN t_SEstD AS d ON m.ChID=d.ChID
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
 m.CodeID5) GMSView
GO
