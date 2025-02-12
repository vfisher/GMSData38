CREATE TABLE [dbo].[r_GOperC] (
  [ChID] [bigint] NOT NULL,
  [GOperCID] [smallint] NOT NULL,
  [GOperCName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_GOperC] PRIMARY KEY CLUSTERED ([GOperCID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_GOperC] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GOperCName]
  ON [dbo].[r_GOperC] ([GOperCName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOperC.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOperC.GOperCID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GOperC] ON [r_GOperC]
FOR INSERT AS
/* r_GOperC - Справочник проводок: категории - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10705001, ChID, 
    '[' + cast(i.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_GOperC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GOperC] ON [r_GOperC]
FOR UPDATE AS
/* r_GOperC - Справочник проводок: категории - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOperC ^ r_GOpers - Обновление CHILD */
/* Справочник проводок: категории ^ Справочник проводок - Обновление CHILD */
  IF UPDATE(GOperCID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperCID = i.GOperCID
          FROM r_GOpers a, inserted i, deleted d WHERE a.GOperCID = d.GOperCID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOpers a, deleted d WHERE a.GOperCID = d.GOperCID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: категории'' => ''Справочник проводок''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10705001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10705001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(GOperCID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10705001 AND l.PKValue = 
        '[' + cast(i.GOperCID as varchar(200)) + ']' AND i.GOperCID = d.GOperCID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10705001 AND l.PKValue = 
        '[' + cast(i.GOperCID as varchar(200)) + ']' AND i.GOperCID = d.GOperCID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10705001, ChID, 
          '[' + cast(d.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10705001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10705001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10705001, ChID, 
          '[' + cast(i.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(GOperCID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperCID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperCID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperCID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10705001 AND l.PKValue = 
          '[' + cast(d.GOperCID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperCID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10705001 AND l.PKValue = 
          '[' + cast(d.GOperCID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10705001, ChID, 
          '[' + cast(d.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10705001 AND PKValue IN (SELECT 
          '[' + cast(GOperCID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10705001 AND PKValue IN (SELECT 
          '[' + cast(GOperCID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10705001, ChID, 
          '[' + cast(i.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10705001, ChID, 
    '[' + cast(i.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_GOperC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GOperC] ON [r_GOperC]
FOR DELETE AS
/* r_GOperC - Справочник проводок: категории - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GOperC ^ r_GOpers - Проверка в CHILD */
/* Справочник проводок: категории ^ Справочник проводок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOpers a WITH(NOLOCK), deleted d WHERE a.GOperCID = d.GOperCID)
    BEGIN
      EXEC z_RelationError 'r_GOperC', 'r_GOpers', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10705001 AND m.PKValue = 
    '[' + cast(i.GOperCID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10705001 AND m.PKValue = 
    '[' + cast(i.GOperCID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10705001, -ChID, 
    '[' + cast(d.GOperCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10705 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_GOperC', N'Last', N'DELETE'
GO