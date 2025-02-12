CREATE TABLE [dbo].[r_CompValues] (
  [CompID] [int] NOT NULL,
  [VarName] [varchar](250) NOT NULL,
  [VarValue] [varchar](250) NOT NULL,
  CONSTRAINT [pk_r_CompValues] PRIMARY KEY CLUSTERED ([CompID], [VarName])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompValues] ON [r_CompValues]
FOR INSERT AS
/* r_CompValues - Справочник предприятий - Значения - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250006, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompValues', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompValues] ON [r_CompValues]
FOR UPDATE AS
/* r_CompValues - Справочник предприятий - Значения - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CompID) OR UPDATE(VarName)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, VarName FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, VarName FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VarName as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250006 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VarName as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VarName as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250006 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VarName as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250006, m.ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID
          DELETE FROM z_LogCreate WHERE TableCode = 10250006 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(VarName as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250006 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(VarName as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250006, m.ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250006, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompValues', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompValues] ON [r_CompValues]
FOR DELETE AS
/* r_CompValues - Справочник предприятий - Значения - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10250006 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10250006 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VarName as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10250006, m.ChID, 
    '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.VarName as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompValues', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[r_CompValues]
  ADD CONSTRAINT [FK_r_CompValues_r_Comps] FOREIGN KEY ([CompID]) REFERENCES [dbo].[r_Comps] ([CompID]) ON DELETE CASCADE ON UPDATE CASCADE
GO