﻿CREATE TABLE [dbo].[b_RepADP] (
  [ChID] [bigint] NOT NULL,
  [StockID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [DocDesc] [varchar](200) NULL,
  [BuyDate] [smalldatetime] NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  CONSTRAINT [_pk_b_RepADP] PRIMARY KEY CLUSTERED ([ChID], [ProdID], [PPID])
)
ON [PRIMARY]
GO

CREATE INDEX [b_PInPb_RepADP]
  ON [dbo].[b_RepADP] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_RepADP] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_RepADP] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[b_RepADP] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[b_RepADP] ([StockID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[b_RepADP] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RepADP.GTranID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_RepADP] ON [b_RepADP]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 122 - Обновление итогов в главной таблице */
/* b_RepADP - Авансовый отчет (ТМЦ) */
/* b_RepA - Авансовый отчет (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt
  FROM b_RepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM b_RepA WITH (NOLOCK), inserted m
     WHERE b_RepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 158 - Текущие остатки товара */
/* b_RepADP - Авансовый отчет (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_RepA.OurID = r.OurID AND m.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_RepA.OurID, m.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_RepADP] ON [b_RepADP]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 122 - Обновление итогов в главной таблице */
/* b_RepADP - Авансовый отчет (ТМЦ) */
/* b_RepA - Авансовый отчет (Заголовок) */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt
  FROM b_RepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM b_RepA WITH (NOLOCK), inserted m
     WHERE b_RepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt
  FROM b_RepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM b_RepA WITH (NOLOCK), deleted m
     WHERE b_RepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 158 - Текущие остатки товара */
/* b_RepADP - Авансовый отчет (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(StockID) OR UPDATE(PPID) OR UPDATE(ProdID) OR UPDATE(Qty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_RepA.OurID = r.OurID AND m.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_RepA.OurID = r.OurID AND m.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_RepA.OurID, m.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_RepA.OurID, m.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_RepADP] ON [b_RepADP]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 122 - Обновление итогов в главной таблице */
/* b_RepADP - Авансовый отчет (ТМЦ) */
/* b_RepA - Авансовый отчет (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt
  FROM b_RepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM b_RepA WITH (NOLOCK), deleted m
     WHERE b_RepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 158 - Текущие остатки товара */
/* b_RepADP - Авансовый отчет (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_RepA.OurID = r.OurID AND m.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_RepA.OurID, m.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_RepA WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_RepA.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_RepA.OurID, m.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_RepADP] ON [b_RepADP]
FOR INSERT AS
/* b_RepADP - Авансовый отчет (ТМЦ) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_RepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_RepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_RepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_RepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_RepA a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14310, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Авансовый отчет'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_RepADP ^ b_PInP - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_RepADP', 0
      RETURN
    END

/* b_RepADP ^ b_RepA - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_RepA))
    BEGIN
      EXEC z_RelationError 'b_RepA', 'b_RepADP', 0
      RETURN
    END

/* b_RepADP ^ r_GOpers - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RepADP', 0
      RETURN
    END

/* b_RepADP ^ r_Stocks - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_RepADP', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14310003, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_RepADP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_RepADP] ON [b_RepADP]
FOR UPDATE AS
/* b_RepADP - Авансовый отчет (ТМЦ) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_RepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_RepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_RepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_RepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_RepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_RepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_RepA a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14310, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Авансовый отчет'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_RepADP ^ b_PInP - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PInP', 'b_RepADP', 1
        RETURN
      END

/* b_RepADP ^ b_RepA - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Авансовый отчет (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_RepA))
      BEGIN
        EXEC z_RelationError 'b_RepA', 'b_RepADP', 1
        RETURN
      END

/* b_RepADP ^ r_GOpers - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_RepADP', 1
        RETURN
      END

/* b_RepADP ^ r_Stocks - Проверка в PARENT */
/* Авансовый отчет (ТМЦ) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_RepADP', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14310003 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14310003 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(ProdID) OR UPDATE(PPID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14310003 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.PPID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.ProdID = d.ProdID AND i.PPID = d.PPID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14310003 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.PPID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.ProdID = d.ProdID AND i.PPID = d.PPID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14310003, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14310003 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14310003 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14310003, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(ProdID) OR UPDATE(PPID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, ProdID, PPID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, ProdID, PPID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14310003 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14310003 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14310003, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14310003 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14310003 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14310003, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14310003, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_RepADP', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_RepADP] ON [b_RepADP]
FOR DELETE AS
/* b_RepADP - Авансовый отчет (ТМЦ) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_RepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_RepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_RepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_RepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет (ТМЦ) (b_RepADP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_RepA a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14310, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Авансовый отчет'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14310003 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14310003 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14310003, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_RepADP', N'Last', N'DELETE'
GO