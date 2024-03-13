CREATE TABLE [dbo].[r_Taxes]
(
[TaxTypeID] [int] NOT NULL,
[TaxName] [varchar] (250) NOT NULL,
[TaxDesc] [varchar] (200) NULL,
[TaxID] [tinyint] NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Taxes] ON [dbo].[r_Taxes]
FOR INSERT AS
/* r_Taxes - Справочник НДС - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10810001, 0, 
    '[' + cast(i.TaxTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Taxes]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Taxes] ON [dbo].[r_Taxes]
FOR UPDATE AS
/* r_Taxes - Справочник НДС - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Taxes ^ r_Prods - Обновление CHILD */
/* Справочник НДС ^ Справочник товаров - Обновление CHILD */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxTypeID = i.TaxTypeID
          FROM r_Prods a, inserted i, deleted d WHERE a.TaxTypeID = d.TaxTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Prods a, deleted d WHERE a.TaxTypeID = d.TaxTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник НДС'' => ''Справочник товаров''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Taxes ^ r_LevyCR - Обновление CHILD */
/* Справочник НДС ^ Справочник сборов - Параметры РРО - Обновление CHILD */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxTypeID = i.TaxTypeID
          FROM r_LevyCR a, inserted i, deleted d WHERE a.TaxTypeID = d.TaxTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_LevyCR a, deleted d WHERE a.TaxTypeID = d.TaxTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник НДС'' => ''Справочник сборов - Параметры РРО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Taxes ^ r_TaxRates - Обновление CHILD */
/* Справочник НДС ^ Справочник НДС: значения - Обновление CHILD */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxTypeID = i.TaxTypeID
          FROM r_TaxRates a, inserted i, deleted d WHERE a.TaxTypeID = d.TaxTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_TaxRates a, deleted d WHERE a.TaxTypeID = d.TaxTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник НДС'' => ''Справочник НДС: значения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Taxes ^ t_CRRetD - Обновление CHILD */
/* Справочник НДС ^ Возврат товара по чеку: Товар - Обновление CHILD */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxTypeID = i.TaxTypeID
          FROM t_CRRetD a, inserted i, deleted d WHERE a.TaxTypeID = d.TaxTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetD a, deleted d WHERE a.TaxTypeID = d.TaxTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник НДС'' => ''Возврат товара по чеку: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Taxes ^ t_SaleD - Обновление CHILD */
/* Справочник НДС ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxTypeID = i.TaxTypeID
          FROM t_SaleD a, inserted i, deleted d WHERE a.TaxTypeID = d.TaxTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.TaxTypeID = d.TaxTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник НДС'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Taxes ^ t_SaleTempD - Обновление CHILD */
/* Справочник НДС ^ Временные данные продаж: Товар - Обновление CHILD */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TaxTypeID = i.TaxTypeID
          FROM t_SaleTempD a, inserted i, deleted d WHERE a.TaxTypeID = d.TaxTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempD a, deleted d WHERE a.TaxTypeID = d.TaxTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник НДС'' => ''Временные данные продаж: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(TaxTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT TaxTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10810001 AND l.PKValue = 
          '[' + cast(d.TaxTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.TaxTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10810001 AND l.PKValue = 
          '[' + cast(d.TaxTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10810001, 0, 
          '[' + cast(d.TaxTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10810001 AND PKValue IN (SELECT 
          '[' + cast(TaxTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10810001 AND PKValue IN (SELECT 
          '[' + cast(TaxTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10810001, 0, 
          '[' + cast(i.TaxTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10810001, 0, 
    '[' + cast(i.TaxTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Taxes]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Taxes] ON [dbo].[r_Taxes]
FOR DELETE AS
/* r_Taxes - Справочник НДС - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Taxes ^ r_Prods - Проверка в CHILD */
/* Справочник НДС ^ Справочник товаров - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Prods a WITH(NOLOCK), deleted d WHERE a.TaxTypeID = d.TaxTypeID)
    BEGIN
      EXEC z_RelationError 'r_Taxes', 'r_Prods', 3
      RETURN
    END

/* r_Taxes ^ r_LevyCR - Проверка в CHILD */
/* Справочник НДС ^ Справочник сборов - Параметры РРО - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_LevyCR a WITH(NOLOCK), deleted d WHERE a.TaxTypeID = d.TaxTypeID)
    BEGIN
      EXEC z_RelationError 'r_Taxes', 'r_LevyCR', 3
      RETURN
    END

/* r_Taxes ^ r_TaxRates - Удаление в CHILD */
/* Справочник НДС ^ Справочник НДС: значения - Удаление в CHILD */
  DELETE r_TaxRates FROM r_TaxRates a, deleted d WHERE a.TaxTypeID = d.TaxTypeID
  IF @@ERROR > 0 RETURN

/* r_Taxes ^ t_CRRetD - Проверка в CHILD */
/* Справочник НДС ^ Возврат товара по чеку: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetD a WITH(NOLOCK), deleted d WHERE a.TaxTypeID = d.TaxTypeID)
    BEGIN
      EXEC z_RelationError 'r_Taxes', 't_CRRetD', 3
      RETURN
    END

/* r_Taxes ^ t_SaleD - Проверка в CHILD */
/* Справочник НДС ^ Продажа товара оператором: Продажи товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleD a WITH(NOLOCK), deleted d WHERE a.TaxTypeID = d.TaxTypeID)
    BEGIN
      EXEC z_RelationError 'r_Taxes', 't_SaleD', 3
      RETURN
    END

/* r_Taxes ^ t_SaleTempD - Проверка в CHILD */
/* Справочник НДС ^ Временные данные продаж: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempD a WITH(NOLOCK), deleted d WHERE a.TaxTypeID = d.TaxTypeID)
    BEGIN
      EXEC z_RelationError 'r_Taxes', 't_SaleTempD', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10810001 AND m.PKValue = 
    '[' + cast(i.TaxTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10810001 AND m.PKValue = 
    '[' + cast(i.TaxTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10810001, 0, 
    '[' + cast(d.TaxTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Taxes]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Taxes] ADD CONSTRAINT [pk_r_Taxes] PRIMARY KEY CLUSTERED ([TaxTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [TaxName] ON [dbo].[r_Taxes] ([TaxName]) ON [PRIMARY]
GO
