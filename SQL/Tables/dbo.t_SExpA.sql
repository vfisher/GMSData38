CREATE TABLE [dbo].[t_SExpA] (
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
  [PriceAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TaxAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [PriceAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TaxSumAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SumAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_SExpA] PRIMARY KEY CLUSTERED ([AChID])
)
ON [PRIMARY]
GO

CREATE INDEX [BarCode]
  ON [dbo].[t_SExpA] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_SExpA] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_SExpA] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_SExpA] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_SExpA] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [SetCostCC]
  ON [dbo].[t_SExpA] ([SetCostCC])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInPt_SExpA]
  ON [dbo].[t_SExpA] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_SExpA] ([ChID], [SrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_SExpA] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotalsNew]
  ON [dbo].[t_SExpA] ([ChID], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SetCostCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SetValue1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SetValue2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SetValue3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.NewPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.NewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.NewTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.NewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.NewPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.NewSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpA.SecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SExpA] ON [t_SExpA]
FOR DELETE AS
/* t_SExpA - Разукомплектация товара: Комплекты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11322, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Разукомплектация товара'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SExpA ^ t_SExpD - Удаление в CHILD */
/* Разукомплектация товара: Комплекты ^ Разукомплектация товара: Составляющие - Удаление в CHILD */
  DELETE t_SExpD FROM t_SExpD a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* t_SExpA ^ t_SExpE - Удаление в CHILD */
/* Разукомплектация товара: Комплекты ^ Разукомплектация товара: Затраты на комплекты - Удаление в CHILD */
  DELETE t_SExpE FROM t_SExpE a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11322003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11322003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11322003, -ChID, 
    '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SExpA', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SExpA] ON [t_SExpA]
