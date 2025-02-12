CREATE TABLE [dbo].[r_DBIs] (
  [ChID] [bigint] NOT NULL,
  [DBiID] [int] NOT NULL,
  [DBiName] [varchar](250) NOT NULL,
  [Notes] [varchar](250) NULL,
  [IsDefault] [bit] NOT NULL DEFAULT (0),
  [RangeValue] [bigint] NOT NULL,
  [ChID_Start] [bigint] NOT NULL,
  [ChID_End] [bigint] NOT NULL,
  [DocID_Start] [bigint] NOT NULL,
  [DocID_End] [bigint] NOT NULL,
  [IntDocID_Start] [bigint] NOT NULL,
  [IntDocID_End] [bigint] NOT NULL,
  [RefID_Start] [int] NOT NULL,
  [RefID_End] [int] NOT NULL,
  [PPID_Start] [int] NOT NULL,
  [PPID_End] [int] NOT NULL,
  [OurID] [int] NOT NULL,
  [PCCode] [int] NOT NULL,
  CONSTRAINT [pk_r_DBIs] PRIMARY KEY CLUSTERED ([DBiID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_DBIs] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [ChID_End]
  ON [dbo].[r_DBIs] ([ChID_End])
  ON [PRIMARY]
GO

CREATE INDEX [ChID_Start]
  ON [dbo].[r_DBIs] ([ChID_Start])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DBiName]
  ON [dbo].[r_DBIs] ([DBiName])
  ON [PRIMARY]
GO

CREATE INDEX [DocID_End]
  ON [dbo].[r_DBIs] ([DocID_End])
  ON [PRIMARY]
GO

CREATE INDEX [DocID_Start]
  ON [dbo].[r_DBIs] ([DocID_Start])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID_End]
  ON [dbo].[r_DBIs] ([IntDocID_End])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID_Start]
  ON [dbo].[r_DBIs] ([IntDocID_Start])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[r_DBIs] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [PCCode]
  ON [dbo].[r_DBIs] ([PCCode])
  ON [PRIMARY]
GO

CREATE INDEX [PPID_End]
  ON [dbo].[r_DBIs] ([PPID_End])
  ON [PRIMARY]
GO

CREATE INDEX [PPID_Start]
  ON [dbo].[r_DBIs] ([PPID_Start])
  ON [PRIMARY]
GO

CREATE INDEX [RefID_End]
  ON [dbo].[r_DBIs] ([RefID_End])
  ON [PRIMARY]
GO

CREATE INDEX [RefID_Start]
  ON [dbo].[r_DBIs] ([RefID_Start])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DBIs] ON [r_DBIs]
FOR INSERT AS
/* r_DBIs - Справочник баз данных - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DBIs ^ r_Ours - Проверка в PARENT */
/* Справочник баз данных ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_DBIs', 0
      RETURN
    END

/* r_DBIs ^ r_PCs - Проверка в PARENT */
/* Справочник баз данных ^ Справочник компьютеров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PCCode NOT IN (SELECT PCCode FROM r_PCs))
    BEGIN
      EXEC z_RelationError 'r_PCs', 'r_DBIs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10500001, ChID, 
    '[' + cast(i.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_DBIs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DBIs] ON [r_DBIs]
FOR UPDATE AS
/* r_DBIs - Справочник баз данных - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DBIs ^ r_Ours - Проверка в PARENT */
/* Справочник баз данных ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_DBIs', 1
        RETURN
      END

/* r_DBIs ^ r_PCs - Проверка в PARENT */
/* Справочник баз данных ^ Справочник компьютеров - Проверка в PARENT */
  IF UPDATE(PCCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PCCode NOT IN (SELECT PCCode FROM r_PCs))
      BEGIN
        EXEC z_RelationError 'r_PCs', 'r_DBIs', 1
        RETURN
      END

/* r_DBIs ^ z_LogDiscExp - Обновление CHILD */
/* Справочник баз данных ^ Регистрация действий - Списание бонусов - Обновление CHILD */
  IF UPDATE(DBiID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DBiID = i.DBiID
          FROM z_LogDiscExp a, inserted i, deleted d WHERE a.DBiID = d.DBiID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExp a, deleted d WHERE a.DBiID = d.DBiID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник баз данных'' => ''Регистрация действий - Списание бонусов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_DBIs ^ z_LogDiscRec - Обновление CHILD */
/* Справочник баз данных ^ Регистрация действий - Начисление бонусов - Обновление CHILD */
  IF UPDATE(DBiID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DBiID = i.DBiID
          FROM z_LogDiscRec a, inserted i, deleted d WHERE a.DBiID = d.DBiID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscRec a, deleted d WHERE a.DBiID = d.DBiID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник баз данных'' => ''Регистрация действий - Начисление бонусов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_DBIs ^ z_Vars - Обновление CHILD */
/* Справочник баз данных ^ Системные переменные - Обновление CHILD */
  IF UPDATE(DBiID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'OT_DBiID', a.VarValue = i.DBiID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'OT_DBiID' AND a.VarValue = d.DBiID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'OT_DBiID' AND a.VarValue = d.DBiID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник баз данных'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10500001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10500001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DBiID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10500001 AND l.PKValue = 
        '[' + cast(i.DBiID as varchar(200)) + ']' AND i.DBiID = d.DBiID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10500001 AND l.PKValue = 
        '[' + cast(i.DBiID as varchar(200)) + ']' AND i.DBiID = d.DBiID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10500001, ChID, 
          '[' + cast(d.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10500001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10500001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10500001, ChID, 
          '[' + cast(i.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DBiID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DBiID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DBiID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DBiID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10500001 AND l.PKValue = 
          '[' + cast(d.DBiID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DBiID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10500001 AND l.PKValue = 
          '[' + cast(d.DBiID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10500001, ChID, 
          '[' + cast(d.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10500001 AND PKValue IN (SELECT 
          '[' + cast(DBiID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10500001 AND PKValue IN (SELECT 
          '[' + cast(DBiID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10500001, ChID, 
          '[' + cast(i.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10500001, ChID, 
    '[' + cast(i.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_DBIs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DBIs] ON [r_DBIs]
FOR DELETE AS
/* r_DBIs - Справочник баз данных - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_DBIs ^ z_LogDiscExp - Проверка в CHILD */
/* Справочник баз данных ^ Регистрация действий - Списание бонусов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_LogDiscExp a WITH(NOLOCK), deleted d WHERE a.DBiID = d.DBiID)
    BEGIN
      EXEC z_RelationError 'r_DBIs', 'z_LogDiscExp', 3
      RETURN
    END

/* r_DBIs ^ z_LogDiscRec - Проверка в CHILD */
/* Справочник баз данных ^ Регистрация действий - Начисление бонусов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_LogDiscRec a WITH(NOLOCK), deleted d WHERE a.DBiID = d.DBiID)
    BEGIN
      EXEC z_RelationError 'r_DBIs', 'z_LogDiscRec', 3
      RETURN
    END

/* r_DBIs ^ z_Vars - Проверка в CHILD */
/* Справочник баз данных ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'OT_DBiID' AND a.VarValue = d.DBiID)
    BEGIN
      EXEC z_RelationError 'r_DBIs', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10500001 AND m.PKValue = 
    '[' + cast(i.DBiID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10500001 AND m.PKValue = 
    '[' + cast(i.DBiID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10500001, -ChID, 
    '[' + cast(d.DBiID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10500 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_DBIs', N'Last', N'DELETE'
GO