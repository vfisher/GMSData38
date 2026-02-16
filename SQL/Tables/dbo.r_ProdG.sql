CREATE TABLE [dbo].[r_ProdG] (
  [ChID] [bigint] NOT NULL,
  [PGrID] [int] NOT NULL,
  [PGrName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_ProdG] PRIMARY KEY CLUSTERED ([PGrID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_ProdG] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PGrName]
  ON [dbo].[r_ProdG] ([PGrName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdG.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdG.PGrID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdG] ON [r_ProdG]
FOR DELETE AS
/* r_ProdG - Справочник товаров: группы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdG ^ r_Prods - Проверка в CHILD */
/* Справочник товаров: группы ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.PGrID = d.PGrID)
    BEGIN
      EXEC z_RelationError 'r_ProdG', 'r_Prods', 3
      RETURN
    END

/* r_ProdG ^ z_UserProdG - Удаление в CHILD */
/* Справочник товаров: группы ^ Доступные значения - Справочник товаров: 2 группа - Удаление в CHILD */
  DELETE z_UserProdG FROM z_UserProdG a, deleted d WHERE a.PGrID = d.PGrID
  IF @@ERROR > 0 RETURN


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10332001 AND m.PKValue = 
    '[' + cast(i.PGrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10332001 AND m.PKValue = 
    '[' + cast(i.PGrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10332001, -ChID, 
    '[' + cast(d.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10332 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdG', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdG] ON [r_ProdG]
FOR UPDATE AS
/* r_ProdG - Справочник товаров: группы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdG ^ r_Prods - Обновление CHILD */
/* Справочник товаров: группы ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(PGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PGrID = i.PGrID
          FROM r_Prods a, inserted i, deleted d WHERE a.PGrID = d.PGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.PGrID = d.PGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: группы'' => ''Справочник товаров''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ProdG ^ z_UserProdG - Обновление CHILD */
/* Справочник товаров: группы ^ Доступные значения - Справочник товаров: 2 группа - Обновление CHILD */
  IF UPDATE(PGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PGrID = i.PGrID
          FROM z_UserProdG a, inserted i, deleted d WHERE a.PGrID = d.PGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserProdG a, deleted d WHERE a.PGrID = d.PGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: группы'' => ''Доступные значения - Справочник товаров: 2 группа''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10332001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10332001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PGrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10332001 AND l.PKValue = 
        '[' + cast(i.PGrID as varchar(200)) + ']' AND i.PGrID = d.PGrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10332001 AND l.PKValue = 
        '[' + cast(i.PGrID as varchar(200)) + ']' AND i.PGrID = d.PGrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10332001, ChID, 
          '[' + cast(d.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10332001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10332001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10332001, ChID, 
          '[' + cast(i.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PGrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10332001 AND l.PKValue = 
          '[' + cast(d.PGrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10332001 AND l.PKValue = 
          '[' + cast(d.PGrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10332001, ChID, 
          '[' + cast(d.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10332001 AND PKValue IN (SELECT 
          '[' + cast(PGrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10332001 AND PKValue IN (SELECT 
          '[' + cast(PGrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10332001, ChID, 
          '[' + cast(i.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10332001, ChID, 
    '[' + cast(i.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdG', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdG] ON [r_ProdG]
FOR INSERT AS
/* r_ProdG - Справочник товаров: группы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10332001, ChID, 
    '[' + cast(i.PGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdG', N'Last', N'INSERT'
GO









SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO