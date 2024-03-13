CREATE TABLE [dbo].[r_AssetC]
(
[ChID] [bigint] NOT NULL,
[ACatID] [int] NOT NULL,
[ACatName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_AssetC] ON [dbo].[r_AssetC]
FOR INSERT AS
/* r_AssetC - Справочник основных средств: категории - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10702001, ChID, 
    '[' + cast(i.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_AssetC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_AssetC] ON [dbo].[r_AssetC]
FOR UPDATE AS
/* r_AssetC - Справочник основных средств: категории - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_AssetC ^ r_AssetH - Обновление CHILD */
/* Справочник основных средств: категории ^ Справочник основных средств: История - Обновление CHILD */
  IF UPDATE(ACatID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ACatID = i.ACatID
          FROM r_AssetH a, inserted i, deleted d WHERE a.ACatID = d.ACatID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetH a, deleted d WHERE a.ACatID = d.ACatID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник основных средств: категории'' => ''Справочник основных средств: История''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10702001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10702001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ACatID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10702001 AND l.PKValue = 
        '[' + cast(i.ACatID as varchar(200)) + ']' AND i.ACatID = d.ACatID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10702001 AND l.PKValue = 
        '[' + cast(i.ACatID as varchar(200)) + ']' AND i.ACatID = d.ACatID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10702001, ChID, 
          '[' + cast(d.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10702001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10702001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10702001, ChID, 
          '[' + cast(i.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ACatID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ACatID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ACatID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ACatID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10702001 AND l.PKValue = 
          '[' + cast(d.ACatID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ACatID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10702001 AND l.PKValue = 
          '[' + cast(d.ACatID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10702001, ChID, 
          '[' + cast(d.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10702001 AND PKValue IN (SELECT 
          '[' + cast(ACatID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10702001 AND PKValue IN (SELECT 
          '[' + cast(ACatID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10702001, ChID, 
          '[' + cast(i.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10702001, ChID, 
    '[' + cast(i.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_AssetC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_AssetC] ON [dbo].[r_AssetC]
FOR DELETE AS
/* r_AssetC - Справочник основных средств: категории - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_AssetC ^ r_AssetH - Проверка в CHILD */
/* Справочник основных средств: категории ^ Справочник основных средств: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetH a WITH(NOLOCK), deleted d WHERE a.ACatID = d.ACatID)
    BEGIN
      EXEC z_RelationError 'r_AssetC', 'r_AssetH', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10702001 AND m.PKValue = 
    '[' + cast(i.ACatID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10702001 AND m.PKValue = 
    '[' + cast(i.ACatID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10702001, -ChID, 
    '[' + cast(d.ACatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10702 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_AssetC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_AssetC] ADD CONSTRAINT [pk_r_AssetC] PRIMARY KEY CLUSTERED ([ACatID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ACatName] ON [dbo].[r_AssetC] ([ACatName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_AssetC] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetC].[ACatID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_AssetC].[ACatID]'
GO
