CREATE TABLE [dbo].[p_ELeavD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [DepID] [smallint] NOT NULL,
  [LeavType] [int] NOT NULL,
  [AgeBDate] [smalldatetime] NOT NULL,
  [AgeEDate] [smalldatetime] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [LeavDays] [smallint] NOT NULL,
  [LeavAvrSalary] [numeric](21, 9) NOT NULL,
  [LeavSumCC] [numeric](21, 9) NOT NULL,
  [AChID] [bigint] NOT NULL,
  CONSTRAINT [_pk_p_ELeavD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [AChID]
  ON [dbo].[p_ELeavD] ([AChID])
  ON [PRIMARY]
GO

CREATE INDEX [AgeBDate]
  ON [dbo].[p_ELeavD] ([AgeBDate])
  ON [PRIMARY]
GO

CREATE INDEX [AgeEDate]
  ON [dbo].[p_ELeavD] ([AgeEDate])
  ON [PRIMARY]
GO

CREATE INDEX [BDate]
  ON [dbo].[p_ELeavD] ([BDate])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[p_ELeavD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [DepID]
  ON [dbo].[p_ELeavD] ([DepID])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[p_ELeavD] ([EDate])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[p_ELeavD] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_ELeavD] ([SubID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.SubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.DepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.LeavType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.LeavDays'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.LeavAvrSalary'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.LeavSumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_ELeavD.AChID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_ELeavD] ON [p_ELeavD]
FOR INSERT AS
/* p_ELeavD - Приказ: Отпуск (Данные) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_ELeav a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_ELeav a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeav a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeav a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_ELeav a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15025, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Приказ: Отпуск'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_ELeavD ^ p_ELeav - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_ELeav))
    BEGIN
      EXEC z_RelationError 'p_ELeav', 'p_ELeavD', 0
      RETURN
    END

/* p_ELeavD ^ r_Deps - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_ELeavD', 0
      RETURN
    END

/* p_ELeavD ^ r_Emps - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_ELeavD', 0
      RETURN
    END

/* p_ELeavD ^ r_Subs - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_ELeavD', 0
      RETURN
    END

/* p_ELeavD ^ r_Uni - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LeavType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10051))
    BEGIN
      EXEC z_RelationErrorUni 'p_ELeavD', 10051, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15025002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_ELeavD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_ELeavD] ON [p_ELeavD]
FOR UPDATE AS
/* p_ELeavD - Приказ: Отпуск (Данные) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_ELeav a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_ELeav a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeav a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeav a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeav a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeav a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_ELeav a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15025, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Приказ: Отпуск'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_ELeavD ^ p_ELeav - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Приказ: Отпуск (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_ELeav))
      BEGIN
        EXEC z_RelationError 'p_ELeav', 'p_ELeavD', 1
        RETURN
      END

/* p_ELeavD ^ r_Deps - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_ELeavD', 1
        RETURN
      END

/* p_ELeavD ^ r_Emps - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_ELeavD', 1
        RETURN
      END

/* p_ELeavD ^ r_Subs - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_ELeavD', 1
        RETURN
      END

/* p_ELeavD ^ r_Uni - Проверка в PARENT */
/* Приказ: Отпуск (Данные) ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(LeavType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LeavType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10051))
      BEGIN
        EXEC z_RelationErrorUni 'p_ELeavD', 10051, 1
        RETURN
      END

/* p_ELeavD ^ p_ELeavDD - Обновление CHILD */
/* Приказ: Отпуск (Данные) ^ Приказ: Отпуск (Подробно) - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM p_ELeavDD a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavDD a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приказ: Отпуск (Данные)'' => ''Приказ: Отпуск (Подробно)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_ELeavD ^ p_ELeavDP - Обновление CHILD */
/* Приказ: Отпуск (Данные) ^ Приказ: Отпуск (Помесячно) - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM p_ELeavDP a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavDP a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Приказ: Отпуск (Данные)'' => ''Приказ: Отпуск (Помесячно)''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15025002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15025002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15025002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15025002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15025002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15025002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15025002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15025002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15025002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15025002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15025002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15025002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15025002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15025002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15025002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_ELeavD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_ELeavD] ON [p_ELeavD]
FOR DELETE AS
/* p_ELeavD - Приказ: Отпуск (Данные) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_ELeav a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_ELeav a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeav a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeav a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Приказ: Отпуск (Данные) (p_ELeavD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_ELeav a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15025, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Приказ: Отпуск'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_ELeavD ^ p_ELeavDD - Удаление в CHILD */
/* Приказ: Отпуск (Данные) ^ Приказ: Отпуск (Подробно) - Удаление в CHILD */
  DELETE p_ELeavDD FROM p_ELeavDD a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* p_ELeavD ^ p_ELeavDP - Удаление в CHILD */
/* Приказ: Отпуск (Данные) ^ Приказ: Отпуск (Помесячно) - Удаление в CHILD */
  DELETE p_ELeavDP FROM p_ELeavDP a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15025002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15025002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15025002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_ELeavD', N'Last', N'DELETE'
GO