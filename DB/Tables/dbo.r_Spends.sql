CREATE TABLE [dbo].[r_Spends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendName] [varchar] (250) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Spends] ON [dbo].[r_Spends]
FOR INSERT AS
/* r_Spends - Справочник затрат - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10180001, ChID, 
    '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Spends]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Spends] ON [dbo].[r_Spends]
FOR UPDATE AS
/* r_Spends - Справочник затрат - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Spends ^ t_AccSpends - Обновление CHILD */
/* Справочник затрат ^ Счет на оплату товара: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_AccSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_AccSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Счет на оплату товара: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_CosSpends - Обновление CHILD */
/* Справочник затрат ^ Формирование себестоимости: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_CosSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CosSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Формирование себестоимости: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_CRetSpends - Обновление CHILD */
/* Справочник затрат ^ Возврат товара поставщику: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_CRetSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRetSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Возврат товара поставщику: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_CstSpends - Обновление CHILD */
/* Справочник затрат ^ Приход товара по ГТД: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_CstSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CstSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Приход товара по ГТД: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_DisSpends - Обновление CHILD */
/* Справочник затрат ^ Распределение товара: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_DisSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DisSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Распределение товара: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_EOExpSpends - Обновление CHILD */
/* Справочник затрат ^ Заказ внешний: Формирование: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_EOExpSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Заказ внешний: Формирование: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_EORecSpends - Обновление CHILD */
/* Справочник затрат ^ Заказ внешний: Обработка: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_EORecSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORecSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Заказ внешний: Обработка: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_EppSpends - Обновление CHILD */
/* Справочник затрат ^ Расходный документ в ценах прихода: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_EppSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EppSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Расходный документ в ценах прихода: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_ExcSpends - Обновление CHILD */
/* Справочник затрат ^ Перемещение товара: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_ExcSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Перемещение товара: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_ExpSpends - Обновление CHILD */
/* Справочник затрат ^ Расходный документ: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_ExpSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExpSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Расходный документ: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_InvSpends - Обновление CHILD */
/* Справочник затрат ^ Расходная накладная: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_InvSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_InvSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Расходная накладная: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_IOExpSpends - Обновление CHILD */
/* Справочник затрат ^ Заказ внутренний: Обработка: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_IOExpSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExpSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Заказ внутренний: Обработка: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_IORecSpends - Обновление CHILD */
/* Справочник затрат ^ Заказ внутренний: Формирование: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_IORecSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORecSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Заказ внутренний: Формирование: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_RecSpends - Обновление CHILD */
/* Справочник затрат ^ Приход товара: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_RecSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RecSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Приход товара: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Spends ^ t_RetSpends - Обновление CHILD */
/* Справочник затрат ^ Возврат товара от получателя: Затраты - Обновление CHILD */
  IF UPDATE(SpendCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SpendCode = i.SpendCode
          FROM t_RetSpends a, inserted i, deleted d WHERE a.SpendCode = d.SpendCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RetSpends a, deleted d WHERE a.SpendCode = d.SpendCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник затрат'' => ''Возврат товара от получателя: Затраты''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10180001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10180001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(SpendCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10180001 AND l.PKValue = 
        '[' + cast(i.SpendCode as varchar(200)) + ']' AND i.SpendCode = d.SpendCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10180001 AND l.PKValue = 
        '[' + cast(i.SpendCode as varchar(200)) + ']' AND i.SpendCode = d.SpendCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10180001, ChID, 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10180001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10180001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10180001, ChID, 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(SpendCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SpendCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SpendCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10180001 AND l.PKValue = 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10180001 AND l.PKValue = 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10180001, ChID, 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10180001 AND PKValue IN (SELECT 
          '[' + cast(SpendCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10180001 AND PKValue IN (SELECT 
          '[' + cast(SpendCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10180001, ChID, 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10180001, ChID, 
    '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Spends]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Spends] ON [dbo].[r_Spends]
FOR DELETE AS
/* r_Spends - Справочник затрат - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Spends ^ t_AccSpends - Проверка в CHILD */
/* Справочник затрат ^ Счет на оплату товара: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_AccSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_AccSpends', 3
      RETURN
    END

/* r_Spends ^ t_CosSpends - Проверка в CHILD */
/* Справочник затрат ^ Формирование себестоимости: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CosSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_CosSpends', 3
      RETURN
    END

/* r_Spends ^ t_CRetSpends - Проверка в CHILD */
/* Справочник затрат ^ Возврат товара поставщику: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRetSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_CRetSpends', 3
      RETURN
    END

/* r_Spends ^ t_CstSpends - Проверка в CHILD */
/* Справочник затрат ^ Приход товара по ГТД: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CstSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_CstSpends', 3
      RETURN
    END

/* r_Spends ^ t_DisSpends - Проверка в CHILD */
/* Справочник затрат ^ Распределение товара: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DisSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_DisSpends', 3
      RETURN
    END

/* r_Spends ^ t_EOExpSpends - Проверка в CHILD */
/* Справочник затрат ^ Заказ внешний: Формирование: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_EOExpSpends', 3
      RETURN
    END

/* r_Spends ^ t_EORecSpends - Проверка в CHILD */
/* Справочник затрат ^ Заказ внешний: Обработка: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORecSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_EORecSpends', 3
      RETURN
    END

/* r_Spends ^ t_EppSpends - Проверка в CHILD */
/* Справочник затрат ^ Расходный документ в ценах прихода: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EppSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_EppSpends', 3
      RETURN
    END

/* r_Spends ^ t_ExcSpends - Проверка в CHILD */
/* Справочник затрат ^ Перемещение товара: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExcSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_ExcSpends', 3
      RETURN
    END

/* r_Spends ^ t_ExpSpends - Проверка в CHILD */
/* Справочник затрат ^ Расходный документ: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExpSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_ExpSpends', 3
      RETURN
    END

/* r_Spends ^ t_InvSpends - Проверка в CHILD */
/* Справочник затрат ^ Расходная накладная: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_InvSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_InvSpends', 3
      RETURN
    END

/* r_Spends ^ t_IOExpSpends - Проверка в CHILD */
/* Справочник затрат ^ Заказ внутренний: Обработка: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExpSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_IOExpSpends', 3
      RETURN
    END

/* r_Spends ^ t_IORecSpends - Проверка в CHILD */
/* Справочник затрат ^ Заказ внутренний: Формирование: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORecSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_IORecSpends', 3
      RETURN
    END

/* r_Spends ^ t_RecSpends - Проверка в CHILD */
/* Справочник затрат ^ Приход товара: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RecSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_RecSpends', 3
      RETURN
    END

/* r_Spends ^ t_RetSpends - Проверка в CHILD */
/* Справочник затрат ^ Возврат товара от получателя: Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RetSpends a WITH(NOLOCK), deleted d WHERE a.SpendCode = d.SpendCode)
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_RetSpends', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10180001 AND m.PKValue = 
    '[' + cast(i.SpendCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10180001 AND m.PKValue = 
    '[' + cast(i.SpendCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10180001, -ChID, 
    '[' + cast(d.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10180 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Spends]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Spends] ADD CONSTRAINT [pk_r_Spends] PRIMARY KEY CLUSTERED ([SpendCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Spends] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [SpendName] ON [dbo].[r_Spends] ([SpendName]) ON [PRIMARY]
GO
