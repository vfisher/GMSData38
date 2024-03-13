CREATE TABLE [dbo].[r_PayForms]
(
[ChID] [bigint] NOT NULL,
[PayFormCode] [int] NOT NULL,
[PayFormName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[SumLabel] [varchar] (50) NULL,
[NotesLabel] [varchar] (50) NULL,
[CanEnterNotes] [bit] NOT NULL,
[NotesMask] [varchar] (250) NULL,
[CanEnterSum] [bit] NOT NULL,
[MaxQty] [int] NOT NULL,
[IsDefault] [bit] NOT NULL,
[ForSale] [bit] NOT NULL,
[ForRet] [bit] NOT NULL,
[AutoCalcSum] [int] NOT NULL DEFAULT (0),
[DCTypeGCode] [int] NOT NULL DEFAULT (0),
[GroupPays] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_PayForms] ON [dbo].[r_PayForms]
FOR INSERT AS
/* r_PayForms - Справочник форм оплаты - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayForms ^ r_DCTypeG - Проверка в PARENT */
/* Справочник форм оплаты ^ Справочник дисконтных карт: группы типов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeGCode NOT IN (SELECT DCTypeGCode FROM r_DCTypeG))
    BEGIN
      EXEC z_RelationError 'r_DCTypeG', 'r_PayForms', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10440001, ChID, 
    '[' + cast(i.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_PayForms]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_PayForms] ON [dbo].[r_PayForms]
FOR UPDATE AS
/* r_PayForms - Справочник форм оплаты - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_PayForms ^ r_DCTypeG - Проверка в PARENT */
/* Справочник форм оплаты ^ Справочник дисконтных карт: группы типов - Проверка в PARENT */
  IF UPDATE(DCTypeGCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeGCode NOT IN (SELECT DCTypeGCode FROM r_DCTypeG))
      BEGIN
        EXEC z_RelationError 'r_DCTypeG', 'r_PayForms', 1
        RETURN
      END

/* r_PayForms ^ r_BServs - Обновление CHILD */
/* Справочник форм оплаты ^ Справочник банковских услуг - Обновление CHILD */
  IF UPDATE(PayFormCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayFormCode = i.PayFormCode
          FROM r_BServs a, inserted i, deleted d WHERE a.PayFormCode = d.PayFormCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_BServs a, deleted d WHERE a.PayFormCode = d.PayFormCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник форм оплаты'' => ''Справочник банковских услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayForms ^ t_CRRetPays - Обновление CHILD */
/* Справочник форм оплаты ^ Возврат товара по чеку: Оплата - Обновление CHILD */
  IF UPDATE(PayFormCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayFormCode = i.PayFormCode
          FROM t_CRRetPays a, inserted i, deleted d WHERE a.PayFormCode = d.PayFormCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetPays a, deleted d WHERE a.PayFormCode = d.PayFormCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник форм оплаты'' => ''Возврат товара по чеку: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayForms ^ t_SalePays - Обновление CHILD */
/* Справочник форм оплаты ^ Продажа товара оператором: Оплата - Обновление CHILD */
  IF UPDATE(PayFormCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayFormCode = i.PayFormCode
          FROM t_SalePays a, inserted i, deleted d WHERE a.PayFormCode = d.PayFormCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SalePays a, deleted d WHERE a.PayFormCode = d.PayFormCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник форм оплаты'' => ''Продажа товара оператором: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_PayForms ^ t_SaleTempPays - Обновление CHILD */
/* Справочник форм оплаты ^ Временные данные продаж: Оплата - Обновление CHILD */
  IF UPDATE(PayFormCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PayFormCode = i.PayFormCode
          FROM t_SaleTempPays a, inserted i, deleted d WHERE a.PayFormCode = d.PayFormCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempPays a, deleted d WHERE a.PayFormCode = d.PayFormCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник форм оплаты'' => ''Временные данные продаж: Оплата''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10440001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10440001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(PayFormCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10440001 AND l.PKValue = 
        '[' + cast(i.PayFormCode as varchar(200)) + ']' AND i.PayFormCode = d.PayFormCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10440001 AND l.PKValue = 
        '[' + cast(i.PayFormCode as varchar(200)) + ']' AND i.PayFormCode = d.PayFormCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10440001, ChID, 
          '[' + cast(d.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10440001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10440001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10440001, ChID, 
          '[' + cast(i.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(PayFormCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT PayFormCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT PayFormCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.PayFormCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10440001 AND l.PKValue = 
          '[' + cast(d.PayFormCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.PayFormCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10440001 AND l.PKValue = 
          '[' + cast(d.PayFormCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10440001, ChID, 
          '[' + cast(d.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10440001 AND PKValue IN (SELECT 
          '[' + cast(PayFormCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10440001 AND PKValue IN (SELECT 
          '[' + cast(PayFormCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10440001, ChID, 
          '[' + cast(i.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10440001, ChID, 
    '[' + cast(i.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_PayForms]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_PayForms] ON [dbo].[r_PayForms]
FOR DELETE AS
/* r_PayForms - Справочник форм оплаты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_PayForms ^ r_BServs - Проверка в CHILD */
/* Справочник форм оплаты ^ Справочник банковских услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_BServs a WITH(NOLOCK), deleted d WHERE a.PayFormCode = d.PayFormCode)
    BEGIN
      EXEC z_RelationError 'r_PayForms', 'r_BServs', 3
      RETURN
    END

/* r_PayForms ^ t_CRRetPays - Проверка в CHILD */
/* Справочник форм оплаты ^ Возврат товара по чеку: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetPays a WITH(NOLOCK), deleted d WHERE a.PayFormCode = d.PayFormCode)
    BEGIN
      EXEC z_RelationError 'r_PayForms', 't_CRRetPays', 3
      RETURN
    END

/* r_PayForms ^ t_SalePays - Проверка в CHILD */
/* Справочник форм оплаты ^ Продажа товара оператором: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SalePays a WITH(NOLOCK), deleted d WHERE a.PayFormCode = d.PayFormCode)
    BEGIN
      EXEC z_RelationError 'r_PayForms', 't_SalePays', 3
      RETURN
    END

/* r_PayForms ^ t_SaleTempPays - Проверка в CHILD */
/* Справочник форм оплаты ^ Временные данные продаж: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempPays a WITH(NOLOCK), deleted d WHERE a.PayFormCode = d.PayFormCode)
    BEGIN
      EXEC z_RelationError 'r_PayForms', 't_SaleTempPays', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10440001 AND m.PKValue = 
    '[' + cast(i.PayFormCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10440001 AND m.PKValue = 
    '[' + cast(i.PayFormCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10440001, -ChID, 
    '[' + cast(d.PayFormCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10440 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_PayForms]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_PayForms] ADD CONSTRAINT [pk_r_PayForms] PRIMARY KEY CLUSTERED ([PayFormCode]) ON [PRIMARY]
GO
