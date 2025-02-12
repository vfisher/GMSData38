CREATE TABLE [dbo].[t_ExcD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [UM] [varchar](50) NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [BarCode] [varchar](42) NOT NULL,
  [SecID] [int] NOT NULL,
  [NewSecID] [int] NOT NULL,
  [PriceAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TaxAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [PriceAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TaxSumAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_t_ExcD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [BarCode]
  ON [dbo].[t_ExcD] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_ExcD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [NewSecID]
  ON [dbo].[t_ExcD] ([NewSecID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_ExcD] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_ExcD] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_ExcD] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInPt_ExcD]
  ON [dbo].[t_ExcD] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_ExcD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_ExcD.NewSecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_ExcD] ON [t_ExcD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 210 - Обновление итогов в главной таблице */
/* t_ExcD - Перемещение товара: Товар */
/* t_Exc - Перемещение товара: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt + q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC + q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt + q.TSumAC_wt
  FROM t_Exc r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt 
     FROM t_Exc WITH (NOLOCK), inserted m
     WHERE t_Exc.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 42 - Текущие остатки товара - Приход */
/* t_ExcD - Перемещение товара: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.NewStockID = r.StockID AND m.NewSecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 43 - Текущие остатки товара - Расход */
/* t_ExcD - Перемещение товара: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_ExcD] ON [t_ExcD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 210 - Обновление итогов в главной таблице */
/* t_ExcD - Перемещение товара: Товар */
/* t_Exc - Перемещение товара: Заголовок */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(SumAC_nt) OR UPDATE(TaxSumAC) OR UPDATE(SumAC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt + q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC + q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt + q.TSumAC_wt
  FROM t_Exc r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt 
     FROM t_Exc WITH (NOLOCK), inserted m
     WHERE t_Exc.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt - q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC - q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt - q.TSumAC_wt
  FROM t_Exc r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt 
     FROM t_Exc WITH (NOLOCK), deleted m
     WHERE t_Exc.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 42 - Текущие остатки товара - Приход */
/* t_ExcD - Перемещение товара: Товар */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(NewSecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.NewStockID = r.StockID AND m.NewSecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.NewStockID = r.StockID AND m.NewSecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 43 - Текущие остатки товара - Расход */
/* t_ExcD - Перемещение товара: Товар */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_ExcD] ON [t_ExcD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 210 - Обновление итогов в главной таблице */
/* t_ExcD - Перемещение товара: Товар */
/* t_Exc - Перемещение товара: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt - q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC - q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt - q.TSumAC_wt
  FROM t_Exc r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt 
     FROM t_Exc WITH (NOLOCK), deleted m
     WHERE t_Exc.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 42 - Текущие остатки товара - Приход */
/* t_ExcD - Перемещение товара: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.NewStockID = r.StockID AND m.NewSecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.NewStockID, m.NewSecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 43 - Текущие остатки товара - Расход */
/* t_ExcD - Перемещение товара: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Exc.OurID = r.OurID AND t_Exc.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Exc WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Exc.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Exc.OurID, t_Exc.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_ExcD] ON [t_ExcD]
FOR INSERT AS
/* t_ExcD - Перемещение товара: Товар - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Exc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Exc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Exc a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11021, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Перемещение товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_ExcD ^ r_Secs - Проверка в PARENT */
/* Перемещение товара: Товар ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.NewSecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_ExcD', 0
      RETURN
    END

/* t_ExcD ^ r_Secs - Проверка в PARENT */
/* Перемещение товара: Товар ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_ExcD', 0
      RETURN
    END

/* t_ExcD ^ t_Exc - Проверка в PARENT */
/* Перемещение товара: Товар ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Exc))
    BEGIN
      EXEC z_RelationError 't_Exc', 't_ExcD', 0
      RETURN
    END

/* t_ExcD ^ t_PInP - Проверка в PARENT */
/* Перемещение товара: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_ExcD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11021002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_ExcD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_ExcD] ON [t_ExcD]
FOR UPDATE AS
/* t_ExcD - Перемещение товара: Товар - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Exc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Exc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Exc a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11021, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Перемещение товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_ExcD ^ r_Secs - Проверка в PARENT */
/* Перемещение товара: Товар ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(NewSecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.NewSecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_ExcD', 1
        RETURN
      END

/* t_ExcD ^ r_Secs - Проверка в PARENT */
/* Перемещение товара: Товар ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_ExcD', 1
        RETURN
      END

/* t_ExcD ^ t_Exc - Проверка в PARENT */
/* Перемещение товара: Товар ^ Перемещение товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Exc))
      BEGIN
        EXEC z_RelationError 't_Exc', 't_ExcD', 1
        RETURN
      END

/* t_ExcD ^ t_PInP - Проверка в PARENT */
/* Перемещение товара: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_ExcD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11021002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11021002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11021002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11021002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11021002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11021002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11021002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11021002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11021002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11021002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11021002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11021002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11021002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11021002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11021002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_ExcD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_ExcD] ON [t_ExcD]
FOR DELETE AS
/* t_ExcD - Перемещение товара: Товар - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Exc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Exc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Товар (t_ExcD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Exc a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11021, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Перемещение товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11021002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11021002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11021002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_ExcD', N'Last', N'DELETE'
GO