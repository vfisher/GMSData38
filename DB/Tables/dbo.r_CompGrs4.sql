CREATE TABLE [dbo].[r_CompGrs4]
(
[ChID] [bigint] NOT NULL,
[CompGrID4] [int] NOT NULL,
[CompGrName4] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompGrs4] ON [dbo].[r_CompGrs4]
FOR INSERT AS
/* r_CompGrs4 - Справочник предприятий: 4 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10198001, ChID, 
    '[' + cast(i.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CompGrs4]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompGrs4] ON [dbo].[r_CompGrs4]
FOR UPDATE AS
/* r_CompGrs4 - Справочник предприятий: 4 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompGrs4 ^ r_Comps - Обновление CHILD */
/* Справочник предприятий: 4 группа ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(CompGrID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompGrID4 = i.CompGrID4
          FROM r_Comps a, inserted i, deleted d WHERE a.CompGrID4 = d.CompGrID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.CompGrID4 = d.CompGrID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: 4 группа'' => ''Справочник предприятий''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10198001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10198001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CompGrID4))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10198001 AND l.PKValue = 
        '[' + cast(i.CompGrID4 as varchar(200)) + ']' AND i.CompGrID4 = d.CompGrID4
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10198001 AND l.PKValue = 
        '[' + cast(i.CompGrID4 as varchar(200)) + ']' AND i.CompGrID4 = d.CompGrID4
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10198001, ChID, 
          '[' + cast(d.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10198001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10198001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10198001, ChID, 
          '[' + cast(i.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CompGrID4)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID4 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID4 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID4 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10198001 AND l.PKValue = 
          '[' + cast(d.CompGrID4 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID4 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10198001 AND l.PKValue = 
          '[' + cast(d.CompGrID4 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10198001, ChID, 
          '[' + cast(d.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10198001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID4 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10198001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID4 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10198001, ChID, 
          '[' + cast(i.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10198001, ChID, 
    '[' + cast(i.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CompGrs4]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompGrs4] ON [dbo].[r_CompGrs4]
FOR DELETE AS
/* r_CompGrs4 - Справочник предприятий: 4 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompGrs4 ^ r_Comps - Проверка в CHILD */
/* Справочник предприятий: 4 группа ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.CompGrID4 = d.CompGrID4)
    BEGIN
      EXEC z_RelationError 'r_CompGrs4', 'r_Comps', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10198001 AND m.PKValue = 
    '[' + cast(i.CompGrID4 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10198001 AND m.PKValue = 
    '[' + cast(i.CompGrID4 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10198001, -ChID, 
    '[' + cast(d.CompGrID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10198 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CompGrs4]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CompGrs4] ADD CONSTRAINT [pk_r_CompGrs4] PRIMARY KEY CLUSTERED ([CompGrID4]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs4] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName4] ON [dbo].[r_CompGrs4] ([CompGrName4]) ON [PRIMARY]
GO
