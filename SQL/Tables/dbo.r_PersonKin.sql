CREATE TABLE [dbo].[r_PersonKin] (
  [PersonID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [KinName] [varchar](200) NOT NULL,
  [KinBirthday] [smalldatetime] NULL,
  [KinRels] [tinyint] NOT NULL,
  CONSTRAINT [pk_r_PersonKin] PRIMARY KEY CLUSTERED ([PersonID], [SrcPosID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PersonKin] ON [r_PersonKin]
FOR INSERT AS
/* r_PersonKin - Справочник персон - члены семьи - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonKin ^ r_Persons - Проверка в PARENT */
/* Справочник персон - члены семьи ^ Справочник персон - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
    BEGIN
      EXEC z_RelationError 'r_Persons', 'r_PersonKin', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118006, m.ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_PersonKin', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PersonKin] ON [r_PersonKin]
FOR UPDATE AS
/* r_PersonKin - Справочник персон - члены семьи - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonKin ^ r_Persons - Проверка в PARENT */
/* Справочник персон - члены семьи ^ Справочник персон - Проверка в PARENT */
  IF UPDATE(PersonID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
      BEGIN
        EXEC z_RelationError 'r_Persons', 'r_PersonKin', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(PersonID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11118006 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11118006 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11118006, m.ChID, 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Persons m ON m.PersonID = d.PersonID
          DELETE FROM z_LogCreate WHERE TableCode = 11118006 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11118006 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11118006, m.ChID, 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118006, m.ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_PersonKin', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PersonKin] ON [r_PersonKin]
FOR DELETE AS
/* r_PersonKin - Справочник персон - члены семьи - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11118006 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11118006 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11118006, m.ChID, 
    '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Persons m ON m.PersonID = d.PersonID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_PersonKin', N'Last', N'DELETE'
GO