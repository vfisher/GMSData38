CREATE TABLE [dbo].[t_SaleD] (
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
  [PurPriceCC_nt] [numeric](21, 9) NOT NULL,
  [PurTax] [numeric](21, 9) NOT NULL,
  [PurPriceCC_wt] [numeric](21, 9) NOT NULL,
  [PLID] [int] NOT NULL,
  [Discount] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_SaleD__Discoun__5BFBAE3E] DEFAULT (0),
  [EmpID] [int] NOT NULL DEFAULT (0),
  [CreateTime] [datetime] NOT NULL DEFAULT (getdate()),
  [ModifyTime] [datetime] NOT NULL DEFAULT (getdate()),
  [TaxTypeID] [int] NOT NULL DEFAULT (0),
  [RealPrice] [numeric](21, 9) NOT NULL,
  [RealSum] [numeric](21, 9) NOT NULL,
  [MarkCode] [int] NULL DEFAULT (0),
  [LevyMark] [varchar](20) NULL,
  CONSTRAINT [_pk_t_SaleD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [BarCode]
  ON [dbo].[t_SaleD] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_SaleD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [PLID]
  ON [dbo].[t_SaleD] ([PLID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_SaleD] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_SaleD] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_SaleD] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInPt_SaleD]
  ON [dbo].[t_SaleD] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_SaleD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PurPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PurTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PurPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SaleD.PLID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SaleD] ON [t_SaleD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 59 - Обновление итогов в главной таблице */
/* t_SaleD - Продажа товара оператором: Продажи товара */
/* t_Sale - Продажа товара оператором: Заголовок */

  UPDATE r
  SET 
    r.TPurSumCC_nt = r.TPurSumCC_nt + q.TPurSumCC_nt, 
    r.TPurTaxSum = r.TPurTaxSum + q.TPurTaxSum, 
    r.TPurSumCC_wt = r.TPurSumCC_wt + q.TPurSumCC_wt, 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.PurPriceCC_nt * m.Qty), 0) TPurSumCC_nt,
       ISNULL(SUM(m.PurTax * m.Qty), 0) TPurTaxSum,
       ISNULL(SUM(m.PurPriceCC_wt * m.Qty), 0) TPurSumCC_wt,
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_Sale WITH (NOLOCK), inserted m
     WHERE t_Sale.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 60 - Текущие остатки товара */
/* t_SaleD - Продажа товара оператором: Продажи товара */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Sale.OurID = r.OurID AND t_Sale.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SaleD] ON [t_SaleD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 59 - Обновление итогов в главной таблице */
/* t_SaleD - Продажа товара оператором: Продажи товара */
/* t_Sale - Продажа товара оператором: Заголовок */

IF UPDATE(PurPriceCC_nt) OR UPDATE(Qty) OR UPDATE(PurTax) OR UPDATE(PurPriceCC_wt) OR UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(RealSum)
BEGIN
  UPDATE r
  SET 
    r.TPurSumCC_nt = r.TPurSumCC_nt + q.TPurSumCC_nt, 
    r.TPurTaxSum = r.TPurTaxSum + q.TPurTaxSum, 
    r.TPurSumCC_wt = r.TPurSumCC_wt + q.TPurSumCC_wt, 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.PurPriceCC_nt * m.Qty), 0) TPurSumCC_nt,
       ISNULL(SUM(m.PurTax * m.Qty), 0) TPurTaxSum,
       ISNULL(SUM(m.PurPriceCC_wt * m.Qty), 0) TPurSumCC_wt,
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_Sale WITH (NOLOCK), inserted m
     WHERE t_Sale.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TPurSumCC_nt = r.TPurSumCC_nt - q.TPurSumCC_nt, 
    r.TPurTaxSum = r.TPurTaxSum - q.TPurTaxSum, 
    r.TPurSumCC_wt = r.TPurSumCC_wt - q.TPurSumCC_wt, 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.PurPriceCC_nt * m.Qty), 0) TPurSumCC_nt,
       ISNULL(SUM(m.PurTax * m.Qty), 0) TPurTaxSum,
       ISNULL(SUM(m.PurPriceCC_wt * m.Qty), 0) TPurSumCC_wt,
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_Sale WITH (NOLOCK), deleted m
     WHERE t_Sale.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 60 - Текущие остатки товара */
