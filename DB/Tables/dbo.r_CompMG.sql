CREATE TABLE [dbo].[r_CompMG]
(
[CGrID] [smallint] NOT NULL,
[CompID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompMG] ON [dbo].[r_CompMG]
FOR INSERT AS
/* r_CompMG - Справочник предприятий - Участие в группах - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompMG ^ r_CompG - Проверка в PARENT */
/* Справочник предприятий - Участие в группах ^ Справочник предприятий: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CGrID NOT IN (SELECT CGrID FROM r_CompG))
    BEGIN
      EXEC z_RelationError 'r_CompG', 'r_CompMG', 0
      RETURN
    END

/* r_CompMG ^ r_Comps - Проверка в PARENT */
/* Справочник предприятий - Участие в группах ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_CompMG', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250002, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CompMG]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompMG] ON [dbo].[r_CompMG]
FOR UPDATE AS
/* r_CompMG - Справочник предприятий - Участие в группах - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompMG ^ r_CompG - Проверка в PARENT */
/* Справочник предприятий - Участие в группах ^ Справочник предприятий: группы - Проверка в PARENT */
  IF UPDATE(CGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CGrID NOT IN (SELECT CGrID FROM r_CompG))
      BEGIN
        EXEC z_RelationError 'r_CompG', 'r_CompMG', 1
        RETURN
      END

/* r_CompMG ^ r_Comps - Проверка в PARENT */
/* Справочник предприятий - Участие в группах ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_CompMG', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CompID) OR UPDATE(CGrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, CGrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, CGrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250002 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CGrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250002 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CGrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250002, m.ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID
          DELETE FROM z_LogCreate WHERE TableCode = 10250002 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CGrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250002 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CGrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250002, m.ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250002, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CompMG]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompMG] ON [dbo].[r_CompMG]
FOR DELETE AS
/* r_CompMG - Справочник предприятий - Участие в группах - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10250002 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CGrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10250002 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CGrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10250002, m.ChID, 
    '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CompMG]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CompMG] ADD CONSTRAINT [_pk_r_CompMG] PRIMARY KEY CLUSTERED ([CGrID], [CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CGrID] ON [dbo].[r_CompMG] ([CGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_CompMG] ([CompID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompMG].[CGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompMG].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompMG].[CGrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CompMG].[CompID]'
GO
