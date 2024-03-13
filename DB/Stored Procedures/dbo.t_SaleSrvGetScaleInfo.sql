SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvGetScaleInfo](@ScaleID int)/* Возвращает расширенную информацию о весах */ASBEGIN  SELECT s.ScaleGrID, s.ScaleID, s.ScaleName, s.ScaleType,         CASE s.MaxProdQty WHEN 0 THEN g.MaxProdQty ELSE s.MaxProdQty END AS MaxProdQty,         CASE s.MaxProdID WHEN 0 THEN g.MaxProdID ELSE s.MaxProdID END AS MaxProdID,           s.IP, s.NetPort,          o.OurName + '. ' + o.PostIndex + ' ' + r.Address + ', ' + o.Phone AS ShopInfo,          i.ScaleImageType, i.ScaleImage, i.ScaleImageNum, s.ScaleDefID  FROM r_Scales s WITH(NOLOCK), r_Stocks r WITH(NOLOCK), r_Ours o WITH(NOLOCK), r_CRSrvs v WITH(NOLOCK),       r_ScaleDefs i WITH(NOLOCK), r_ScaleGRs g WITH(NOLOCK)  WHERE s.ScaleID = @ScaleID AND s.ScaleID <> 0 AND s.StockID = r.StockID AND v.SrvID = s.SrvID AND o.OurID = v.OurID AND        g.ScaleGrID = s.ScaleGrID AND i.ScaleDefID = s.ScaleDefID   ORDER BY s.ScaleGrID, s.ScaleIDEND
GO
