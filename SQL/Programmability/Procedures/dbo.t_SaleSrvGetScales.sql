SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetScales](@SrvID int)
/* Формирует список весов */
AS
BEGIN
  SELECT s.ScaleGrID, s.ScaleID, s.ScaleName, s.ScaleType, s.IP, s.NetPort,
         CASE s.MaxProdQty WHEN 0 THEN g.MaxProdQty ELSE s.MaxProdQty END AS MaxProdQty,
         CASE s.MaxProdID WHEN 0 THEN g.MaxProdID ELSE s.MaxProdID END AS MaxProdID
  FROM r_Scales s WITH(NOLOCK), r_ScaleGRs g WITH(NOLOCK)
  WHERE s.SrvID = @SrvID AND s.ScaleID <> 0 AND g.ScaleGrID = s.ScaleGrID AND s.ScaleType In (1, 3, 7)
  ORDER BY s.ScaleGrID, s.ScaleID
END
GO