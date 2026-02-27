CREATE TABLE [dbo].[t_SPExpA] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [UM] [varchar](50) NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [SetCostCC] [numeric](21, 9) NOT NULL,
  [SetValue1] [numeric](21, 9) NULL,
  [SetValue2] [numeric](21, 9) NULL,
  [SetValue3] [numeric](21, 9) NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [NewPriceCC_nt] [numeric](21, 9) NOT NULL,
  [NewSumCC_nt] [numeric](21, 9) NOT NULL,
  [NewTax] [numeric](21, 9) NOT NULL,
  [NewTaxSum] [numeric](21, 9) NOT NULL,
  [NewPriceCC_wt] [numeric](21, 9) NOT NULL,
  [NewSumCC_wt] [numeric](21, 9) NOT NULL,
  [AChID] [bigint] NOT NULL,
  [BarCode] [varchar](42) NOT NULL,
  [SecID] [int] NOT NULL,
  CONSTRAINT [pk_t_SPExpA] PRIMARY KEY CLUSTERED ([AChID])
)
ON [PRIMARY]
GO

CREATE INDEX [BarCode]
  ON [dbo].[t_SPExpA] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_SPExpA] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_SPExpA] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_SPExpA] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_SPExpA] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [SetCostCC]
  ON [dbo].[t_SPExpA] ([SetCostCC])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInP_Tt_SPExpA]
  ON [dbo].[t_SPExpA] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_SPExpA] ([ChID], [SrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_SPExpA] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotalsNew]
  ON [dbo].[t_SPExpA] ([ChID], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SetCostCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SetValue1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SetValue2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SetValue3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.NewPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.NewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.NewTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.NewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.NewPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.NewSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPExpA.SecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SPExpA] ON [t_SPExpA]
FOR DELETE AS
/* t_SPExpA - Планирование: Разукомплектация: Комплекты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_SPExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SPExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SPExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11312, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Планирование: Разукомплектация'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SPExpA ^ t_SPExpD - Удаление в CHILD */
/* Планирование: Разукомплектация: Комплекты ^ Планирование: Разукомплектация: Составляющие - Удаление в CHILD */
  DELETE t_SPExpD FROM t_SPExpD a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* t_SPExpA ^ t_SPExpE - Удаление в CHILD */
/* Планирование: Разукомплектация: Комплекты ^ Планирование: Разукомплектация: Затраты на комплекты - Удаление в CHILD */
  DELETE t_SPExpE FROM t_SPExpE a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11312003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11312003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11312003, -ChID, 
    '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SPExpA', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SPExpA] ON [t_SPExpA]
FOR UPDATE AS
/* t_SPExpA - Планирование: Разукомплектация: Комплекты - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SPExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SPExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SPExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11312, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Планирование: Разукомплектация'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SPExpA ^ r_Secs - Проверка в PARENT */
/* Планирование: Разукомплектация: Комплекты ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_SPExpA', 1
        RETURN
      END

/* t_SPExpA ^ t_PInP - Проверка в PARENT */
/* Планирование: Разукомплектация: Комплекты ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_SPExpA', 1
        RETURN
      END

/* t_SPExpA ^ t_SPExp - Проверка в PARENT */
/* Планирование: Разукомплектация: Комплекты ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SPExp))
      BEGIN
        EXEC z_RelationError 't_SPExp', 't_SPExpA', 1
        RETURN
      END

/* t_SPExpA ^ t_SPExpD - Обновление CHILD */
/* Планирование: Разукомплектация: Комплекты ^ Планирование: Разукомплектация: Составляющие - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_SPExpD a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpD a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Планирование: Разукомплектация: Комплекты'' => ''Планирование: Разукомплектация: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SPExpA ^ t_SPExpE - Обновление CHILD */
/* Планирование: Разукомплектация: Комплекты ^ Планирование: Разукомплектация: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_SPExpE a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpE a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Планирование: Разукомплектация: Комплекты'' => ''Планирование: Разукомплектация: Затраты на комплекты''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11312003 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11312003 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(AChID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11312003 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11312003 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11312003, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11312003 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11312003 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11312003, ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11312003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11312003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11312003, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11312003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11312003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11312003, ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11312003, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SPExpA', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SPExpA] ON [t_SPExpA]
FOR INSERT AS
/* t_SPExpA - Планирование: Разукомплектация: Комплекты - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SPExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SPExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Планирование: Разукомплектация: Комплекты'), 't_SPExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SPExp a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11312, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Планирование: Разукомплектация'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SPExpA ^ r_Secs - Проверка в PARENT */
/* Планирование: Разукомплектация: Комплекты ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SPExpA', 0
      RETURN
    END

/* t_SPExpA ^ t_PInP - Проверка в PARENT */
/* Планирование: Разукомплектация: Комплекты ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SPExpA', 0
      RETURN
    END

/* t_SPExpA ^ t_SPExp - Проверка в PARENT */
/* Планирование: Разукомплектация: Комплекты ^ Планирование: Разукомплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SPExp))
    BEGIN
      EXEC z_RelationError 't_SPExp', 't_SPExpA', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11312003, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SPExpA', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SPExpA] ON [t_SPExpA]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 84 - Обновление итогов в главной таблице */
