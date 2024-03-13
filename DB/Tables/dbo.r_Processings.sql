CREATE TABLE [dbo].[r_Processings]
(
[ChID] [bigint] NOT NULL,
[ProcessingID] [int] NOT NULL,
[ProcessingName] [varchar] (250) NOT NULL,
[ProcessingType] [int] NULL DEFAULT (0),
[IP] [varchar] (250) NOT NULL,
[NetPort] [int] NOT NULL DEFAULT (0),
[Path] [varchar] (250) NULL,
[MaxDifference] [int] NOT NULL DEFAULT (0),
[Multiplicity] [int] NOT NULL DEFAULT (0),
[RetryTime] [datetime] NOT NULL DEFAULT (0),
[RetryPeriod] [int] NOT NULL DEFAULT (0),
[ExtraInfo] [varchar] (8000) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Processings] ON [dbo].[r_Processings]
FOR INSERT AS
/* r_Processings - Справочник процессинговых центров - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10459001, ChID, 
    '[' + cast(i.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Processings]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Processings] ON [dbo].[r_Processings]
FOR UPDATE AS
/* r_Processings - Справочник процессинговых центров - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Processings ^ r_WPRoles - Обновление CHILD */
/* Справочник процессинговых центров ^ Справочник рабочих мест: роли - Обновление CHILD */
  IF UPDATE(ProcessingID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProcessingID = i.ProcessingID
          FROM r_WPRoles a, inserted i, deleted d WHERE a.ProcessingID = d.ProcessingID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_WPRoles a, deleted d WHERE a.ProcessingID = d.ProcessingID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник процессинговых центров'' => ''Справочник рабочих мест: роли''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Processings ^ r_DCTypeG - Обновление CHILD */
/* Справочник процессинговых центров ^ Справочник дисконтных карт: группы типов - Обновление CHILD */
  IF UPDATE(ProcessingID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProcessingID = i.ProcessingID
          FROM r_DCTypeG a, inserted i, deleted d WHERE a.ProcessingID = d.ProcessingID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCTypeG a, deleted d WHERE a.ProcessingID = d.ProcessingID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник процессинговых центров'' => ''Справочник дисконтных карт: группы типов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Processings ^ z_LogProcessingExchange - Обновление CHILD */
/* Справочник процессинговых центров ^ Регистрация действий – Замена карт процессинга - Обновление CHILD */
  IF UPDATE(ProcessingID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProcessingID = i.ProcessingID
          FROM z_LogProcessingExchange a, inserted i, deleted d WHERE a.ProcessingID = d.ProcessingID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogProcessingExchange a, deleted d WHERE a.ProcessingID = d.ProcessingID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник процессинговых центров'' => ''Регистрация действий – Замена карт процессинга''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10459001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10459001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ProcessingID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10459001 AND l.PKValue = 
        '[' + cast(i.ProcessingID as varchar(200)) + ']' AND i.ProcessingID = d.ProcessingID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10459001 AND l.PKValue = 
        '[' + cast(i.ProcessingID as varchar(200)) + ']' AND i.ProcessingID = d.ProcessingID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10459001, ChID, 
          '[' + cast(d.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10459001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10459001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10459001, ChID, 
          '[' + cast(i.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ProcessingID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProcessingID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProcessingID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProcessingID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10459001 AND l.PKValue = 
          '[' + cast(d.ProcessingID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProcessingID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10459001 AND l.PKValue = 
          '[' + cast(d.ProcessingID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10459001, ChID, 
          '[' + cast(d.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10459001 AND PKValue IN (SELECT 
          '[' + cast(ProcessingID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10459001 AND PKValue IN (SELECT 
          '[' + cast(ProcessingID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10459001, ChID, 
          '[' + cast(i.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10459001, ChID, 
    '[' + cast(i.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Processings]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Processings] ON [dbo].[r_Processings]
FOR DELETE AS
/* r_Processings - Справочник процессинговых центров - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Processings ^ r_WPRoles - Проверка в CHILD */
/* Справочник процессинговых центров ^ Справочник рабочих мест: роли - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_WPRoles a WITH(NOLOCK), deleted d WHERE a.ProcessingID = d.ProcessingID)
    BEGIN
      EXEC z_RelationError 'r_Processings', 'r_WPRoles', 3
      RETURN
    END

/* r_Processings ^ r_DCTypeG - Проверка в CHILD */
/* Справочник процессинговых центров ^ Справочник дисконтных карт: группы типов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DCTypeG a WITH(NOLOCK), deleted d WHERE a.ProcessingID = d.ProcessingID)
    BEGIN
      EXEC z_RelationError 'r_Processings', 'r_DCTypeG', 3
      RETURN
    END

/* r_Processings ^ z_LogProcessingExchange - Удаление в CHILD */
/* Справочник процессинговых центров ^ Регистрация действий – Замена карт процессинга - Удаление в CHILD */
  DELETE z_LogProcessingExchange FROM z_LogProcessingExchange a, deleted d WHERE a.ProcessingID = d.ProcessingID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10459001 AND m.PKValue = 
    '[' + cast(i.ProcessingID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10459001 AND m.PKValue = 
    '[' + cast(i.ProcessingID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10459001, -ChID, 
    '[' + cast(d.ProcessingID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10459 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Processings]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Processings] ADD CONSTRAINT [pk_r_Processings] PRIMARY KEY CLUSTERED ([ProcessingID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Processings] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProcessingName] ON [dbo].[r_Processings] ([ProcessingName]) ON [PRIMARY]
GO
