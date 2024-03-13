CREATE TABLE [dbo].[r_ServiceCompatibility]
(
[SrvcID] [int] NOT NULL,
[CompatibleServiceID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ServiceCompatibility] ON [dbo].[r_ServiceCompatibility]
FOR INSERT AS
/* r_ServiceCompatibility - Справочник услуг - совместимость - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ServiceCompatibility ^ r_Services - Проверка в PARENT */
/* Справочник услуг - совместимость ^ Справочник услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompatibleServiceID NOT IN (SELECT SrvcID FROM r_Services))
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ServiceCompatibility', 0
      RETURN
    END

/* r_ServiceCompatibility ^ r_Services - Проверка в PARENT */
/* Справочник услуг - совместимость ^ Справочник услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ServiceCompatibility', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11115002, m.ChID, 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Services m ON m.SrvcID = i.SrvcID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ServiceCompatibility]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ServiceCompatibility] ON [dbo].[r_ServiceCompatibility]
FOR UPDATE AS
/* r_ServiceCompatibility - Справочник услуг - совместимость - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ServiceCompatibility ^ r_Services - Проверка в PARENT */
/* Справочник услуг - совместимость ^ Справочник услуг - Проверка в PARENT */
  IF UPDATE(CompatibleServiceID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompatibleServiceID NOT IN (SELECT SrvcID FROM r_Services))
      BEGIN
        EXEC z_RelationError 'r_Services', 'r_ServiceCompatibility', 1
        RETURN
      END

/* r_ServiceCompatibility ^ r_Services - Проверка в PARENT */
/* Справочник услуг - совместимость ^ Справочник услуг - Проверка в PARENT */
  IF UPDATE(SrvcID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
      BEGIN
        EXEC z_RelationError 'r_Services', 'r_ServiceCompatibility', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(SrvcID) OR UPDATE(CompatibleServiceID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvcID, CompatibleServiceID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvcID, CompatibleServiceID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11115002 AND l.PKValue = 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompatibleServiceID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11115002 AND l.PKValue = 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompatibleServiceID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11115002, m.ChID, 
          '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompatibleServiceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Services m ON m.SrvcID = d.SrvcID
          DELETE FROM z_LogCreate WHERE TableCode = 11115002 AND PKValue IN (SELECT 
          '[' + cast(SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompatibleServiceID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11115002 AND PKValue IN (SELECT 
          '[' + cast(SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompatibleServiceID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11115002, m.ChID, 
          '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Services m ON m.SrvcID = i.SrvcID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11115002, m.ChID, 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Services m ON m.SrvcID = i.SrvcID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ServiceCompatibility]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ServiceCompatibility] ON [dbo].[r_ServiceCompatibility]
FOR DELETE AS
/* r_ServiceCompatibility - Справочник услуг - совместимость - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11115002 AND m.PKValue = 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11115002 AND m.PKValue = 
    '[' + cast(i.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompatibleServiceID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11115002, m.ChID, 
    '[' + cast(d.SrvcID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CompatibleServiceID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Services m ON m.SrvcID = d.SrvcID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ServiceCompatibility]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ServiceCompatibility] ADD CONSTRAINT [pk_r_ServiceCompatibility] PRIMARY KEY CLUSTERED ([SrvcID], [CompatibleServiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompatibleServiceID] ON [dbo].[r_ServiceCompatibility] ([CompatibleServiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_ServiceCompatibility] ([SrvcID]) ON [PRIMARY]
GO
