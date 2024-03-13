CREATE TABLE [dbo].[r_UniTypes]
(
[ChID] [bigint] NOT NULL,
[RefTypeID] [int] NOT NULL,
[RefTypeName] [varchar] (250) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_UniTypes] ON [dbo].[r_UniTypes]
FOR INSERT AS
/* r_UniTypes - Справочник универсальный: типы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10010001, ChID, 
    '[' + cast(i.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_UniTypes]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_UniTypes] ON [dbo].[r_UniTypes]
FOR UPDATE AS
/* r_UniTypes - Справочник универсальный: типы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_UniTypes ^ r_Uni - Обновление CHILD */
/* Справочник универсальный: типы ^ Справочник универсальный - Обновление CHILD */
  IF UPDATE(RefTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.RefTypeID = i.RefTypeID
          FROM r_Uni a, inserted i, deleted d WHERE a.RefTypeID = d.RefTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Uni a, deleted d WHERE a.RefTypeID = d.RefTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник универсальный: типы'' => ''Справочник универсальный''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10010001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10010001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(RefTypeID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10010001 AND l.PKValue = 
        '[' + cast(i.RefTypeID as varchar(200)) + ']' AND i.RefTypeID = d.RefTypeID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10010001 AND l.PKValue = 
        '[' + cast(i.RefTypeID as varchar(200)) + ']' AND i.RefTypeID = d.RefTypeID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10010001, ChID, 
          '[' + cast(d.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10010001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10010001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10010001, ChID, 
          '[' + cast(i.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(RefTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT RefTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT RefTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.RefTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10010001 AND l.PKValue = 
          '[' + cast(d.RefTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.RefTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10010001 AND l.PKValue = 
          '[' + cast(d.RefTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10010001, ChID, 
          '[' + cast(d.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10010001 AND PKValue IN (SELECT 
          '[' + cast(RefTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10010001 AND PKValue IN (SELECT 
          '[' + cast(RefTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10010001, ChID, 
          '[' + cast(i.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10010001, ChID, 
    '[' + cast(i.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_UniTypes]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_UniTypes] ON [dbo].[r_UniTypes]
FOR DELETE AS
/* r_UniTypes - Справочник универсальный: типы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_UniTypes ^ r_Uni - Удаление в CHILD */
/* Справочник универсальный: типы ^ Справочник универсальный - Удаление в CHILD */
  DELETE r_Uni FROM r_Uni a, deleted d WHERE a.RefTypeID = d.RefTypeID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10010001 AND m.PKValue = 
    '[' + cast(i.RefTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10010001 AND m.PKValue = 
    '[' + cast(i.RefTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10010001, -ChID, 
    '[' + cast(d.RefTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10010 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_UniTypes]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_UniTypes] ADD CONSTRAINT [pk_r_UniTypes] PRIMARY KEY CLUSTERED ([RefTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_UniTypes] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [RefTypeName] ON [dbo].[r_UniTypes] ([RefTypeName]) ON [PRIMARY]
GO
