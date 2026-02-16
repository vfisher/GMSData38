CREATE TABLE [dbo].[t_SExpD] (
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
  [SubExtra] [numeric](21, 9) NULL,
  [SubPriceCC] [numeric](21, 9) NULL,
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
  CONSTRAINT [_pk_t_SExpD] PRIMARY KEY CLUSTERED ([AChID], [SubSrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [AChID]
  ON [dbo].[t_SExpD] ([AChID])
  ON [PRIMARY]
GO

CREATE INDEX [SubBarCode]
  ON [dbo].[t_SExpD] ([SubBarCode])
  ON [PRIMARY]
GO

CREATE INDEX [SubPPID]
  ON [dbo].[t_SExpD] ([SubPPID])
  ON [PRIMARY]
GO

CREATE INDEX [SubProdID]
  ON [dbo].[t_SExpD] ([SubProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SubSecID]
  ON [dbo].[t_SExpD] ([SubSecID])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInPt_SExpD]
  ON [dbo].[t_SExpD] ([SubProdID], [SubPPID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_SExpD] ([AChID], [SubQty], [SubSumCC_nt], [SubTaxSum], [SubSumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotalsNew]
  ON [dbo].[t_SExpD] ([AChID], [SubNewSumCC_nt], [SubNewTaxSum], [SubNewSumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubSrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubPPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubExtra'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubPriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubNewPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubNewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubNewTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubNewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubNewPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubNewSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SExpD.SubSecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SExpD] ON [t_SExpD]
FOR DELETE AS
/* t_SExpD - Разукомплектация товара: Составляющие - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, t_SExpA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, t_SExpA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, t_SExpA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, t_SExpA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SExp a, t_SExpA b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11322, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Разукомплектация товара'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

DECLARE @ChID bigint
SET @ChID = (SELECT TOP 1 m.CHID FROM t_SExpA m, deleted d WHERE m.AChID = d.AChID)
/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11322004 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11322004 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11322004, (-1) * @ChID, 
    '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SExpD', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SExpD] ON [t_SExpD]
FOR UPDATE AS
/* t_SExpD - Разукомплектация товара: Составляющие - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, t_SExpA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, t_SExpA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, t_SExpA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, t_SExpA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, t_SExpA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, t_SExpA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SExp a, t_SExpA b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11322, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Разукомплектация товара'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SExpD ^ r_Secs - Проверка в PARENT */
/* Разукомплектация товара: Составляющие ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SubSecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubSecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_SExpD', 1
        RETURN
      END

/* t_SExpD ^ t_PInP - Проверка в PARENT */
/* Разукомплектация товара: Составляющие ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(SubPPID) OR UPDATE(SubProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.SubPPID = m.PPID AND i.SubProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_SExpD', 1
        RETURN
      END

/* t_SExpD ^ t_SExpA - Проверка в PARENT */
/* Разукомплектация товара: Составляющие ^ Разукомплектация товара: Комплекты - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM t_SExpA))
      BEGIN
        EXEC z_RelationError 't_SExpA', 't_SExpD', 1
        RETURN
      END

DECLARE @ChID bigint
SET @ChID = (SELECT TOP 1 m.CHID FROM t_SExpA m, inserted i WHERE m.AChID = i.AChID)
/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID) OR UPDATE(SubSrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, SubSrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, SubSrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11322004 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11322004 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11322004, @ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11322004 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SubSrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11322004 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SubSrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11322004, @ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11322004, @ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SExpD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SExpD] ON [t_SExpD]
FOR INSERT AS
/* t_SExpD - Разукомплектация товара: Составляющие - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, t_SExpA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SExp a, t_SExpA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SExp a, t_SExpA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SExp a, t_SExpA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Разукомплектация товара: Составляющие'), 't_SExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SExp a, t_SExpA b, inserted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11322, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Разукомплектация товара'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SExpD ^ r_Secs - Проверка в PARENT */
/* Разукомплектация товара: Составляющие ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubSecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SExpD', 0
      RETURN
    END

/* t_SExpD ^ t_PInP - Проверка в PARENT */
/* Разукомплектация товара: Составляющие ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.SubPPID = m.PPID AND i.SubProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SExpD', 0
      RETURN
    END

/* t_SExpD ^ t_SExpA - Проверка в PARENT */
/* Разукомплектация товара: Составляющие ^ Разукомплектация товара: Комплекты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM t_SExpA))
    BEGIN
      EXEC z_RelationError 't_SExpA', 't_SExpD', 0
      RETURN
    END

DECLARE @ChID bigint
SET @ChID = (SELECT TOP 1 m.CHID FROM t_SExpA m, inserted i WHERE m.AChID = i.AChID)
/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11322004, @ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SubSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SExpD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SExpD] ON [t_SExpD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 100 - Обновление итогов в главной таблице */
/* t_SExpD - Разукомплектация товара: Составляющие */
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
    (SELECT t_SExpA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), deleted m
     WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID
     GROUP BY t_SExpA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 101 - Текущие остатки товара: Составляющие */
/* t_SExpD - Разукомплектация товара: Составляющие */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), deleted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), deleted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SExpD] ON [t_SExpD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 100 - Обновление итогов в главной таблице */
/* t_SExpD - Разукомплектация товара: Составляющие */
/* t_SExp - Разукомплектация товара: Заголовок */

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
  FROM t_SExp r, 
    (SELECT t_SExpA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), inserted m
     WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID
     GROUP BY t_SExpA.ChID) q
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
  FROM t_SExp r, 
    (SELECT t_SExpA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), deleted m
     WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID
     GROUP BY t_SExpA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 101 - Текущие остатки товара: Составляющие */
/* t_SExpD - Разукомплектация товара: Составляющие */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SubSecID) OR UPDATE(SubProdID) OR UPDATE(SubPPID) OR UPDATE(SubQty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), inserted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), deleted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), inserted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), deleted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SExpD] ON [t_SExpD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 100 - Обновление итогов в главной таблице */
/* t_SExpD - Разукомплектация товара: Составляющие */
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
    (SELECT t_SExpA.ChID, 
       ISNULL(SUM(m.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(m.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(m.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(m.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(m.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(m.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), inserted m
     WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID
     GROUP BY t_SExpA.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 101 - Текущие остатки товара: Составляющие */
/* t_SExpD - Разукомплектация товара: Составляющие */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), inserted m
  WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_SExp.OurID = r.OurID AND t_SExp.SubStockID = r.StockID AND m.SubSecID = r.SecID AND m.SubProdID = r.ProdID AND m.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID, 
       ISNULL(SUM(m.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SExp WITH (NOLOCK), t_SExpA WITH (NOLOCK), inserted m
     WHERE m.SubProdID = r_Prods.ProdID AND t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY t_SExp.OurID, t_SExp.SubStockID, m.SubSecID, m.SubProdID, m.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
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