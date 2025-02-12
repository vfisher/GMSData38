CREATE TABLE [dbo].[r_PCs] (
  [ChID] [bigint] NOT NULL,
  [PCCode] [int] NOT NULL,
  [PCName] [varchar](200) NOT NULL,
  [Host] [varchar](250) NULL,
  [Notes] [varchar](200) NULL,
  [Email] [varchar](250) NULL,
  [SyncBy] [int] NULL DEFAULT (0),
  [UseRAS] [bit] NOT NULL DEFAULT (0),
  [RASConnection] [varchar](250) NULL,
  [NetPort] [int] NULL,
  CONSTRAINT [pk_r_PCs] PRIMARY KEY CLUSTERED ([PCCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_PCs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PCName]
  ON [dbo].[r_PCs] ([PCName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PCs] ON [r_PCs]
FOR INSERT AS
/* r_PCs - Справочник компьютеров - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10130001, ChID, 
    '[' + cast(i.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_PCs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PCs] ON [r_PCs]
FOR UPDATE AS
/* r_PCs - Справочник компьютеров - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PCs ^ r_DBIs - Обновление CHILD */
/* Справочник компьютеров ^ Справочник баз данных - Обновление CHILD */
  IF UPDATE(PCCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCCode = i.PCCode
          FROM r_DBIs a, inserted i, deleted d WHERE a.PCCode = d.PCCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DBIs a, deleted d WHERE a.PCCode = d.PCCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник компьютеров'' => ''Справочник баз данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PCs ^ z_ReplicaSubs - Обновление CHILD */
/* Справочник компьютеров ^ Объекты репликации: Подписки - Обновление CHILD */
  IF UPDATE(PCCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PublisherCode = i.PCCode
          FROM z_ReplicaSubs a, inserted i, deleted d WHERE a.PublisherCode = d.PCCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_ReplicaSubs a, deleted d WHERE a.PublisherCode = d.PCCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник компьютеров'' => ''Объекты репликации: Подписки''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10130001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10130001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PCCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10130001 AND l.PKValue = 
        '[' + cast(i.PCCode as varchar(200)) + ']' AND i.PCCode = d.PCCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10130001 AND l.PKValue = 
        '[' + cast(i.PCCode as varchar(200)) + ']' AND i.PCCode = d.PCCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10130001, ChID, 
          '[' + cast(d.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10130001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10130001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10130001, ChID, 
          '[' + cast(i.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PCCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PCCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PCCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PCCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10130001 AND l.PKValue = 
          '[' + cast(d.PCCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PCCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10130001 AND l.PKValue = 
          '[' + cast(d.PCCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10130001, ChID, 
          '[' + cast(d.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10130001 AND PKValue IN (SELECT 
          '[' + cast(PCCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10130001 AND PKValue IN (SELECT 
          '[' + cast(PCCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10130001, ChID, 
          '[' + cast(i.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10130001, ChID, 
    '[' + cast(i.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_PCs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PCs] ON [r_PCs]
FOR DELETE AS
/* r_PCs - Справочник компьютеров - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PCs ^ r_DBIs - Проверка в CHILD */
/* Справочник компьютеров ^ Справочник баз данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DBIs a WITH(NOLOCK), deleted d WHERE a.PCCode = d.PCCode)
    BEGIN
      EXEC z_RelationError 'r_PCs', 'r_DBIs', 3
      RETURN
    END

/* r_PCs ^ z_ReplicaSubs - Проверка в CHILD */
/* Справочник компьютеров ^ Объекты репликации: Подписки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_ReplicaSubs a WITH(NOLOCK), deleted d WHERE a.PublisherCode = d.PCCode)
    BEGIN
      EXEC z_RelationError 'r_PCs', 'z_ReplicaSubs', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10130001 AND m.PKValue = 
    '[' + cast(i.PCCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10130001 AND m.PKValue = 
    '[' + cast(i.PCCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10130001, -ChID, 
    '[' + cast(d.PCCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10130 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_PCs', N'Last', N'DELETE'
GO