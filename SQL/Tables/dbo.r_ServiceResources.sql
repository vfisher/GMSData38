CREATE TABLE [dbo].[r_ServiceResources] (
  [SrvcID] [int] NOT NULL,
  [ResourceTypeID] [int] NOT NULL,
  CONSTRAINT [pk_r_ServiceResources] PRIMARY KEY CLUSTERED ([SrvcID], [ResourceTypeID])
)
ON [PRIMARY]
GO

CREATE INDEX [ResourceTypeID]
  ON [dbo].[r_ServiceResources] ([ResourceTypeID])
  ON [PRIMARY]
GO

CREATE INDEX [SrvcID]
  ON [dbo].[r_ServiceResources] ([SrvcID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ServiceResources] ON [r_ServiceResources]
FOR INSERT AS
/* r_ServiceResources - Справочник услуг - ресурсы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ServiceResources ^ r_ResourceTypes - Проверка в PARENT */
/* Справочник услуг - ресурсы ^ Справочник ресурсов: типы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceTypeID NOT IN (SELECT ResourceTypeID FROM r_ResourceTypes))
    BEGIN
      EXEC z_RelationError 'r_ResourceTypes', 'r_ServiceResources', 0
      RETURN
    END

/* r_ServiceResources ^ r_Services - Проверка в PARENT */
/* Справочник услуг - ресурсы ^ Справочник услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ServiceResources', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11115003, m.ChID, 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Services m ON m.SrvcID = i.SrvcID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ServiceResources', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ServiceResources] ON [r_ServiceResources]
FOR UPDATE AS
/* r_ServiceResources - Справочник услуг - ресурсы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ServiceResources ^ r_ResourceTypes - Проверка в PARENT */
/* Справочник услуг - ресурсы ^ Справочник ресурсов: типы - Проверка в PARENT */
  IF UPDATE(ResourceTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ResourceTypeID NOT IN (SELECT ResourceTypeID FROM r_ResourceTypes))
      BEGIN
        EXEC z_RelationError 'r_ResourceTypes', 'r_ServiceResources', 1
        RETURN
      END

/* r_ServiceResources ^ r_Services - Проверка в PARENT */
/* Справочник услуг - ресурсы ^ Справочник услуг - Проверка в PARENT */
  IF UPDATE(SrvcID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
      BEGIN
        EXEC z_RelationError 'r_Services', 'r_ServiceResources', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(SrvcID) OR UPDATE(ResourceTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvcID, ResourceTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvcID, ResourceTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11115003 AND l.PKValue = 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11115003 AND l.PKValue = 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11115003, m.ChID, 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Services m ON m.SrvcID = d.SrvcID
          DELETE FROM z_LogCreate WHERE TableCode = 11115003 AND PKValue IN (SELECT 
          '[' + cast(SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ResourceTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11115003 AND PKValue IN (SELECT 
          '[' + cast(SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ResourceTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11115003, m.ChID, 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Services m ON m.SrvcID = i.SrvcID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11115003, m.ChID, 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Services m ON m.SrvcID = i.SrvcID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ServiceResources', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ServiceResources] ON [r_ServiceResources]
FOR DELETE AS
/* r_ServiceResources - Справочник услуг - ресурсы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11115003 AND m.PKValue = 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11115003 AND m.PKValue = 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ResourceTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11115003, m.ChID, 
    '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ResourceTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Services m ON m.SrvcID = d.SrvcID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ServiceResources', N'Last', N'DELETE'
GO