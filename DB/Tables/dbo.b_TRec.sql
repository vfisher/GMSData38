CREATE TABLE [dbo].[b_TRec]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[SrcDocID] [varchar] (250) NULL,
[SrcDocDate] [smalldatetime] NULL,
[DocType] [int] NOT NULL,
[GTSum_wt] [numeric] (21, 9) NOT NULL,
[GTTaxSum] [numeric] (21, 9) NOT NULL,
[GTAccID] [int] NOT NULL,
[PosType] [tinyint] NOT NULL,
[TaxType] [tinyint] NOT NULL,
[TaxCredit] [bit] NOT NULL,
[PayDate] [smalldatetime] NULL,
[PayForm] [varchar] (200) NULL,
[TakeTotalCosts] [bit] NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[GPosID] [int] NOT NULL DEFAULT (0),
[GTCorrSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[IsCorrection] [bit] NOT NULL DEFAULT (0),
[GTAdvAccID] [int] NOT NULL DEFAULT (0),
[GTAdvSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrAdvSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTAdvTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrAdvTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCC_nt_20] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TaxSum_20] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCC_nt_0] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TaxSum_0] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCC_nt_Free] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TaxSum_Free] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCC_nt_No] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TaxSum_No] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TaxCorrType] [tinyint] NOT NULL,
[SumCC_nt_7] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[TaxSum_7] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[GMSCheck_IU] 
  ON [dbo].[b_TRec]
  AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON

  DECLARE
    @ChID bigint,
    @CompID int,
    @SrcDocDate smalldatetime,
    @SrcDocID varchar(50),
    @ABegin smalldatetime,
    @AEnd smalldatetime,
    @err varchar(250)

  SELECT @ChID = ChID, @CompID = CompID, @SrcDocDate = SrcDocDate, @SrcDocID = SrcDocID FROM inserted

  /* Проверка на дублирование входящего номера */
  SELECT @ABegin = dbo.zf_GetMonthFirstDay(@SrcDocDate)
  SELECT @AEnd = dbo.zf_GetMonthLastDay(@SrcDocDate)
  IF EXISTS(SELECT TOP 1 1 FROM b_TRec WHERE ChID <> @ChID AND CompID = @CompID AND SrcDocID = @SrcDocID AND (SrcDocDate between @ABegin and @AEnd))
    BEGIN
      SELECT
        @err = 'Налоговая накладная от текущего предприятия с номером ' + @SrcDocID +
        ' в период с ' + dbo.zf_DateToStr(@ABegin) + ' по ' + dbo.zf_DateToStr(@AEnd) + ' уже зарегистрирована.'
      RAISERROR (@err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_TRec] ON [dbo].[b_TRec]
FOR INSERT AS
/* b_TRec - Налоговые накладные: Входящие - INSERT TRIGGER */
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
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(14341, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Налоговые накладные: Входящие'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* b_TRec ^ r_Codes1 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Codes2 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Codes3 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Codes4 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Codes5 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Comps - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_GAccs - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_GAccs - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTAdvAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_GOpers - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Ours - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_States - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TRec', 0
      RETURN
    END

/* b_TRec ^ r_Uni - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PosType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10041))
    BEGIN
      EXEC z_RelationErrorUni 'b_TRec', 10041, 0
      RETURN
    END

/* b_TRec ^ r_Uni - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxCorrType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10042))
    BEGIN
      EXEC z_RelationErrorUni 'b_TRec', 10042, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14341001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_TRec]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_TRec] ON [dbo].[b_TRec]
FOR UPDATE AS
/* b_TRec - Налоговые накладные: Входящие - UPDATE TRIGGER */
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
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(14341, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Налоговые накладные: Входящие).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 14341, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('b_TRec', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14341, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Налоговые накладные: Входящие'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_TRec ^ r_Codes1 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Codes2 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Codes3 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Codes4 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Codes5 - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Comps - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_GAccs - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_GAccs - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTAdvAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTAdvAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_GOpers - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Ours - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_States - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_TRec', 1
        RETURN
      END

/* b_TRec ^ r_Uni - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(PosType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PosType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10041))
      BEGIN
        EXEC z_RelationErrorUni 'b_TRec', 10041, 1
        RETURN
      END

/* b_TRec ^ r_Uni - Проверка в PARENT */
/* Налоговые накладные: Входящие ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(TaxCorrType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxCorrType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10042))
      BEGIN
        EXEC z_RelationErrorUni 'b_TRec', 10042, 1
        RETURN
      END

/* b_TRec ^ z_DocLinks - Обновление CHILD */
/* Налоговые накладные: Входящие ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 14341, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 14341 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14341 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Налоговые накладные: Входящие'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_TRec ^ z_DocLinks - Обновление CHILD */
/* Налоговые накладные: Входящие ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 14341, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 14341 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 14341 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Налоговые накладные: Входящие'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_TRec ^ z_DocShed - Обновление CHILD */
/* Налоговые накладные: Входящие ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14341, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14341 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14341 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Налоговые накладные: Входящие'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14341 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14341 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14341001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14341001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14341001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14341001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14341001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14341001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14341001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14341001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14341001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_TRec]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_TRec] ON [dbo].[b_TRec]
FOR DELETE AS
/* b_TRec - Налоговые накладные: Входящие - DELETE TRIGGER */
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
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Налоговые накладные: Входящие (b_TRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 14341 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14341, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Налоговые накладные: Входящие'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_TRec ^ z_DocLinks - Удаление в CHILD */
/* Налоговые накладные: Входящие ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14341 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_TRec ^ z_DocLinks - Проверка в CHILD */
/* Налоговые накладные: Входящие ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 14341 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'b_TRec', 'z_DocLinks', 3
      RETURN
    END

/* b_TRec ^ z_DocShed - Удаление в CHILD */
/* Налоговые накладные: Входящие ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14341 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14341001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14341001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14341001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14341 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_TRec]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_TRec] ADD CONSTRAINT [pk_b_TRec] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_TRec] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_TRec] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_TRec] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_TRec] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_TRec] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[b_TRec] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_TRec] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_TRec] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocType] ON [dbo].[b_TRec] ([DocType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_TRec] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTAccID] ON [dbo].[b_TRec] ([GTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_TRec] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_TRec] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[b_TRec] ([OurID], [DocID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[DocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[PosType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TaxType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TaxCredit]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TakeTotalCosts]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[DocType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[GTAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[PosType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TaxType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TaxCredit]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TRec].[TakeTotalCosts]'
GO
