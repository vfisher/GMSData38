CREATE TABLE [dbo].[r_CarrsC]
(
[ChID] [bigint] NOT NULL,
[CarrCID] [smallint] NOT NULL,
[CarrCName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CarrsC] ON [dbo].[r_CarrsC]
FOR INSERT AS
/* r_CarrsC - Справочник транспорта: категории - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10714001, ChID, 
    '[' + cast(i.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_CarrsC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CarrsC] ON [dbo].[r_CarrsC]
FOR UPDATE AS
/* r_CarrsC - Справочник транспорта: категории - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CarrsC ^ r_Carrs - Обновление CHILD */
/* Справочник транспорта: категории ^ Справочник транспорта - Обновление CHILD */
  IF UPDATE(CarrCID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CarrCID = i.CarrCID
          FROM r_Carrs a, inserted i, deleted d WHERE a.CarrCID = d.CarrCID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Carrs a, deleted d WHERE a.CarrCID = d.CarrCID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник транспорта: категории'' => ''Справочник транспорта''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10714001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10714001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CarrCID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10714001 AND l.PKValue = 
        '[' + cast(i.CarrCID as varchar(200)) + ']' AND i.CarrCID = d.CarrCID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10714001 AND l.PKValue = 
        '[' + cast(i.CarrCID as varchar(200)) + ']' AND i.CarrCID = d.CarrCID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10714001, ChID, 
          '[' + cast(d.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10714001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10714001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10714001, ChID, 
          '[' + cast(i.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CarrCID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CarrCID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CarrCID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CarrCID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10714001 AND l.PKValue = 
          '[' + cast(d.CarrCID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CarrCID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10714001 AND l.PKValue = 
          '[' + cast(d.CarrCID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10714001, ChID, 
          '[' + cast(d.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10714001 AND PKValue IN (SELECT 
          '[' + cast(CarrCID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10714001 AND PKValue IN (SELECT 
          '[' + cast(CarrCID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10714001, ChID, 
          '[' + cast(i.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10714001, ChID, 
    '[' + cast(i.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_CarrsC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CarrsC] ON [dbo].[r_CarrsC]
FOR DELETE AS
/* r_CarrsC - Справочник транспорта: категории - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CarrsC ^ r_Carrs - Проверка в CHILD */
/* Справочник транспорта: категории ^ Справочник транспорта - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Carrs a WITH(NOLOCK), deleted d WHERE a.CarrCID = d.CarrCID)
    BEGIN
      EXEC z_RelationError 'r_CarrsC', 'r_Carrs', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10714001 AND m.PKValue = 
    '[' + cast(i.CarrCID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10714001 AND m.PKValue = 
    '[' + cast(i.CarrCID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10714001, -ChID, 
    '[' + cast(d.CarrCID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10714 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_CarrsC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_CarrsC] ADD CONSTRAINT [pk_r_CarrsC] PRIMARY KEY CLUSTERED ([CarrCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CarrCName] ON [dbo].[r_CarrsC] ([CarrCName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_CarrsC] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CarrsC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CarrsC].[CarrCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CarrsC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CarrsC].[CarrCID]'
GO
