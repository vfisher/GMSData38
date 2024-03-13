CREATE TABLE [dbo].[r_Resources]
(
[ChID] [bigint] NOT NULL,
[ResourceID] [int] NOT NULL,
[ResourceName] [varchar] (200) NOT NULL,
[ResourceTypeID] [int] NOT NULL,
[MaxClients] [int] NOT NULL DEFAULT ((1)),
[StockID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Resources] ON [dbo].[r_Resources]
FOR INSERT AS
/* r_Resources - Справочник ресурсов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Resources ^ r_ResourceTypes - Проверка в PARENT */
/* Справочник ресурсов ^ Справочник ресурсов: типы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceTypeID NOT IN (SELECT ResourceTypeID FROM r_ResourceTypes))
    BEGIN
      EXEC z_RelationError 'r_ResourceTypes', 'r_Resources', 0
      RETURN
    END

/* r_Resources ^ r_Stocks - Проверка в PARENT */
/* Справочник ресурсов ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_Resources', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11114001, ChID, 
    '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Resources]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Resources] ON [dbo].[r_Resources]
FOR UPDATE AS
/* r_Resources - Справочник ресурсов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Resources ^ r_ResourceTypes - Проверка в PARENT */
/* Справочник ресурсов ^ Справочник ресурсов: типы - Проверка в PARENT */
  IF UPDATE(ResourceTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceTypeID NOT IN (SELECT ResourceTypeID FROM r_ResourceTypes))
      BEGIN
        EXEC z_RelationError 'r_ResourceTypes', 'r_Resources', 1
        RETURN
      END

/* r_Resources ^ r_Stocks - Проверка в PARENT */
/* Справочник ресурсов ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_Resources', 1
        RETURN
      END

/* r_Resources ^ r_ResourceSched - Обновление CHILD */
/* Справочник ресурсов ^ Справочник ресурсов - график работ - Обновление CHILD */
  IF UPDATE(ResourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceID = i.ResourceID
          FROM r_ResourceSched a, inserted i, deleted d WHERE a.ResourceID = d.ResourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ResourceSched a, deleted d WHERE a.ResourceID = d.ResourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов'' => ''Справочник ресурсов - график работ''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Resources ^ r_PersonPreferences - Обновление CHILD */
/* Справочник ресурсов ^ Справочник персон - предпочтения - Обновление CHILD */
  IF UPDATE(ResourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceID = i.ResourceID
          FROM r_PersonPreferences a, inserted i, deleted d WHERE a.ResourceID = d.ResourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonPreferences a, deleted d WHERE a.ResourceID = d.ResourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов'' => ''Справочник персон - предпочтения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Resources ^ r_PersonResourcesBL - Обновление CHILD */
/* Справочник ресурсов ^ Справочник персон - черный список ресурсов - Обновление CHILD */
  IF UPDATE(ResourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceID = i.ResourceID
          FROM r_PersonResourcesBL a, inserted i, deleted d WHERE a.ResourceID = d.ResourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonResourcesBL a, deleted d WHERE a.ResourceID = d.ResourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов'' => ''Справочник персон - черный список ресурсов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Resources ^ t_BookingD - Обновление CHILD */
/* Справочник ресурсов ^ Заявки: Подробно - Обновление CHILD */
  IF UPDATE(ResourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceID = i.ResourceID
          FROM t_BookingD a, inserted i, deleted d WHERE a.ResourceID = d.ResourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_BookingD a, deleted d WHERE a.ResourceID = d.ResourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов'' => ''Заявки: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Resources ^ t_BookingTempD - Обновление CHILD */
/* Справочник ресурсов ^ Интернет заявки - подробно - Обновление CHILD */
  IF UPDATE(ResourceID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ResourceID = i.ResourceID
          FROM t_BookingTempD a, inserted i, deleted d WHERE a.ResourceID = d.ResourceID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_BookingTempD a, deleted d WHERE a.ResourceID = d.ResourceID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресурсов'' => ''Интернет заявки - подробно''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11114001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11114001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ResourceID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11114001 AND l.PKValue = 
        '[' + cast(i.ResourceID as varchar(200)) + ']' AND i.ResourceID = d.ResourceID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11114001 AND l.PKValue = 
        '[' + cast(i.ResourceID as varchar(200)) + ']' AND i.ResourceID = d.ResourceID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11114001, ChID, 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11114001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11114001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11114001, ChID, 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ResourceID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ResourceID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ResourceID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11114001 AND l.PKValue = 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11114001 AND l.PKValue = 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11114001, ChID, 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11114001 AND PKValue IN (SELECT 
          '[' + cast(ResourceID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11114001 AND PKValue IN (SELECT 
          '[' + cast(ResourceID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11114001, ChID, 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11114001, ChID, 
    '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Resources]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Resources] ON [dbo].[r_Resources]
FOR DELETE AS
/* r_Resources - Справочник ресурсов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Resources ^ r_ResourceSched - Удаление в CHILD */
/* Справочник ресурсов ^ Справочник ресурсов - график работ - Удаление в CHILD */
  DELETE r_ResourceSched FROM r_ResourceSched a, deleted d WHERE a.ResourceID = d.ResourceID
  IF @@ERROR > 0 RETURN

/* r_Resources ^ r_PersonPreferences - Проверка в CHILD */
/* Справочник ресурсов ^ Справочник персон - предпочтения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PersonPreferences a WITH(NOLOCK), deleted d WHERE a.ResourceID = d.ResourceID)
    BEGIN
      EXEC z_RelationError 'r_Resources', 'r_PersonPreferences', 3
      RETURN
    END

/* r_Resources ^ r_PersonResourcesBL - Проверка в CHILD */
/* Справочник ресурсов ^ Справочник персон - черный список ресурсов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PersonResourcesBL a WITH(NOLOCK), deleted d WHERE a.ResourceID = d.ResourceID)
    BEGIN
      EXEC z_RelationError 'r_Resources', 'r_PersonResourcesBL', 3
      RETURN
    END

/* r_Resources ^ t_BookingD - Проверка в CHILD */
/* Справочник ресурсов ^ Заявки: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_BookingD a WITH(NOLOCK), deleted d WHERE a.ResourceID = d.ResourceID)
    BEGIN
      EXEC z_RelationError 'r_Resources', 't_BookingD', 3
      RETURN
    END

/* r_Resources ^ t_BookingTempD - Проверка в CHILD */
/* Справочник ресурсов ^ Интернет заявки - подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_BookingTempD a WITH(NOLOCK), deleted d WHERE a.ResourceID = d.ResourceID)
    BEGIN
      EXEC z_RelationError 'r_Resources', 't_BookingTempD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11114001 AND m.PKValue = 
    '[' + cast(i.ResourceID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11114001 AND m.PKValue = 
    '[' + cast(i.ResourceID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11114001, -ChID, 
    '[' + cast(d.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11114 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Resources]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Resources] ADD CONSTRAINT [pk_r_Resources] PRIMARY KEY CLUSTERED ([ResourceID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Resources] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceName] ON [dbo].[r_Resources] ([ResourceName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceTypeID] ON [dbo].[r_Resources] ([ResourceTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[r_Resources] ([StockID]) ON [PRIMARY]
GO
