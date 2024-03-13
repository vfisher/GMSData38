CREATE TABLE [dbo].[r_PostMC]
(
[PostID] [int] NOT NULL,
[EmpClass] [tinyint] NOT NULL,
[ClassName] [varchar] (200) NOT NULL,
[ClassFactor] [numeric] (21, 9) NOT NULL,
[ClassSalary] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PostMC] ON [dbo].[r_PostMC]
FOR INSERT AS
/* r_PostMC - Справочник должностей - Разряды - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PostMC ^ r_Posts - Проверка в PARENT */
/* Справочник должностей - Разряды ^ Справочник должностей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PostID NOT IN (SELECT PostID FROM r_Posts))
    BEGIN
      EXEC z_RelationError 'r_Posts', 'r_PostMC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10093002, m.ChID, 
    '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpClass as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Posts m ON m.PostID = i.PostID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PostMC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PostMC] ON [dbo].[r_PostMC]
FOR UPDATE AS
/* r_PostMC - Справочник должностей - Разряды - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PostMC ^ r_Posts - Проверка в PARENT */
/* Справочник должностей - Разряды ^ Справочник должностей - Проверка в PARENT */
  IF UPDATE(PostID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PostID NOT IN (SELECT PostID FROM r_Posts))
      BEGIN
        EXEC z_RelationError 'r_Posts', 'r_PostMC', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldEmpClass tinyint, @NewEmpClass tinyint
  DECLARE @OldPostID int, @NewPostID int

