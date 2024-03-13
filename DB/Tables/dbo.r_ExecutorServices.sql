CREATE TABLE [dbo].[r_ExecutorServices]
(
[ExecutorID] [int] NOT NULL,
[SrvcID] [int] NOT NULL,
[MaxClients] [int] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ExecutorServices] ON [dbo].[r_ExecutorServices]
FOR INSERT AS
/* r_ExecutorServices - Справочник исполнителей - услуги - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ExecutorServices ^ r_Executors - Проверка в PARENT */
/* Справочник исполнителей - услуги ^ Справочник исполнителей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
    BEGIN
      EXEC z_RelationError 'r_Executors', 'r_ExecutorServices', 0
      RETURN
    END

/* r_ExecutorServices ^ r_Services - Проверка в PARENT */
/* Справочник исполнителей - услуги ^ Справочник услуг - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ExecutorServices', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11117002, m.ChID, 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Executors m ON m.ExecutorID = i.ExecutorID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ExecutorServices]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ExecutorServices] ON [dbo].[r_ExecutorServices]
FOR UPDATE AS
/* r_ExecutorServices - Справочник исполнителей - услуги - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ExecutorServices ^ r_Executors - Проверка в PARENT */
/* Справочник исполнителей - услуги ^ Справочник исполнителей - Проверка в PARENT */
  IF UPDATE(ExecutorID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ExecutorID NOT IN (SELECT ExecutorID FROM r_Executors))
      BEGIN
        EXEC z_RelationError 'r_Executors', 'r_ExecutorServices', 1
        RETURN
      END

/* r_ExecutorServices ^ r_Services - Проверка в PARENT */
/* Справочник исполнителей - услуги ^ Справочник услуг - Проверка в PARENT */
  IF UPDATE(SrvcID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvcID NOT IN (SELECT SrvcID FROM r_Services))
      BEGIN
        EXEC z_RelationError 'r_Services', 'r_ExecutorServices', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ExecutorID) OR UPDATE(SrvcID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ExecutorID, SrvcID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ExecutorID, SrvcID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11117002 AND l.PKValue = 
          '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11117002 AND l.PKValue = 
          '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11117002, m.ChID, 
          '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Executors m ON m.ExecutorID = d.ExecutorID
          DELETE FROM z_LogCreate WHERE TableCode = 11117002 AND PKValue IN (SELECT 
          '[' + cast(ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrvcID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11117002 AND PKValue IN (SELECT 
          '[' + cast(ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrvcID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11117002, m.ChID, 
          '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Executors m ON m.ExecutorID = i.ExecutorID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11117002, m.ChID, 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Executors m ON m.ExecutorID = i.ExecutorID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ExecutorServices]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ExecutorServices] ON [dbo].[r_ExecutorServices]
FOR DELETE AS
/* r_ExecutorServices - Справочник исполнителей - услуги - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11117002 AND m.PKValue = 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11117002 AND m.PKValue = 
    '[' + cast(i.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrvcID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11117002, m.ChID, 
    '[' + cast(d.ExecutorID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Executors m ON m.ExecutorID = d.ExecutorID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ExecutorServices]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ExecutorServices] ADD CONSTRAINT [pk_r_ExecutorServices] PRIMARY KEY CLUSTERED ([ExecutorID], [SrvcID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExecutorID] ON [dbo].[r_ExecutorServices] ([ExecutorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrvcID] ON [dbo].[r_ExecutorServices] ([SrvcID]) ON [PRIMARY]
GO
