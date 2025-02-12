CREATE TABLE [dbo].[r_ScaleDefs] (
  [ChID] [bigint] NOT NULL,
  [ScaleDefID] [int] NOT NULL,
  [ScaleDefName] [varchar](200) NOT NULL,
  [ScaleType] [int] NOT NULL,
  [ScaleImageNum] [int] NOT NULL,
  [ScaleImageType] [bit] NOT NULL,
  [ScaleImage] [varchar](2000) NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_r_ScaleDefs] PRIMARY KEY CLUSTERED ([ScaleDefID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_ScaleDefs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ScaleDefName]
  ON [dbo].[r_ScaleDefs] ([ScaleDefName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ScaleDefs] ON [r_ScaleDefs]
FOR INSERT AS
/* r_ScaleDefs - Справочник весов: конфигурации - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10422001, ChID, 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ScaleDefs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ScaleDefs] ON [r_ScaleDefs]
FOR UPDATE AS
/* r_ScaleDefs - Справочник весов: конфигурации - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ScaleDefs ^ r_ScaleDefKeys - Обновление CHILD */
/* Справочник весов: конфигурации ^ Справочник весов: конфигурации - раскладки - Обновление CHILD */
  IF UPDATE(ScaleDefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ScaleDefID = i.ScaleDefID
          FROM r_ScaleDefKeys a, inserted i, deleted d WHERE a.ScaleDefID = d.ScaleDefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ScaleDefKeys a, deleted d WHERE a.ScaleDefID = d.ScaleDefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник весов: конфигурации'' => ''Справочник весов: конфигурации - раскладки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ScaleDefs ^ r_Scales - Обновление CHILD */
/* Справочник весов: конфигурации ^ Справочник весов - Обновление CHILD */
  IF UPDATE(ScaleDefID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ScaleDefID = i.ScaleDefID
          FROM r_Scales a, inserted i, deleted d WHERE a.ScaleDefID = d.ScaleDefID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Scales a, deleted d WHERE a.ScaleDefID = d.ScaleDefID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник весов: конфигурации'' => ''Справочник весов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10422001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10422001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ScaleDefID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10422001 AND l.PKValue = 
        '[' + cast(i.ScaleDefID as varchar(200)) + ']' AND i.ScaleDefID = d.ScaleDefID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10422001 AND l.PKValue = 
        '[' + cast(i.ScaleDefID as varchar(200)) + ']' AND i.ScaleDefID = d.ScaleDefID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10422001, ChID, 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10422001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10422001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10422001, ChID, 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ScaleDefID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleDefID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleDefID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10422001 AND l.PKValue = 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10422001 AND l.PKValue = 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10422001, ChID, 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10422001 AND PKValue IN (SELECT 
          '[' + cast(ScaleDefID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10422001 AND PKValue IN (SELECT 
          '[' + cast(ScaleDefID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10422001, ChID, 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10422001, ChID, 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ScaleDefs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ScaleDefs] ON [r_ScaleDefs]
FOR DELETE AS
/* r_ScaleDefs - Справочник весов: конфигурации - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ScaleDefs ^ r_ScaleDefKeys - Проверка в CHILD */
/* Справочник весов: конфигурации ^ Справочник весов: конфигурации - раскладки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ScaleDefKeys a WITH(NOLOCK), deleted d WHERE a.ScaleDefID = d.ScaleDefID)
    BEGIN
      EXEC z_RelationError 'r_ScaleDefs', 'r_ScaleDefKeys', 3
      RETURN
    END

/* r_ScaleDefs ^ r_Scales - Проверка в CHILD */
/* Справочник весов: конфигурации ^ Справочник весов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Scales a WITH(NOLOCK), deleted d WHERE a.ScaleDefID = d.ScaleDefID)
    BEGIN
      EXEC z_RelationError 'r_ScaleDefs', 'r_Scales', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10422001 AND m.PKValue = 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10422001 AND m.PKValue = 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10422001, -ChID, 
    '[' + cast(d.ScaleDefID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10422 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ScaleDefs', N'Last', N'DELETE'
GO