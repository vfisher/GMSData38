CREATE TABLE [dbo].[r_PayTypeCats] (
  [ChID] [bigint] NOT NULL,
  [PayTypeCatID] [smallint] NOT NULL,
  [PayTypeCatName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_PayTypeCats] PRIMARY KEY CLUSTERED ([PayTypeCatID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_PayTypeCats] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PayTypeCatName]
  ON [dbo].[r_PayTypeCats] ([PayTypeCatName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypeCats.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_PayTypeCats.PayTypeCatID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PayTypeCats] ON [r_PayTypeCats]
FOR INSERT AS
/* r_PayTypeCats - Справочник выплат/удержаний: категории - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10089001, ChID, 
    '[' + cast(i.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_PayTypeCats', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PayTypeCats] ON [r_PayTypeCats]
FOR UPDATE AS
/* r_PayTypeCats - Справочник выплат/удержаний: категории - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayTypeCats ^ r_PayTypes - Обновление CHILD */
/* Справочник выплат/удержаний: категории ^ Справочник выплат/удержаний - Обновление CHILD */
  IF UPDATE(PayTypeCatID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayTypeCatID = i.PayTypeCatID
          FROM r_PayTypes a, inserted i, deleted d WHERE a.PayTypeCatID = d.PayTypeCatID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PayTypes a, deleted d WHERE a.PayTypeCatID = d.PayTypeCatID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник выплат/удержаний: категории'' => ''Справочник выплат/удержаний''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10089001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10089001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PayTypeCatID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10089001 AND l.PKValue = 
        '[' + cast(i.PayTypeCatID as varchar(200)) + ']' AND i.PayTypeCatID = d.PayTypeCatID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10089001 AND l.PKValue = 
        '[' + cast(i.PayTypeCatID as varchar(200)) + ']' AND i.PayTypeCatID = d.PayTypeCatID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10089001, ChID, 
          '[' + cast(d.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10089001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10089001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10089001, ChID, 
          '[' + cast(i.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PayTypeCatID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PayTypeCatID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PayTypeCatID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PayTypeCatID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10089001 AND l.PKValue = 
          '[' + cast(d.PayTypeCatID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PayTypeCatID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10089001 AND l.PKValue = 
          '[' + cast(d.PayTypeCatID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10089001, ChID, 
          '[' + cast(d.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10089001 AND PKValue IN (SELECT 
          '[' + cast(PayTypeCatID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10089001 AND PKValue IN (SELECT 
          '[' + cast(PayTypeCatID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10089001, ChID, 
          '[' + cast(i.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10089001, ChID, 
    '[' + cast(i.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_PayTypeCats', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PayTypeCats] ON [r_PayTypeCats]
FOR DELETE AS
/* r_PayTypeCats - Справочник выплат/удержаний: категории - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PayTypeCats ^ r_PayTypes - Проверка в CHILD */
/* Справочник выплат/удержаний: категории ^ Справочник выплат/удержаний - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PayTypes a WITH(NOLOCK), deleted d WHERE a.PayTypeCatID = d.PayTypeCatID)
    BEGIN
      EXEC z_RelationError 'r_PayTypeCats', 'r_PayTypes', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10089001 AND m.PKValue = 
    '[' + cast(i.PayTypeCatID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10089001 AND m.PKValue = 
    '[' + cast(i.PayTypeCatID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10089001, -ChID, 
    '[' + cast(d.PayTypeCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10089 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_PayTypeCats', N'Last', N'DELETE'
GO