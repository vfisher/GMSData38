CREATE TABLE [dbo].[r_PersonPreferences]
(
[PersonID] [bigint] NOT NULL,
[ExecutorID] [int] NOT NULL,
[SrvcID] [int] NOT NULL,
[ResourceID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PersonPreferences] ON [dbo].[r_PersonPreferences]
FOR INSERT AS
/* r_PersonPreferences - Справочник персон - предпочтения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonPreferences ^ r_Executors - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник исполнителей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
    BEGIN
      EXEC z_RelationError 'r_Executors', 'r_PersonPreferences', 0
      RETURN
    END

/* r_PersonPreferences ^ r_Persons - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник персон - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
    BEGIN
      EXEC z_RelationError 'r_Persons', 'r_PersonPreferences', 0
      RETURN
    END

/* r_PersonPreferences ^ r_Resources - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник ресурсов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
    BEGIN
      EXEC z_RelationError 'r_Resources', 'r_PersonPreferences', 0
      RETURN
    END

/* r_PersonPreferences ^ r_Services - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_PersonPreferences', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118002, m.ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PersonPreferences]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PersonPreferences] ON [dbo].[r_PersonPreferences]
FOR UPDATE AS
/* r_PersonPreferences - Справочник персон - предпочтения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonPreferences ^ r_Executors - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник исполнителей - Проверка в PARENT */
  IF UPDATE(ExecutorID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
      BEGIN
        EXEC z_RelationError 'r_Executors', 'r_PersonPreferences', 1
        RETURN
      END

/* r_PersonPreferences ^ r_Persons - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник персон - Проверка в PARENT */
  IF UPDATE(PersonID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
      BEGIN
        EXEC z_RelationError 'r_Persons', 'r_PersonPreferences', 1
        RETURN
      END

/* r_PersonPreferences ^ r_Resources - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник ресурсов - Проверка в PARENT */
  IF UPDATE(ResourceID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceID NOT IN (SELECT ResourceID FROM r_Resources))
      BEGIN
        EXEC z_RelationError 'r_Resources', 'r_PersonPreferences', 1
        RETURN
      END

/* r_PersonPreferences ^ r_Services - Проверка в PARENT */
/* Справочник персон - предпочтения ^ Справочник услуг - Проверка в PARENT */
  IF UPDATE(SrvcID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
      BEGIN
        EXEC z_RelationError 'r_Services', 'r_PersonPreferences', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(PersonID) OR UPDATE(ExecutorID) OR UPDATE(SrvcID) OR UPDATE(ResourceID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID, ExecutorID, SrvcID, ResourceID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID, ExecutorID, SrvcID, ResourceID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11118002 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11118002 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11118002, m.ChID, 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Persons m ON m.PersonID = d.PersonID
          DELETE FROM z_LogCreate WHERE TableCode = 11118002 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ResourceID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11118002 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ResourceID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11118002, m.ChID, 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118002, m.ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PersonPreferences]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PersonPreferences] ON [dbo].[r_PersonPreferences]
FOR DELETE AS
/* r_PersonPreferences - Справочник персон - предпочтения - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11118002 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11118002 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11118002, m.ChID, 
    '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ResourceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Persons m ON m.PersonID = d.PersonID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_PersonPreferences]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_PersonPreferences] ADD CONSTRAINT [pk_r_PersonPreferences] PRIMARY KEY CLUSTERED ([PersonID], [ExecutorID], [SrvcID], [ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_PersonPreferences] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonPreferences] ([PersonID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[r_PersonPreferences] ([ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_PersonPreferences] ([SrvcID]) ON [PRIMARY]
GO
