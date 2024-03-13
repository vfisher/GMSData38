CREATE TABLE [dbo].[r_ResourceTypes]
(
[ChID] [bigint] NOT NULL,
[ResourceTypeID] [int] NOT NULL,
[ResourceTypeName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ResourceTypes] ON [dbo].[r_ResourceTypes]
FOR INSERT AS
/* r_ResourceTypes - Справочник ресурсов: типы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11113001, ChID, 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ResourceTypes]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ResourceTypes] ON [dbo].[r_ResourceTypes]
FOR UPDATE AS
/* r_ResourceTypes - Справочник ресурсов: типы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ResourceTypes ^ r_ServiceResources - Обновление CHILD */
/* Справочник ресурсов: типы ^ Справочник услуг - ресурсы - Обновление CHILD */
  IF UPDATE(ResourceTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceTypeID = i.ResourceTypeID
          FROM r_ServiceResources a, inserted i, deleted d WHERE a.ResourceTypeID = d.ResourceTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ServiceResources a, deleted d WHERE a.ResourceTypeID = d.ResourceTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов: типы'' => ''Справочник услуг - ресурсы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ResourceTypes ^ r_Resources - Обновление CHILD */
/* Справочник ресурсов: типы ^ Справочник ресурсов - Обновление CHILD */
  IF UPDATE(ResourceTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceTypeID = i.ResourceTypeID
          FROM r_Resources a, inserted i, deleted d WHERE a.ResourceTypeID = d.ResourceTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Resources a, deleted d WHERE a.ResourceTypeID = d.ResourceTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов: типы'' => ''Справочник ресурсов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11113001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11113001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ResourceTypeID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11113001 AND l.PKValue = 
        '[' + cast(i.ResourceTypeID as varchar(200)) + ']' AND i.ResourceTypeID = d.ResourceTypeID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11113001 AND l.PKValue = 
        '[' + cast(i.ResourceTypeID as varchar(200)) + ']' AND i.ResourceTypeID = d.ResourceTypeID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11113001, ChID, 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11113001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11113001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11113001, ChID, 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ResourceTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ResourceTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ResourceTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11113001 AND l.PKValue = 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11113001 AND l.PKValue = 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11113001, ChID, 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11113001 AND PKValue IN (SELECT 
          '[' + cast(ResourceTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11113001 AND PKValue IN (SELECT 
          '[' + cast(ResourceTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11113001, ChID, 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11113001, ChID, 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ResourceTypes]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ResourceTypes] ON [dbo].[r_ResourceTypes]
FOR DELETE AS
/* r_ResourceTypes - Справочник ресурсов: типы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ResourceTypes ^ r_ServiceResources - Проверка в CHILD */
/* Справочник ресурсов: типы ^ Справочник услуг - ресурсы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ServiceResources a WITH(NOLOCK), deleted d WHERE a.ResourceTypeID = d.ResourceTypeID)
    BEGIN
      EXEC z_RelationError 'r_ResourceTypes', 'r_ServiceResources', 3
      RETURN
    END

/* r_ResourceTypes ^ r_Resources - Проверка в CHILD */
/* Справочник ресурсов: типы ^ Справочник ресурсов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Resources a WITH(NOLOCK), deleted d WHERE a.ResourceTypeID = d.ResourceTypeID)
    BEGIN
      EXEC z_RelationError 'r_ResourceTypes', 'r_Resources', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11113001 AND m.PKValue = 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11113001 AND m.PKValue = 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11113001, -ChID, 
    '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11113 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ResourceTypes]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ResourceTypes] ADD CONSTRAINT [pk_r_ResourceTypes] PRIMARY KEY CLUSTERED ([ResourceTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ResourceTypes] ([ChID]) ON [PRIMARY]
GO
