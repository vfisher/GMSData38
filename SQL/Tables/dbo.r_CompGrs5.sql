CREATE TABLE [dbo].[r_CompGrs5] (
  [ChID] [bigint] NOT NULL,
  [CompGrID5] [int] NOT NULL,
  [CompGrName5] [varchar](250) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_CompGrs5] PRIMARY KEY CLUSTERED ([CompGrID5])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_CompGrs5] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CompGrName5]
  ON [dbo].[r_CompGrs5] ([CompGrName5])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompGrs5] ON [r_CompGrs5]
FOR INSERT AS
/* r_CompGrs5 - Справочник предприятий: 5 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10199001, ChID, 
    '[' + cast(i.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompGrs5', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompGrs5] ON [r_CompGrs5]
FOR UPDATE AS
/* r_CompGrs5 - Справочник предприятий: 5 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompGrs5 ^ r_Comps - Обновление CHILD */
/* Справочник предприятий: 5 группа ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(CompGrID5)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompGrID5 = i.CompGrID5
          FROM r_Comps a, inserted i, deleted d WHERE a.CompGrID5 = d.CompGrID5
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.CompGrID5 = d.CompGrID5)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: 5 группа'' => ''Справочник предприятий''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10199001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10199001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CompGrID5))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10199001 AND l.PKValue = 
        '[' + cast(i.CompGrID5 as varchar(200)) + ']' AND i.CompGrID5 = d.CompGrID5
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10199001 AND l.PKValue = 
        '[' + cast(i.CompGrID5 as varchar(200)) + ']' AND i.CompGrID5 = d.CompGrID5
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10199001, ChID, 
          '[' + cast(d.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10199001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10199001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10199001, ChID, 
          '[' + cast(i.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CompGrID5)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID5 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID5 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID5 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10199001 AND l.PKValue = 
          '[' + cast(d.CompGrID5 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID5 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10199001 AND l.PKValue = 
          '[' + cast(d.CompGrID5 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10199001, ChID, 
          '[' + cast(d.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10199001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID5 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10199001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID5 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10199001, ChID, 
          '[' + cast(i.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10199001, ChID, 
    '[' + cast(i.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompGrs5', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompGrs5] ON [r_CompGrs5]
FOR DELETE AS
/* r_CompGrs5 - Справочник предприятий: 5 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompGrs5 ^ r_Comps - Проверка в CHILD */
/* Справочник предприятий: 5 группа ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.CompGrID5 = d.CompGrID5)
    BEGIN
      EXEC z_RelationError 'r_CompGrs5', 'r_Comps', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10199001 AND m.PKValue = 
    '[' + cast(i.CompGrID5 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10199001 AND m.PKValue = 
    '[' + cast(i.CompGrID5 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10199001, -ChID, 
    '[' + cast(d.CompGrID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10199 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompGrs5', N'Last', N'DELETE'
GO