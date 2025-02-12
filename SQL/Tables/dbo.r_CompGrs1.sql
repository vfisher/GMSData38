CREATE TABLE [dbo].[r_CompGrs1] (
  [ChID] [bigint] NOT NULL,
  [CompGrID1] [int] NOT NULL,
  [CompGrName1] [varchar](250) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_CompGrs1] PRIMARY KEY CLUSTERED ([CompGrID1])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_CompGrs1] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CompGrName1]
  ON [dbo].[r_CompGrs1] ([CompGrName1])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompGrs1] ON [r_CompGrs1]
FOR INSERT AS
/* r_CompGrs1 - Справочник предприятий: 1 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10195001, ChID, 
    '[' + cast(i.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompGrs1', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompGrs1] ON [r_CompGrs1]
FOR UPDATE AS
/* r_CompGrs1 - Справочник предприятий: 1 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompGrs1 ^ r_Comps - Обновление CHILD */
/* Справочник предприятий: 1 группа ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(CompGrID1)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompGrID1 = i.CompGrID1
          FROM r_Comps a, inserted i, deleted d WHERE a.CompGrID1 = d.CompGrID1
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.CompGrID1 = d.CompGrID1)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: 1 группа'' => ''Справочник предприятий''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10195001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10195001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CompGrID1))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10195001 AND l.PKValue = 
        '[' + cast(i.CompGrID1 as varchar(200)) + ']' AND i.CompGrID1 = d.CompGrID1
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10195001 AND l.PKValue = 
        '[' + cast(i.CompGrID1 as varchar(200)) + ']' AND i.CompGrID1 = d.CompGrID1
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10195001, ChID, 
          '[' + cast(d.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10195001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10195001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10195001, ChID, 
          '[' + cast(i.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CompGrID1)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID1 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID1 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID1 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10195001 AND l.PKValue = 
          '[' + cast(d.CompGrID1 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID1 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10195001 AND l.PKValue = 
          '[' + cast(d.CompGrID1 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10195001, ChID, 
          '[' + cast(d.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10195001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID1 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10195001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID1 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10195001, ChID, 
          '[' + cast(i.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10195001, ChID, 
    '[' + cast(i.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompGrs1', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompGrs1] ON [r_CompGrs1]
FOR DELETE AS
/* r_CompGrs1 - Справочник предприятий: 1 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompGrs1 ^ r_Comps - Проверка в CHILD */
/* Справочник предприятий: 1 группа ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.CompGrID1 = d.CompGrID1)
    BEGIN
      EXEC z_RelationError 'r_CompGrs1', 'r_Comps', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10195001 AND m.PKValue = 
    '[' + cast(i.CompGrID1 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10195001 AND m.PKValue = 
    '[' + cast(i.CompGrID1 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10195001, -ChID, 
    '[' + cast(d.CompGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10195 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompGrs1', N'Last', N'DELETE'
GO