FOR UPDATE AS
/* t_SExpA - Разукомплектация товара: Комплекты - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11322, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Разукомплектация товара'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SExpA ^ r_Secs - Проверка в PARENT */
/* Разукомплектация товара: Комплекты ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_SExpA', 1
        RETURN
      END

/* t_SExpA ^ t_PInP - Проверка в PARENT */
/* Разукомплектация товара: Комплекты ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_SExpA', 1
        RETURN
      END

/* t_SExpA ^ t_SExp - Проверка в PARENT */
/* Разукомплектация товара: Комплекты ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SExp))
      BEGIN
        EXEC z_RelationError 't_SExp', 't_SExpA', 1
        RETURN
      END

/* t_SExpA ^ t_SExpD - Обновление CHILD */
/* Разукомплектация товара: Комплекты ^ Разукомплектация товара: Составляющие - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_SExpD a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpD a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Разукомплектация товара: Комплекты'' => ''Разукомплектация товара: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SExpA ^ t_SExpE - Обновление CHILD */
/* Разукомплектация товара: Комплекты ^ Разукомплектация товара: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_SExpE a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpE a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Разукомплектация товара: Комплекты'' => ''Разукомплектация товара: Затраты на комплекты''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11322003 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11322003 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(AChID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11322003 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11322003 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11322003, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11322003 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11322003 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11322003, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11322003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11322003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11322003, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11322003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11322003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11322003, ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11322003, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SExpA', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SExpA] ON [t_SExpA]
FOR INSERT AS
/* t_SExpA - Разукомплектация товара: Комплекты - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Комплекты'), 't_SExpA', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SExp a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11322, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Разукомплектация товара'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SExpA ^ r_Secs - Проверка в PARENT */
/* Разукомплектация товара: Комплекты ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SExpA', 0
      RETURN
    END

/* t_SExpA ^ t_PInP - Проверка в PARENT */
/* Разукомплектация товара: Комплекты ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SExpA', 0
      RETURN
    END

/* t_SExpA ^ t_SExp - Проверка в PARENT */
/* Разукомплектация товара: Комплекты ^ Разукомплектация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SExp))
    BEGIN
      EXEC z_RelationError 't_SExp', 't_SExpA', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11322003, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SExpA', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SExpA] ON [t_SExpA]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 98 - Обновление итогов в главной таблице */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_SExp - Разукомплектация товара: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_SExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), deleted m
     WHERE t_SExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 184 - Обновление итогов в главной таблице: Составляющие */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_SExp - Разукомплектация товара: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt - q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum - q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt - q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt - q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum - q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt - q.TSubNewSumCC_wt
  FROM t_SExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(t_SExpD.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(t_SExpD.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(t_SExpD.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(t_SExpD.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(t_SExpD.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(t_SExpD.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), t_SExpD WITH (NOLOCK), deleted m
     WHERE t_SExp.ChID = m.ChID AND m.AChID = t_SExpD.AChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 99 - Текущие остатки товара: Комплекты */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 183 - Текущие остатки товара: Составляющие */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, PPID, ProdID, Qty, SecID)
  SELECT DISTINCT t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubPPID, t_SExpD.SubProdID, 0, t_SExpD.SubSecID
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpD WITH (NOLOCK), deleted m
  WHERE t_SExpD.SubProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND m.AChID = t_SExpD.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.SubStockID = r.StockID AND t_SExpD.SubPPID = r.PPID AND t_SExpD.SubProdID = r.ProdID AND t_SExpD.SubSecID = r.SecID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubPPID, t_SExpD.SubProdID, t_SExpD.SubSecID, 
       ISNULL(SUM(t_SExpD.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpD WITH (NOLOCK), deleted m
     WHERE t_SExpD.SubProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND m.AChID = t_SExpD.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubPPID, t_SExpD.SubProdID, t_SExpD.SubSecID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubPPID = r.PPID AND q.SubProdID = r.ProdID AND q.SubSecID = r.SecID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SExpA] ON [t_SExpA]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 98 - Обновление итогов в главной таблице */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_SExp - Разукомплектация товара: Заголовок */

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
  FROM t_SExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), inserted m
     WHERE t_SExp.ChID = m.ChID
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
  FROM t_SExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), deleted m
     WHERE t_SExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 184 - Обновление итогов в главной таблице: Составляющие */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_SExp - Разукомплектация товара: Заголовок */

/* -------------------------------------------------------------------------- */

/* 99 - Текущие остатки товара: Комплекты */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 183 - Текущие остатки товара: Составляющие */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_Rem - Остатки товара (Таблица) */

/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SExpA] ON [t_SExpA]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 98 - Обновление итогов в главной таблице */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_SExp - Разукомплектация товара: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_SExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), inserted m
     WHERE t_SExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 184 - Обновление итогов в главной таблице: Составляющие */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_SExp - Разукомплектация товара: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt + q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum + q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt + q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt + q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum + q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt + q.TSubNewSumCC_wt
  FROM t_SExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(t_SExpD.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(t_SExpD.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(t_SExpD.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(t_SExpD.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(t_SExpD.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(t_SExpD.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), t_SExpD WITH (NOLOCK), inserted m
     WHERE t_SExp.ChID = m.ChID AND m.AChID = t_SExpD.AChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 99 - Текущие остатки товара: Комплекты */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 183 - Текущие остатки товара: Составляющие */
/* t_SExpA - Разукомплектация товара: Комплекты */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, PPID, ProdID, Qty, SecID)
  SELECT DISTINCT t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubPPID, t_SExpD.SubProdID, 0, t_SExpD.SubSecID
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpD WITH (NOLOCK), inserted m
  WHERE t_SExpD.SubProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND m.AChID = t_SExpD.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.SubStockID = r.StockID AND t_SExpD.SubPPID = r.PPID AND t_SExpD.SubProdID = r.ProdID AND t_SExpD.SubSecID = r.SecID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubPPID, t_SExpD.SubProdID, t_SExpD.SubSecID, 
       ISNULL(SUM(t_SExpD.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpD WITH (NOLOCK), inserted m
     WHERE t_SExpD.SubProdID = r_Prods.ProdID AND t_SExp.ChID = m.ChID AND m.AChID = t_SExpD.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubPPID, t_SExpD.SubProdID, t_SExpD.SubSecID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubPPID = r.PPID AND q.SubProdID = r.ProdID AND q.SubSecID = r.SecID
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