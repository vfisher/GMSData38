CREATE TABLE [dbo].[t_Cst2] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [KursAC] [numeric](21, 9) NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [CompID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [PayDelay] [smallint] NULL,
  [Notes] [varchar](200) NULL,
  [CurrID] [smallint] NOT NULL,
  [DelID] [tinyint] NOT NULL,
  [TSumAC_In] [numeric](21, 9) NOT NULL,
  [TTrtAC] [numeric](21, 9) NOT NULL,
  [TMoreCC] [numeric](21, 9) NOT NULL,
  [Note1] [varchar](200) NULL,
  [CompAdd] [varchar](200) NULL,
  [StateCode] [int] NOT NULL,
  [TTaxSum] [numeric](21, 9) NOT NULL,
  [TSumCC_In] [numeric](21, 9) NOT NULL,
  [CstCompID] [int] NOT NULL,
  [TCstSumCCCor] [numeric](21, 9) NOT NULL,
  [TTrtCC] [numeric](21, 9) NOT NULL,
  [KursAC_In] [numeric](21, 9) NOT NULL,
  [CstDocCode] [varchar](250) NULL,
  [UseTrtCCToCstSumCC] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_Cst2] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_Cst2] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_Cst2] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_Cst2] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_Cst2] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_Cst2] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[t_Cst2] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[t_Cst2] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [DelID]
  ON [dbo].[t_Cst2] ([DelID])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[t_Cst2] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[t_Cst2] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[t_Cst2] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID]
  ON [dbo].[t_Cst2] ([IntDocID])
  ON [PRIMARY]
GO

CREATE INDEX [KursAC]
  ON [dbo].[t_Cst2] ([KursAC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_Cst2] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [PayDelay]
  ON [dbo].[t_Cst2] ([PayDelay])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_Cst2] ([StockID])
  ON [PRIMARY]
GO

CREATE INDEX [TMoreCC]
  ON [dbo].[t_Cst2] ([TMoreCC])
  ON [PRIMARY]
GO

CREATE INDEX [TSumAC_In]
  ON [dbo].[t_Cst2] ([TSumAC_In])
  ON [PRIMARY]
GO

CREATE INDEX [TTrtAC]
  ON [dbo].[t_Cst2] ([TTrtAC])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_Cst2] ON [t_Cst2]
FOR INSERT AS
/* t_Cst2 - Приход товара по ГТД (новый)(Заголовок) - INSERT TRIGGER */
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
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11046, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Приход товара по ГТД (новый)'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_Cst2 ^ r_Codes1 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Codes2 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Codes3 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Codes4 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Codes5 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Comps - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Comps - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CstCompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Currs - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Emps - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Ours - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_States - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_Cst2', 0
      RETURN
    END

/* t_Cst2 ^ r_Stocks - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Cst2', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_Cst2', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_Cst2] ON [t_Cst2]
FOR UPDATE AS
/* t_Cst2 - Приход товара по ГТД (новый)(Заголовок) - UPDATE TRIGGER */
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
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11046, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Приход товара по ГТД (новый)).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11046, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('t_Cst2', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11046, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Приход товара по ГТД (новый)'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Cst2 ^ r_Codes1 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Codes2 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Codes3 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Codes4 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Codes5 - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Comps - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Comps - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CstCompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CstCompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Currs - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Emps - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Ours - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_States - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ r_Stocks - Проверка в PARENT */
/* Приход товара по ГТД (новый)(Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_Cst2', 1
        RETURN
      END

/* t_Cst2 ^ t_Cst2D - Обновление CHILD */
/* Приход товара по ГТД (новый)(Заголовок) ^ Приход товара по ГТД (новый) (Данные) - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_Cst2D a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2D a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приход товара по ГТД (новый)(Заголовок)'' => ''Приход товара по ГТД (новый) (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11046 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11046 AND l.ParentChID = i.ChID
  END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_Cst2', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_Cst2] ON [t_Cst2]
FOR DELETE AS
/* t_Cst2 - Приход товара по ГТД (новый)(Заголовок) - DELETE TRIGGER */
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
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приход товара по ГТД (новый)(Заголовок) (t_Cst2):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11046 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11046, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Приход товара по ГТД (новый)'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Cst2 ^ t_Cst2D - Удаление в CHILD */
/* Приход товара по ГТД (новый)(Заголовок) ^ Приход товара по ГТД (новый) (Данные) - Удаление в CHILD */
  DELETE t_Cst2D FROM t_Cst2D a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11046 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_Cst2', N'Last', N'DELETE'
GO