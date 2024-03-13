CREATE TABLE [dbo].[r_PersonDC]
(
[PersonID] [bigint] NOT NULL,
[Notes] [varchar] (200) NULL,
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__r_PersonD__DCard__1E600526] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PersonDC] ON [dbo].[r_PersonDC]
FOR INSERT AS
/* r_PersonDC - Справочник персон - дисконтные карты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonDC ^ r_Persons - Проверка в PARENT */
/* Справочник персон - дисконтные карты ^ Справочник персон - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
    BEGIN
      EXEC z_RelationError 'r_Persons', 'r_PersonDC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118005, m.ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCardChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PersonDC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PersonDC] ON [dbo].[r_PersonDC]
FOR UPDATE AS
/* r_PersonDC - Справочник персон - дисконтные карты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PersonDC ^ r_Persons - Проверка в PARENT */
/* Справочник персон - дисконтные карты ^ Справочник персон - Проверка в PARENT */
  IF UPDATE(PersonID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PersonID NOT IN (SELECT PersonID FROM r_Persons))
      BEGIN
        EXEC z_RelationError 'r_Persons', 'r_PersonDC', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(PersonID) OR UPDATE(DCardChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID, DCardChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PersonID, DCardChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DCardChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11118005 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DCardChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DCardChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11118005 AND l.PKValue = 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DCardChID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11118005, m.ChID, 
          '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DCardChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Persons m ON m.PersonID = d.PersonID
          DELETE FROM z_LogCreate WHERE TableCode = 11118005 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DCardChID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11118005 AND PKValue IN (SELECT 
          '[' + cast(PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DCardChID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11118005, m.ChID, 
          '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DCardChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11118005, m.ChID, 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCardChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Persons m ON m.PersonID = i.PersonID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PersonDC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PersonDC] ON [dbo].[r_PersonDC]
FOR DELETE AS
/* r_PersonDC - Справочник персон - дисконтные карты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11118005 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCardChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11118005 AND m.PKValue = 
    '[' + cast(i.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DCardChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11118005, m.ChID, 
    '[' + cast(d.PersonID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DCardChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Persons m ON m.PersonID = d.PersonID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_PersonDC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_PersonDC] ADD CONSTRAINT [pk_r_PersonDC] PRIMARY KEY CLUSTERED ([PersonID], [DCardChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DCardChID] ON [dbo].[r_PersonDC] ([DCardChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PersonID] ON [dbo].[r_PersonDC] ([PersonID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PersonDC] ADD CONSTRAINT [FK_r_PersonDC_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
