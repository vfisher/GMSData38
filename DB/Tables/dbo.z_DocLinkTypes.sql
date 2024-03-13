CREATE TABLE [dbo].[z_DocLinkTypes]
(
[DocLinkTypeID] [int] NOT NULL,
[DocLinkTypeName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[SignType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_z_DocLinkTypes] ON [dbo].[z_DocLinkTypes]
FOR INSERT AS
/* z_DocLinkTypes - Документы - Взаимосвязи: Типы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 1001071, 0, 
    '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_z_DocLinkTypes]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_z_DocLinkTypes] ON [dbo].[z_DocLinkTypes]
FOR UPDATE AS
/* z_DocLinkTypes - Документы - Взаимосвязи: Типы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(DocLinkTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DocLinkTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DocLinkTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 1001071 AND l.PKValue = 
          '[' + cast(d.DocLinkTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 1001071 AND l.PKValue = 
          '[' + cast(d.DocLinkTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 1001071, 0, 
          '[' + cast(d.DocLinkTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 1001071 AND PKValue IN (SELECT 
          '[' + cast(DocLinkTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 1001071 AND PKValue IN (SELECT 
          '[' + cast(DocLinkTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 1001071, 0, 
          '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 1001071, 0, 
    '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_z_DocLinkTypes]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_DocLinkTypes] ON [dbo].[z_DocLinkTypes]FOR DELETE AS/* z_DocLinkTypes - Документы - Взаимосвязи: Типы - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 1001071 AND m.PKValue =     '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 1001071 AND m.PKValue =     '[' + cast(i.DocLinkTypeID as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 1001071, 0,     '[' + cast(d.DocLinkTypeID as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_z_DocLinkTypes]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[z_DocLinkTypes] ADD CONSTRAINT [pk_z_DocLinkTypes] PRIMARY KEY CLUSTERED ([DocLinkTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocLinkTypeName] ON [dbo].[z_DocLinkTypes] ([DocLinkTypeName]) ON [PRIMARY]
GO
