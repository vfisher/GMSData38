CREATE TABLE [dbo].[r_PostC]
(
[ChID] [bigint] NOT NULL,
[PostCID] [smallint] NOT NULL,
[PostCName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PostC] ON [dbo].[r_PostC]
FOR INSERT AS
/* r_PostC - Справочник должностей: категории - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10092001, ChID, 
    '[' + cast(i.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PostC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PostC] ON [dbo].[r_PostC]
FOR UPDATE AS
/* r_PostC - Справочник должностей: категории - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PostC ^ r_Posts - Обновление CHILD */
/* Справочник должностей: категории ^ Справочник должностей - Обновление CHILD */
  IF UPDATE(PostCID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PostCID = i.PostCID
          FROM r_Posts a, inserted i, deleted d WHERE a.PostCID = d.PostCID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Posts a, deleted d WHERE a.PostCID = d.PostCID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник должностей: категории'' => ''Справочник должностей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10092001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10092001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PostCID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10092001 AND l.PKValue = 
        '[' + cast(i.PostCID as varchar(200)) + ']' AND i.PostCID = d.PostCID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10092001 AND l.PKValue = 
        '[' + cast(i.PostCID as varchar(200)) + ']' AND i.PostCID = d.PostCID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10092001, ChID, 
          '[' + cast(d.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10092001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10092001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10092001, ChID, 
          '[' + cast(i.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PostCID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PostCID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PostCID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PostCID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10092001 AND l.PKValue = 
          '[' + cast(d.PostCID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PostCID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10092001 AND l.PKValue = 
          '[' + cast(d.PostCID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10092001, ChID, 
          '[' + cast(d.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10092001 AND PKValue IN (SELECT 
          '[' + cast(PostCID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10092001 AND PKValue IN (SELECT 
          '[' + cast(PostCID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10092001, ChID, 
          '[' + cast(i.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10092001, ChID, 
    '[' + cast(i.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PostC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PostC] ON [dbo].[r_PostC]
FOR DELETE AS
/* r_PostC - Справочник должностей: категории - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PostC ^ r_Posts - Проверка в CHILD */
/* Справочник должностей: категории ^ Справочник должностей - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Posts a WITH(NOLOCK), deleted d WHERE a.PostCID = d.PostCID)
    BEGIN
      EXEC z_RelationError 'r_PostC', 'r_Posts', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10092001 AND m.PKValue = 
    '[' + cast(i.PostCID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10092001 AND m.PKValue = 
    '[' + cast(i.PostCID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10092001, -ChID, 
    '[' + cast(d.PostCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10092 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_PostC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_PostC] ADD CONSTRAINT [pk_r_PostC] PRIMARY KEY CLUSTERED ([PostCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_PostC] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PostCName] ON [dbo].[r_PostC] ([PostCName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostC].[PostCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PostC].[PostCID]'
GO
