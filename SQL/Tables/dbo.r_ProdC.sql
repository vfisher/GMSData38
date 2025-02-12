CREATE TABLE [dbo].[r_ProdC] (
  [ChID] [bigint] NOT NULL,
  [PCatID] [int] NOT NULL,
  [PCatName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_ProdC] PRIMARY KEY CLUSTERED ([PCatID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_ProdC] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PCatName]
  ON [dbo].[r_ProdC] ([PCatName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdC.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdC.PCatID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdC] ON [r_ProdC]
FOR INSERT AS
/* r_ProdC - Справочник товаров: 1 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10331001, ChID, 
    '[' + cast(i.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdC] ON [r_ProdC]
FOR UPDATE AS
/* r_ProdC - Справочник товаров: 1 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdC ^ r_Prods - Обновление CHILD */
/* Справочник товаров: 1 группа ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(PCatID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCatID = i.PCatID
          FROM r_Prods a, inserted i, deleted d WHERE a.PCatID = d.PCatID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.PCatID = d.PCatID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: 1 группа'' => ''Справочник товаров''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ProdC ^ z_UserProdC - Обновление CHILD */
/* Справочник товаров: 1 группа ^ Доступные значения - Справочник товаров: 1 группа - Обновление CHILD */
  IF UPDATE(PCatID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCatID = i.PCatID
          FROM z_UserProdC a, inserted i, deleted d WHERE a.PCatID = d.PCatID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserProdC a, deleted d WHERE a.PCatID = d.PCatID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: 1 группа'' => ''Доступные значения - Справочник товаров: 1 группа''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10331001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10331001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PCatID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10331001 AND l.PKValue = 
        '[' + cast(i.PCatID as varchar(200)) + ']' AND i.PCatID = d.PCatID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10331001 AND l.PKValue = 
        '[' + cast(i.PCatID as varchar(200)) + ']' AND i.PCatID = d.PCatID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10331001, ChID, 
          '[' + cast(d.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10331001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10331001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10331001, ChID, 
          '[' + cast(i.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PCatID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PCatID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PCatID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PCatID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10331001 AND l.PKValue = 
          '[' + cast(d.PCatID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PCatID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10331001 AND l.PKValue = 
          '[' + cast(d.PCatID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10331001, ChID, 
          '[' + cast(d.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10331001 AND PKValue IN (SELECT 
          '[' + cast(PCatID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10331001 AND PKValue IN (SELECT 
          '[' + cast(PCatID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10331001, ChID, 
          '[' + cast(i.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10331001, ChID, 
    '[' + cast(i.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdC] ON [r_ProdC]
FOR DELETE AS
/* r_ProdC - Справочник товаров: 1 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdC ^ r_Prods - Проверка в CHILD */
/* Справочник товаров: 1 группа ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.PCatID = d.PCatID)
    BEGIN
      EXEC z_RelationError 'r_ProdC', 'r_Prods', 3
      RETURN
    END

/* r_ProdC ^ z_UserProdC - Удаление в CHILD */
/* Справочник товаров: 1 группа ^ Доступные значения - Справочник товаров: 1 группа - Удаление в CHILD */
  DELETE z_UserProdC FROM z_UserProdC a, deleted d WHERE a.PCatID = d.PCatID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10331001 AND m.PKValue = 
    '[' + cast(i.PCatID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10331001 AND m.PKValue = 
    '[' + cast(i.PCatID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10331001, -ChID, 
    '[' + cast(d.PCatID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10331 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdC', N'Last', N'DELETE'
GO