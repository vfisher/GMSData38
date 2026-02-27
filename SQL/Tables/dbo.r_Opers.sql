CREATE TABLE [dbo].[r_Opers] (
  [ChID] [bigint] NOT NULL,
  [OperID] [int] NOT NULL,
  [OperName] [varchar](10) NOT NULL,
  [OperPwd] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [OperLockPwd] [varchar](200) NOT NULL,
  CONSTRAINT [pk_r_Opers] PRIMARY KEY CLUSTERED ([OperID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Opers] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[r_Opers] ([EmpID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [OperName]
  ON [dbo].[r_Opers] ([OperName])
  ON [PRIMARY]
GO

CREATE INDEX [OperPwd]
  ON [dbo].[r_Opers] ([OperPwd])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Opers.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Opers.OperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Opers.OperPwd'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Opers.EmpID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Opers] ON [r_Opers]
FOR DELETE AS
/* r_Opers - Справочник ЭККА: операторы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Opers ^ r_OperCRs - Проверка в CHILD */
/* Справочник ЭККА: операторы ^ Справочник ЭККА - Операторы ЭККА - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OperCRs a WITH(NOLOCK), deleted d WHERE a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_Opers', 'r_OperCRs', 3
      RETURN
    END

/* r_Opers ^ t_ZRepT - Проверка в CHILD */
/* Справочник ЭККА: операторы ^ Z-отчеты плат. терминалов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ZRepT a WITH(NOLOCK), deleted d WHERE a.OperID = d.OperID)
    BEGIN
      EXEC z_RelationError 'r_Opers', 't_ZRepT', 3
      RETURN
    END


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10454001 AND m.PKValue = 
    '[' + cast(i.OperID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10454001 AND m.PKValue = 
    '[' + cast(i.OperID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10454001, -ChID, 
    '[' + cast(d.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10454 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Opers', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Opers] ON [r_Opers]
FOR UPDATE AS
/* r_Opers - Справочник ЭККА: операторы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Opers ^ r_Emps - Проверка в PARENT */
/* Справочник ЭККА: операторы ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_Opers', 1
        RETURN
      END

/* r_Opers ^ r_OperCRs - Обновление CHILD */
/* Справочник ЭККА: операторы ^ Справочник ЭККА - Операторы ЭККА - Обновление CHILD */
  IF UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OperID = i.OperID
          FROM r_OperCRs a, inserted i, deleted d WHERE a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OperCRs a, deleted d WHERE a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА: операторы'' => ''Справочник ЭККА - Операторы ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Opers ^ t_ZRepT - Обновление CHILD */
/* Справочник ЭККА: операторы ^ Z-отчеты плат. терминалов - Обновление CHILD */
  IF UPDATE(OperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OperID = i.OperID
          FROM t_ZRepT a, inserted i, deleted d WHERE a.OperID = d.OperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ZRepT a, deleted d WHERE a.OperID = d.OperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА: операторы'' => ''Z-отчеты плат. терминалов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10454001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10454001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(OperID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10454001 AND l.PKValue = 
        '[' + cast(i.OperID as varchar(200)) + ']' AND i.OperID = d.OperID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10454001 AND l.PKValue = 
        '[' + cast(i.OperID as varchar(200)) + ']' AND i.OperID = d.OperID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10454001, ChID, 
          '[' + cast(d.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10454001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10454001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10454001, ChID, 
          '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(OperID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OperID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OperID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OperID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10454001 AND l.PKValue = 
          '[' + cast(d.OperID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OperID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10454001 AND l.PKValue = 
          '[' + cast(d.OperID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10454001, ChID, 
          '[' + cast(d.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10454001 AND PKValue IN (SELECT 
          '[' + cast(OperID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10454001 AND PKValue IN (SELECT 
          '[' + cast(OperID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10454001, ChID, 
          '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10454001, ChID, 
    '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Opers', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Opers] ON [r_Opers]
FOR INSERT AS
/* r_Opers - Справочник ЭККА: операторы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Opers ^ r_Emps - Проверка в PARENT */
/* Справочник ЭККА: операторы ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Opers', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10454001, ChID, 
    '[' + cast(i.OperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Opers', N'Last', N'INSERT'
GO

















SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO