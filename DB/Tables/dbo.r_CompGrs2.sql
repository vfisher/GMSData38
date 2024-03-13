CREATE TABLE [dbo].[r_CompGrs2]
(
[ChID] [bigint] NOT NULL,
[CompGrID2] [int] NOT NULL,
[CompGrName2] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompGrs2] ON [dbo].[r_CompGrs2]
FOR INSERT AS
/* r_CompGrs2 - Справочник предприятий: 2 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10196001, ChID, 
    '[' + cast(i.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CompGrs2]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompGrs2] ON [dbo].[r_CompGrs2]
FOR UPDATE AS
/* r_CompGrs2 - Справочник предприятий: 2 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompGrs2 ^ r_Comps - Обновление CHILD */
/* Справочник предприятий: 2 группа ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(CompGrID2)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompGrID2 = i.CompGrID2
          FROM r_Comps a, inserted i, deleted d WHERE a.CompGrID2 = d.CompGrID2
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.CompGrID2 = d.CompGrID2)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий: 2 группа'' => ''Справочник предприятий''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10196001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10196001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CompGrID2))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10196001 AND l.PKValue = 
        '[' + cast(i.CompGrID2 as varchar(200)) + ']' AND i.CompGrID2 = d.CompGrID2
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10196001 AND l.PKValue = 
        '[' + cast(i.CompGrID2 as varchar(200)) + ']' AND i.CompGrID2 = d.CompGrID2
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10196001, ChID, 
          '[' + cast(d.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10196001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10196001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10196001, ChID, 
          '[' + cast(i.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CompGrID2)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID2 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompGrID2 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID2 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10196001 AND l.PKValue = 
          '[' + cast(d.CompGrID2 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompGrID2 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10196001 AND l.PKValue = 
          '[' + cast(d.CompGrID2 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10196001, ChID, 
          '[' + cast(d.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10196001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID2 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10196001 AND PKValue IN (SELECT 
          '[' + cast(CompGrID2 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10196001, ChID, 
          '[' + cast(i.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10196001, ChID, 
    '[' + cast(i.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CompGrs2]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompGrs2] ON [dbo].[r_CompGrs2]
FOR DELETE AS
/* r_CompGrs2 - Справочник предприятий: 2 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompGrs2 ^ r_Comps - Проверка в CHILD */
/* Справочник предприятий: 2 группа ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.CompGrID2 = d.CompGrID2)
    BEGIN
      EXEC z_RelationError 'r_CompGrs2', 'r_Comps', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10196001 AND m.PKValue = 
    '[' + cast(i.CompGrID2 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10196001 AND m.PKValue = 
    '[' + cast(i.CompGrID2 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10196001, -ChID, 
    '[' + cast(d.CompGrID2 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10196 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CompGrs2]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CompGrs2] ADD CONSTRAINT [pk_r_CompGrs2] PRIMARY KEY CLUSTERED ([CompGrID2]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CompGrs2] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CompGrName2] ON [dbo].[r_CompGrs2] ([CompGrName2]) ON [PRIMARY]
GO
