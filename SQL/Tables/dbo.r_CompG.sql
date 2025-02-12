CREATE TABLE [dbo].[r_CompG] (
  [ChID] [bigint] NOT NULL,
  [CGrID] [smallint] NOT NULL,
  [CGrName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_CompG] PRIMARY KEY CLUSTERED ([CGrID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CGrName]
  ON [dbo].[r_CompG] ([CGrName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_CompG] ([ChID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompG.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompG.CGrID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompG] ON [r_CompG]
FOR INSERT AS
/* r_CompG - Справочник предприятий: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10200001, ChID, 
    '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompG', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompG] ON [r_CompG]
FOR UPDATE AS
/* r_CompG - Справочник предприятий: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompG ^ r_CompMG - Обновление CHILD */
/* Справочник предприятий: группы ^ Справочник предприятий - Участие в группах - Обновление CHILD */
  IF UPDATE(CGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CGrID = i.CGrID
          FROM r_CompMG a, inserted i, deleted d WHERE a.CGrID = d.CGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CompMG a, deleted d WHERE a.CGrID = d.CGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: группы'' => ''Справочник предприятий - Участие в группах''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompG ^ z_UserCompG - Обновление CHILD */
/* Справочник предприятий: группы ^ Доступные значения - Справочник предприятий: группы - Обновление CHILD */
  IF UPDATE(CGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CGrID = i.CGrID
          FROM z_UserCompG a, inserted i, deleted d WHERE a.CGrID = d.CGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCompG a, deleted d WHERE a.CGrID = d.CGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: группы'' => ''Доступные значения - Справочник предприятий: группы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10200001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10200001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CGrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10200001 AND l.PKValue = 
        '[' + cast(i.CGrID as varchar(200)) + ']' AND i.CGrID = d.CGrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10200001 AND l.PKValue = 
        '[' + cast(i.CGrID as varchar(200)) + ']' AND i.CGrID = d.CGrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10200001, ChID, 
          '[' + cast(d.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10200001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10200001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10200001, ChID, 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CGrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CGrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CGrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10200001 AND l.PKValue = 
          '[' + cast(d.CGrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10200001 AND l.PKValue = 
          '[' + cast(d.CGrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10200001, ChID, 
          '[' + cast(d.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10200001 AND PKValue IN (SELECT 
          '[' + cast(CGrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10200001 AND PKValue IN (SELECT 
          '[' + cast(CGrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10200001, ChID, 
          '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10200001, ChID, 
    '[' + cast(i.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompG', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompG] ON [r_CompG]
FOR DELETE AS
/* r_CompG - Справочник предприятий: группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompG ^ r_CompMG - Проверка в CHILD */
/* Справочник предприятий: группы ^ Справочник предприятий - Участие в группах - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CompMG a WITH(NOLOCK), deleted d WHERE a.CGrID = d.CGrID)
    BEGIN
      EXEC z_RelationError 'r_CompG', 'r_CompMG', 3
      RETURN
    END

/* r_CompG ^ z_UserCompG - Удаление в CHILD */
/* Справочник предприятий: группы ^ Доступные значения - Справочник предприятий: группы - Удаление в CHILD */
  DELETE z_UserCompG FROM z_UserCompG a, deleted d WHERE a.CGrID = d.CGrID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10200001 AND m.PKValue = 
    '[' + cast(i.CGrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10200001 AND m.PKValue = 
    '[' + cast(i.CGrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10200001, -ChID, 
    '[' + cast(d.CGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10200 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompG', N'Last', N'DELETE'
GO