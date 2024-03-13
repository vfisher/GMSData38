CREATE TABLE [dbo].[b_PAcc]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[Discount] [numeric] (21, 9) NOT NULL,
[PayDelay] [smallint] NULL,
[Notes] [varchar] (200) NULL,
[TranCC] [numeric] (21, 9) NULL,
[MoreCC] [numeric] (21, 9) NULL,
[Note1] [varchar] (200) NULL,
[Note2] [varchar] (200) NULL,
[CompAdd] [varchar] (200) NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[CurrID] [smallint] NOT NULL DEFAULT (0),
[TSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_PAcc__TSumCC_n__4D58892C] DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_PAcc__TTaxSum__4E4CAD65] DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_PAcc__TSumCC_w__4F40D19E] DEFAULT (0),
[TSumCC_In] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_PAcc__TSumCC_I__5034F5D7] DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PAcc] ON [dbo].[b_PAcc]
FOR INSERT AS
/* b_PAcc - ТМЦ: Счет на оплату (Заголовок) - INSERT TRIGGER */
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
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(14101, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''ТМЦ: Счет на оплату'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* b_PAcc ^ r_Codes1 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Codes2 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Codes3 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Codes4 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Codes5 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Comps - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Currs - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Emps - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_States - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PAcc', 0
      RETURN
    END

/* b_PAcc ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PAcc', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14101001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_PAcc]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PAcc] ON [dbo].[b_PAcc]
FOR UPDATE AS
/* b_PAcc - ТМЦ: Счет на оплату (Заголовок) - UPDATE TRIGGER */
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
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
          RAISERROR ('Изменение даты документа невозможно (Различные налоговые ставки).', 18, 1)
          ROLLBACK TRAN
          RETURN 
        END
    END  

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(14101, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (ТМЦ: Счет на оплату).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 14101, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('b_PAcc', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14101, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''ТМЦ: Счет на оплату'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_PAcc ^ r_Codes1 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Codes2 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Codes3 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Codes4 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Codes5 - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Comps - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Currs - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Emps - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_States - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Счет на оплату (Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_PAcc', 1
        RETURN
      END

/* b_PAcc ^ b_PAccD - Обновление CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ ТМЦ: Счет на оплату (ТМЦ) - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM b_PAccD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAccD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Счет на оплату (Заголовок)'' => ''ТМЦ: Счет на оплату (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PAcc ^ z_DocLinks - Обновление CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 14101, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 14101 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14101 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Счет на оплату (Заголовок)'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PAcc ^ z_DocLinks - Обновление CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 14101, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 14101 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 14101 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Счет на оплату (Заголовок)'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PAcc ^ z_DocShed - Обновление CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14101, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14101 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14101 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Счет на оплату (Заголовок)'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14101 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14101 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(DocID) OR UPDATE(IntDocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(CompID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(EmpID) OR UPDATE(Discount) OR UPDATE(PayDelay) OR UPDATE(Notes) OR UPDATE(TranCC) OR UPDATE(MoreCC) OR UPDATE(Note1) OR UPDATE(Note2) OR UPDATE(CompAdd) OR UPDATE(StateCode) OR UPDATE(CurrID)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14101001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14101001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14101001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14101001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14101001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14101001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14101001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14101001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14101001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_PAcc]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PAcc] ON [dbo].[b_PAcc]
FOR DELETE AS
/* b_PAcc - ТМЦ: Счет на оплату (Заголовок) - DELETE TRIGGER */
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
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Счет на оплату (Заголовок) (b_PAcc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 14101 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14101, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''ТМЦ: Счет на оплату'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_PAcc ^ b_PAccD - Удаление в CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ ТМЦ: Счет на оплату (ТМЦ) - Удаление в CHILD */
  DELETE b_PAccD FROM b_PAccD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_PAcc ^ z_DocLinks - Удаление в CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14101 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_PAcc ^ z_DocLinks - Проверка в CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 14101 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'b_PAcc', 'z_DocLinks', 3
      RETURN
    END

/* b_PAcc ^ z_DocShed - Удаление в CHILD */
/* ТМЦ: Счет на оплату (Заголовок) ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14101 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14101001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14101001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14101001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14101 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_PAcc]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_PAcc] ADD CONSTRAINT [pk_b_PAcc] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_PAcc] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_PAcc] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_PAcc] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_PAcc] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_PAcc] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[b_PAcc] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_PAcc] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_PAcc] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_PAcc] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_PAcc] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_PAcc] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_PAcc] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[b_PAcc] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayDelay] ON [dbo].[b_PAcc] ([PayDelay]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[b_PAcc] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[Discount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[PayDelay]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[TranCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[Discount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[PayDelay]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[TranCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PAcc].[MoreCC]'
GO
