CREATE TABLE [dbo].[r_Services]
(
[ChID] [bigint] NOT NULL,
[SrvcID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[TimeNorm] [int] NOT NULL DEFAULT ((0)),
[StockID] [int] NOT NULL,
[NeedResource] [bit] NOT NULL,
[NeedExecutor] [bit] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Services] ON [dbo].[r_Services]
FOR INSERT AS
/* r_Services - Справочник услуг - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Services ^ r_Prods - Проверка в PARENT */
/* Справочник услуг ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_Services', 0
      RETURN
    END

/* r_Services ^ r_Stocks - Проверка в PARENT */
/* Справочник услуг ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_Services', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11115001, ChID, 
    '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Services]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Services] ON [dbo].[r_Services]
FOR UPDATE AS
/* r_Services - Справочник услуг - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Services ^ r_Prods - Проверка в PARENT */
/* Справочник услуг ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_Services', 1
        RETURN
      END

/* r_Services ^ r_Stocks - Проверка в PARENT */
/* Справочник услуг ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_Services', 1
        RETURN
      END

/* r_Services ^ r_ServiceCompatibility - Проверка в CHILD */
/* Справочник услуг ^ Справочник услуг - совместимость - Проверка в CHILD */
  IF UPDATE(SrvcID) IF EXISTS (SELECT * FROM r_ServiceCompatibility a WITH(NOLOCK), deleted d WHERE a.CompatibleServiceID = d.SrvcID)
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ServiceCompatibility', 2
      RETURN
    END

/* r_Services ^ r_ServiceCompatibility - Обновление CHILD */
/* Справочник услуг ^ Справочник услуг - совместимость - Обновление CHILD */
  IF UPDATE(SrvcID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvcID = i.SrvcID
          FROM r_ServiceCompatibility a, inserted i, deleted d WHERE a.SrvcID = d.SrvcID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ServiceCompatibility a, deleted d WHERE a.SrvcID = d.SrvcID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник услуг'' => ''Справочник услуг - совместимость''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Services ^ r_ServiceResources - Обновление CHILD */
/* Справочник услуг ^ Справочник услуг - ресурсы - Обновление CHILD */
  IF UPDATE(SrvcID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvcID = i.SrvcID
          FROM r_ServiceResources a, inserted i, deleted d WHERE a.SrvcID = d.SrvcID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ServiceResources a, deleted d WHERE a.SrvcID = d.SrvcID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник услуг'' => ''Справочник услуг - ресурсы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Services ^ r_PersonPreferences - Обновление CHILD */
/* Справочник услуг ^ Справочник персон - предпочтения - Обновление CHILD */
  IF UPDATE(SrvcID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvcID = i.SrvcID
          FROM r_PersonPreferences a, inserted i, deleted d WHERE a.SrvcID = d.SrvcID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_PersonPreferences a, deleted d WHERE a.SrvcID = d.SrvcID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник услуг'' => ''Справочник персон - предпочтения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Services ^ r_ExecutorServices - Обновление CHILD */
/* Справочник услуг ^ Справочник исполнителей - услуги - Обновление CHILD */
  IF UPDATE(SrvcID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvcID = i.SrvcID
          FROM r_ExecutorServices a, inserted i, deleted d WHERE a.SrvcID = d.SrvcID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ExecutorServices a, deleted d WHERE a.SrvcID = d.SrvcID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник услуг'' => ''Справочник исполнителей - услуги''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Services ^ t_BookingD - Обновление CHILD */
/* Справочник услуг ^ Заявки: Подробно - Обновление CHILD */
  IF UPDATE(SrvcID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvcID = i.SrvcID
          FROM t_BookingD a, inserted i, deleted d WHERE a.SrvcID = d.SrvcID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_BookingD a, deleted d WHERE a.SrvcID = d.SrvcID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник услуг'' => ''Заявки: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Services ^ t_BookingTempD - Обновление CHILD */
/* Справочник услуг ^ Интернет заявки - подробно - Обновление CHILD */
  IF UPDATE(SrvcID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvcID = i.SrvcID
          FROM t_BookingTempD a, inserted i, deleted d WHERE a.SrvcID = d.SrvcID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_BookingTempD a, deleted d WHERE a.SrvcID = d.SrvcID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник услуг'' => ''Интернет заявки - подробно''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11115001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11115001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(SrvcID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11115001 AND l.PKValue = 
        '[' + cast(i.SrvcID as varchar(200)) + ']' AND i.SrvcID = d.SrvcID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11115001 AND l.PKValue = 
        '[' + cast(i.SrvcID as varchar(200)) + ']' AND i.SrvcID = d.SrvcID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11115001, ChID, 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11115001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11115001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11115001, ChID, 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(SrvcID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvcID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvcID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11115001 AND l.PKValue = 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11115001 AND l.PKValue = 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11115001, ChID, 
          '[' + cast(d.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11115001 AND PKValue IN (SELECT 
          '[' + cast(SrvcID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11115001 AND PKValue IN (SELECT 
          '[' + cast(SrvcID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11115001, ChID, 
          '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11115001, ChID, 
    '[' + cast(i.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Services]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Services] ON [dbo].[r_Services]
FOR DELETE AS
/* r_Services - Справочник услуг - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Services ^ r_ServiceCompatibility - Проверка в CHILD */
/* Справочник услуг ^ Справочник услуг - совместимость - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ServiceCompatibility a WITH(NOLOCK), deleted d WHERE a.CompatibleServiceID = d.SrvcID)
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ServiceCompatibility', 3
      RETURN
    END

/* r_Services ^ r_ServiceCompatibility - Удаление в CHILD */
/* Справочник услуг ^ Справочник услуг - совместимость - Удаление в CHILD */
  DELETE r_ServiceCompatibility FROM r_ServiceCompatibility a, deleted d WHERE a.SrvcID = d.SrvcID
  IF @@ERROR > 0 RETURN

/* r_Services ^ r_ServiceResources - Удаление в CHILD */
/* Справочник услуг ^ Справочник услуг - ресурсы - Удаление в CHILD */
  DELETE r_ServiceResources FROM r_ServiceResources a, deleted d WHERE a.SrvcID = d.SrvcID
  IF @@ERROR > 0 RETURN

/* r_Services ^ r_PersonPreferences - Проверка в CHILD */
/* Справочник услуг ^ Справочник персон - предпочтения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_PersonPreferences a WITH(NOLOCK), deleted d WHERE a.SrvcID = d.SrvcID)
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_PersonPreferences', 3
      RETURN
    END

/* r_Services ^ r_ExecutorServices - Проверка в CHILD */
/* Справочник услуг ^ Справочник исполнителей - услуги - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ExecutorServices a WITH(NOLOCK), deleted d WHERE a.SrvcID = d.SrvcID)
    BEGIN
      EXEC z_RelationError 'r_Services', 'r_ExecutorServices', 3
      RETURN
    END

/* r_Services ^ t_BookingD - Проверка в CHILD */
/* Справочник услуг ^ Заявки: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_BookingD a WITH(NOLOCK), deleted d WHERE a.SrvcID = d.SrvcID)
    BEGIN
      EXEC z_RelationError 'r_Services', 't_BookingD', 3
      RETURN
    END

/* r_Services ^ t_BookingTempD - Проверка в CHILD */
/* Справочник услуг ^ Интернет заявки - подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_BookingTempD a WITH(NOLOCK), deleted d WHERE a.SrvcID = d.SrvcID)
    BEGIN
      EXEC z_RelationError 'r_Services', 't_BookingTempD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11115001 AND m.PKValue = 
    '[' + cast(i.SrvcID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11115001 AND m.PKValue = 
    '[' + cast(i.SrvcID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11115001, -ChID, 
    '[' + cast(d.SrvcID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11115 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Services]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Services] ADD CONSTRAINT [pk_r_Services] PRIMARY KEY CLUSTERED ([SrvcID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Services] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdID_StockID] ON [dbo].[r_Services] ([ProdID], [StockID]) ON [PRIMARY]
GO
