CREATE TABLE [dbo].[b_PVenA] (
  [ChID] [bigint] NOT NULL,
  [ProdID] [int] NOT NULL,
  [UM] [varchar](50) NULL,
  [TQty] [numeric](21, 9) NOT NULL,
  [TNewQty] [numeric](21, 9) NOT NULL,
  [TSumCC_nt] [numeric](21, 9) NOT NULL,
  [TTaxSum] [numeric](21, 9) NOT NULL,
  [TSumCC_wt] [numeric](21, 9) NOT NULL,
  [TNewSumCC_nt] [numeric](21, 9) NOT NULL,
  [TNewTaxSum] [numeric](21, 9) NOT NULL,
  [TNewSumCC_wt] [numeric](21, 9) NOT NULL,
  [Norma1] [numeric](21, 9) NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [TSrcPosID] [int] NOT NULL,
  CONSTRAINT [_pk_b_PVenA] PRIMARY KEY CLUSTERED ([ChID], [ProdID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_PVenA] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_PVenA] ([GOperID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [NoDuplicate]
  ON [dbo].[b_PVenA] ([ChID], [TSrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[b_PVenA] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [TSrcPosID]
  ON [dbo].[b_PVenA] ([TSrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ZNewTotals]
  ON [dbo].[b_PVenA] ([TNewSumCC_wt], [TNewTaxSum], [TNewSumCC_nt], [TNewQty])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[b_PVenA] ([TSumCC_wt], [TTaxSum], [TSumCC_nt], [TQty])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TNewQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TNewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TNewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TNewSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.Norma1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenA.TSrcPosID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_PVenA] ON [b_PVenA]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 119 - Обновление итогов в главной таблице */
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM b_PVen r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVen WITH (NOLOCK), inserted m
     WHERE b_PVen.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PVenA] ON [b_PVenA]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 119 - Обновление итогов в главной таблице */
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */

IF UPDATE(TSumCC_nt) OR UPDATE(TTaxSum) OR UPDATE(TSumCC_wt) OR UPDATE(TNewSumCC_nt) OR UPDATE(TNewTaxSum) OR UPDATE(TNewSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM b_PVen r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVen WITH (NOLOCK), inserted m
     WHERE b_PVen.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM b_PVen r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVen WITH (NOLOCK), deleted m
     WHERE b_PVen.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PVenA] ON [b_PVenA]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 119 - Обновление итогов в главной таблице */
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM b_PVen r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVen WITH (NOLOCK), deleted m
     WHERE b_PVen.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PVenA] ON [b_PVenA]
FOR INSERT AS
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_PVen a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Инвентаризация'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PVenA ^ b_PVen - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Итоги) ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_PVen))
    BEGIN
      EXEC z_RelationError 'b_PVen', 'b_PVenA', 0
      RETURN
    END

/* b_PVenA ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Итоги) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PVenA', 0
      RETURN
    END

/* b_PVenA ^ r_Prods - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Итоги) ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_PVenA', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14122002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PVenA', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PVenA] ON [b_PVenA]
FOR UPDATE AS
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_PVen a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Инвентаризация'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PVenA ^ b_PVen - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Итоги) ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_PVen))
      BEGIN
        EXEC z_RelationError 'b_PVen', 'b_PVenA', 1
        RETURN
      END

/* b_PVenA ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Итоги) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_PVenA', 1
        RETURN
      END

/* b_PVenA ^ r_Prods - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Итоги) ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_PVenA', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldProdID int, @NewProdID int

/* b_PVenA ^ b_PVenD - Обновление CHILD */
/* ТМЦ: Инвентаризация (Итоги) ^ ТМЦ: Инвентаризация (ТМЦ) - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DetProdID = i.ProdID
          FROM b_PVenD a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE b_PVenD SET b_PVenD.ChID = @NewChID FROM b_PVenD, deleted d WHERE b_PVenD.ChID = @OldChID AND b_PVenD.DetProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE b_PVenD SET b_PVenD.DetProdID = @NewProdID FROM b_PVenD, deleted d WHERE b_PVenD.DetProdID = @OldProdID AND b_PVenD.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM b_PVenD a, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Инвентаризация (Итоги)'' => ''ТМЦ: Инвентаризация (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(ProdID) OR UPDATE(UM) OR UPDATE(TQty) OR UPDATE(TNewQty) OR UPDATE(Norma1) OR UPDATE(GOperID) OR UPDATE(GTranID) OR UPDATE(TSrcPosID)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14122002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14122002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(ProdID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14122002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.ProdID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.ProdID = d.ProdID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14122002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.ProdID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.ProdID = d.ProdID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14122002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14122002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14122002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14122002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(ProdID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, ProdID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, ProdID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14122002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14122002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14122002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14122002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14122002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14122002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14122002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PVenA', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PVenA] ON [b_PVenA]
FOR DELETE AS
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Инвентаризация (Итоги) (b_PVenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_PVen a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Инвентаризация'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_PVenA ^ b_PVenD - Удаление в CHILD */
/* ТМЦ: Инвентаризация (Итоги) ^ ТМЦ: Инвентаризация (ТМЦ) - Удаление в CHILD */
  DELETE b_PVenD FROM b_PVenD a, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14122002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14122002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14122002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PVenA', N'Last', N'DELETE'
GO