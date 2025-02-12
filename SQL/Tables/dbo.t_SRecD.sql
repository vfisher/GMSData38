CREATE TABLE [dbo].[t_SRecD] (
  [AChID] [bigint] NOT NULL,
  [SubSrcPosID] [int] NOT NULL,
  [SubProdID] [int] NOT NULL,
  [SubPPID] [int] NOT NULL,
  [SubUM] [varchar](10) NULL,
  [SubQty] [numeric](21, 9) NOT NULL,
  [SubPriceCC_nt] [numeric](21, 9) NOT NULL,
  [SubSumCC_nt] [numeric](21, 9) NOT NULL,
  [SubTax] [numeric](21, 9) NOT NULL,
  [SubTaxSum] [numeric](21, 9) NOT NULL,
  [SubPriceCC_wt] [numeric](21, 9) NOT NULL,
  [SubSumCC_wt] [numeric](21, 9) NOT NULL,
  [SubNewPriceCC_nt] [numeric](21, 9) NOT NULL,
  [SubNewSumCC_nt] [numeric](21, 9) NOT NULL,
  [SubNewTax] [numeric](21, 9) NOT NULL,
  [SubNewTaxSum] [numeric](21, 9) NOT NULL,
  [SubNewPriceCC_wt] [numeric](21, 9) NOT NULL,
  [SubNewSumCC_wt] [numeric](21, 9) NOT NULL,
  [SubSecID] [int] NOT NULL,
  [SubBarCode] [varchar](42) NOT NULL,
  [SubPriceAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SubTaxAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SubPriceAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_t_SRecD] PRIMARY KEY CLUSTERED ([AChID], [SubSrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [AChID]
  ON [dbo].[t_SRecD] ([AChID])
  ON [PRIMARY]
GO

CREATE INDEX [SubBarCode]
  ON [dbo].[t_SRecD] ([SubBarCode])
  ON [PRIMARY]
GO

CREATE INDEX [SubPPID]
  ON [dbo].[t_SRecD] ([SubPPID])
  ON [PRIMARY]
GO

CREATE INDEX [SubProdID]
  ON [dbo].[t_SRecD] ([SubProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SubSecID]
  ON [dbo].[t_SRecD] ([SubSecID])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInPt_SRecD]
  ON [dbo].[t_SRecD] ([SubProdID], [SubPPID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_SRecD] ([AChID], [SubQty], [SubSumCC_nt], [SubTaxSum], [SubSumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotalsNew]
  ON [dbo].[t_SRecD] ([AChID], [SubNewSumCC_nt], [SubNewTaxSum], [SubNewSumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubSrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubPPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubNewPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubNewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubNewTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubNewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubNewPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubNewSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SRecD.SubSecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SRecD] ON [t_SRecD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 92 - Обновление итогов в главной таблице */
/* t_SRecD - Комплектация товара: Составляющие */
/* t_SRec - Комплектация товара: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt + q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum + q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt + q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt + q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum + q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt + q.TSubNewSumCC_wt
  FROM t_SRec r, 
    (SELECT t_SRecA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
     WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID
     GROUP BY t_SRecA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 93 - Текущие остатки товара: Составляющие */
/* t_SRecD - Комплектация товара: Составляющие */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SRec.OurID = r.OurID AND t_SRec.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SRecD] ON [t_SRecD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 92 - Обновление итогов в главной таблице */
/* t_SRecD - Комплектация товара: Составляющие */
/* t_SRec - Комплектация товара: Заголовок */

IF UPDATE(SubSumCC_nt) OR UPDATE(SubTaxSum) OR UPDATE(SubSumCC_wt) OR UPDATE(SubNewSumCC_nt) OR UPDATE(SubNewTaxSum) OR UPDATE(SubNewSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt + q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum + q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt + q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt + q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum + q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt + q.TSubNewSumCC_wt
  FROM t_SRec r, 
    (SELECT t_SRecA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
     WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID
     GROUP BY t_SRecA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt - q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum - q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt - q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt - q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum - q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt - q.TSubNewSumCC_wt
  FROM t_SRec r, 
    (SELECT t_SRecA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
     WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID
     GROUP BY t_SRecA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 93 - Текущие остатки товара: Составляющие */
/* t_SRecD - Комплектация товара: Составляющие */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SubSecID) OR UPDATE(SubProdID) OR UPDATE(SubPPID) OR UPDATE(SubQty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SRec.OurID = r.OurID AND t_SRec.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SRec.OurID = r.OurID AND t_SRec.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SRecD] ON [t_SRecD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 92 - Обновление итогов в главной таблице */
/* t_SRecD - Комплектация товара: Составляющие */
/* t_SRec - Комплектация товара: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt - q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum - q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt - q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt - q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum - q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt - q.TSubNewSumCC_wt
  FROM t_SRec r, 
    (SELECT t_SRecA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
     WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID
     GROUP BY t_SRecA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 93 - Текущие остатки товара: Составляющие */
/* t_SRecD - Комплектация товара: Составляющие */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SRec.OurID = r.OurID AND t_SRec.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRec WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SRec.OurID, t_SRec.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SRecD] ON [t_SRecD]
FOR INSERT AS
/* t_SRecD - Комплектация товара: Составляющие - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SRec a, t_SRecA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SRec a, t_SRecA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SRec a, t_SRecA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SRec a, t_SRecA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SRec a, t_SRecA b, inserted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11321, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Комплектация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SRecD ^ r_Secs - Проверка в PARENT */
/* Комплектация товара: Составляющие ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubSecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SRecD', 0
      RETURN
    END

/* t_SRecD ^ t_PInP - Проверка в PARENT */
/* Комплектация товара: Составляющие ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.SubPPID = m.PPID AND i.SubProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SRecD', 0
      RETURN
    END

/* t_SRecD ^ t_SRecA - Проверка в PARENT */
/* Комплектация товара: Составляющие ^ Комплектация товара: Комплекты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM t_SRecA))
    BEGIN
      EXEC z_RelationError 't_SRecA', 't_SRecD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11321004, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SRecD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SRecD] ON [t_SRecD]
FOR UPDATE AS
/* t_SRecD - Комплектация товара: Составляющие - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SRec a, t_SRecA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SRec a, t_SRecA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SRec a, t_SRecA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SRec a, t_SRecA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SRec a, t_SRecA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SRec a, t_SRecA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SRec a, t_SRecA b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11321, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Комплектация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SRecD ^ r_Secs - Проверка в PARENT */
/* Комплектация товара: Составляющие ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SubSecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubSecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_SRecD', 1
        RETURN
      END

/* t_SRecD ^ t_PInP - Проверка в PARENT */
/* Комплектация товара: Составляющие ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(SubPPID) OR UPDATE(SubProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.SubPPID = m.PPID AND i.SubProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_SRecD', 1
        RETURN
      END

/* t_SRecD ^ t_SRecA - Проверка в PARENT */
/* Комплектация товара: Составляющие ^ Комплектация товара: Комплекты - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM t_SRecA))
      BEGIN
        EXEC z_RelationError 't_SRecA', 't_SRecD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID) OR UPDATE(SubSrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, SubSrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, SubSrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11321004 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11321004 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11321004, 0, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11321004 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SubSrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11321004 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SubSrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11321004, 0, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11321004, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SRecD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SRecD] ON [t_SRecD]
FOR DELETE AS
/* t_SRecD - Комплектация товара: Составляющие - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_SRec a, t_SRecA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SRec a, t_SRecA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SRec a, t_SRecA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SRec a, t_SRecA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Составляющие (t_SRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SRec a, t_SRecA b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11321, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Комплектация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11321004 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11321004 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11321004, 0, 
    '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SRecD', N'Last', N'DELETE'
GO