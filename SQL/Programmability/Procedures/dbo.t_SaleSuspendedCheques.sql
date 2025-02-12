SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSuspendedCheques](@CRID int, @ChID bigint)
/* Возвращает отложенные чеки */
AS
BEGIN
  SELECT q.*, p1.ProdName AS ProdName1, p2.ProdName AS ProdName2, p3.ProdName AS ProdName3
  FROM
    (
       SELECT m.ChID, m.CRID, 
       ISNULL((SELECT ProdID FROM t_SaleTempD WHERE ChID = m.ChID AND SrcPosID = (CASE WHEN MaxPosID >= 3 THEN MaxPosID ELSE 3 END) - 2), NULL) AS ProdID1,
       ISNULL((SELECT ProdID FROM t_SaleTempD WHERE ChID = m.ChID AND SrcPosID = (CASE WHEN MaxPosID >= 3 THEN MaxPosID ELSE 3 END) - 1), NULL) AS ProdID2, 
       ISNULL((SELECT ProdID FROM t_SaleTempD WHERE ChID = m.ChID AND SrcPosID = (CASE WHEN MaxPosID >= 3 THEN MaxPosID ELSE 3 END)), NULL) AS ProdID3,
       DocTime,
       ISNULL((SELECT SUM(SumCC_wt) FROM t_SaleTempD d WHERE d.ChID = m.ChID), 0) AS SumCC_wt,
       Notes
       FROM t_SaleTemp m, (SELECT ChID, MAX(SrcPosID) MaxPosID FROM t_SaleTempD GROUP BY ChID) s
       WHERE s.ChID = m.ChID AND m.CRID = @CRID AND m.ChID <> @ChID
    ) q
  LEFT JOIN r_Prods p1 ON q.ProdID1 = p1.ProdID
  LEFT JOIN r_Prods p2 ON q.ProdID2 = p2.ProdID
  LEFT JOIN r_Prods p3 ON q.ProdID3 = p3.ProdID
END
GO