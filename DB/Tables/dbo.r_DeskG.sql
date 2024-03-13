CREATE TABLE [dbo].[r_DeskG]
(
[ChID] [bigint] NOT NULL,
[DeskGCode] [int] NOT NULL,
[DeskGName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DeskG] ON [dbo].[r_DeskG]
FOR INSERT AS
/* r_DeskG - Справочник ресторана: столики: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10600001, ChID, 
    '[' + cast(i.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_DeskG]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DeskG] ON [dbo].[r_DeskG]
FOR UPDATE AS
/* r_DeskG - Справочник ресторана: столики: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DeskG ^ r_Desks - Обновление CHILD */
/* Справочник ресторана: столики: группы ^ Справочник ресторана: столики - Обновление CHILD */
  IF UPDATE(DeskGCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DeskGCode = i.DeskGCode
          FROM r_Desks a, inserted i, deleted d WHERE a.DeskGCode = d.DeskGCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Desks a, deleted d WHERE a.DeskGCode = d.DeskGCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресторана: столики: группы'' => ''Справочник ресторана: столики''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10600001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10600001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DeskGCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10600001 AND l.PKValue = 
        '[' + cast(i.DeskGCode as varchar(200)) + ']' AND i.DeskGCode = d.DeskGCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10600001 AND l.PKValue = 
        '[' + cast(i.DeskGCode as varchar(200)) + ']' AND i.DeskGCode = d.DeskGCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10600001, ChID, 
          '[' + cast(d.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10600001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10600001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10600001, ChID, 
          '[' + cast(i.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DeskGCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DeskGCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DeskGCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DeskGCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10600001 AND l.PKValue = 
          '[' + cast(d.DeskGCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DeskGCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10600001 AND l.PKValue = 
          '[' + cast(d.DeskGCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10600001, ChID, 
          '[' + cast(d.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10600001 AND PKValue IN (SELECT 
          '[' + cast(DeskGCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10600001 AND PKValue IN (SELECT 
          '[' + cast(DeskGCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10600001, ChID, 
          '[' + cast(i.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10600001, ChID, 
    '[' + cast(i.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_DeskG]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DeskG] ON [dbo].[r_DeskG]
FOR DELETE AS
/* r_DeskG - Справочник ресторана: столики: группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_DeskG ^ r_Desks - Проверка в CHILD */
/* Справочник ресторана: столики: группы ^ Справочник ресторана: столики - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Desks a WITH(NOLOCK), deleted d WHERE a.DeskGCode = d.DeskGCode)
    BEGIN
      EXEC z_RelationError 'r_DeskG', 'r_Desks', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10600001 AND m.PKValue = 
    '[' + cast(i.DeskGCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10600001 AND m.PKValue = 
    '[' + cast(i.DeskGCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10600001, -ChID, 
    '[' + cast(d.DeskGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10600 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_DeskG]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_DeskG] ADD CONSTRAINT [pk_r_DeskG] PRIMARY KEY CLUSTERED ([DeskGCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_DeskG] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DeskGName] ON [dbo].[r_DeskG] ([DeskGName]) ON [PRIMARY]
GO
