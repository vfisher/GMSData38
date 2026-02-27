CREATE TABLE [dbo].[b_PVenD] (
  [ChID] [bigint] NOT NULL,
  [DetProdID] [int] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [DetUM] [varchar](10) NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [NewQty] [numeric](21, 9) NOT NULL,
  [NewSumCC_nt] [numeric](21, 9) NOT NULL,
  [NewTaxSum] [numeric](21, 9) NOT NULL,
  [NewSumCC_wt] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_b_PVenD] PRIMARY KEY CLUSTERED ([ChID], [DetProdID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [b_PInPb_PVenD]
  ON [dbo].[b_PVenD] ([DetProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [b_PVenAb_PVenD]
  ON [dbo].[b_PVenD] ([ChID], [DetProdID])
  ON [PRIMARY]
GO

CREATE INDEX [DetProdID]
  ON [dbo].[b_PVenD] ([DetProdID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[b_PVenD] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[b_PVenD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotalsNew]
  ON [dbo].[b_PVenD] ([ChID], [NewQty], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.DetProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.NewQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.NewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.NewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVenD.NewSumCC_wt'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PVenD] ON [b_PVenD]
FOR DELETE AS
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, b_PVenA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, b_PVenA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, b_PVenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, b_PVenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_PVen a, b_PVenA b, deleted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14122003 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14122003 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14122003, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PVenD', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PVenD] ON [b_PVenD]
FOR UPDATE AS
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, b_PVenA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, b_PVenA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, b_PVenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, b_PVenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, b_PVenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, b_PVenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_PVen a, b_PVenA b, deleted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PVenD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Инвентаризация (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(DetProdID)
    IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.DetProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PInP', 'b_PVenD', 1
        RETURN
      END

/* b_PVenD ^ b_PVenA - Проверка в PARENT */
/* ТМЦ: Инвентаризация (ТМЦ) ^ ТМЦ: Инвентаризация (Итоги) - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DetProdID)
    IF (SELECT COUNT(*) FROM b_PVenA m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DetProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PVenA', 'b_PVenD', 1
        RETURN
      END


/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14122003 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14122003 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(DetProdID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14122003 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.DetProdID = d.DetProdID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14122003 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.DetProdID = d.DetProdID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14122003, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14122003 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14122003 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14122003, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(DetProdID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, DetProdID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, DetProdID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14122003 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14122003 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14122003, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14122003 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14122003 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14122003, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14122003, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PVenD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PVenD] ON [b_PVenD]
FOR INSERT AS
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, b_PVenA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PVen a, b_PVenA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PVen a, b_PVenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PVen a, b_PVenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (ТМЦ)'), 'b_PVenD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_PVen a, b_PVenA b, inserted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PVenD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Инвентаризация (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.DetProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_PVenD', 0
      RETURN
    END

/* b_PVenD ^ b_PVenA - Проверка в PARENT */
/* ТМЦ: Инвентаризация (ТМЦ) ^ ТМЦ: Инвентаризация (Итоги) - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PVenA m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DetProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PVenA', 'b_PVenD', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14122003, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PVenD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PVenD] ON [b_PVenD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 180 - Обновление промежуточных итогов (Бизнес): Инвентаризация товара */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM b_PVenA r, 
    (SELECT m.ChID, m.DetProdID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVenA WITH (NOLOCK), deleted m
     WHERE b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID
     GROUP BY m.ChID, m.DetProdID) q
  WHERE q.ChID = r.ChID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 166 - Текущие остатки товара - Расход */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 169 - Текущие остатки товара - Приход */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PVenD] ON [b_PVenD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 180 - Обновление промежуточных итогов (Бизнес): Инвентаризация товара */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) */

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
  FROM b_PVenA r, 
    (SELECT m.ChID, m.DetProdID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVenA WITH (NOLOCK), inserted m
     WHERE b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID
     GROUP BY m.ChID, m.DetProdID) q
  WHERE q.ChID = r.ChID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM b_PVenA r, 
    (SELECT m.ChID, m.DetProdID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVenA WITH (NOLOCK), deleted m
     WHERE b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID
     GROUP BY m.ChID, m.DetProdID) q
  WHERE q.ChID = r.ChID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 166 - Текущие остатки товара - Расход */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(PPID) OR UPDATE(DetProdID) OR UPDATE(Qty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 169 - Текущие остатки товара - Приход */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(PPID) OR UPDATE(DetProdID) OR UPDATE(NewQty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_PVenD] ON [b_PVenD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 180 - Обновление промежуточных итогов (Бизнес): Инвентаризация товара */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_PVenA - ТМЦ: Инвентаризация (Итоги) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM b_PVenA r, 
    (SELECT m.ChID, m.DetProdID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM b_PVenA WITH (NOLOCK), inserted m
     WHERE b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID
     GROUP BY m.ChID, m.DetProdID) q
  WHERE q.ChID = r.ChID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 166 - Текущие остатки товара - Расход */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 169 - Текущие остатки товара - Приход */
/* b_PVenD - ТМЦ: Инвентаризация (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PVen.OurID = r.OurID AND b_PVen.StockID = r.StockID AND m.PPID = r.PPID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID, 
       ISNULL(SUM(m.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVen WITH (NOLOCK), b_PVenA WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.DetProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = m.ChID AND b_PVenA.ProdID = m.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY b_PVen.OurID, b_PVen.StockID, m.PPID, m.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
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