/* r_PostMC ^ r_EmpMPst - Обновление CHILD */
/* Справочник должностей - Разряды ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpClass = i.EmpClass, a.PostID = i.PostID
          FROM r_EmpMPst a, inserted i, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(PostID) AND (SELECT COUNT(DISTINCT EmpClass) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpClass) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpClass = EmpClass FROM deleted
          SELECT TOP 1 @NewEmpClass = EmpClass FROM inserted
          UPDATE r_EmpMPst SET r_EmpMPst.EmpClass = @NewEmpClass FROM r_EmpMPst, deleted d WHERE r_EmpMPst.EmpClass = @OldEmpClass AND r_EmpMPst.PostID = d.PostID
        END
      ELSE IF NOT UPDATE(EmpClass) AND (SELECT COUNT(DISTINCT PostID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PostID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPostID = PostID FROM deleted
          SELECT TOP 1 @NewPostID = PostID FROM inserted
          UPDATE r_EmpMPst SET r_EmpMPst.PostID = @NewPostID FROM r_EmpMPst, deleted d WHERE r_EmpMPst.PostID = @OldPostID AND r_EmpMPst.EmpClass = d.EmpClass
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей - Разряды'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PostMC ^ p_EExc - Обновление CHILD */
/* Справочник должностей - Разряды ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpClass = i.EmpClass, a.PostID = i.PostID
          FROM p_EExc a, inserted i, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(PostID) AND (SELECT COUNT(DISTINCT EmpClass) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpClass) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpClass = EmpClass FROM deleted
          SELECT TOP 1 @NewEmpClass = EmpClass FROM inserted
          UPDATE p_EExc SET p_EExc.EmpClass = @NewEmpClass FROM p_EExc, deleted d WHERE p_EExc.EmpClass = @OldEmpClass AND p_EExc.PostID = d.PostID
        END
      ELSE IF NOT UPDATE(EmpClass) AND (SELECT COUNT(DISTINCT PostID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PostID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPostID = PostID FROM deleted
          SELECT TOP 1 @NewPostID = PostID FROM inserted
          UPDATE p_EExc SET p_EExc.PostID = @NewPostID FROM p_EExc, deleted d WHERE p_EExc.PostID = @OldPostID AND p_EExc.EmpClass = d.EmpClass
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей - Разряды'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PostMC ^ p_EGiv - Обновление CHILD */
/* Справочник должностей - Разряды ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpClass = i.EmpClass, a.PostID = i.PostID
          FROM p_EGiv a, inserted i, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(PostID) AND (SELECT COUNT(DISTINCT EmpClass) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpClass) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpClass = EmpClass FROM deleted
          SELECT TOP 1 @NewEmpClass = EmpClass FROM inserted
          UPDATE p_EGiv SET p_EGiv.EmpClass = @NewEmpClass FROM p_EGiv, deleted d WHERE p_EGiv.EmpClass = @OldEmpClass AND p_EGiv.PostID = d.PostID
        END
      ELSE IF NOT UPDATE(EmpClass) AND (SELECT COUNT(DISTINCT PostID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PostID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPostID = PostID FROM deleted
          SELECT TOP 1 @NewPostID = PostID FROM inserted
          UPDATE p_EGiv SET p_EGiv.PostID = @NewPostID FROM p_EGiv, deleted d WHERE p_EGiv.PostID = @OldPostID AND p_EGiv.EmpClass = d.EmpClass
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей - Разряды'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PostMC ^ p_LExcD - Обновление CHILD */
/* Справочник должностей - Разряды ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpClass = i.EmpClass, a.PostID = i.PostID
          FROM p_LExcD a, inserted i, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(PostID) AND (SELECT COUNT(DISTINCT EmpClass) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpClass) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpClass = EmpClass FROM deleted
          SELECT TOP 1 @NewEmpClass = EmpClass FROM inserted
          UPDATE p_LExcD SET p_LExcD.EmpClass = @NewEmpClass FROM p_LExcD, deleted d WHERE p_LExcD.EmpClass = @OldEmpClass AND p_LExcD.PostID = d.PostID
        END
      ELSE IF NOT UPDATE(EmpClass) AND (SELECT COUNT(DISTINCT PostID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PostID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPostID = PostID FROM deleted
          SELECT TOP 1 @NewPostID = PostID FROM inserted
          UPDATE p_LExcD SET p_LExcD.PostID = @NewPostID FROM p_LExcD, deleted d WHERE p_LExcD.PostID = @OldPostID AND p_LExcD.EmpClass = d.EmpClass
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей - Разряды'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PostMC ^ p_WExc - Обновление CHILD */
/* Справочник должностей - Разряды ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(EmpClass) OR UPDATE(PostID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpClass = i.EmpClass, a.PostID = i.PostID
          FROM p_WExc a, inserted i, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(PostID) AND (SELECT COUNT(DISTINCT EmpClass) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpClass) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpClass = EmpClass FROM deleted
          SELECT TOP 1 @NewEmpClass = EmpClass FROM inserted
          UPDATE p_WExc SET p_WExc.EmpClass = @NewEmpClass FROM p_WExc, deleted d WHERE p_WExc.EmpClass = @OldEmpClass AND p_WExc.PostID = d.PostID
        END
      ELSE IF NOT UPDATE(EmpClass) AND (SELECT COUNT(DISTINCT PostID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PostID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPostID = PostID FROM deleted
          SELECT TOP 1 @NewPostID = PostID FROM inserted
          UPDATE p_WExc SET p_WExc.PostID = @NewPostID FROM p_WExc, deleted d WHERE p_WExc.PostID = @OldPostID AND p_WExc.EmpClass = d.EmpClass
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей - Разряды'' => ''Привлечение на другую работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(PostID) OR UPDATE(EmpClass)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PostID, EmpClass FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PostID, EmpClass FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpClass as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10093002 AND l.PKValue = 
          '[' + cast(d.PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpClass as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpClass as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10093002 AND l.PKValue = 
          '[' + cast(d.PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpClass as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10093002, m.ChID, 
          '[' + cast(d.PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpClass as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Posts m ON m.PostID = d.PostID
          DELETE FROM z_LogCreate WHERE TableCode = 10093002 AND PKValue IN (SELECT 
          '[' + cast(PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpClass as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10093002 AND PKValue IN (SELECT 
          '[' + cast(PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpClass as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10093002, m.ChID, 
          '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpClass as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Posts m ON m.PostID = i.PostID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10093002, m.ChID, 
    '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpClass as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Posts m ON m.PostID = i.PostID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PostMC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PostMC] ON [dbo].[r_PostMC]
FOR DELETE AS
/* r_PostMC - Справочник должностей - Разряды - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PostMC ^ r_EmpMPst - Проверка в CHILD */
/* Справочник должностей - Разряды ^ Справочник служащих - Должности и оплата труда - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMPst a WITH(NOLOCK), deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'r_EmpMPst', 3
      RETURN
    END

/* r_PostMC ^ p_EExc - Проверка в CHILD */
/* Справочник должностей - Разряды ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'p_EExc', 3
      RETURN
    END

/* r_PostMC ^ p_EGiv - Проверка в CHILD */
/* Справочник должностей - Разряды ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'p_EGiv', 3
      RETURN
    END

/* r_PostMC ^ p_LExcD - Проверка в CHILD */
/* Справочник должностей - Разряды ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'p_LExcD', 3
      RETURN
    END

/* r_PostMC ^ p_WExc - Проверка в CHILD */
/* Справочник должностей - Разряды ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.EmpClass = d.EmpClass AND a.PostID = d.PostID)
    BEGIN
      EXEC z_RelationError 'r_PostMC', 'p_WExc', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10093002 AND m.PKValue = 
    '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpClass as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10093002 AND m.PKValue = 
    '[' + cast(i.PostID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpClass as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10093002, m.ChID, 
    '[' + cast(d.PostID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EmpClass as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Posts m ON m.PostID = d.PostID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_PostMC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_PostMC] ADD CONSTRAINT [_pk_r_PostMC] PRIMARY KEY CLUSTERED ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpClass] ON [dbo].[r_PostMC] ([EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostID] ON [dbo].[r_PostMC] ([PostID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[ClassFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[ClassSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[ClassFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostMC].[ClassSalary]'
GO
