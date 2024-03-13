CREATE TABLE [dbo].[b_GOperDocs]
(
[ChID] [bigint] NOT NULL,
[GOperID] [int] NOT NULL,
[GTAccID] [int] NOT NULL,
[GTaxAccID] [int] NOT NULL,
[DSCode] [int] NOT NULL DEFAULT (0),
[Priority] [int] NOT NULL DEFAULT (1),
[GTAdvAccID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_GOperDocs] ON [dbo].[b_GOperDocs]
FOR INSERT AS
/* b_GOperDocs - Проводки для документов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GOperDocs ^ r_GAccs - Проверка в PARENT */
/* Проводки для документов ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 0
      RETURN
    END

/* b_GOperDocs ^ r_GAccs - Проверка в PARENT */
/* Проводки для документов ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTAdvAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 0
      RETURN
    END

/* b_GOperDocs ^ r_GAccs - Проверка в PARENT */
/* Проводки для документов ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GTaxAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 0
      RETURN
    END

/* b_GOperDocs ^ r_GOpers - Проверка в PARENT */
/* Проводки для документов ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_GOperDocs', 0
      RETURN
    END

/* b_GOperDocs ^ z_DataSets - Проверка в PARENT */
/* Проводки для документов ^ Источники данных - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DSCode NOT IN (SELECT DSCode FROM z_DataSets))
    BEGIN
      EXEC z_RelationError 'z_DataSets', 'b_GOperDocs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14920001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_GOperDocs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_GOperDocs] ON [dbo].[b_GOperDocs]
FOR UPDATE AS
/* b_GOperDocs - Проводки для документов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_GOperDocs ^ r_GAccs - Проверка в PARENT */
/* Проводки для документов ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 1
        RETURN
      END

/* b_GOperDocs ^ r_GAccs - Проверка в PARENT */
/* Проводки для документов ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTAdvAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTAdvAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 1
        RETURN
      END

/* b_GOperDocs ^ r_GAccs - Проверка в PARENT */
/* Проводки для документов ^ План счетов - Проверка в PARENT */
  IF UPDATE(GTaxAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GTaxAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_GOperDocs', 1
        RETURN
      END

/* b_GOperDocs ^ r_GOpers - Проверка в PARENT */
/* Проводки для документов ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_GOperDocs', 1
        RETURN
      END

/* b_GOperDocs ^ z_DataSets - Проверка в PARENT */
/* Проводки для документов ^ Источники данных - Проверка в PARENT */
  IF UPDATE(DSCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DSCode NOT IN (SELECT DSCode FROM z_DataSets))
      BEGIN
        EXEC z_RelationError 'z_DataSets', 'b_GOperDocs', 1
        RETURN
      END

/* b_GOperDocs ^ z_DocShed - Обновление CHILD */
/* Проводки для документов ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14920, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14920 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14920 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Проводки для документов'' => ''Документы - Процессы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14920001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14920001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14920001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14920001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14920001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14920001, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14920001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14920001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14920001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_GOperDocs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_GOperDocs] ON [dbo].[b_GOperDocs]
FOR DELETE AS
/* b_GOperDocs - Проводки для документов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* b_GOperDocs ^ z_DocShed - Удаление в CHILD */
/* Проводки для документов ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14920 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14920001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14920001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14920001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14920 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_GOperDocs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_GOperDocs] ADD CONSTRAINT [_pk_b_MapDO] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_GOperDocs] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTAccID] ON [dbo].[b_GOperDocs] ([GTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTaxAccID] ON [dbo].[b_GOperDocs] ([GTaxAccID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GTAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GTaxAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GTAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GOperDocs].[GTaxAccID]'
GO
