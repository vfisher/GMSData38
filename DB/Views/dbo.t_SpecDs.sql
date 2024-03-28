SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[t_SpecDs] WITH VIEW_METADATA AS
SELECT  * FROM 
(SELECT d.ChID, d.SrcPosID, d.ProdID, d.UM, ISNULL(mq.UM, d.UM) OutUM, d.Qty, d.Percent1, d.Percent2, 
 d.Qty / ISNULL(mq.Qty, 1) * p.LayQty / CASE WHEN p.LayUM = m.OutUM AND m.OutQty <> 0 THEN m.OutQty ELSE 1 END GrossQty,
 d.Qty / ISNULL(mq.Qty, 1) * p.LayQty / CASE WHEN p.LayUM = m.OutUM AND m.OutQty <> 0 THEN m.OutQty ELSE 1 END * (100 - d.Percent1) / 100 NetQty,
 d.Qty / ISNULL(mq.Qty, 1) * p.LayQty / CASE WHEN p.LayUM = m.OutUM AND m.OutQty <> 0 THEN m.OutQty ELSE 1 END * (100 - d.Percent1) / 100 * (100 - d.Percent2) / 100 OutQty, 
 dbo.tf_GetDateCostCC(m.OurID, ss.SubStockID, p.ProdDate, d.ProdID, d.UseSubItems) PriceCC,
 dbo.tf_GetDateCostCC(m.OurID, ss.SubStockID, p.ProdDate, d.ProdID, d.UseSubItems) * d.Qty * p.LayQty / CASE WHEN p.LayUM = m.OutUM AND m.OutQty <> 0 THEN m.OutQty ELSE 1 END SumCC,
 d.UseSubItems, ISNULL(d.OperDesc, '<Нет данных>') OperDesc
 FROM t_Spec m
 INNER JOIN t_SpecD d ON m.ChID = d.ChID
 INNER JOIN t_SpecParams p ON m.ChID = p.ChID 
 LEFT JOIN r_ProdMQ mq ON d.ProdID = mq.ProdID AND d.OutUM = mq.UM AND mq.Qty > 0
 INNER JOIN r_Stocks s ON p.StockID = s.StockID 
 LEFT JOIN r_ProdMP mp ON s.PLID = mp.PLID AND m.ProdID = mp.ProdID
 LEFT JOIN r_StockSubs ss ON p.StockID = ss.StockID AND mp.DepID = ss.DepID
) GMSView
GO
