CREATE TABLE [dbo].[r_CompContacts] (
  [CompID] [int] NOT NULL,
  [Contact] [varchar](250) NOT NULL,
  [PhoneWork] [varchar](50) NULL,
  [PhoneMob] [varchar](50) NULL,
  [PhoneHome] [varchar](50) NULL,
  [eMail] [varchar](250) NULL,
  [Job] [varchar](250) NULL,
  [BirthDate] [smalldatetime] NULL,
  CONSTRAINT [pk_r_CompContacts] PRIMARY KEY CLUSTERED ([CompID], [Contact])
)
ON [PRIMARY]
GO

CREATE INDEX [Contact]
  ON [dbo].[r_CompContacts] ([Contact])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompContacts] ON [r_CompContacts]
FOR INSERT AS
/* r_CompContacts - Справочник Предприятий - Контакты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250007, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.Contact as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompContacts', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompContacts] ON [r_CompContacts]
FOR UPDATE AS
/* r_CompContacts - Справочник Предприятий - Контакты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CompID) OR UPDATE(Contact)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, Contact FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, Contact FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.Contact as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250007 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.Contact as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.Contact as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250007 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.Contact as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250007, m.ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.Contact as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID
          DELETE FROM z_LogCreate WHERE TableCode = 10250007 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(Contact as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250007 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(Contact as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250007, m.ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.Contact as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250007, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.Contact as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompContacts', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompContacts] ON [r_CompContacts]
FOR DELETE AS
/* r_CompContacts - Справочник Предприятий - Контакты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10250007 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.Contact as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10250007 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.Contact as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10250007, m.ChID, 
    '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.Contact as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompContacts', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[r_CompContacts]
  ADD CONSTRAINT [FK_r_CompContacts_r_Comps] FOREIGN KEY ([CompID]) REFERENCES [dbo].[r_Comps] ([CompID]) ON DELETE CASCADE ON UPDATE CASCADE
GO