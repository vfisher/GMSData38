CREATE TABLE [dbo].[b_BankExpAC] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [AccountAC] [varchar](250) NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [StockID] [int] NOT NULL,
  [CompID] [int] NOT NULL,
  [CompAccountAC] [varchar](250) NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  [SumAC] [numeric](21, 9) NOT NULL,
  [CKursMC] [numeric](21, 9) NOT NULL,
  [CKursCC] [numeric](21, 9) NOT NULL,
  [CSumCC] [numeric](21, 9) NOT NULL,
  [Subject] [varchar](255) NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTAccID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [GTSum_wt] [numeric](21, 9) NOT NULL,
  [GTTaxSum] [numeric](21, 9) NOT NULL,
  [StateCode] [int] NOT NULL DEFAULT (0),
  [GPosID] [int] NOT NULL DEFAULT (0),
  [SumCC] [numeric](21, 9) NOT NULL,
  [GTCorrSum_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [GTCorrTaxSum] [numeric](21, 9) NOT NULL DEFAULT (0),
  [SrcDocID] [varchar](250) NULL,
  [GTAdvAccID] [int] NOT NULL DEFAULT (0),
  [GTAdvSum_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [GTCorrAdvSum_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [GTAdvTaxSum] [numeric](21, 9) NOT NULL DEFAULT (0),
  [GTCorrAdvTaxSum] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [pk_b_BankExpAC] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [AccountAC]
  ON [dbo].[b_BankExpAC] ([AccountAC])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[b_BankExpAC] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[b_BankExpAC] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[b_BankExpAC] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[b_BankExpAC] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[b_BankExpAC] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompAccountAC]
  ON [dbo].[b_BankExpAC] ([CompAccountAC])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[b_BankExpAC] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[b_BankExpAC] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[b_BankExpAC] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[b_BankExpAC] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[b_BankExpAC] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [KursCC]
  ON [dbo].[b_BankExpAC] ([KursCC])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[b_BankExpAC] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[b_BankExpAC] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[b_BankExpAC] ([StockID])
  ON [PRIMARY]
GO

CREATE INDEX [SumAC]
  ON [dbo].[b_BankExpAC] ([SumAC])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_BankExpAC] ON [b_BankExpAC]
FOR INSERT AS
/* b_BankExpAC - Валютный счет: Расход - INSERT TRIGGER */
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
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(14022, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Валютный счет: Расход'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* b_BankExpAC ^ r_Codes1 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Codes2 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Codes3 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Codes4 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Codes5 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_CompsAC - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник предприятий - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_CompsAC m WITH(NOLOCK), inserted i WHERE i.CompID = m.CompID AND i.CompAccountAC = m.CompAccountAC) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Currs - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Emps - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_GAccs - Проверка в PARENT */
/* Валютный счет: Расход ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTAccID NOT IN (SELECT GAccId FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_GAccs - Проверка в PARENT */
/* Валютный счет: Расход ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTAdvAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_GOpers - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_OursAC - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.OurID = m.OurID AND i.AccountAC = m.AccountAC) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_States - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankExpAC', 0
      RETURN
    END

/* b_BankExpAC ^ r_Stocks - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_BankExpAC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14022001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_BankExpAC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_BankExpAC] ON [b_BankExpAC]
FOR UPDATE AS
/* b_BankExpAC - Валютный счет: Расход - UPDATE TRIGGER */
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
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(14022, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Валютный счет: Расход).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 14022, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('b_BankExpAC', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14022, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Валютный счет: Расход'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_BankExpAC ^ r_Codes1 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Codes2 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Codes3 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Codes4 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Codes5 - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_CompsAC - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник предприятий - Валютные счета - Проверка в PARENT */
  IF UPDATE(CompID) OR UPDATE(CompAccountAC)
    IF (SELECT COUNT(*) FROM r_CompsAC m WITH(NOLOCK), inserted i WHERE i.CompID = m.CompID AND i.CompAccountAC = m.CompAccountAC) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_CompsAC', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Currs - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Emps - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_GAccs - Проверка в PARENT */
/* Валютный счет: Расход ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTAccID NOT IN (SELECT GAccId FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_GAccs - Проверка в PARENT */
/* Валютный счет: Расход ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTAdvAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTAdvAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_GOpers - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_OursAC - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF UPDATE(OurID) OR UPDATE(AccountAC)
    IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.OurID = m.OurID AND i.AccountAC = m.AccountAC) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OursAC', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_States - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ r_Stocks - Проверка в PARENT */
/* Валютный счет: Расход ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_BankExpAC', 1
        RETURN
      END

/* b_BankExpAC ^ z_DocLinks - Обновление CHILD */
/* Валютный счет: Расход ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 14022, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 14022 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14022 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Валютный счет: Расход'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_BankExpAC ^ z_DocLinks - Обновление CHILD */
/* Валютный счет: Расход ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 14022, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 14022 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 14022 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Валютный счет: Расход'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_BankExpAC ^ z_DocShed - Обновление CHILD */
/* Валютный счет: Расход ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14022, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14022 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14022 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Валютный счет: Расход'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14022 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14022 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14022001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14022001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14022001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14022001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14022001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14022001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14022001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14022001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14022001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_BankExpAC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_BankExpAC] ON [b_BankExpAC]
FOR DELETE AS
/* b_BankExpAC - Валютный счет: Расход - DELETE TRIGGER */
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
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Валютный счет: Расход (b_BankExpAC):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 14022 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14022, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Валютный счет: Расход'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_BankExpAC ^ z_DocLinks - Удаление в CHILD */
/* Валютный счет: Расход ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14022 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_BankExpAC ^ z_DocLinks - Проверка в CHILD */
/* Валютный счет: Расход ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 14022 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'b_BankExpAC', 'z_DocLinks', 3
      RETURN
    END

/* b_BankExpAC ^ z_DocShed - Удаление в CHILD */
/* Валютный счет: Расход ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14022 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14022001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14022001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14022001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14022 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_BankExpAC', N'Last', N'DELETE'
GO