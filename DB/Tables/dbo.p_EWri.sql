CREATE TABLE [dbo].[p_EWri]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[WritDocID] [varchar] (50) NOT NULL,
[WritDate] [smalldatetime] NULL,
[WritDept] [varchar] (200) NOT NULL,
[WritType] [tinyint] NOT NULL,
[WritBDate] [smalldatetime] NOT NULL,
[WritEDate] [smalldatetime] NOT NULL,
[WritSumCC] [numeric] (21, 9) NOT NULL,
[WritPrc] [numeric] (21, 9) NOT NULL,
[TransType] [tinyint] NOT NULL,
[BankID] [int] NOT NULL,
[AccountCC] [varchar] (250) NULL,
[Notes] [varchar] (200) NULL,
[AddrCompID] [int] NOT NULL,
[AddrEmpID] [int] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_EWri] ON [dbo].[p_EWri]
FOR INSERT AS
/* p_EWri - Исполнительный лист - INSERT TRIGGER */
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
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(15042, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Исполнительный лист'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* p_EWri ^ r_Banks - Проверка в PARENT */
/* Исполнительный лист ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Codes1 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Codes2 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Codes3 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Codes4 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Codes5 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Comps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AddrCompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Deps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Emps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Emps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AddrEmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Ours - Проверка в PARENT */
/* Исполнительный лист ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_States - Проверка в PARENT */
/* Исполнительный лист ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EWri', 0
      RETURN
    END

/* p_EWri ^ r_Subs - Проверка в PARENT */
/* Исполнительный лист ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EWri', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15042001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_p_EWri]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_EWri] ON [dbo].[p_EWri]
FOR UPDATE AS
/* p_EWri - Исполнительный лист - UPDATE TRIGGER */
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
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(15042, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Исполнительный лист).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 15042, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('p_EWri', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(15042, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Исполнительный лист'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* p_EWri ^ r_Banks - Проверка в PARENT */
/* Исполнительный лист ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Codes1 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Codes2 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Codes3 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Codes4 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Codes5 - Проверка в PARENT */
/* Исполнительный лист ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Comps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(AddrCompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AddrCompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Deps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Emps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Emps - Проверка в PARENT */
/* Исполнительный лист ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(AddrEmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AddrEmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Ours - Проверка в PARENT */
/* Исполнительный лист ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_States - Проверка в PARENT */
/* Исполнительный лист ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ r_Subs - Проверка в PARENT */
/* Исполнительный лист ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_EWri', 1
        RETURN
      END

/* p_EWri ^ p_EWriP - Обновление CHILD */
/* Исполнительный лист ^ Исполнительный лист (Удержания) - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM p_EWriP a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWriP a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Исполнительный лист'' => ''Исполнительный лист (Удержания)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EWri ^ z_DocLinks - Обновление CHILD */
/* Исполнительный лист ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 15042, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 15042 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15042 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Исполнительный лист'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EWri ^ z_DocLinks - Обновление CHILD */
/* Исполнительный лист ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 15042, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 15042 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 15042 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Исполнительный лист'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EWri ^ z_DocShed - Обновление CHILD */
/* Исполнительный лист ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 15042, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 15042 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 15042 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Исполнительный лист'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 15042 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 15042 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15042001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15042001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(OurID) OR UPDATE(DocID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15042001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DocID as varchar(200)) + ']' AND i.OurID = d.OurID AND i.DocID = d.DocID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15042001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DocID as varchar(200)) + ']' AND i.OurID = d.OurID AND i.DocID = d.DocID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15042001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15042001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15042001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15042001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(DocID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, DocID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, DocID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15042001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15042001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15042001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15042001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15042001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15042001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15042001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_p_EWri]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_EWri] ON [dbo].[p_EWri]
FOR DELETE AS
/* p_EWri - Исполнительный лист - DELETE TRIGGER */
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
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Исполнительный лист (p_EWri):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 15042 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(15042, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Исполнительный лист'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* p_EWri ^ p_EWriP - Удаление в CHILD */
/* Исполнительный лист ^ Исполнительный лист (Удержания) - Удаление в CHILD */
  DELETE p_EWriP FROM p_EWriP a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_EWri ^ z_DocLinks - Удаление в CHILD */
/* Исполнительный лист ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15042 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_EWri ^ z_DocLinks - Проверка в CHILD */
/* Исполнительный лист ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 15042 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'p_EWri', 'z_DocLinks', 3
      RETURN
    END

/* p_EWri ^ z_DocShed - Удаление в CHILD */
/* Исполнительный лист ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 15042 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15042001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15042001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15042001, -ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 15042 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_p_EWri]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[p_EWri] ADD CONSTRAINT [_pk_p_EWri] PRIMARY KEY CLUSTERED ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountCC] ON [dbo].[p_EWri] ([AccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AddrCompID] ON [dbo].[p_EWri] ([AddrCompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AddrEmpID] ON [dbo].[p_EWri] ([AddrEmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[p_EWri] ([BankID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[p_EWri] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[p_EWri] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[p_EWri] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[p_EWri] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[p_EWri] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[p_EWri] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_EWri] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[p_EWri] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_EWri] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[p_EWri] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[p_EWri] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[p_EWri] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_EWri] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[WritType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[WritSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[WritPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[TransType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[AddrCompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[AddrEmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[WritType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[WritSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[WritPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[TransType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[AddrCompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EWri].[AddrEmpID]'
GO
