CREATE TABLE [dbo].[r_DCTypeG] (
  [ChID] [bigint] NOT NULL,
  [DCTypeGCode] [int] NOT NULL,
  [DCTypeGName] [varchar](250) NOT NULL,
  [Notes] [varchar](250) NULL,
  [MainDialog] [bit] NOT NULL,
  [CloseDialogAfterEnter] [bit] NOT NULL,
  [ProcessingID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_DCTypeG] PRIMARY KEY CLUSTERED ([DCTypeGCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DCTypeGName]
  ON [dbo].[r_DCTypeG] ([DCTypeGName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[r_DCTypeG] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DCTypeG] ON [r_DCTypeG]
FOR INSERT AS
/* r_DCTypeG - Справочник дисконтных карт: группы типов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCTypeG ^ r_Processings - Проверка в PARENT */
/* Справочник дисконтных карт: группы типов ^ Справочник процессинговых центров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProcessingID NOT IN (SELECT ProcessingID FROM r_Processings))
    BEGIN
      EXEC z_RelationError 'r_Processings', 'r_DCTypeG', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10391001, ChID, 
    '[' + cast(i.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DCTypeG', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DCTypeG] ON [r_DCTypeG]
FOR UPDATE AS
/* r_DCTypeG - Справочник дисконтных карт: группы типов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCTypeG ^ r_Processings - Проверка в PARENT */
/* Справочник дисконтных карт: группы типов ^ Справочник процессинговых центров - Проверка в PARENT */
  IF UPDATE(ProcessingID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProcessingID NOT IN (SELECT ProcessingID FROM r_Processings))
      BEGIN
        EXEC z_RelationError 'r_Processings', 'r_DCTypeG', 1
        RETURN
      END

/* r_DCTypeG ^ r_PayForms - Обновление CHILD */
/* Справочник дисконтных карт: группы типов ^ Справочник форм оплаты - Обновление CHILD */
  IF UPDATE(DCTypeGCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DCTypeGCode = i.DCTypeGCode
          FROM r_PayForms a, inserted i, deleted d WHERE a.DCTypeGCode = d.DCTypeGCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PayForms a, deleted d WHERE a.DCTypeGCode = d.DCTypeGCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник дисконтных карт: группы типов'' => ''Справочник форм оплаты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_DCTypeG ^ r_DCTypes - Обновление CHILD */
/* Справочник дисконтных карт: группы типов ^ Справочник дисконтных карт: типы - Обновление CHILD */
  IF UPDATE(DCTypeGCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DCTypeGCode = i.DCTypeGCode
          FROM r_DCTypes a, inserted i, deleted d WHERE a.DCTypeGCode = d.DCTypeGCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCTypes a, deleted d WHERE a.DCTypeGCode = d.DCTypeGCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник дисконтных карт: группы типов'' => ''Справочник дисконтных карт: типы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10391001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10391001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DCTypeGCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10391001 AND l.PKValue = 
        '[' + cast(i.DCTypeGCode as varchar(200)) + ']' AND i.DCTypeGCode = d.DCTypeGCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10391001 AND l.PKValue = 
        '[' + cast(i.DCTypeGCode as varchar(200)) + ']' AND i.DCTypeGCode = d.DCTypeGCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10391001, ChID, 
          '[' + cast(d.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10391001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10391001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10391001, ChID, 
          '[' + cast(i.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DCTypeGCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DCTypeGCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DCTypeGCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DCTypeGCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10391001 AND l.PKValue = 
          '[' + cast(d.DCTypeGCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DCTypeGCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10391001 AND l.PKValue = 
          '[' + cast(d.DCTypeGCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10391001, ChID, 
          '[' + cast(d.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10391001 AND PKValue IN (SELECT 
          '[' + cast(DCTypeGCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10391001 AND PKValue IN (SELECT 
          '[' + cast(DCTypeGCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10391001, ChID, 
          '[' + cast(i.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10391001, ChID, 
    '[' + cast(i.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DCTypeG', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DCTypeG] ON [r_DCTypeG]
FOR DELETE AS
/* r_DCTypeG - Справочник дисконтных карт: группы типов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_DCTypeG ^ r_PayForms - Проверка в CHILD */
/* Справочник дисконтных карт: группы типов ^ Справочник форм оплаты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PayForms a WITH(NOLOCK), deleted d WHERE a.DCTypeGCode = d.DCTypeGCode)
    BEGIN
      EXEC z_RelationError 'r_DCTypeG', 'r_PayForms', 3
      RETURN
    END

/* r_DCTypeG ^ r_DCTypes - Проверка в CHILD */
/* Справочник дисконтных карт: группы типов ^ Справочник дисконтных карт: типы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DCTypes a WITH(NOLOCK), deleted d WHERE a.DCTypeGCode = d.DCTypeGCode)
    BEGIN
      EXEC z_RelationError 'r_DCTypeG', 'r_DCTypes', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10391001 AND m.PKValue = 
    '[' + cast(i.DCTypeGCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10391001 AND m.PKValue = 
    '[' + cast(i.DCTypeGCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10391001, -ChID, 
    '[' + cast(d.DCTypeGCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10391 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_DCTypeG', N'Last', N'DELETE'
GO