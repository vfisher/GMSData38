CREATE TABLE [dbo].[p_EExc] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [WOrderID] [int] NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [ExcDate] [smalldatetime] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [OurID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [DepID] [smallint] NOT NULL,
  [PostID] [int] NOT NULL,
  [EmpClass] [tinyint] NOT NULL,
  [ShedID] [smallint] NOT NULL,
  [WorkCond] [tinyint] NOT NULL,
  [SubJob] [varchar](200) NULL,
  [SalaryQty] [numeric](21, 9) NULL,
  [SalaryType] [tinyint] NOT NULL,
  [SalaryForm] [tinyint] NOT NULL,
  [SalaryMethod] [tinyint] NOT NULL,
  [BSalary] [numeric](21, 9) NOT NULL,
  [BSalaryPrc] [numeric](21, 9) NOT NULL,
  [TimeNormType] [tinyint] NOT NULL,
  [PensMethod] [tinyint] NOT NULL CONSTRAINT [df_p_EExc_PensMethod] DEFAULT (1),
  [StateCode] [int] NOT NULL DEFAULT (0),
  [IndexBaseMonth] [smalldatetime] NOT NULL,
  [LeavDays] [smallint] NOT NULL DEFAULT (0),
  [LeavDaysExtra] [smallint] NOT NULL DEFAULT (0),
  [PensCatID] [tinyint] NOT NULL DEFAULT (1),
  [Joint] [bit] NOT NULL DEFAULT (0),
  [GEmpType] [tinyint] NOT NULL DEFAULT (0),
  [ContractType] [tinyint] NOT NULL DEFAULT (0),
  [ContractFile] [varchar](250) NULL,
  [ContrEDate] [smalldatetime] NULL,
  [DecreeEmpID] [int] NOT NULL DEFAULT (0),
  [StrucPostID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_p_EExc] PRIMARY KEY CLUSTERED ([DocID], [OurID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[p_EExc] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[p_EExc] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[p_EExc] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[p_EExc] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[p_EExc] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[p_EExc] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [DepID]
  ON [dbo].[p_EExc] ([DepID])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[p_EExc] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[p_EExc] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [ExcDate]
  ON [dbo].[p_EExc] ([ExcDate])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID]
  ON [dbo].[p_EExc] ([IntDocID])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[p_EExc] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[p_EExc] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [r_PostMCp_EExc]
  ON [dbo].[p_EExc] ([PostID], [EmpClass])
  ON [PRIMARY]
GO

CREATE INDEX [ShedID]
  ON [dbo].[p_EExc] ([ShedID])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_EExc] ([SubID])
  ON [PRIMARY]
GO

CREATE INDEX [WOrderID]
  ON [dbo].[p_EExc] ([WOrderID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.DocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.WOrderID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.SubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.DepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.PostID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.EmpClass'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.ShedID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.WorkCond'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.SalaryQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.SalaryType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.SalaryForm'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.SalaryMethod'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.BSalary'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.BSalaryPrc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EExc.TimeNormType'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_EExc] ON [p_EExc]
FOR INSERT AS
/* p_EExc - Приказ: Кадровое перемещение - INSERT TRIGGER */
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
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(15022, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Приказ: Кадровое перемещение'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* p_EExc ^ r_Codes1 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Codes2 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Codes3 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Codes4 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Codes5 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Deps - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Emps - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DecreeEmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Emps - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Ours - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_PostMC - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник должностей - Разряды - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_PostMC m WITH(NOLOCK), inserted i WHERE i.EmpClass = m.EmpClass AND i.PostID = m.PostID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Sheds - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник работ: графики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_States - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Subs - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EExc', 0
      RETURN
    END

/* p_EExc ^ r_Uni - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PensMethod NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10057))
    BEGIN
      EXEC z_RelationErrorUni 'p_EExc', 10057, 0
      RETURN
    END

/* p_EExc ^ r_Uni - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PensCatID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10058))
    BEGIN
      EXEC z_RelationErrorUni 'p_EExc', 10058, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15022001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_EExc', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_EExc] ON [p_EExc]
FOR UPDATE AS
/* p_EExc - Приказ: Кадровое перемещение - UPDATE TRIGGER */
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
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(15022, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Приказ: Кадровое перемещение).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 15022, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('p_EExc', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(15022, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Приказ: Кадровое перемещение'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* p_EExc ^ r_Codes1 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Codes2 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Codes3 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Codes4 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Codes5 - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Deps - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Emps - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(DecreeEmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DecreeEmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Emps - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Ours - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_PostMC - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник должностей - Разряды - Проверка в PARENT */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    IF (SELECT COUNT(*) FROM r_PostMC m WITH(NOLOCK), inserted i WHERE i.EmpClass = m.EmpClass AND i.PostID = m.PostID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_PostMC', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Sheds - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник работ: графики - Проверка в PARENT */
  IF UPDATE(ShedID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
      BEGIN
        EXEC z_RelationError 'r_Sheds', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_States - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Subs - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_EExc', 1
        RETURN
      END

/* p_EExc ^ r_Uni - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(PensMethod)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PensMethod NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10057))
      BEGIN
        EXEC z_RelationErrorUni 'p_EExc', 10057, 1
        RETURN
      END

/* p_EExc ^ r_Uni - Проверка в PARENT */
/* Приказ: Кадровое перемещение ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(PensCatID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PensCatID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10058))
      BEGIN
        EXEC z_RelationErrorUni 'p_EExc', 10058, 1
        RETURN
      END

/* p_EExc ^ z_DocLinks - Обновление CHILD */
/* Приказ: Кадровое перемещение ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 15022, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 15022 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15022 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приказ: Кадровое перемещение'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EExc ^ z_DocLinks - Обновление CHILD */
/* Приказ: Кадровое перемещение ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 15022, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 15022 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 15022 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приказ: Кадровое перемещение'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EExc ^ z_DocShed - Обновление CHILD */
/* Приказ: Кадровое перемещение ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 15022, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 15022 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 15022 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приказ: Кадровое перемещение'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 15022 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 15022 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15022001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15022001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(OurID) OR UPDATE(DocID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15022001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DocID as varchar(200)) + ']' AND i.OurID = d.OurID AND i.DocID = d.DocID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15022001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DocID as varchar(200)) + ']' AND i.OurID = d.OurID AND i.DocID = d.DocID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15022001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15022001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15022001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15022001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15022001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15022001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15022001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15022001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15022001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DocID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15022001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15022001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_EExc', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_EExc] ON [p_EExc]
FOR DELETE AS
/* p_EExc - Приказ: Кадровое перемещение - DELETE TRIGGER */
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
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Кадровое перемещение (p_EExc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 15022 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(15022, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Приказ: Кадровое перемещение'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* p_EExc ^ z_DocLinks - Удаление в CHILD */
/* Приказ: Кадровое перемещение ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15022 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_EExc ^ z_DocLinks - Проверка в CHILD */
/* Приказ: Кадровое перемещение ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 15022 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'p_EExc', 'z_DocLinks', 3
      RETURN
    END

/* p_EExc ^ z_DocShed - Удаление в CHILD */
/* Приказ: Кадровое перемещение ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 15022 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15022001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15022001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DocID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15022001, -ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DocID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 15022 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_EExc', N'Last', N'DELETE'
GO