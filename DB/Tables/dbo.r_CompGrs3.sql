CREATE TABLE [dbo].[r_CompGrs3]
(
[ChID] [bigint] NOT NULL,
[CompGrID3] [int] NOT NULL,
[CompGrName3] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompGrs3] ON [dbo].[r_CompGrs3]
FOR INSERT AS
/* r_CompGrs3 - Справочник предприятий: 3 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10197001, ChID, 
    '[' + cast(i.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CompGrs3]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompGrs3] ON [dbo].[r_CompGrs3]
FOR UPDATE AS
/* r_CompGrs3 - Справочник предприятий: 3 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompGrs3 ^ r_Comps - Обновление CHILD */
/* Справочник предприятий: 3 группа ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(CompGrID3)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompGrID3 = i.CompGrID3
          FROM r_Comps a, inserted i, deleted d WHERE a.CompGrID3 = d.CompGrID3
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.CompGrID3 = d.CompGrID3)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: 3 группа'' => ''Справочник предприятий''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10197001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10197001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CompGrID3))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10197001 AND l.PKValue = 
        '[' + cast(i.CompGrID3 as varchar(200)) + ']' AND i.CompGrID3 = d.CompGrID3
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10197001 AND l.PKValue = 
        '[' + cast(i.CompGrID3 as varchar(200)) + ']' AND i.CompGrID3 = d.CompGrID3
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10197001, ChID, 
          '[' + cast(d.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10197001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10197001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10197001, ChID, 
          '[' + cast(i.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CompGrID3)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID3 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID3 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID3 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10197001 AND l.PKValue = 
          '[' + cast(d.CompGrID3 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID3 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10197001 AND l.PKValue = 
          '[' + cast(d.CompGrID3 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10197001, ChID, 
          '[' + cast(d.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10197001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID3 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10197001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID3 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10197001, ChID, 
          '[' + cast(i.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10197001, ChID, 
    '[' + cast(i.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CompGrs3]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompGrs3] ON [dbo].[r_CompGrs3]
FOR DELETE AS
/* r_CompGrs3 - Справочник предприятий: 3 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompGrs3 ^ r_Comps - Проверка в CHILD */
/* Справочник предприятий: 3 группа ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.CompGrID3 = d.CompGrID3)
    BEGIN
      EXEC z_RelationError 'r_CompGrs3', 'r_Comps', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10197001 AND m.PKValue = 
    '[' + cast(i.CompGrID3 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10197001 AND m.PKValue = 
    '[' + cast(i.CompGrID3 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10197001, -ChID, 
    '[' + cast(d.CompGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10197 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CompGrs3]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CompGrs3] ADD CONSTRAINT [pk_r_CompGrs3] PRIMARY KEY CLUSTERED ([CompGrID3]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs3] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName3] ON [dbo].[r_CompGrs3] ([CompGrName3]) ON [PRIMARY]
GO
