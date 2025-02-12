CREATE TABLE [dbo].[r_StockGs] (
  [ChID] [bigint] NOT NULL,
  [StockGID] [smallint] NOT NULL,
  [StockGName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_StockGs] PRIMARY KEY CLUSTERED ([StockGID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_StockGs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [StockGName]
  ON [dbo].[r_StockGs] ([StockGName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_StockGs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_StockGs.StockGID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_StockGs] ON [r_StockGs]
FOR INSERT AS
/* r_StockGs - Справочник складов: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10300001, ChID, 
    '[' + cast(i.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_StockGs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_StockGs] ON [r_StockGs]
FOR UPDATE AS
/* r_StockGs - Справочник складов: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_StockGs ^ r_Stocks - Обновление CHILD */
/* Справочник складов: группы ^ Справочник складов - Обновление CHILD */
  IF UPDATE(StockGID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockGID = i.StockGID
          FROM r_Stocks a, inserted i, deleted d WHERE a.StockGID = d.StockGID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Stocks a, deleted d WHERE a.StockGID = d.StockGID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов: группы'' => ''Справочник складов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_StockGs ^ z_UserStockGs - Обновление CHILD */
/* Справочник складов: группы ^ Доступные значения - Справочник складов: группы - Обновление CHILD */
  IF UPDATE(StockGID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StockGID = i.StockGID
          FROM z_UserStockGs a, inserted i, deleted d WHERE a.StockGID = d.StockGID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserStockGs a, deleted d WHERE a.StockGID = d.StockGID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник складов: группы'' => ''Доступные значения - Справочник складов: группы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10300001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10300001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(StockGID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10300001 AND l.PKValue = 
        '[' + cast(i.StockGID as varchar(200)) + ']' AND i.StockGID = d.StockGID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10300001 AND l.PKValue = 
        '[' + cast(i.StockGID as varchar(200)) + ']' AND i.StockGID = d.StockGID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10300001, ChID, 
          '[' + cast(d.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10300001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10300001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10300001, ChID, 
          '[' + cast(i.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(StockGID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT StockGID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT StockGID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.StockGID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10300001 AND l.PKValue = 
          '[' + cast(d.StockGID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.StockGID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10300001 AND l.PKValue = 
          '[' + cast(d.StockGID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10300001, ChID, 
          '[' + cast(d.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10300001 AND PKValue IN (SELECT 
          '[' + cast(StockGID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10300001 AND PKValue IN (SELECT 
          '[' + cast(StockGID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10300001, ChID, 
          '[' + cast(i.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10300001, ChID, 
    '[' + cast(i.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_StockGs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_StockGs] ON [r_StockGs]
FOR DELETE AS
/* r_StockGs - Справочник складов: группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_StockGs ^ r_Stocks - Проверка в CHILD */
/* Справочник складов: группы ^ Справочник складов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Stocks a WITH(NOLOCK), deleted d WHERE a.StockGID = d.StockGID)
    BEGIN
      EXEC z_RelationError 'r_StockGs', 'r_Stocks', 3
      RETURN
    END

/* r_StockGs ^ z_UserStockGs - Удаление в CHILD */
/* Справочник складов: группы ^ Доступные значения - Справочник складов: группы - Удаление в CHILD */
  DELETE z_UserStockGs FROM z_UserStockGs a, deleted d WHERE a.StockGID = d.StockGID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10300001 AND m.PKValue = 
    '[' + cast(i.StockGID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10300001 AND m.PKValue = 
    '[' + cast(i.StockGID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10300001, -ChID, 
    '[' + cast(d.StockGID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10300 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_StockGs', N'Last', N'DELETE'
GO