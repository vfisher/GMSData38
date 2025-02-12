CREATE TABLE [dbo].[r_ProdBG] (
  [ChID] [bigint] NOT NULL,
  [PBGrID] [smallint] NOT NULL,
  [PBGrName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [Tare] [bit] NOT NULL,
  CONSTRAINT [pk_r_ProdBG] PRIMARY KEY CLUSTERED ([PBGrID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_ProdBG] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PBGrName]
  ON [dbo].[r_ProdBG] ([PBGrName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdBG.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdBG.PBGrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdBG.Tare'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdBG] ON [r_ProdBG]
FOR INSERT AS
/* r_ProdBG - Справочник товаров: группа бухгалтерии - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10345001, ChID, 
    '[' + cast(i.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdBG', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdBG] ON [r_ProdBG]
FOR UPDATE AS
/* r_ProdBG - Справочник товаров: группа бухгалтерии - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdBG ^ r_Prods - Обновление CHILD */
/* Справочник товаров: группа бухгалтерии ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(PBGrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PBGrID = i.PBGrID
          FROM r_Prods a, inserted i, deleted d WHERE a.PBGrID = d.PBGrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.PBGrID = d.PBGrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: группа бухгалтерии'' => ''Справочник товаров''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10345001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10345001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PBGrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10345001 AND l.PKValue = 
        '[' + cast(i.PBGrID as varchar(200)) + ']' AND i.PBGrID = d.PBGrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10345001 AND l.PKValue = 
        '[' + cast(i.PBGrID as varchar(200)) + ']' AND i.PBGrID = d.PBGrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10345001, ChID, 
          '[' + cast(d.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10345001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10345001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10345001, ChID, 
          '[' + cast(i.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PBGrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PBGrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PBGrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PBGrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10345001 AND l.PKValue = 
          '[' + cast(d.PBGrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PBGrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10345001 AND l.PKValue = 
          '[' + cast(d.PBGrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10345001, ChID, 
          '[' + cast(d.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10345001 AND PKValue IN (SELECT 
          '[' + cast(PBGrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10345001 AND PKValue IN (SELECT 
          '[' + cast(PBGrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10345001, ChID, 
          '[' + cast(i.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10345001, ChID, 
    '[' + cast(i.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdBG', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdBG] ON [r_ProdBG]
FOR DELETE AS
/* r_ProdBG - Справочник товаров: группа бухгалтерии - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdBG ^ r_Prods - Проверка в CHILD */
/* Справочник товаров: группа бухгалтерии ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.PBGrID = d.PBGrID)
    BEGIN
      EXEC z_RelationError 'r_ProdBG', 'r_Prods', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10345001 AND m.PKValue = 
    '[' + cast(i.PBGrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10345001 AND m.PKValue = 
    '[' + cast(i.PBGrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10345001, -ChID, 
    '[' + cast(d.PBGrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10345 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdBG', N'Last', N'DELETE'
GO