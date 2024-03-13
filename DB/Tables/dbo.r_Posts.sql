CREATE TABLE [dbo].[r_Posts]
(
[ChID] [bigint] NOT NULL,
[PostID] [int] NOT NULL,
[PostName] [varchar] (200) NOT NULL,
[PostCID] [smallint] NOT NULL,
[SalaryType] [tinyint] NOT NULL,
[PostTypeID] [tinyint] NOT NULL,
[Notes] [varchar] (200) NULL,
[CostGAccID] [int] NOT NULL DEFAULT (0),
[Rank] [int] NULL DEFAULT ((0)),
[PostClassifierCode] [varchar] (6) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Posts] ON [dbo].[r_Posts]
FOR INSERT AS
/* r_Posts - Справочник должностей - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Posts ^ r_GAccs - Проверка в PARENT */
/* Справочник должностей ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostGAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_Posts', 0
      RETURN
    END

/* r_Posts ^ r_PostC - Проверка в PARENT */
/* Справочник должностей ^ Справочник должностей: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PostCID NOT IN (SELECT PostCID FROM r_PostC))
    BEGIN
      EXEC z_RelationError 'r_PostC', 'r_Posts', 0
      RETURN
    END

/* r_Posts ^ r_Uni - Проверка в PARENT */
/* Справочник должностей ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PostTypeID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10050))
    BEGIN
      EXEC z_RelationErrorUni 'r_Posts', 10050, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10093001, ChID, 
    '[' + cast(i.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Posts]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Posts] ON [dbo].[r_Posts]
FOR UPDATE AS
/* r_Posts - Справочник должностей - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Posts ^ r_GAccs - Проверка в PARENT */
/* Справочник должностей ^ План счетов - Проверка в PARENT */
  IF UPDATE(CostGAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostGAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_Posts', 1
        RETURN
      END

/* r_Posts ^ r_PostC - Проверка в PARENT */
/* Справочник должностей ^ Справочник должностей: категории - Проверка в PARENT */
  IF UPDATE(PostCID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PostCID NOT IN (SELECT PostCID FROM r_PostC))
      BEGIN
        EXEC z_RelationError 'r_PostC', 'r_Posts', 1
        RETURN
      END

/* r_Posts ^ r_Uni - Проверка в PARENT */
/* Справочник должностей ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(PostTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PostTypeID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10050))
      BEGIN
        EXEC z_RelationErrorUni 'r_Posts', 10050, 1
        RETURN
      END

/* r_Posts ^ r_PostMC - Обновление CHILD */
/* Справочник должностей ^ Справочник должностей - Разряды - Обновление CHILD */
  IF UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostID = i.PostID
          FROM r_PostMC a, inserted i, deleted d WHERE a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PostMC a, deleted d WHERE a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей'' => ''Справочник должностей - Разряды''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Posts ^ p_EmpSchedExtD - Обновление CHILD */
/* Справочник должностей ^ Приказ: Дополнительный график работы (Список) - Обновление CHILD */
  IF UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostID = i.PostID
          FROM p_EmpSchedExtD a, inserted i, deleted d WHERE a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExtD a, deleted d WHERE a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей'' => ''Приказ: Дополнительный график работы (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Posts ^ p_LMemD - Обновление CHILD */
/* Справочник должностей ^ Штатное расписание (Данные) - Обновление CHILD */
  IF UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostID = i.PostID
          FROM p_LMemD a, inserted i, deleted d WHERE a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LMemD a, deleted d WHERE a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей'' => ''Штатное расписание (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Posts ^ p_LStrD - Обновление CHILD */
/* Справочник должностей ^ Штатная численность сотрудников (Данные) - Обновление CHILD */
  IF UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostID = i.PostID
          FROM p_LStrD a, inserted i, deleted d WHERE a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LStrD a, deleted d WHERE a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей'' => ''Штатная численность сотрудников (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Posts ^ p_PostStrucD - Обновление CHILD */
/* Справочник должностей ^ Структура должностей (Список) - Обновление CHILD */
  IF UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostID = i.PostID
          FROM p_PostStrucD a, inserted i, deleted d WHERE a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_PostStrucD a, deleted d WHERE a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей'' => ''Структура должностей (Список)''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10093001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10093001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PostID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10093001 AND l.PKValue = 
        '[' + cast(i.PostID as varchar(200)) + ']' AND i.PostID = d.PostID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10093001 AND l.PKValue = 
        '[' + cast(i.PostID as varchar(200)) + ']' AND i.PostID = d.PostID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10093001, ChID, 
          '[' + cast(d.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10093001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10093001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10093001, ChID, 
          '[' + cast(i.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PostID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PostID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PostID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PostID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10093001 AND l.PKValue = 
          '[' + cast(d.PostID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PostID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10093001 AND l.PKValue = 
          '[' + cast(d.PostID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10093001, ChID, 
          '[' + cast(d.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10093001 AND PKValue IN (SELECT 
          '[' + cast(PostID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10093001 AND PKValue IN (SELECT 
          '[' + cast(PostID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10093001, ChID, 
          '[' + cast(i.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10093001, ChID, 
    '[' + cast(i.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Posts]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Posts] ON [dbo].[r_Posts]
FOR DELETE AS
/* r_Posts - Справочник должностей - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Posts ^ r_PostMC - Удаление в CHILD */
/* Справочник должностей ^ Справочник должностей - Разряды - Удаление в CHILD */
  DELETE r_PostMC FROM r_PostMC a, deleted d WHERE a.PostID = d.PostID
  IF @@ERROR > 0 RETURN

/* r_Posts ^ p_EmpSchedExtD - Проверка в CHILD */
/* Справочник должностей ^ Приказ: Дополнительный график работы (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExtD a WITH(NOLOCK), deleted d WHERE a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_Posts', 'p_EmpSchedExtD', 3
      RETURN
    END

/* r_Posts ^ p_LMemD - Проверка в CHILD */
/* Справочник должностей ^ Штатное расписание (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LMemD a WITH(NOLOCK), deleted d WHERE a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_Posts', 'p_LMemD', 3
      RETURN
    END

/* r_Posts ^ p_LStrD - Проверка в CHILD */
/* Справочник должностей ^ Штатная численность сотрудников (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LStrD a WITH(NOLOCK), deleted d WHERE a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_Posts', 'p_LStrD', 3
      RETURN
    END

/* r_Posts ^ p_PostStrucD - Проверка в CHILD */
/* Справочник должностей ^ Структура должностей (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_PostStrucD a WITH(NOLOCK), deleted d WHERE a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_Posts', 'p_PostStrucD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10093001 AND m.PKValue = 
    '[' + cast(i.PostID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10093001 AND m.PKValue = 
    '[' + cast(i.PostID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10093001, -ChID, 
    '[' + cast(d.PostID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10093 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Posts]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Posts] ADD CONSTRAINT [pk_r_Posts] PRIMARY KEY CLUSTERED ([PostID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Posts] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostCID] ON [dbo].[r_Posts] ([PostCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PostName] ON [dbo].[r_Posts] ([PostName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostTypeID] ON [dbo].[r_Posts] ([PostTypeID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Posts].[PostTypeID]'
GO
