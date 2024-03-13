CREATE TABLE [dbo].[b_TranH]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[CurrID] [smallint] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[GTranID] [int] NOT NULL,
[D_GAccID] [int] NOT NULL,
[C_GAccID] [int] NOT NULL,
[D_CompID] [int] NOT NULL,
[C_CompID] [int] NOT NULL,
[D_EmpID] [int] NOT NULL,
[C_EmpID] [int] NOT NULL,
[D_CodeID1] [smallint] NOT NULL,
[C_CodeID1] [smallint] NOT NULL,
[D_CodeID2] [smallint] NOT NULL,
[C_CodeID2] [smallint] NOT NULL,
[D_CodeID3] [smallint] NOT NULL,
[C_CodeID3] [smallint] NOT NULL,
[D_CodeID4] [smallint] NOT NULL,
[C_CodeID4] [smallint] NOT NULL,
[D_CodeID5] [smallint] NOT NULL,
[C_CodeID5] [smallint] NOT NULL,
[D_StockID] [int] NOT NULL,
[C_StockID] [int] NOT NULL,
[D_ProdID] [int] NOT NULL,
[C_ProdID] [int] NOT NULL,
[D_AssID] [int] NOT NULL,
[C_AssID] [int] NOT NULL,
[D_GVolID] [int] NOT NULL,
[C_GVolID] [int] NOT NULL,
[D_Qty] [numeric] (21, 9) NOT NULL,
[C_Qty] [numeric] (21, 9) NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[SrcDocID] [varchar] (250) NULL,
[SrcDocDate] [smalldatetime] NULL,
[SrcDocName] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_TranH] ON [dbo].[b_TranH]
FOR INSERT AS
/* b_TranH - Ручные проводки - INSERT TRIGGER */
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
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(14335, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Ручные проводки'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* b_TranH ^ r_Assets - Проверка в PARENT */
/* Ручные проводки ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Assets - Проверка в PARENT */
/* Ручные проводки ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes1 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes1 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes2 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes2 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes3 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes3 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes4 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes4 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes5 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Codes5 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Comps - Проверка в PARENT */
/* Ручные проводки ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Comps - Проверка в PARENT */
/* Ручные проводки ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Currs - Проверка в PARENT */
/* Ручные проводки ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Emps - Проверка в PARENT */
/* Ручные проводки ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Emps - Проверка в PARENT */
/* Ручные проводки ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_GAccs - Проверка в PARENT */
/* Ручные проводки ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_GAccs - Проверка в PARENT */
/* Ручные проводки ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_GVols - Проверка в PARENT */
/* Ручные проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GVolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_GVols - Проверка в PARENT */
/* Ручные проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GVolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Ours - Проверка в PARENT */
/* Ручные проводки ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Prods - Проверка в PARENT */
/* Ручные проводки ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Prods - Проверка в PARENT */
/* Ручные проводки ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_States - Проверка в PARENT */
/* Ручные проводки ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Stocks - Проверка в PARENT */
/* Ручные проводки ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_TranH', 0
      RETURN
    END

/* b_TranH ^ r_Stocks - Проверка в PARENT */
/* Ручные проводки ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_TranH', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14335001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_TranH]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_TranH] ON [dbo].[b_TranH]
FOR UPDATE AS
/* b_TranH - Ручные проводки - UPDATE TRIGGER */
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
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(14335, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Ручные проводки).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 14335, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('b_TranH', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14335, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Ручные проводки'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_TranH ^ r_Assets - Проверка в PARENT */
/* Ручные проводки ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(C_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Assets - Проверка в PARENT */
/* Ручные проводки ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(D_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes1 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(C_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes1 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(D_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes2 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(C_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes2 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(D_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes3 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(C_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes3 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(D_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes4 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(C_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes4 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(D_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes5 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(C_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Codes5 - Проверка в PARENT */
/* Ручные проводки ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(D_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Comps - Проверка в PARENT */
/* Ручные проводки ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(C_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Comps - Проверка в PARENT */
/* Ручные проводки ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(D_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Currs - Проверка в PARENT */
/* Ручные проводки ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Emps - Проверка в PARENT */
/* Ручные проводки ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(C_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Emps - Проверка в PARENT */
/* Ручные проводки ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(D_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_GAccs - Проверка в PARENT */
/* Ручные проводки ^ План счетов - Проверка в PARENT */
  IF UPDATE(C_GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_GAccs - Проверка в PARENT */
/* Ручные проводки ^ План счетов - Проверка в PARENT */
  IF UPDATE(D_GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_GVols - Проверка в PARENT */
/* Ручные проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(C_GVolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GVolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_GVols - Проверка в PARENT */
/* Ручные проводки ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(D_GVolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GVolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Ours - Проверка в PARENT */
/* Ручные проводки ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Prods - Проверка в PARENT */
/* Ручные проводки ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(C_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Prods - Проверка в PARENT */
/* Ручные проводки ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(D_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_States - Проверка в PARENT */
/* Ручные проводки ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Stocks - Проверка в PARENT */
/* Ручные проводки ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(C_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ r_Stocks - Проверка в PARENT */
/* Ручные проводки ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(D_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_TranH', 1
        RETURN
      END

/* b_TranH ^ z_DocLinks - Обновление CHILD */
/* Ручные проводки ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 14335, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 14335 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14335 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Ручные проводки'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_TranH ^ z_DocLinks - Обновление CHILD */
/* Ручные проводки ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 14335, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 14335 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 14335 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Ручные проводки'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_TranH ^ z_DocShed - Обновление CHILD */
/* Ручные проводки ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14335, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14335 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14335 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Ручные проводки'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14335001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14335001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14335001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14335001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14335001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14335001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14335001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14335001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14335001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_TranH]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_TranH] ON [dbo].[b_TranH]
FOR DELETE AS
/* b_TranH - Ручные проводки - DELETE TRIGGER */
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
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Ручные проводки (b_TranH):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 14335 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14335, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Ручные проводки'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_TranH ^ z_DocLinks - Удаление в CHILD */
/* Ручные проводки ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 14335 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_TranH ^ z_DocLinks - Проверка в CHILD */
/* Ручные проводки ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 14335 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'b_TranH', 'z_DocLinks', 3
      RETURN
    END

/* b_TranH ^ z_DocShed - Удаление в CHILD */
/* Ручные проводки ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14335 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14335001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14335001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14335001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14335 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_TranH]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_TranH] ADD CONSTRAINT [pk_b_TranH] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_AssID] ON [dbo].[b_TranH] ([C_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID1] ON [dbo].[b_TranH] ([C_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID2] ON [dbo].[b_TranH] ([C_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID3] ON [dbo].[b_TranH] ([C_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID4] ON [dbo].[b_TranH] ([C_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID5] ON [dbo].[b_TranH] ([C_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CompID] ON [dbo].[b_TranH] ([C_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_EmpID] ON [dbo].[b_TranH] ([C_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccID] ON [dbo].[b_TranH] ([C_GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GVolID] ON [dbo].[b_TranH] ([C_GVolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_ProdID] ON [dbo].[b_TranH] ([C_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_StockID] ON [dbo].[b_TranH] ([C_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_TranH] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_AssID] ON [dbo].[b_TranH] ([D_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID1] ON [dbo].[b_TranH] ([D_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID2] ON [dbo].[b_TranH] ([D_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID3] ON [dbo].[b_TranH] ([D_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID4] ON [dbo].[b_TranH] ([D_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID5] ON [dbo].[b_TranH] ([D_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CompID] ON [dbo].[b_TranH] ([D_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_EmpID] ON [dbo].[b_TranH] ([D_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccID] ON [dbo].[b_TranH] ([D_GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GVolID] ON [dbo].[b_TranH] ([D_GVolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_ProdID] ON [dbo].[b_TranH] ([D_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_StockID] ON [dbo].[b_TranH] ([D_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_TranH] ([OurID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[D_Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranH].[C_Qty]'
GO
