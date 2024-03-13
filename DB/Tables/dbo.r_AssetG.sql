CREATE TABLE [dbo].[r_AssetG]
(
[ChID] [bigint] NOT NULL,
[AGrID] [int] NOT NULL,
[AGrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (250) NULL,
[AssGrGAccID] [int] NOT NULL DEFAULT (0),
[AssDepGAccID] [int] NOT NULL DEFAULT (0),
[AGrID1] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_AssetG] ON [dbo].[r_AssetG]
FOR INSERT AS
/* r_AssetG - Справочник основных средств: подгруппы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetG ^ r_AssetG1 - Проверка в PARENT */
/* Справочник основных средств: подгруппы ^ Справочник основных средств: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AGrID1 NOT IN (SELECT AGrID1 FROM r_AssetG1))
    BEGIN
      EXEC z_RelationError 'r_AssetG1', 'r_AssetG', 0
      RETURN
    END

/* r_AssetG ^ r_GAccs - Проверка в PARENT */
/* Справочник основных средств: подгруппы ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AssDepGAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_AssetG', 0
      RETURN
    END

/* r_AssetG ^ r_GAccs - Проверка в PARENT */
/* Справочник основных средств: подгруппы ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AssGrGAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_AssetG', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10703001, ChID, 
    '[' + cast(i.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_AssetG]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_AssetG] ON [dbo].[r_AssetG]
FOR UPDATE AS
/* r_AssetG - Справочник основных средств: подгруппы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetG ^ r_AssetG1 - Проверка в PARENT */
/* Справочник основных средств: подгруппы ^ Справочник основных средств: группы - Проверка в PARENT */
  IF UPDATE(AGrID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AGrID1 NOT IN (SELECT AGrID1 FROM r_AssetG1))
      BEGIN
        EXEC z_RelationError 'r_AssetG1', 'r_AssetG', 1
        RETURN
      END

/* r_AssetG ^ r_GAccs - Проверка в PARENT */
/* Справочник основных средств: подгруппы ^ План счетов - Проверка в PARENT */
  IF UPDATE(AssDepGAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AssDepGAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_AssetG', 1
        RETURN
      END

/* r_AssetG ^ r_GAccs - Проверка в PARENT */
/* Справочник основных средств: подгруппы ^ План счетов - Проверка в PARENT */
  IF UPDATE(AssGrGAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AssGrGAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_AssetG', 1
        RETURN
      END

/* r_AssetG ^ r_AssetGDeps - Обновление CHILD */
/* Справочник основных средств: подгруппы ^ Справочник основных средств: подгруппы: Ставки амортизации - Обновление CHILD */
  IF UPDATE(AGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AGrID = i.AGrID
          FROM r_AssetGDeps a, inserted i, deleted d WHERE a.AGrID = d.AGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetGDeps a, deleted d WHERE a.AGrID = d.AGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств: подгруппы'' => ''Справочник основных средств: подгруппы: Ставки амортизации''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_AssetG ^ r_AssetH - Обновление CHILD */
/* Справочник основных средств: подгруппы ^ Справочник основных средств: История - Обновление CHILD */
  IF UPDATE(AGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AGrID = i.AGrID
          FROM r_AssetH a, inserted i, deleted d WHERE a.AGrID = d.AGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetH a, deleted d WHERE a.AGrID = d.AGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств: подгруппы'' => ''Справочник основных средств: История''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10703001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10703001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(AGrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10703001 AND l.PKValue = 
        '[' + cast(i.AGrID as varchar(200)) + ']' AND i.AGrID = d.AGrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10703001 AND l.PKValue = 
        '[' + cast(i.AGrID as varchar(200)) + ']' AND i.AGrID = d.AGrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10703001, ChID, 
          '[' + cast(d.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10703001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10703001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10703001, ChID, 
          '[' + cast(i.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(AGrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AGrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AGrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AGrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10703001 AND l.PKValue = 
          '[' + cast(d.AGrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AGrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10703001 AND l.PKValue = 
          '[' + cast(d.AGrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10703001, ChID, 
          '[' + cast(d.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10703001 AND PKValue IN (SELECT 
          '[' + cast(AGrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10703001 AND PKValue IN (SELECT 
          '[' + cast(AGrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10703001, ChID, 
          '[' + cast(i.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10703001, ChID, 
    '[' + cast(i.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_AssetG]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_AssetG] ON [dbo].[r_AssetG]
FOR DELETE AS
/* r_AssetG - Справочник основных средств: подгруппы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_AssetG ^ r_AssetGDeps - Удаление в CHILD */
/* Справочник основных средств: подгруппы ^ Справочник основных средств: подгруппы: Ставки амортизации - Удаление в CHILD */
  DELETE r_AssetGDeps FROM r_AssetGDeps a, deleted d WHERE a.AGrID = d.AGrID
  IF @@ERROR > 0 RETURN

/* r_AssetG ^ r_AssetH - Проверка в CHILD */
/* Справочник основных средств: подгруппы ^ Справочник основных средств: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetH a WITH(NOLOCK), deleted d WHERE a.AGrID = d.AGrID)
    BEGIN
      EXEC z_RelationError 'r_AssetG', 'r_AssetH', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10703001 AND m.PKValue = 
    '[' + cast(i.AGrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10703001 AND m.PKValue = 
    '[' + cast(i.AGrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10703001, -ChID, 
    '[' + cast(d.AGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10703 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_AssetG]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_AssetG] ADD CONSTRAINT [pk_r_AssetG] PRIMARY KEY CLUSTERED ([AGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AGrName] ON [dbo].[r_AssetG] ([AGrName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_AssetG] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetG].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetG].[AGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetG].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetG].[AGrID]'
GO
