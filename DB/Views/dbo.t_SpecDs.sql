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
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Del_t_SpecDs] ON [dbo].[t_SpecDs]
INSTEAD OF DELETE
AS
  DELETE m 
  FROM t_SpecD m WITH (NOLOCK)
  INNER JOIN deleted d ON m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Ins_t_SpecDs] ON [dbo].[t_SpecDs]
INSTEAD OF INSERT
AS
  INSERT INTO t_SpecD
  (
    ChID, SrcPosID, ProdID, UM, 
    OutUM, Qty, Percent1, Percent2, UseSubItems,   
    OperDesc
  )
SELECT
  d.ChID, d.SrcPosID, d.ProdID, d.UM,   
  ISNULL(mq.UM, d.UM), 
  d.GrossQty * ISNULL(mq.Qty, 1) / p.LayQty 
  * 
  CASE WHEN p.LayUM = m.OutUM AND m.OutQty <> 0 
    THEN m.OutQty 
    ELSE 1 
  END Qty, 
  CASE WHEN d.NetQty = 0 
    THEN COALESCE(po.Percent1, pod.Percent1, d.Percent1) 
    ELSE ISNULL(1 - d.NetQty / NULLIF(d.GrossQty, 0), 0) * 100
  END Percent1, 
  CASE WHEN d.OutQty = 0 THEN COALESCE(po.Percent2, pod.Percent2, d.Percent2)
    ELSE ISNULL(1 - d.OutQty / NULLIF 
    (
      CASE WHEN d.NetQty = 0 
        THEN d.GrossQty * (1 - COALESCE(po.Percent1, pod.Percent1, d.Percent1) / 100)
        ELSE d.NetQty
      END, 0
    ), 0) * 100 
  END Percent2, d.UseSubItems, 
  COALESCE(po.OperDesc, pod.OperDesc, d.OperDesc) 
  FROM t_Spec m WITH (NOLOCK)
  INNER JOIN inserted d WITH (NOLOCK) ON m.ChID = d.ChID
  INNER JOIN t_SpecParams p WITH (NOLOCK) ON m.ChID = p.ChID 
  LEFT JOIN r_ProdMQ mq WITH (NOLOCK) ON d.ProdID = mq.ProdID AND d.OutUM = mq.UM
  LEFT JOIN r_ProdOpers po WITH (NOLOCK) ON d.ProdID = po.ProdID AND d.OperDesc = po.OperDesc
  LEFT JOIN r_ProdOpers pod WITH (NOLOCK) ON d.ProdID = pod.ProdID AND pod.IsDefault = 1
  WHERE ISNULL(mq.Qty, 1) <> 0 AND p.LayQty <> 0
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_t_SpecDs] ON [dbo].[t_SpecDs]
INSTEAD OF UPDATE
AS
DECLARE 
  @P1 bit, @P2 bit, @OP bit  
  IF NOT UPDATE(NetQty)
    SELECT @P1 = 1  

  IF NOT UPDATE(OutQty)
    SELECT @P2 = 1 

  IF NOT(UPDATE(Percent1)) AND NOT(UPDATE(Percent2)) AND UPDATE(OperDesc)
    SELECT @OP = 1 

  IF UPDATE(SrcPosID) AND (SELECT COUNT(*) FROM inserted) = 1
    BEGIN
      UPDATE m 
      SET
        m.SrcPosID = i.SrcPosID 
      FROM t_SpecD m WITH (NOLOCK) 
      INNER JOIN deleted d   
      ON m.ChID = d.ChID AND m.SrcPosID = d.SrcPosID  
      CROSS JOIN inserted i
    END

  UPDATE d
  SET 
    d.ProdID = i.ProdID, 
    d.UM = i.UM, 
    d.OutUM = ISNULL(mq.UM, i.UM), 
    d.Qty = i.GrossQty * ISNULL(mq.Qty, 1) / p.LayQty 
    * 
    CASE WHEN p.LayUM = m.OutUM AND m.OutQty <> 0 
      THEN m.OutQty 
      ELSE 1 
    END, 
    d.Percent1 = 
    CASE WHEN @P1 = 1
      THEN ISNULL(po.Percent1, i.Percent1) 
      ELSE ISNULL(1 - i.NetQty / NULLIF(i.GrossQty, 0), 0) * 100
    END, 
    d.Percent2 =   
    CASE WHEN @P2 = 1 THEN ISNULL(po.Percent2, i.Percent2)
      ELSE ISNULL(1 - i.OutQty / NULLIF 
      (
        CASE WHEN @P1 = 1 
          THEN i.GrossQty * (1 - ISNULL(po.Percent1, i.Percent1) / 100)
          ELSE i.NetQty
        END, 0
      ), 0) * 100 
    END,   
    d.UseSubItems = i.UseSubItems,
    d.OperDesc = i.OperDesc
  FROM t_Spec m WITH (NOLOCK)
  INNER JOIN t_SpecD d WITH (NOLOCK) ON m.ChID = d.ChID
  INNER JOIN inserted i
  ON d.ChID = i.ChID AND d.SrcPosID = i.SrcPosID
  INNER JOIN t_SpecParams p WITH (NOLOCK) ON m.ChID = p.ChID 
  LEFT JOIN r_ProdMQ mq WITH (NOLOCK) ON i.ProdID = mq.ProdID AND i.OutUM = mq.UM
  LEFT JOIN r_ProdOpers po WITH (NOLOCK) 
  ON @OP = 1 AND i.ProdID = po.ProdID AND i.OperDesc = po.OperDesc
  WHERE ISNULL(mq.Qty, 1) <> 0 AND p.LayQty <> 0
GO
