CREATE TABLE [dbo].[r_ScaleDefKeys]
(
[ScaleDefID] [int] NOT NULL,
[ScaleKey] [int] NOT NULL,
[BarCode] [varchar] (42) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ScaleDefKeys] ON [dbo].[r_ScaleDefKeys]
FOR INSERT AS
/* r_ScaleDefKeys - Справочник весов: конфигурации - раскладки - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ScaleDefKeys ^ r_ScaleDefs - Проверка в PARENT */
/* Справочник весов: конфигурации - раскладки ^ Справочник весов: конфигурации - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleDefID NOT IN (SELECT ScaleDefID FROM r_ScaleDefs))
    BEGIN
      EXEC z_RelationError 'r_ScaleDefs', 'r_ScaleDefKeys', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10422002, m.ChID, 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ScaleKey as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_ScaleDefs m ON m.ScaleDefID = i.ScaleDefID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ScaleDefKeys]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ScaleDefKeys] ON [dbo].[r_ScaleDefKeys]
FOR UPDATE AS
/* r_ScaleDefKeys - Справочник весов: конфигурации - раскладки - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ScaleDefKeys ^ r_ScaleDefs - Проверка в PARENT */
/* Справочник весов: конфигурации - раскладки ^ Справочник весов: конфигурации - Проверка в PARENT */
  IF UPDATE(ScaleDefID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleDefID NOT IN (SELECT ScaleDefID FROM r_ScaleDefs))
      BEGIN
        EXEC z_RelationError 'r_ScaleDefs', 'r_ScaleDefKeys', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ScaleDefID) OR UPDATE(ScaleKey)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleDefID, ScaleKey FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleDefID, ScaleKey FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ScaleKey as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10422002 AND l.PKValue = 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ScaleKey as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ScaleKey as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10422002 AND l.PKValue = 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ScaleKey as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10422002, m.ChID, 
          '[' + cast(d.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ScaleKey as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_ScaleDefs m ON m.ScaleDefID = d.ScaleDefID
          DELETE FROM z_LogCreate WHERE TableCode = 10422002 AND PKValue IN (SELECT 
          '[' + cast(ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ScaleKey as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10422002 AND PKValue IN (SELECT 
          '[' + cast(ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ScaleKey as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10422002, m.ChID, 
          '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ScaleKey as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_ScaleDefs m ON m.ScaleDefID = i.ScaleDefID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10422002, m.ChID, 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ScaleKey as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_ScaleDefs m ON m.ScaleDefID = i.ScaleDefID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ScaleDefKeys]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ScaleDefKeys] ON [dbo].[r_ScaleDefKeys]
FOR DELETE AS
/* r_ScaleDefKeys - Справочник весов: конфигурации - раскладки - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10422002 AND m.PKValue = 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ScaleKey as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10422002 AND m.PKValue = 
    '[' + cast(i.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ScaleKey as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10422002, m.ChID, 
    '[' + cast(d.ScaleDefID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ScaleKey as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_ScaleDefs m ON m.ScaleDefID = d.ScaleDefID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ScaleDefKeys]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ScaleDefKeys] ADD CONSTRAINT [pk_r_ScaleDefKeys] PRIMARY KEY CLUSTERED ([ScaleDefID], [ScaleKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ScaleKey] ON [dbo].[r_ScaleDefKeys] ([ScaleKey]) ON [PRIMARY]
GO
