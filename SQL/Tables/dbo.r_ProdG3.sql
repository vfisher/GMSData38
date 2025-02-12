CREATE TABLE [dbo].[r_ProdG3] (
  [ChID] [bigint] NOT NULL,
  [PGrID3] [int] NOT NULL,
  [PGrName3] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_ProdG3] PRIMARY KEY CLUSTERED ([PGrID3])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_ProdG3] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [PGrName3]
  ON [dbo].[r_ProdG3] ([PGrName3])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdG3.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdG3.PGrID3'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdG3] ON [r_ProdG3]
FOR INSERT AS
/* r_ProdG3 - Справочник товаров: 5 группа - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10335001, ChID, 
    '[' + cast(i.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdG3', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdG3] ON [r_ProdG3]
FOR UPDATE AS
/* r_ProdG3 - Справочник товаров: 5 группа - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdG3 ^ r_Prods - Обновление CHILD */
/* Справочник товаров: 5 группа ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(PGrID3)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PGrID3 = i.PGrID3
          FROM r_Prods a, inserted i, deleted d WHERE a.PGrID3 = d.PGrID3
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.PGrID3 = d.PGrID3)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: 5 группа'' => ''Справочник товаров''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10335001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10335001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PGrID3))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10335001 AND l.PKValue = 
        '[' + cast(i.PGrID3 as varchar(200)) + ']' AND i.PGrID3 = d.PGrID3
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10335001 AND l.PKValue = 
        '[' + cast(i.PGrID3 as varchar(200)) + ']' AND i.PGrID3 = d.PGrID3
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10335001, ChID, 
          '[' + cast(d.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10335001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10335001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10335001, ChID, 
          '[' + cast(i.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PGrID3)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrID3 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrID3 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrID3 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10335001 AND l.PKValue = 
          '[' + cast(d.PGrID3 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrID3 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10335001 AND l.PKValue = 
          '[' + cast(d.PGrID3 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10335001, ChID, 
          '[' + cast(d.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10335001 AND PKValue IN (SELECT 
          '[' + cast(PGrID3 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10335001 AND PKValue IN (SELECT 
          '[' + cast(PGrID3 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10335001, ChID, 
          '[' + cast(i.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10335001, ChID, 
    '[' + cast(i.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdG3', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdG3] ON [r_ProdG3]
FOR DELETE AS
/* r_ProdG3 - Справочник товаров: 5 группа - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdG3 ^ r_Prods - Проверка в CHILD */
/* Справочник товаров: 5 группа ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.PGrID3 = d.PGrID3)
    BEGIN
      EXEC z_RelationError 'r_ProdG3', 'r_Prods', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10335001 AND m.PKValue = 
    '[' + cast(i.PGrID3 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10335001 AND m.PKValue = 
    '[' + cast(i.PGrID3 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10335001, -ChID, 
    '[' + cast(d.PGrID3 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10335 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdG3', N'Last', N'DELETE'
GO