/* t_SPExpA - Планирование: Разукомплектация: Комплекты */
/* t_SPExp - Планирование: Разукомплектация: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_SPExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPExp WITH (NOLOCK), deleted m
     WHERE t_SPExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 186 - Обновление итогов в главной таблице: Составляющие */
/* t_SPExpA - Планирование: Разукомплектация: Комплекты */
/* t_SPExp - Планирование: Разукомплектация: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt - q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum - q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt - q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt - q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum - q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt - q.TSubNewSumCC_wt
  FROM t_SPExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(t_SPExpD.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(t_SPExpD.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(t_SPExpD.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(t_SPExpD.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(t_SPExpD.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(t_SPExpD.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SPExp WITH (NOLOCK), t_SPExpD WITH (NOLOCK), deleted m
     WHERE t_SPExp.ChID = m.ChID AND m.AChID = t_SPExpD.AChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SPExpA] ON [t_SPExpA]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 84 - Обновление итогов в главной таблице */
/* t_SPExpA - Планирование: Разукомплектация: Комплекты */
/* t_SPExp - Планирование: Разукомплектация: Заголовок */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(NewSumCC_nt) OR UPDATE(NewTaxSum) OR UPDATE(NewSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_SPExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPExp WITH (NOLOCK), inserted m
     WHERE t_SPExp.ChID = m.ChID
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
  FROM t_SPExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPExp WITH (NOLOCK), deleted m
     WHERE t_SPExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 186 - Обновление итогов в главной таблице: Составляющие */
/* t_SPExpA - Планирование: Разукомплектация: Комплекты */
/* t_SPExp - Планирование: Разукомплектация: Заголовок */

/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SPExpA] ON [t_SPExpA]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 84 - Обновление итогов в главной таблице */
/* t_SPExpA - Планирование: Разукомплектация: Комплекты */
/* t_SPExp - Планирование: Разукомплектация: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_SPExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPExp WITH (NOLOCK), inserted m
     WHERE t_SPExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 186 - Обновление итогов в главной таблице: Составляющие */
/* t_SPExpA - Планирование: Разукомплектация: Комплекты */
/* t_SPExp - Планирование: Разукомплектация: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt + q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum + q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt + q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt + q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum + q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt + q.TSubNewSumCC_wt
  FROM t_SPExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(t_SPExpD.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(t_SPExpD.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(t_SPExpD.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(t_SPExpD.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(t_SPExpD.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(t_SPExpD.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SPExp WITH (NOLOCK), t_SPExpD WITH (NOLOCK), inserted m
     WHERE t_SPExp.ChID = m.ChID AND m.AChID = t_SPExpD.AChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO



































































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO