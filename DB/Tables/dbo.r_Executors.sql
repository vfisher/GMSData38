CREATE TABLE [dbo].[r_Executors]
(
[ChID] [bigint] NOT NULL,
[ExecutorID] [int] NOT NULL,
[ExecutorName] [varchar] (200) NOT NULL,
[EmpID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Executors] ON [dbo].[r_Executors]
FOR INSERT AS
/* r_Executors - Справочник исполнителей - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Executors ^ r_Emps - Проверка в PARENT */
/* Справочник исполнителей ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Executors', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11117001, ChID, 
    '[' + cast(i.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Executors]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Executors] ON [dbo].[r_Executors]
FOR UPDATE AS
/* r_Executors - Справочник исполнителей - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Executors ^ r_Emps - Проверка в PARENT */
/* Справочник исполнителей ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_Executors', 1
        RETURN
      END

/* r_Executors ^ r_PersonExecutorsBL - Обновление CHILD */
/* Справочник исполнителей ^ Справочник персон - черный список исполнителей - Обновление CHILD */
  IF UPDATE(ExecutorID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ExecutorID = i.ExecutorID
          FROM r_PersonExecutorsBL a, inserted i, deleted d WHERE a.ExecutorID = d.ExecutorID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonExecutorsBL a, deleted d WHERE a.ExecutorID = d.ExecutorID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник исполнителей'' => ''Справочник персон - черный список исполнителей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Executors ^ r_PersonPreferences - Обновление CHILD */
/* Справочник исполнителей ^ Справочник персон - предпочтения - Обновление CHILD */
  IF UPDATE(ExecutorID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ExecutorID = i.ExecutorID
          FROM r_PersonPreferences a, inserted i, deleted d WHERE a.ExecutorID = d.ExecutorID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonPreferences a, deleted d WHERE a.ExecutorID = d.ExecutorID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник исполнителей'' => ''Справочник персон - предпочтения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Executors ^ r_ExecutorServices - Обновление CHILD */
/* Справочник исполнителей ^ Справочник исполнителей - услуги - Обновление CHILD */
  IF UPDATE(ExecutorID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ExecutorID = i.ExecutorID
          FROM r_ExecutorServices a, inserted i, deleted d WHERE a.ExecutorID = d.ExecutorID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ExecutorServices a, deleted d WHERE a.ExecutorID = d.ExecutorID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник исполнителей'' => ''Справочник исполнителей - услуги''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Executors ^ r_ExecutorShifts - Обновление CHILD */
/* Справочник исполнителей ^ Справочник исполнителей - смены - Обновление CHILD */
  IF UPDATE(ExecutorID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ExecutorID = i.ExecutorID
          FROM r_ExecutorShifts a, inserted i, deleted d WHERE a.ExecutorID = d.ExecutorID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ExecutorShifts a, deleted d WHERE a.ExecutorID = d.ExecutorID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник исполнителей'' => ''Справочник исполнителей - смены''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Executors ^ t_BookingTempD - Обновление CHILD */
/* Справочник исполнителей ^ Интернет заявки - подробно - Обновление CHILD */
  IF UPDATE(ExecutorID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ExecutorID = i.ExecutorID
          FROM t_BookingTempD a, inserted i, deleted d WHERE a.ExecutorID = d.ExecutorID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_BookingTempD a, deleted d WHERE a.ExecutorID = d.ExecutorID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник исполнителей'' => ''Интернет заявки - подробно''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11117001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11117001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ExecutorID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11117001 AND l.PKValue = 
        '[' + cast(i.ExecutorID as varchar(200)) + ']' AND i.ExecutorID = d.ExecutorID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11117001 AND l.PKValue = 
        '[' + cast(i.ExecutorID as varchar(200)) + ']' AND i.ExecutorID = d.ExecutorID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11117001, ChID, 
          '[' + cast(d.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11117001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11117001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11117001, ChID, 
          '[' + cast(i.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ExecutorID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ExecutorID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ExecutorID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ExecutorID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11117001 AND l.PKValue = 
          '[' + cast(d.ExecutorID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ExecutorID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11117001 AND l.PKValue = 
          '[' + cast(d.ExecutorID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11117001, ChID, 
          '[' + cast(d.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11117001 AND PKValue IN (SELECT 
          '[' + cast(ExecutorID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11117001 AND PKValue IN (SELECT 
          '[' + cast(ExecutorID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11117001, ChID, 
          '[' + cast(i.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11117001, ChID, 
    '[' + cast(i.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Executors]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Executors] ON [dbo].[r_Executors]
FOR DELETE AS
/* r_Executors - Справочник исполнителей - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Executors ^ r_PersonExecutorsBL - Проверка в CHILD */
/* Справочник исполнителей ^ Справочник персон - черный список исполнителей - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PersonExecutorsBL a WITH(NOLOCK), deleted d WHERE a.ExecutorID = d.ExecutorID)
    BEGIN
      EXEC z_RelationError 'r_Executors', 'r_PersonExecutorsBL', 3
      RETURN
    END

/* r_Executors ^ r_PersonPreferences - Проверка в CHILD */
/* Справочник исполнителей ^ Справочник персон - предпочтения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PersonPreferences a WITH(NOLOCK), deleted d WHERE a.ExecutorID = d.ExecutorID)
    BEGIN
      EXEC z_RelationError 'r_Executors', 'r_PersonPreferences', 3
      RETURN
    END

/* r_Executors ^ r_ExecutorServices - Удаление в CHILD */
/* Справочник исполнителей ^ Справочник исполнителей - услуги - Удаление в CHILD */
  DELETE r_ExecutorServices FROM r_ExecutorServices a, deleted d WHERE a.ExecutorID = d.ExecutorID
  IF @@ERROR > 0 RETURN

/* r_Executors ^ r_ExecutorShifts - Удаление в CHILD */
/* Справочник исполнителей ^ Справочник исполнителей - смены - Удаление в CHILD */
  DELETE r_ExecutorShifts FROM r_ExecutorShifts a, deleted d WHERE a.ExecutorID = d.ExecutorID
  IF @@ERROR > 0 RETURN

/* r_Executors ^ t_BookingTempD - Проверка в CHILD */
/* Справочник исполнителей ^ Интернет заявки - подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_BookingTempD a WITH(NOLOCK), deleted d WHERE a.ExecutorID = d.ExecutorID)
    BEGIN
      EXEC z_RelationError 'r_Executors', 't_BookingTempD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11117001 AND m.PKValue = 
    '[' + cast(i.ExecutorID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11117001 AND m.PKValue = 
    '[' + cast(i.ExecutorID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11117001, -ChID, 
    '[' + cast(d.ExecutorID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11117 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Executors]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Executors] ADD CONSTRAINT [pk_r_Executors] PRIMARY KEY CLUSTERED ([ExecutorID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Executors] ([ChID]) ON [PRIMARY]
GO
