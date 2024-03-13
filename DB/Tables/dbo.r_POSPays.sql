CREATE TABLE [dbo].[r_POSPays]
(
[ChID] [bigint] NOT NULL,
[POSPayID] [int] NOT NULL,
[POSPayName] [varchar] (250) NOT NULL,
[POSPayClass] [varchar] (250) NOT NULL,
[POSPayPort] [int] NOT NULL,
[POSPayTimeout] [int] NOT NULL,
[Notes] [varchar] (250) NULL,
[UseGrpCardForDiscs] [bit] NOT NULL DEFAULT (0),
[UseUnionCheque] [bit] NOT NULL DEFAULT ((0)),
[BankID] [int] NOT NULL DEFAULT ((0)),
[PrintTranInfoInCheque] [bit] NOT NULL DEFAULT ((0)),
[IP] [varchar] (250) NULL,
[NetPort] [int] NULL,
[UsePosCollection] [bit] NOT NULL DEFAULT ((0)),
[SettleBeforeRefund] [bit] NOT NULL DEFAULT ((1)),
[POSMerchantId] [int] NOT NULL DEFAULT ((1)),
[UsePosCompareCR] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_POSPays] ON [dbo].[r_POSPays]
FOR INSERT AS
/* r_PosPays - Справочник платежных терминалов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PosPays ^ r_Banks - Проверка в PARENT */
/* Справочник платежных терминалов ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_PosPays', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10457001, ChID, 
    '[' + cast(i.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_POSPays]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_POSPays] ON [dbo].[r_POSPays]
FOR UPDATE AS
/* r_PosPays - Справочник платежных терминалов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PosPays ^ r_Banks - Проверка в PARENT */
/* Справочник платежных терминалов ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'r_PosPays', 1
        RETURN
      END

/* r_PosPays ^ r_CRPOSPays - Обновление CHILD */
/* Справочник платежных терминалов ^ Справочник ЭККА: Платежные терминалы - Обновление CHILD */
  IF UPDATE(POSPayID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.POSPayID = i.POSPayID
          FROM r_CRPOSPays a, inserted i, deleted d WHERE a.POSPayID = d.POSPayID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRPOSPays a, deleted d WHERE a.POSPayID = d.POSPayID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник платежных терминалов'' => ''Справочник ЭККА: Платежные терминалы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PosPays ^ t_CRRetPays - Обновление CHILD */
/* Справочник платежных терминалов ^ Возврат товара по чеку: Оплата - Обновление CHILD */
  IF UPDATE(POSPayID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.POSPayID = i.POSPayID
          FROM t_CRRetPays a, inserted i, deleted d WHERE a.POSPayID = d.POSPayID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetPays a, deleted d WHERE a.POSPayID = d.POSPayID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник платежных терминалов'' => ''Возврат товара по чеку: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PosPays ^ t_SalePays - Обновление CHILD */
/* Справочник платежных терминалов ^ Продажа товара оператором: Оплата - Обновление CHILD */
  IF UPDATE(POSPayID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.POSPayID = i.POSPayID
          FROM t_SalePays a, inserted i, deleted d WHERE a.POSPayID = d.POSPayID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SalePays a, deleted d WHERE a.POSPayID = d.POSPayID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник платежных терминалов'' => ''Продажа товара оператором: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PosPays ^ t_SaleTempPays - Обновление CHILD */
/* Справочник платежных терминалов ^ Временные данные продаж: Оплата - Обновление CHILD */
  IF UPDATE(POSPayID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.POSPayID = i.POSPayID
          FROM t_SaleTempPays a, inserted i, deleted d WHERE a.POSPayID = d.POSPayID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempPays a, deleted d WHERE a.POSPayID = d.POSPayID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник платежных терминалов'' => ''Временные данные продаж: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PosPays ^ t_ZRepT - Обновление CHILD */
/* Справочник платежных терминалов ^ Z-отчеты плат. терминалов - Обновление CHILD */
  IF UPDATE(POSPayID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.POSPayID = i.POSPayID
          FROM t_ZRepT a, inserted i, deleted d WHERE a.POSPayID = d.POSPayID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ZRepT a, deleted d WHERE a.POSPayID = d.POSPayID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник платежных терминалов'' => ''Z-отчеты плат. терминалов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10457001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10457001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(POSPayID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10457001 AND l.PKValue = 
        '[' + cast(i.POSPayID as varchar(200)) + ']' AND i.POSPayID = d.POSPayID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10457001 AND l.PKValue = 
        '[' + cast(i.POSPayID as varchar(200)) + ']' AND i.POSPayID = d.POSPayID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10457001, ChID, 
          '[' + cast(d.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10457001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10457001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10457001, ChID, 
          '[' + cast(i.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(POSPayID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT POSPayID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT POSPayID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.POSPayID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10457001 AND l.PKValue = 
          '[' + cast(d.POSPayID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.POSPayID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10457001 AND l.PKValue = 
          '[' + cast(d.POSPayID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10457001, ChID, 
          '[' + cast(d.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10457001 AND PKValue IN (SELECT 
          '[' + cast(POSPayID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10457001 AND PKValue IN (SELECT 
          '[' + cast(POSPayID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10457001, ChID, 
          '[' + cast(i.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10457001, ChID, 
    '[' + cast(i.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_POSPays]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_POSPays] ON [dbo].[r_POSPays]
FOR DELETE AS
/* r_PosPays - Справочник платежных терминалов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PosPays ^ r_CRPOSPays - Проверка в CHILD */
/* Справочник платежных терминалов ^ Справочник ЭККА: Платежные терминалы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRPOSPays a WITH(NOLOCK), deleted d WHERE a.POSPayID = d.POSPayID)
    BEGIN
      EXEC z_RelationError 'r_PosPays', 'r_CRPOSPays', 3
      RETURN
    END

/* r_PosPays ^ t_CRRetPays - Проверка в CHILD */
/* Справочник платежных терминалов ^ Возврат товара по чеку: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetPays a WITH(NOLOCK), deleted d WHERE a.POSPayID = d.POSPayID)
    BEGIN
      EXEC z_RelationError 'r_PosPays', 't_CRRetPays', 3
      RETURN
    END

/* r_PosPays ^ t_SalePays - Проверка в CHILD */
/* Справочник платежных терминалов ^ Продажа товара оператором: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SalePays a WITH(NOLOCK), deleted d WHERE a.POSPayID = d.POSPayID)
    BEGIN
      EXEC z_RelationError 'r_PosPays', 't_SalePays', 3
      RETURN
    END

/* r_PosPays ^ t_SaleTempPays - Проверка в CHILD */
/* Справочник платежных терминалов ^ Временные данные продаж: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempPays a WITH(NOLOCK), deleted d WHERE a.POSPayID = d.POSPayID)
    BEGIN
      EXEC z_RelationError 'r_PosPays', 't_SaleTempPays', 3
      RETURN
    END

/* r_PosPays ^ t_ZRepT - Проверка в CHILD */
/* Справочник платежных терминалов ^ Z-отчеты плат. терминалов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ZRepT a WITH(NOLOCK), deleted d WHERE a.POSPayID = d.POSPayID)
    BEGIN
      EXEC z_RelationError 'r_PosPays', 't_ZRepT', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10457001 AND m.PKValue = 
    '[' + cast(i.POSPayID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10457001 AND m.PKValue = 
    '[' + cast(i.POSPayID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10457001, -ChID, 
    '[' + cast(d.POSPayID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10457 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_POSPays]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_POSPays] ADD CONSTRAINT [pk_r_POSPays] PRIMARY KEY CLUSTERED ([POSPayID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_POSPays] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [POSPayName] ON [dbo].[r_POSPays] ([POSPayName]) ON [PRIMARY]
GO
