CREATE TABLE [dbo].[r_Countries]
(
[ChID] [bigint] NOT NULL,
[CounID] [smallint] NOT NULL,
[Country] [varchar] (200) NOT NULL,
[UACountry] [varchar] (200) NOT NULL,
[CountryCode2] [varchar] (2) NOT NULL,
[CountryCode3] [varchar] (3) NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Countries] ON [dbo].[r_Countries]
FOR INSERT AS
/* r_Countries - Справочник стран - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10900001, ChID, 
    '[' + cast(i.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Countries]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Countries] ON [dbo].[r_Countries]
FOR UPDATE AS
/* r_Countries - Справочник стран - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Countries ^ b_PInP - Обновление CHILD */
/* Справочник стран ^ Справочник товаров - Цены прихода Бухгалтерии - Обновление CHILD */
  IF UPDATE(CounID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CounID = i.CounID
          FROM b_PInP a, inserted i, deleted d WHERE a.CounID = d.CounID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PInP a, deleted d WHERE a.CounID = d.CounID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник стран'' => ''Справочник товаров - Цены прихода Бухгалтерии''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Countries ^ r_Prods - Обновление CHILD */
/* Справочник стран ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(CounID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CounID = i.CounID
          FROM r_Prods a, inserted i, deleted d WHERE a.CounID = d.CounID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.CounID = d.CounID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник стран'' => ''Справочник товаров''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10900001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10900001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CounID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10900001 AND l.PKValue = 
        '[' + cast(i.CounID as varchar(200)) + ']' AND i.CounID = d.CounID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10900001 AND l.PKValue = 
        '[' + cast(i.CounID as varchar(200)) + ']' AND i.CounID = d.CounID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10900001, ChID, 
          '[' + cast(d.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10900001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10900001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10900001, ChID, 
          '[' + cast(i.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CounID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CounID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CounID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CounID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10900001 AND l.PKValue = 
          '[' + cast(d.CounID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CounID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10900001 AND l.PKValue = 
          '[' + cast(d.CounID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10900001, ChID, 
          '[' + cast(d.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10900001 AND PKValue IN (SELECT 
          '[' + cast(CounID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10900001 AND PKValue IN (SELECT 
          '[' + cast(CounID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10900001, ChID, 
          '[' + cast(i.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10900001, ChID, 
    '[' + cast(i.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Countries]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Countries] ON [dbo].[r_Countries]
FOR DELETE AS
/* r_Countries - Справочник стран - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Countries ^ b_PInP - Проверка в CHILD */
/* Справочник стран ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PInP a WITH(NOLOCK), deleted d WHERE a.CounID = d.CounID)
    BEGIN
      EXEC z_RelationError 'r_Countries', 'b_PInP', 3
      RETURN
    END

/* r_Countries ^ r_Prods - Проверка в CHILD */
/* Справочник стран ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.CounID = d.CounID)
    BEGIN
      EXEC z_RelationError 'r_Countries', 'r_Prods', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10900001 AND m.PKValue = 
    '[' + cast(i.CounID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10900001 AND m.PKValue = 
    '[' + cast(i.CounID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10900001, -ChID, 
    '[' + cast(d.CounID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10900 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Countries]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Countries] ADD CONSTRAINT [pk_r_Countries] PRIMARY KEY CLUSTERED ([CounID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Countries] ([ChID]) ON [PRIMARY]
GO
