CREATE TABLE [dbo].[c_CompCurr]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[AccountAC] [varchar] (250) NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CompAccountAC] [varchar] (250) NOT NULL,
[NewCompAccountAC] [varchar] (250) NOT NULL,
[CurrID] [smallint] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[Subject] [varchar] (200) NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[NewAccountAC] [varchar] (250) NOT NULL,
[NewCurrID] [smallint] NOT NULL,
[NewSumAC] [numeric] (21, 9) NOT NULL,
[NewKursMC] [numeric] (21, 9) NOT NULL,
[NewKursCC] [numeric] (21, 9) NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[SrcDocID] [varchar] (250) NULL,
[OldNewAccountAC] [varchar] (20) NULL,
[OldNewCompAccountAC] [varchar] (20) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_c_CompCurr] 
ON [dbo].[c_CompCurr] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND (UPDATE(NewAccountAC) OR UPDATE(NewCompAccountAC)) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(NewCompAccountAC)    
      UPDATE oc 
      SET    oc.OldNewCompAccountAC = CASE  
                                    WHEN i.NewCompAccountAC LIKE '[a-Z][a-Z]%' AND d.NewCompAccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.NewCompAccountAC 
                                    ELSE i.OldNewCompAccountAC 
                               END 
      FROM   DELETED d 
            ,c_CompCurr oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.NewCompAccountAC=i.NewCompAccountAC) 
    IF UPDATE(NewAccountAC)    
      UPDATE oc 
      SET    oc.OldNewAccountAC = CASE  
                                    WHEN i.NewAccountAC LIKE '[a-Z][a-Z]%' AND d.NewAccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.NewAccountAC 
                                    ELSE i.OldNewAccountAC 
                               END 
      FROM   DELETED d 
            ,c_CompCurr oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.NewAccountAC=i.NewAccountAC) 
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_c_CompCurr] ON [dbo].[c_CompCurr]
FOR INSERT AS
/* c_CompCurr - Обмен валюты по предприятиям - INSERT TRIGGER */
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
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(12003, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Обмен валюты по предприятиям'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* c_CompCurr ^ r_Codes1 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Codes2 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Codes3 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Codes4 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Codes5 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_CompsAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник предприятий - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_CompsAC m WITH(NOLOCK), inserted i WHERE i.CompAccountAC = m.CompAccountAC AND i.CompID = m.CompID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_CompsAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник предприятий - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_CompsAC m WITH(NOLOCK), inserted i WHERE i.NewCompAccountAC = m.CompAccountAC AND i.CompID = m.CompID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Currs - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.NewCurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Currs - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_OursAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.NewAccountAC = m.AccountAC AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_OursAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.AccountAC = m.AccountAC AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_States - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'c_CompCurr', 0
      RETURN
    END

/* c_CompCurr ^ r_Stocks - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'c_CompCurr', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 12003001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_c_CompCurr]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_c_CompCurr] ON [dbo].[c_CompCurr]
FOR UPDATE AS
/* c_CompCurr - Обмен валюты по предприятиям - UPDATE TRIGGER */
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
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(12003, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Обмен валюты по предприятиям).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 12003, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
  DECLARE @StateCodePosID int
  SELECT @StateCodePosID = colid FROM syscolumns WHERE id = object_id('c_CompCurr') AND name = 'StateCode'
  DECLARE @BytePos int
  DECLARE @UpdLen int
  DECLARE @FieldsChanged bit
  SET @FieldsChanged = 0
  SET @BytePos = CAST(CEILING(@StateCodePosID / 8.0) AS int)
  SET @UpdLen = LEN(COLUMNS_UPDATED())
  WHILE (@UpdLen > 0 AND @FieldsChanged = 0)
    BEGIN
      IF @UpdLen = @BytePos
        BEGIN
         IF CAST(SUBSTRING(COLUMNS_UPDATED(), @UpdLen, 1) AS Int) <> POWER(2, @StateCodePosID - (CEILING(@StateCodePosID / 8.0) - 1) * 8 - 1)
           SET @FieldsChanged = 1
        END
      ELSE
        IF CAST(SUBSTRING(COLUMNS_UPDATED(), @UpdLen, 1) AS Int) <> 0
          SET @FieldsChanged = 1
      SET @UpdLen = @UpdLen - 1
    END
  IF @FieldsChanged = 1
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(12003, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Обмен валюты по предприятиям'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* c_CompCurr ^ r_Codes1 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Codes2 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Codes3 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Codes4 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Codes5 - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_CompsAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник предприятий - Валютные счета - Проверка в PARENT */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    IF (SELECT COUNT(*) FROM r_CompsAC m WITH(NOLOCK), inserted i WHERE i.CompAccountAC = m.CompAccountAC AND i.CompID = m.CompID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_CompsAC', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_CompsAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник предприятий - Валютные счета - Проверка в PARENT */
  IF UPDATE(NewCompAccountAC) OR UPDATE(CompID)
    IF (SELECT COUNT(*) FROM r_CompsAC m WITH(NOLOCK), inserted i WHERE i.NewCompAccountAC = m.CompAccountAC AND i.CompID = m.CompID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_CompsAC', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Currs - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(NewCurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.NewCurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Currs - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_OursAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF UPDATE(NewAccountAC) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.NewAccountAC = m.AccountAC AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OursAC', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_OursAC - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.AccountAC = m.AccountAC AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OursAC', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_States - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ r_Stocks - Проверка в PARENT */
/* Обмен валюты по предприятиям ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'c_CompCurr', 1
        RETURN
      END

/* c_CompCurr ^ z_DocLinks - Обновление CHILD */
/* Обмен валюты по предприятиям ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 12003, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 12003 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 12003 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Обмен валюты по предприятиям'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* c_CompCurr ^ z_DocLinks - Обновление CHILD */
/* Обмен валюты по предприятиям ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 12003, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 12003 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 12003 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Обмен валюты по предприятиям'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* c_CompCurr ^ z_DocShed - Обновление CHILD */
/* Обмен валюты по предприятиям ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 12003, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 12003 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 12003 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Обмен валюты по предприятиям'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 12003 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 12003 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 12003001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 12003001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 12003001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 12003001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 12003001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 12003001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 12003001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 12003001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 12003001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_c_CompCurr]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_c_CompCurr] ON [dbo].[c_CompCurr]
FOR DELETE AS
/* c_CompCurr - Обмен валюты по предприятиям - DELETE TRIGGER */
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
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Обмен валюты по предприятиям (c_CompCurr):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 12003 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(12003, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Обмен валюты по предприятиям'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* c_CompCurr ^ z_DocLinks - Удаление в CHILD */
/* Обмен валюты по предприятиям ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 12003 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* c_CompCurr ^ z_DocLinks - Проверка в CHILD */
/* Обмен валюты по предприятиям ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 12003 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'c_CompCurr', 'z_DocLinks', 3
      RETURN
    END

/* c_CompCurr ^ z_DocShed - Удаление в CHILD */
/* Обмен валюты по предприятиям ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 12003 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 12003001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 12003001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 12003001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 12003 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_c_CompCurr]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[c_CompCurr] ADD CONSTRAINT [pk_c_CompCurr] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountAC] ON [dbo].[c_CompCurr] ([AccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[c_CompCurr] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[c_CompCurr] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[c_CompCurr] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[c_CompCurr] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[c_CompCurr] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompAccountAC] ON [dbo].[c_CompCurr] ([CompAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[c_CompCurr] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[c_CompCurr] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[c_CompCurr] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[c_CompCurr] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[c_CompCurr] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[c_CompCurr] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewAccountAC] ON [dbo].[c_CompCurr] ([NewAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewCompAccountAC] ON [dbo].[c_CompCurr] ([NewCompAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewCurrID] ON [dbo].[c_CompCurr] ([NewCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewKursCC] ON [dbo].[c_CompCurr] ([NewKursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewKursMC] ON [dbo].[c_CompCurr] ([NewKursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewSumAC] ON [dbo].[c_CompCurr] ([NewSumAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[c_CompCurr] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[c_CompCurr] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[c_CompCurr] ([SumAC]) ON [PRIMARY]
GO