/* t_SaleD - Продажа товара оператором: Продажи товара */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Sale.OurID = r.OurID AND t_Sale.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Sale.OurID = r.OurID AND t_Sale.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SaleD] ON [t_SaleD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 59 - Обновление итогов в главной таблице */
/* t_SaleD - Продажа товара оператором: Продажи товара */
/* t_Sale - Продажа товара оператором: Заголовок */

  UPDATE r
  SET 
    r.TPurSumCC_nt = r.TPurSumCC_nt - q.TPurSumCC_nt, 
    r.TPurTaxSum = r.TPurTaxSum - q.TPurTaxSum, 
    r.TPurSumCC_wt = r.TPurSumCC_wt - q.TPurSumCC_wt, 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM t_Sale r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.PurPriceCC_nt * m.Qty), 0) TPurSumCC_nt,
       ISNULL(SUM(m.PurTax * m.Qty), 0) TPurTaxSum,
       ISNULL(SUM(m.PurPriceCC_wt * m.Qty), 0) TPurSumCC_wt,
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_Sale WITH (NOLOCK), deleted m
     WHERE t_Sale.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 60 - Текущие остатки товара */
/* t_SaleD - Продажа товара оператором: Продажи товара */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Sale.OurID = r.OurID AND t_Sale.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Sale WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Sale.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Sale.OurID, t_Sale.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel2_Upd_t_SaleD] ON [t_SaleD]
FOR UPDATE AS
/* t_SaleD - Продажа товара оператором: Продажи товара - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  /* t_SaleD - Продажа товара оператором: Продажи товара ^ Заявки: подробно - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF EXISTS(SELECT TOP 1 1 FROM t_Booking m ,t_BookingD a, deleted d WHERE m.ChID = a.ChID AND m.DocCode = 11035 AND m.DocChID = d.ChID AND a.DetSrcPosID = d.SrcPosID)
      EXEC z_RelationError 't_SaleD', 't_BookingD', 2

 /* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

  /* t_SaleD ^ z_LogDiscRec - Удаление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM z_LogDiscRec a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID AND a.DocCode = 11035
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.ChID = @NewChID FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.ChID = @OldChID AND z_LogDiscRec.SrcPosID = d.SrcPosID AND z_LogDiscRec.DocCode = 11035
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.SrcPosID = @NewSrcPosID FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.SrcPosID = @OldSrcPosID AND z_LogDiscRec.ChID = d.ChID AND z_LogDiscRec.DocCode = 11035
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscRec a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''t_SaleD'' => ''z_LogDiscRec''.', 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

  /* t_SaleD ^ z_LogDiscExp - Удаление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM z_LogDiscExp a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID AND a.DocCode = 11035
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.ChID = @NewChID FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.ChID = @OldChID AND z_LogDiscExp.SrcPosID = d.SrcPosID AND z_LogDiscExp.DocCode = 11035
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.SrcPosID = @NewSrcPosID FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.SrcPosID = @OldSrcPosID AND z_LogDiscExp.ChID = d.ChID AND z_LogDiscExp.DocCode = 11035
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExp a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''t_SaleD'' => ''z_LogDiscExp''.', 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

  /* t_SaleD ^ z_LogDiscExpP - Удаление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM z_LogDiscExpP a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID AND a.DocCode = 11035
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscExpP SET z_LogDiscExpP.ChID = @NewChID FROM z_LogDiscExpP, deleted d WHERE z_LogDiscExpP.ChID = @OldChID AND z_LogDiscExpP.SrcPosID = d.SrcPosID AND z_LogDiscExpP.DocCode = 11035
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE z_LogDiscExpP SET z_LogDiscExpP.SrcPosID = @NewSrcPosID FROM z_LogDiscExpP, deleted d WHERE z_LogDiscExpP.SrcPosID = @OldSrcPosID AND z_LogDiscExpP.ChID = d.ChID AND z_LogDiscExpP.DocCode = 11035
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExpP a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''t_SaleD'' => ''z_LogDiscExpP''.', 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel3_Del_t_SaleD] ON [t_SaleD]
FOR DELETE AS
/* t_SaleD - Продажа товара оператором: Продажи товара - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

  /* t_SaleD ^ t_BookingD - Удаление в CHILD */
  /*  Продажа товара оператором: Продажи товара ^ Заявки: подробно - Удаление в CHILD */
  DELETE t_BookingD FROM t_Booking m, t_BookingD a, deleted d 
  WHERE m.DocChID = d.ChID AND m.DocCode = 11035 AND m.ChID = a.ChID AND a.DetSrcPosID = d.SrcPosID 

  /* t_SaleD ^ z_LogDiscRec - Удаление в CHILD */
  DELETE z_LogDiscRec FROM z_LogDiscRec m, deleted d 
  WHERE m.ChID = d.ChID AND m.DocCode = 11035 AND m.SrcPosID = d.SrcPosID 

  /* t_SaleD ^ z_LogDiscExp - Удаление в CHILD */
  DELETE z_LogDiscExp FROM z_LogDiscExp m, deleted d 
  WHERE m.ChID = d.ChID AND m.DocCode = 11035 AND m.SrcPosID = d.SrcPosID 

  /* t_SaleD ^ z_LogDiscExpP - Удаление в CHILD */
  DELETE z_LogDiscExpP FROM z_LogDiscExpP m, deleted d 
  WHERE m.ChID = d.ChID AND m.DocCode = 11035 AND m.SrcPosID = d.SrcPosID 
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleD] ON [t_SaleD]
FOR INSERT AS
/* t_SaleD - Продажа товара оператором: Продажи товара - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Sale a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Продажа товара оператором'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SaleD ^ r_Emps - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SaleD', 0
      RETURN
    END

/* t_SaleD ^ r_PLs - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 't_SaleD', 0
      RETURN
    END

/* t_SaleD ^ r_ProdMarks - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник товаров: маркировки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MarkCode IS NOT NULL AND i.MarkCode NOT IN (SELECT MarkCode FROM r_ProdMarks))
    BEGIN
      EXEC z_RelationError 'r_ProdMarks', 't_SaleD', 0
      RETURN
    END

/* t_SaleD ^ r_Secs - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SaleD', 0
      RETURN
    END

/* t_SaleD ^ r_Taxes - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник НДС - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
    BEGIN
      EXEC z_RelationError 'r_Taxes', 't_SaleD', 0
      RETURN
    END

/* t_SaleD ^ t_PInP - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SaleD', 0
      RETURN
    END

/* t_SaleD ^ t_Sale - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 't_SaleD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11035002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SaleD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleD] ON [t_SaleD]
FOR UPDATE AS
/* t_SaleD - Продажа товара оператором: Продажи товара - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Sale a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Продажа товара оператором'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SaleD ^ r_Emps - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_SaleD', 1
        RETURN
      END

/* t_SaleD ^ r_PLs - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 't_SaleD', 1
        RETURN
      END

/* t_SaleD ^ r_ProdMarks - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник товаров: маркировки - Проверка в PARENT */
  IF UPDATE(MarkCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MarkCode IS NOT NULL AND i.MarkCode NOT IN (SELECT MarkCode FROM r_ProdMarks))
      BEGIN
        EXEC z_RelationError 'r_ProdMarks', 't_SaleD', 1
        RETURN
      END

