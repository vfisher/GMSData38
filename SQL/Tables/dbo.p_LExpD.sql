CREATE TABLE [dbo].[p_LExpD] (
  [ChID] [bigint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [LArrSumCC] [numeric](21, 9) NOT NULL,
  [LRecSumCC] [numeric](21, 9) NOT NULL,
  [LExpSumCC] [numeric](21, 9) NOT NULL,
  [LDepSumCC] [numeric](21, 9) NOT NULL,
  [SubID] [smallint] NOT NULL,
  [DepID] [smallint] NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  CONSTRAINT [_pk_p_LExpD] PRIMARY KEY CLUSTERED ([ChID], [EmpID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[p_LExpD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [DepID]
  ON [dbo].[p_LExpD] ([DepID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[p_LExpD] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[p_LExpD] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [LExpSumCC]
  ON [dbo].[p_LExpD] ([LExpSumCC])
  ON [PRIMARY]
GO

CREATE INDEX [LRecSumCC]
  ON [dbo].[p_LExpD] ([LRecSumCC])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_LExpD] ([SubID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.LArrSumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.LRecSumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.LExpSumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.LDepSumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.SubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.DepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_LExpD.GTranID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_LExpD] ON [p_LExpD]
FOR DELETE AS
/* p_LExpD - Заработная плата: Выплата (Данные) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_LExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_LExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_LExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15062, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Заработная плата: Выплата'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15062002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15062002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15062002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_LExpD', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_LExpD] ON [p_LExpD]
FOR UPDATE AS
/* p_LExpD - Заработная плата: Выплата (Данные) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_LExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_LExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_LExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15062, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Заработная плата: Выплата'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_LExpD ^ p_LExp - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_LExp))
      BEGIN
        EXEC z_RelationError 'p_LExp', 'p_LExpD', 1
        RETURN
      END

/* p_LExpD ^ r_Deps - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_LExpD', 1
        RETURN
      END

/* p_LExpD ^ r_Emps - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_LExpD', 1
        RETURN
      END

/* p_LExpD ^ r_GOpers - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'p_LExpD', 1
        RETURN
      END

/* p_LExpD ^ r_Subs - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_LExpD', 1
        RETURN
      END


/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15062002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15062002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(EmpID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15062002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.EmpID = d.EmpID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15062002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.EmpID = d.EmpID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15062002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15062002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15062002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15062002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(EmpID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, EmpID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, EmpID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15062002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15062002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15062002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15062002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15062002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15062002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15062002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_LExpD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_LExpD] ON [p_LExpD]
FOR INSERT AS
/* p_LExpD - Заработная плата: Выплата (Данные) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_LExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_LExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Заработная плата: Выплата (Данные)'), 'p_LExpD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_LExp a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(15062, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Заработная плата: Выплата'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_LExpD ^ p_LExp - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Заработная плата: Выплата (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_LExp))
    BEGIN
      EXEC z_RelationError 'p_LExp', 'p_LExpD', 0
      RETURN
    END

/* p_LExpD ^ r_Deps - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LExpD', 0
      RETURN
    END

/* p_LExpD ^ r_Emps - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_LExpD', 0
      RETURN
    END

/* p_LExpD ^ r_GOpers - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_LExpD', 0
      RETURN
    END

/* p_LExpD ^ r_Subs - Проверка в PARENT */
/* Заработная плата: Выплата (Данные) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LExpD', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15062002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_LExpD', N'Last', N'INSERT'
GO



































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO