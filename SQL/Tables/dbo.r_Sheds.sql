CREATE TABLE [dbo].[r_Sheds] (
  [ChID] [bigint] NOT NULL,
  [ShedID] [smallint] NOT NULL,
  [ShedName] [varchar](200) NOT NULL,
  [ShedDaysQty] [smallint] NOT NULL,
  [WWeekTypeID] [tinyint] NOT NULL,
  [ShedBDate] [smalldatetime] NOT NULL,
  [Notes] [varchar](200) NULL,
  [ConHolDays] [bit] NULL,
  [SlidingShed] [bit] NOT NULL,
  [IsIrregShed] [bit] NOT NULL,
  CONSTRAINT [pk_r_Sheds] PRIMARY KEY CLUSTERED ([ShedID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Sheds] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ShedName]
  ON [dbo].[r_Sheds] ([ShedName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [WWeekType]
  ON [dbo].[r_Sheds] ([WWeekTypeID], [ChID])
  ON [PRIMARY]
GO

CREATE INDEX [WWeekTypeID]
  ON [dbo].[r_Sheds] ([WWeekTypeID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.ShedID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.ShedDaysQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.WWeekTypeID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.ConHolDays'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.SlidingShed'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Sheds.IsIrregShed'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Sheds] ON [r_Sheds]
FOR INSERT AS
/* r_Sheds - Справочник работ: графики - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Sheds ^ r_WWeeks - Проверка в PARENT */
/* Справочник работ: графики ^ Справочник работ: типы недели - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WWeekTypeID NOT IN (SELECT WWeekTypeID FROM r_WWeeks))
    BEGIN
      EXEC z_RelationError 'r_WWeeks', 'r_Sheds', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10095001, ChID, 
    '[' + cast(i.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Sheds', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Sheds] ON [r_Sheds]
FOR UPDATE AS
/* r_Sheds - Справочник работ: графики - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Sheds ^ r_WWeeks - Проверка в PARENT */
/* Справочник работ: графики ^ Справочник работ: типы недели - Проверка в PARENT */
  IF UPDATE(WWeekTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WWeekTypeID NOT IN (SELECT WWeekTypeID FROM r_WWeeks))
      BEGIN
        EXEC z_RelationError 'r_WWeeks', 'r_Sheds', 1
        RETURN
      END

/* r_Sheds ^ r_EmpMPst - Обновление CHILD */
/* Справочник работ: графики ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM r_EmpMPst a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ r_Subs - Обновление CHILD */
/* Справочник работ: графики ^ Справочник работ: подразделения - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM r_Subs a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Subs a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Справочник работ: подразделения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ r_ShedMD - Обновление CHILD */
/* Справочник работ: графики ^ Справочник работ: графики - Дни графика - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM r_ShedMD a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ShedMD a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Справочник работ: графики - Дни графика''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ p_CWTimeDDExt - Обновление CHILD */
/* Справочник работ: графики ^ Табель учета рабочего времени: Подробно: Графики - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM p_CWTimeDDExt a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeDDExt a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Табель учета рабочего времени: Подробно: Графики''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ p_EExc - Обновление CHILD */
/* Справочник работ: графики ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM p_EExc a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ p_EGiv - Обновление CHILD */
/* Справочник работ: графики ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM p_EGiv a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ p_EmpSchedExtD - Обновление CHILD */
/* Справочник работ: графики ^ Приказ: Дополнительный график работы (Список) - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM p_EmpSchedExtD a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExtD a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Приказ: Дополнительный график работы (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Sheds ^ p_LExcD - Обновление CHILD */
/* Справочник работ: графики ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ShedID = i.ShedID
          FROM p_LExcD a, inserted i, deleted d WHERE a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10095001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10095001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ShedID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10095001 AND l.PKValue = 
        '[' + cast(i.ShedID as varchar(200)) + ']' AND i.ShedID = d.ShedID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10095001 AND l.PKValue = 
        '[' + cast(i.ShedID as varchar(200)) + ']' AND i.ShedID = d.ShedID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10095001, ChID, 
          '[' + cast(d.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10095001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10095001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10095001, ChID, 
          '[' + cast(i.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ShedID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ShedID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ShedID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ShedID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10095001 AND l.PKValue = 
          '[' + cast(d.ShedID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ShedID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10095001 AND l.PKValue = 
          '[' + cast(d.ShedID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10095001, ChID, 
          '[' + cast(d.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10095001 AND PKValue IN (SELECT 
          '[' + cast(ShedID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10095001 AND PKValue IN (SELECT 
          '[' + cast(ShedID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10095001, ChID, 
          '[' + cast(i.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10095001, ChID, 
    '[' + cast(i.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Sheds', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Sheds] ON [r_Sheds]
FOR DELETE AS
/* r_Sheds - Справочник работ: графики - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Sheds ^ r_EmpMPst - Проверка в CHILD */
/* Справочник работ: графики ^ Справочник служащих - Должности и оплата труда - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMPst a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'r_EmpMPst', 3
      RETURN
    END

/* r_Sheds ^ r_Subs - Проверка в CHILD */
/* Справочник работ: графики ^ Справочник работ: подразделения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Subs a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'r_Subs', 3
      RETURN
    END

/* r_Sheds ^ r_ShedMD - Удаление в CHILD */
/* Справочник работ: графики ^ Справочник работ: графики - Дни графика - Удаление в CHILD */
  DELETE r_ShedMD FROM r_ShedMD a, deleted d WHERE a.ShedID = d.ShedID
  IF @@ERROR > 0 RETURN

/* r_Sheds ^ p_CWTimeDDExt - Проверка в CHILD */
/* Справочник работ: графики ^ Табель учета рабочего времени: Подробно: Графики - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeDDExt a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_CWTimeDDExt', 3
      RETURN
    END

/* r_Sheds ^ p_EExc - Проверка в CHILD */
/* Справочник работ: графики ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_EExc', 3
      RETURN
    END

/* r_Sheds ^ p_EGiv - Проверка в CHILD */
/* Справочник работ: графики ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_EGiv', 3
      RETURN
    END

/* r_Sheds ^ p_EmpSchedExtD - Проверка в CHILD */
/* Справочник работ: графики ^ Приказ: Дополнительный график работы (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExtD a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_EmpSchedExtD', 3
      RETURN
    END

/* r_Sheds ^ p_LExcD - Проверка в CHILD */
/* Справочник работ: графики ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE a.ShedID = d.ShedID)
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_LExcD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10095001 AND m.PKValue = 
    '[' + cast(i.ShedID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10095001 AND m.PKValue = 
    '[' + cast(i.ShedID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10095001, -ChID, 
    '[' + cast(d.ShedID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10095 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Sheds', N'Last', N'DELETE'
GO