CREATE TABLE [dbo].[b_ARepADV] (
  [ChID] [bigint] NOT NULL,
  [VCodeID1] [smallint] NOT NULL,
  [VCodeID2] [smallint] NOT NULL,
  [VCodeID3] [smallint] NOT NULL,
  [VCodeID4] [smallint] NOT NULL,
  [VCodeID5] [smallint] NOT NULL,
  [VKursMC] [numeric](21, 9) NOT NULL,
  [VKursCC] [numeric](21, 9) NOT NULL,
  [VCurrID] [smallint] NOT NULL,
  [VSumAC] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [DocDesc] [varchar](200) NOT NULL,
  [BuyDate] [smalldatetime] NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [GVTSum_wt] [numeric](21, 9) NOT NULL,
  [GVTTaxSum] [numeric](21, 9) NOT NULL,
  [GVTAccID] [int] NOT NULL,
  CONSTRAINT [_pk_b_ARepADV] PRIMARY KEY CLUSTERED ([ChID], [DocDesc])
)
ON [PRIMARY]
GO

CREATE INDEX [_b_ARepADV_ZTotals]
  ON [dbo].[b_ARepADV] ([ChID], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_ARepADV] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_ARepADV] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [GVTAccID]
  ON [dbo].[b_ARepADV] ([GVTAccID])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID1]
  ON [dbo].[b_ARepADV] ([VCodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID2]
  ON [dbo].[b_ARepADV] ([VCodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID3]
  ON [dbo].[b_ARepADV] ([VCodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID4]
  ON [dbo].[b_ARepADV] ([VCodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID5]
  ON [dbo].[b_ARepADV] ([VCodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [VCurrID]
  ON [dbo].[b_ARepADV] ([VCurrID])
  ON [PRIMARY]
GO

CREATE INDEX [VKursCC]
  ON [dbo].[b_ARepADV] ([VKursCC])
  ON [PRIMARY]
GO

CREATE INDEX [VKursMC]
  ON [dbo].[b_ARepADV] ([VKursMC])
  ON [PRIMARY]
GO

CREATE INDEX [VSumAC]
  ON [dbo].[b_ARepADV] ([VSumAC])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VCodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VCodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VCodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VCodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VCodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VKursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VKursCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VCurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.VSumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.GVTSum_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.GVTTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADV.GVTAccID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_ARepADV] ON [b_ARepADV]
FOR DELETE AS
/* b_ARepADV - Авансовый отчет валютный (Общие) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_ARepA a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14312, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Авансовый отчет валютный'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14312002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDesc as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14312002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDesc as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14312002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_ARepADV', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_ARepADV] ON [b_ARepADV]
FOR UPDATE AS
/* b_ARepADV - Авансовый отчет валютный (Общие) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_ARepA a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14312, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Авансовый отчет валютный'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_ARepADV ^ b_ARepA - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_ARepA))
      BEGIN
        EXEC z_RelationError 'b_ARepA', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_Codes1 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(VCodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_Codes2 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(VCodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_Codes3 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(VCodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_Codes4 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(VCodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_Codes5 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(VCodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_Currs - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(VCurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_GAccs - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ План счетов - Проверка в PARENT */
  IF UPDATE(GVTAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GVTAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_ARepADV', 1
        RETURN
      END

/* b_ARepADV ^ r_GOpers - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_ARepADV', 1
        RETURN
      END


/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14312002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14312002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(DocDesc))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14312002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DocDesc as varchar(200)) + ']' AND i.ChID = d.ChID AND i.DocDesc = d.DocDesc
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14312002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DocDesc as varchar(200)) + ']' AND i.ChID = d.ChID AND i.DocDesc = d.DocDesc
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14312002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14312002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14312002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14312002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(DocDesc)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, DocDesc FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, DocDesc FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDesc as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14312002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDesc as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDesc as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14312002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDesc as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14312002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14312002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocDesc as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14312002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocDesc as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14312002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14312002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_ARepADV', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_ARepADV] ON [b_ARepADV]
FOR INSERT AS
/* b_ARepADV - Авансовый отчет валютный (Общие) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Авансовый отчет валютный (Общие)'), 'b_ARepADV', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_ARepA a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14312, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Авансовый отчет валютный'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_ARepADV ^ b_ARepA - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_ARepA))
    BEGIN
      EXEC z_RelationError 'b_ARepA', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_Codes1 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_Codes2 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_Codes3 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_Codes4 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_Codes5 - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_Currs - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_GAccs - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GVTAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARepADV', 0
      RETURN
    END

/* b_ARepADV ^ r_GOpers - Проверка в PARENT */
/* Авансовый отчет валютный (Общие) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ARepADV', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14312002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocDesc as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_ARepADV', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_ARepADV] ON [b_ARepADV]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 107 - Обновление итогов в главной таблице */
/* b_ARepADV - Авансовый отчет валютный (Общие) */
/* b_ARepA - Авансовый отчет валютный (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumMC = r.TSumMC - q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.VSumAC / m.VKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), deleted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_ARepADV] ON [b_ARepADV]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 107 - Обновление итогов в главной таблице */
/* b_ARepADV - Авансовый отчет валютный (Общие) */
/* b_ARepA - Авансовый отчет валютный (Заголовок) */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(VSumAC) OR UPDATE(VKursMC)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumMC = r.TSumMC + q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.VSumAC / m.VKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), inserted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumMC = r.TSumMC - q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.VSumAC / m.VKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), deleted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_ARepADV] ON [b_ARepADV]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 107 - Обновление итогов в главной таблице */
/* b_ARepADV - Авансовый отчет валютный (Общие) */
/* b_ARepA - Авансовый отчет валютный (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumMC = r.TSumMC + q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.VSumAC / m.VKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), inserted m
     WHERE b_ARepA.ChID = m.ChID
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