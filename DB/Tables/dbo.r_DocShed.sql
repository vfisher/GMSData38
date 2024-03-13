CREATE TABLE [dbo].[r_DocShed]
(
[ChID] [bigint] NOT NULL,
[DocShedCode] [int] NOT NULL,
[DocShedName] [varchar] (200) NOT NULL,
[ToolCode] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DocShed] ON [dbo].[r_DocShed]
FOR INSERT AS
/* r_DocShed - Шаблоны процессов: Заголовок - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DocShed ^ z_Tools - Проверка в PARENT */
/* Шаблоны процессов: Заголовок ^ Инструменты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ToolCode NOT IN (SELECT ToolCode FROM z_Tools))
    BEGIN
      EXEC z_RelationError 'z_Tools', 'r_DocShed', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 8020001, ChID, 
    '[' + cast(i.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_DocShed]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DocShed] ON [dbo].[r_DocShed]
FOR UPDATE AS
/* r_DocShed - Шаблоны процессов: Заголовок - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DocShed ^ z_Tools - Проверка в PARENT */
/* Шаблоны процессов: Заголовок ^ Инструменты - Проверка в PARENT */
  IF UPDATE(ToolCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ToolCode NOT IN (SELECT ToolCode FROM z_Tools))
      BEGIN
        EXEC z_RelationError 'z_Tools', 'r_DocShed', 1
        RETURN
      END

/* r_DocShed ^ r_DocShedD - Обновление CHILD */
/* Шаблоны процессов: Заголовок ^ Шаблоны процессов: Детали - Обновление CHILD */
  IF UPDATE(DocShedCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocShedCode = i.DocShedCode
          FROM r_DocShedD a, inserted i, deleted d WHERE a.DocShedCode = d.DocShedCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DocShedD a, deleted d WHERE a.DocShedCode = d.DocShedCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Шаблоны процессов: Заголовок'' => ''Шаблоны процессов: Детали''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_DocShed ^ z_DocShed - Обновление CHILD */
/* Шаблоны процессов: Заголовок ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 8020, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 8020 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 8020 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Шаблоны процессов: Заголовок'' => ''Документы - Процессы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 8020001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 8020001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DocShedCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 8020001 AND l.PKValue = 
        '[' + cast(i.DocShedCode as varchar(200)) + ']' AND i.DocShedCode = d.DocShedCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 8020001 AND l.PKValue = 
        '[' + cast(i.DocShedCode as varchar(200)) + ']' AND i.DocShedCode = d.DocShedCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 8020001, ChID, 
          '[' + cast(d.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 8020001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 8020001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 8020001, ChID, 
          '[' + cast(i.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DocShedCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DocShedCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DocShedCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DocShedCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 8020001 AND l.PKValue = 
          '[' + cast(d.DocShedCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DocShedCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 8020001 AND l.PKValue = 
          '[' + cast(d.DocShedCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 8020001, ChID, 
          '[' + cast(d.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 8020001 AND PKValue IN (SELECT 
          '[' + cast(DocShedCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 8020001 AND PKValue IN (SELECT 
          '[' + cast(DocShedCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 8020001, ChID, 
          '[' + cast(i.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 8020001, ChID, 
    '[' + cast(i.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_DocShed]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DocShed] ON [dbo].[r_DocShed]
FOR DELETE AS
/* r_DocShed - Шаблоны процессов: Заголовок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_DocShed ^ r_DocShedD - Удаление в CHILD */
/* Шаблоны процессов: Заголовок ^ Шаблоны процессов: Детали - Удаление в CHILD */
  DELETE r_DocShedD FROM r_DocShedD a, deleted d WHERE a.DocShedCode = d.DocShedCode
  IF @@ERROR > 0 RETURN

/* r_DocShed ^ z_DocShed - Удаление в CHILD */
/* Шаблоны процессов: Заголовок ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 8020 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 8020001 AND m.PKValue = 
    '[' + cast(i.DocShedCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 8020001 AND m.PKValue = 
    '[' + cast(i.DocShedCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 8020001, -ChID, 
    '[' + cast(d.DocShedCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 8020 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_DocShed]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_DocShed] ADD CONSTRAINT [pk_r_DocShed] PRIMARY KEY CLUSTERED ([DocShedCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocShedName] ON [dbo].[r_DocShed] ([DocShedName]) ON [PRIMARY]
GO
