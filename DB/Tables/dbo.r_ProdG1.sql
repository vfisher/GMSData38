CREATE TABLE [dbo].[r_ProdG1]
(
[ChID] [bigint] NOT NULL,
[PGrID1] [int] NOT NULL,
[PGrName1] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdG1] ON [dbo].[r_ProdG1]
FOR INSERT AS
/* r_ProdG1 - Справочник товаров: 3 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10333001, ChID, 
    '[' + cast(i.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdG1]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdG1] ON [dbo].[r_ProdG1]
FOR UPDATE AS
/* r_ProdG1 - Справочник товаров: 3 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdG1 ^ r_Prods - Обновление CHILD */
/* Справочник товаров: 3 группа ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(PGrID1)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PGrID1 = i.PGrID1
          FROM r_Prods a, inserted i, deleted d WHERE a.PGrID1 = d.PGrID1
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.PGrID1 = d.PGrID1)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: 3 группа'' => ''Справочник товаров''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ProdG1 ^ z_UserProdG1 - Обновление CHILD */
/* Справочник товаров: 3 группа ^ Доступные значения - Справочник товаров: 3 группа - Обновление CHILD */
  IF UPDATE(PGrID1)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PGrID1 = i.PGrID1
          FROM z_UserProdG1 a, inserted i, deleted d WHERE a.PGrID1 = d.PGrID1
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserProdG1 a, deleted d WHERE a.PGrID1 = d.PGrID1)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: 3 группа'' => ''Доступные значения - Справочник товаров: 3 группа''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10333001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10333001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PGrID1))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10333001 AND l.PKValue = 
        '[' + cast(i.PGrID1 as varchar(200)) + ']' AND i.PGrID1 = d.PGrID1
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10333001 AND l.PKValue = 
        '[' + cast(i.PGrID1 as varchar(200)) + ']' AND i.PGrID1 = d.PGrID1
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10333001, ChID, 
          '[' + cast(d.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10333001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10333001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10333001, ChID, 
          '[' + cast(i.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PGrID1)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrID1 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrID1 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrID1 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10333001 AND l.PKValue = 
          '[' + cast(d.PGrID1 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrID1 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10333001 AND l.PKValue = 
          '[' + cast(d.PGrID1 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10333001, ChID, 
          '[' + cast(d.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10333001 AND PKValue IN (SELECT 
          '[' + cast(PGrID1 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10333001 AND PKValue IN (SELECT 
          '[' + cast(PGrID1 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10333001, ChID, 
          '[' + cast(i.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10333001, ChID, 
    '[' + cast(i.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdG1]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdG1] ON [dbo].[r_ProdG1]
FOR DELETE AS
/* r_ProdG1 - Справочник товаров: 3 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdG1 ^ r_Prods - Проверка в CHILD */
/* Справочник товаров: 3 группа ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.PGrID1 = d.PGrID1)
    BEGIN
      EXEC z_RelationError 'r_ProdG1', 'r_Prods', 3
      RETURN
    END

/* r_ProdG1 ^ z_UserProdG1 - Удаление в CHILD */
/* Справочник товаров: 3 группа ^ Доступные значения - Справочник товаров: 3 группа - Удаление в CHILD */
  DELETE z_UserProdG1 FROM z_UserProdG1 a, deleted d WHERE a.PGrID1 = d.PGrID1
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10333001 AND m.PKValue = 
    '[' + cast(i.PGrID1 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10333001 AND m.PKValue = 
    '[' + cast(i.PGrID1 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10333001, -ChID, 
    '[' + cast(d.PGrID1 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10333 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ProdG1]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ProdG1] ADD CONSTRAINT [pk_r_ProdG1] PRIMARY KEY CLUSTERED ([PGrID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdG1] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrName1] ON [dbo].[r_ProdG1] ([PGrName1]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG1].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG1].[PGrID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG1].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG1].[PGrID1]'
GO
