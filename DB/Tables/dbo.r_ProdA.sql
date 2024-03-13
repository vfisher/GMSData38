CREATE TABLE [dbo].[r_ProdA]
(
[ChID] [bigint] NOT NULL,
[PGrAID] [smallint] NOT NULL,
[PGrAName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdA] ON [dbo].[r_ProdA]
FOR INSERT AS
/* r_ProdA - Справочник товаров: группа альтернатив - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10340001, ChID, 
    '[' + cast(i.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdA]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdA] ON [dbo].[r_ProdA]
FOR UPDATE AS
/* r_ProdA - Справочник товаров: группа альтернатив - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdA ^ r_Prods - Обновление CHILD */
/* Справочник товаров: группа альтернатив ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(PGrAID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PGrAID = i.PGrAID
          FROM r_Prods a, inserted i, deleted d WHERE a.PGrAID = d.PGrAID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.PGrAID = d.PGrAID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: группа альтернатив'' => ''Справочник товаров''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10340001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10340001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PGrAID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10340001 AND l.PKValue = 
        '[' + cast(i.PGrAID as varchar(200)) + ']' AND i.PGrAID = d.PGrAID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10340001 AND l.PKValue = 
        '[' + cast(i.PGrAID as varchar(200)) + ']' AND i.PGrAID = d.PGrAID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10340001, ChID, 
          '[' + cast(d.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10340001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10340001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10340001, ChID, 
          '[' + cast(i.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PGrAID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrAID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PGrAID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrAID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10340001 AND l.PKValue = 
          '[' + cast(d.PGrAID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PGrAID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10340001 AND l.PKValue = 
          '[' + cast(d.PGrAID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10340001, ChID, 
          '[' + cast(d.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10340001 AND PKValue IN (SELECT 
          '[' + cast(PGrAID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10340001 AND PKValue IN (SELECT 
          '[' + cast(PGrAID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10340001, ChID, 
          '[' + cast(i.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10340001, ChID, 
    '[' + cast(i.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdA]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdA] ON [dbo].[r_ProdA]
FOR DELETE AS
/* r_ProdA - Справочник товаров: группа альтернатив - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdA ^ r_Prods - Проверка в CHILD */
/* Справочник товаров: группа альтернатив ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.PGrAID = d.PGrAID)
    BEGIN
      EXEC z_RelationError 'r_ProdA', 'r_Prods', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10340001 AND m.PKValue = 
    '[' + cast(i.PGrAID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10340001 AND m.PKValue = 
    '[' + cast(i.PGrAID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10340001, -ChID, 
    '[' + cast(d.PGrAID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10340 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ProdA]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ProdA] ADD CONSTRAINT [pk_r_ProdA] PRIMARY KEY CLUSTERED ([PGrAID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdA] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrAName] ON [dbo].[r_ProdA] ([PGrAName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdA].[PGrAID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdA].[PGrAID]'
GO