/* t_SaleD ^ r_Secs - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_SaleD', 1
        RETURN
      END

/* t_SaleD ^ r_Taxes - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник НДС - Проверка в PARENT */
  IF UPDATE(TaxTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
      BEGIN
        EXEC z_RelationError 'r_Taxes', 't_SaleD', 1
        RETURN
      END

/* t_SaleD ^ t_PInP - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_SaleD', 1
        RETURN
      END

/* t_SaleD ^ t_Sale - Проверка в PARENT */
/* Продажа товара оператором: Продажи товара ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 't_SaleD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* t_SaleD ^ t_SaleDLV - Обновление CHILD */
/* Продажа товара оператором: Продажи товара ^ Продажа товара оператором: Сборы по товару - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM t_SaleDLV a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_SaleDLV SET t_SaleDLV.ChID = @NewChID FROM t_SaleDLV, deleted d WHERE t_SaleDLV.ChID = @OldChID AND t_SaleDLV.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE t_SaleDLV SET t_SaleDLV.SrcPosID = @NewSrcPosID FROM t_SaleDLV, deleted d WHERE t_SaleDLV.SrcPosID = @OldSrcPosID AND t_SaleDLV.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Продажи товара'' => ''Продажа товара оператором: Сборы по товару''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SaleD ^ t_SaleM - Обновление CHILD */
/* Продажа товара оператором: Продажи товара ^ Продажа товара оператором: Модификаторы - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM t_SaleM a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_SaleM SET t_SaleM.ChID = @NewChID FROM t_SaleM, deleted d WHERE t_SaleM.ChID = @OldChID AND t_SaleM.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE t_SaleM SET t_SaleM.SrcPosID = @NewSrcPosID FROM t_SaleM, deleted d WHERE t_SaleM.SrcPosID = @OldSrcPosID AND t_SaleM.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleM a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Продажи товара'' => ''Продажа товара оператором: Модификаторы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11035002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11035002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11035002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11035002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11035002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11035002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11035002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11035002, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11035002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11035002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11035002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11035002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11035002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11035002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11035002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SaleD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SaleD] ON [t_SaleD]
FOR DELETE AS
/* t_SaleD - Продажа товара оператором: Продажи товара - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Продажи товара (t_SaleD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Sale a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Продажа товара оператором'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SaleD ^ t_SaleDLV - Удаление в CHILD */
/* Продажа товара оператором: Продажи товара ^ Продажа товара оператором: Сборы по товару - Удаление в CHILD */
  DELETE t_SaleDLV FROM t_SaleDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* t_SaleD ^ t_SaleM - Удаление в CHILD */
/* Продажа товара оператором: Продажи товара ^ Продажа товара оператором: Модификаторы - Удаление в CHILD */
  DELETE t_SaleM FROM t_SaleM a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11035002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11035002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11035002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SaleD', N'Last', N'DELETE'
GO