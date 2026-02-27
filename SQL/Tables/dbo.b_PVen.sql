CREATE TABLE [dbo].[b_PVen] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [CompID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  [TranCC] [numeric](21, 9) NULL,
  [MoreCC] [numeric](21, 9) NULL,
  [StateCode] [int] NOT NULL DEFAULT (0),
  [CurrID] [smallint] NOT NULL DEFAULT (0),
  [TSumCC_nt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__b_PVen__TSumCC_n__15D34A18] DEFAULT (0),
  [TTaxSum] [numeric](21, 9) NOT NULL CONSTRAINT [DF__b_PVen__TTaxSum__16C76E51] DEFAULT (0),
  [TSumCC_wt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__b_PVen__TSumCC_w__17BB928A] DEFAULT (0),
  [TNewSumCC_nt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__b_PVen__TNewSumC__18AFB6C3] DEFAULT (0),
  [TNewTaxSum] [numeric](21, 9) NOT NULL CONSTRAINT [DF__b_PVen__TNewTaxS__19A3DAFC] DEFAULT (0),
  [TNewSumCC_wt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__b_PVen__TNewSumC__1A97FF35] DEFAULT (0),
  CONSTRAINT [pk_b_PVen] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[b_PVen] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[b_PVen] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[b_PVen] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[b_PVen] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[b_PVen] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[b_PVen] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[b_PVen] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[b_PVen] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[b_PVen] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID]
  ON [dbo].[b_PVen] ([IntDocID])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[b_PVen] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[b_PVen] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[b_PVen] ([StockID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[b_PVen] ([OurID], [DocID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.DocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.TranCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_PVen.MoreCC'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PVen] ON [b_PVen]
FOR DELETE AS
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM inserted a 

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM deleted a 

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 14122 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
      BEGIN
        DECLARE @Err2 varchar(200)
        SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
        RAISERROR(@Err2, 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_PVen ^ b_PVenA - Удаление в CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ ТМЦ: Инвентаризация (Итоги) - Удаление в CHILD */
  DELETE b_PVenA FROM b_PVenA a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_PVen ^ z_DocLinks - Удаление в CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14122 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_PVen ^ z_DocLinks - Проверка в CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 14122 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'b_PVen', 'z_DocLinks', 3
      RETURN
    END

/* b_PVen ^ z_DocShed - Удаление в CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14122 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14122001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14122001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14122001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14122 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PVen', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PVen] ON [b_PVen]
FOR UPDATE AS
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM inserted a 

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM deleted a 

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли изменить дату документа */
  IF UPDATE(DocDate) 
    BEGIN
      DECLARE @OldTaxPercent numeric(21, 9)
      DECLARE @NewTaxPercent numeric(21, 9)
      SELECT @OldTaxPercent = dbo.zf_GetTaxPercentByDate(0, (SELECT DocDate FROM deleted)), @NewTaxPercent = dbo.zf_GetTaxPercentByDate(0, (SELECT DocDate FROM inserted))
      IF @OldTaxPercent <> @NewTaxPercent
        BEGIN
          DECLARE @Err3 varchar(max)
          SELECT @Err3 = dbo.zf_Translate('Изменение даты документа невозможно (Различные налоговые ставки).')
          RAISERROR (@Err3, 18, 1)
          ROLLBACK TRAN
          RETURN 
        END
    END  

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(14122, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      DECLARE @Err1 varchar(200)
      SELECT @Err1 = FORMATMESSAGE(dbo.zf_Translate('Переход в указанный статус невозможен (%s).'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
      RAISERROR(@Err1, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 14122, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('b_PVen', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14122, a.ChID, a.StateCode) = 0)
      BEGIN
        DECLARE @Err2 varchar(200)
        SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
        RAISERROR(@Err2, 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_PVen ^ r_Codes1 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Codes2 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Codes3 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Codes4 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Codes5 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Comps - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Currs - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Emps - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_States - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_PVen', 1
        RETURN
      END

/* b_PVen ^ b_PVenA - Обновление CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ ТМЦ: Инвентаризация (Итоги) - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM b_PVenA a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVenA a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Инвентаризация (Заголовок)'' => ''ТМЦ: Инвентаризация (Итоги)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PVen ^ z_DocLinks - Обновление CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 14122, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 14122 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14122 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Инвентаризация (Заголовок)'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PVen ^ z_DocLinks - Обновление CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 14122, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 14122 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 14122 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Инвентаризация (Заголовок)'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PVen ^ z_DocShed - Обновление CHILD */
/* ТМЦ: Инвентаризация (Заголовок) ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14122, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14122 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14122 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Инвентаризация (Заголовок)'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14122 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14122 AND l.ParentChID = i.ChID
  END


/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(DocID) OR UPDATE(IntDocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(CompID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(EmpID) OR UPDATE(Notes) OR UPDATE(TranCC) OR UPDATE(MoreCC) OR UPDATE(StateCode) OR UPDATE(CurrID)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14122001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14122001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14122001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14122001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14122001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14122001, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14122001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14122001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14122001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PVen', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PVen] ON [b_PVen]
FOR INSERT AS
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM inserted a 

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM deleted a 

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Инвентаризация (Заголовок)'), 'b_PVen', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(14122, i.StateCode) = 0)
    BEGIN
      DECLARE @Err1 varchar(200)
      SELECT @Err1 = FORMATMESSAGE(dbo.zf_Translate('Документ ''%s'' не может иметь указанный статус.'), dbo.zf_Translate('ТМЦ: Инвентаризация'))
      RAISERROR(@Err1, 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* b_PVen ^ r_Codes1 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Codes2 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Codes3 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Codes4 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Codes5 - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Comps - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Currs - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Emps - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_States - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PVen', 0
      RETURN
    END

/* b_PVen ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Инвентаризация (Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PVen', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14122001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PVen', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PVen] ON [b_PVen]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 165 - Текущие остатки товара - Расход */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PVenD.PPID = r.PPID AND b_PVenD.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 
       ISNULL(SUM(b_PVenD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 168 - Текущие остатки товара - Приход */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PVenD.PPID = r.PPID AND b_PVenD.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 
       ISNULL(SUM(b_PVenD.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PVen] ON [b_PVen]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 165 - Текущие остатки товара - Расход */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PVenD.PPID = r.PPID AND b_PVenD.DetProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PVenD.PPID = r.PPID AND b_PVenD.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 
       ISNULL(SUM(b_PVenD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 
       ISNULL(SUM(b_PVenD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 168 - Текущие остатки товара - Приход */
/* b_PVen - ТМЦ: Инвентаризация (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PVenD.PPID = r.PPID AND b_PVenD.DetProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PVenD.PPID = r.PPID AND b_PVenD.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 
       ISNULL(SUM(b_PVenD.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID, 
       ISNULL(SUM(b_PVenD.NewQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND m.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PVenD.PPID, b_PVenD.DetProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
END
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