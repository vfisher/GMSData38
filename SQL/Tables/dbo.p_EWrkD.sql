CREATE TABLE [dbo].[p_EWrkD] (
  [ChID] [bigint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [WrkID] [int] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [DepID] [smallint] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PriceCC] [numeric](21, 9) NOT NULL,
  [SumCC] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_p_EWrkD] PRIMARY KEY CLUSTERED ([ChID], [EmpID], [WrkID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[p_EWrkD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [DepID]
  ON [dbo].[p_EWrkD] ([DepID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[p_EWrkD] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_EWrkD] ([SubID])
  ON [PRIMARY]
GO

CREATE INDEX [WrkID]
  ON [dbo].[p_EWrkD] ([WrkID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.WrkID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.SubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.DepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.PriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_EWrkD.SumCC'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_EWrkD] ON [p_EWrkD]
FOR INSERT AS
/* p_EWrkD - Выполнение работ (Служащие) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_EWrk a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_EWrk a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_EWrk a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_EWrk a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_EWrk a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15053, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Выполнение работ'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_EWrkD ^ p_EWrk - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_EWrk))
    BEGIN
      EXEC z_RelationError 'p_EWrk', 'p_EWrkD', 0
      RETURN
    END

/* p_EWrkD ^ r_Deps - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_EWrkD', 0
      RETURN
    END

/* p_EWrkD ^ r_Emps - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EWrkD', 0
      RETURN
    END

/* p_EWrkD ^ r_Subs - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_EWrkD', 0
      RETURN
    END

/* p_EWrkD ^ r_WrkTypes - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник работ: виды - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WrkID NOT IN (SELECT WrkID FROM r_WrkTypes))
    BEGIN
      EXEC z_RelationError 'r_WrkTypes', 'p_EWrkD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15053002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_EWrkD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_EWrkD] ON [p_EWrkD]
FOR UPDATE AS
/* p_EWrkD - Выполнение работ (Служащие) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_EWrk a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_EWrk a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_EWrk a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_EWrk a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_EWrk a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_EWrk a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_EWrk a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15053, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Выполнение работ'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_EWrkD ^ p_EWrk - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Выполнение работ (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_EWrk))
      BEGIN
        EXEC z_RelationError 'p_EWrk', 'p_EWrkD', 1
        RETURN
      END

/* p_EWrkD ^ r_Deps - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_EWrkD', 1
        RETURN
      END

/* p_EWrkD ^ r_Emps - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_EWrkD', 1
        RETURN
      END

/* p_EWrkD ^ r_Subs - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_EWrkD', 1
        RETURN
      END

/* p_EWrkD ^ r_WrkTypes - Проверка в PARENT */
/* Выполнение работ (Служащие) ^ Справочник работ: виды - Проверка в PARENT */
  IF UPDATE(WrkID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WrkID NOT IN (SELECT WrkID FROM r_WrkTypes))
      BEGIN
        EXEC z_RelationError 'r_WrkTypes', 'p_EWrkD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15053002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15053002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(EmpID) OR UPDATE(WrkID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15053002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.WrkID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.EmpID = d.EmpID AND i.WrkID = d.WrkID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15053002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.WrkID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.EmpID = d.EmpID AND i.WrkID = d.WrkID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15053002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15053002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15053002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15053002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(EmpID) OR UPDATE(WrkID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, EmpID, WrkID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, EmpID, WrkID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15053002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WrkID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15053002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WrkID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15053002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15053002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WrkID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15053002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WrkID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15053002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15053002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_EWrkD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_EWrkD] ON [p_EWrkD]
FOR DELETE AS
/* p_EWrkD - Выполнение работ (Служащие) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_EWrk a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_EWrk a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_EWrk a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_EWrk a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Выполнение работ (Служащие) (p_EWrkD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_EWrk a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15053, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Выполнение работ'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15053002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WrkID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15053002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WrkID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15053002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.WrkID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_EWrkD', N'Last', N'DELETE'
GO