CREATE TABLE [dbo].[r_Secs] (
  [ChID] [bigint] NOT NULL,
  [SecID] [int] NOT NULL,
  [SecName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [CRSecID] [tinyint] NOT NULL,
  CONSTRAINT [pk_r_Secs] PRIMARY KEY CLUSTERED ([SecID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Secs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [SecName]
  ON [dbo].[r_Secs] ([SecName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Secs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Secs.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Secs.CRSecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Secs] ON [r_Secs]
FOR INSERT AS
/* r_Secs - Справочник секций - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10320001, ChID, 
    '[' + cast(i.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Secs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Secs] ON [r_Secs]
FOR UPDATE AS
/* r_Secs - Справочник секций - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Secs ^ r_CRMP - Обновление CHILD */
/* Справочник секций ^ Справочник ЭККА - Товары - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM r_CRMP a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRMP a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Справочник ЭККА - Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ r_CRs - Обновление CHILD */
/* Справочник секций ^ Справочник ЭККА - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM r_CRs a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRs a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Справочник ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_AccD - Обновление CHILD */
/* Справочник секций ^ Счет на оплату товара: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_AccD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_AccD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Счет на оплату товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_CRetD - Обновление CHILD */
/* Справочник секций ^ Возврат товара поставщику: Товары - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_CRetD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRetD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Возврат товара поставщику: Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_CRRetD - Обновление CHILD */
/* Справочник секций ^ Возврат товара по чеку: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_CRRetD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Возврат товара по чеку: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_CstD - Обновление CHILD */
/* Справочник секций ^ Приход товара по ГТД: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_CstD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CstD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Приход товара по ГТД: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_DisD - Обновление CHILD */
/* Справочник секций ^ Распределение товара: Данные - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_DisD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DisD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Распределение товара: Данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_DisDD - Обновление CHILD */
/* Справочник секций ^ Распределение товара: Подробно - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetSecID = i.SecID
          FROM t_DisDD a, inserted i, deleted d WHERE a.DetSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DisDD a, deleted d WHERE a.DetSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Распределение товара: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_EOExpD - Обновление CHILD */
/* Справочник секций ^ Заказ внешний: Формирование: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_EOExpD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Заказ внешний: Формирование: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_EOExpDD - Обновление CHILD */
/* Справочник секций ^ Заказ внешний: Формирование: Подробно - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetSecID = i.SecID
          FROM t_EOExpDD a, inserted i, deleted d WHERE a.DetSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpDD a, deleted d WHERE a.DetSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Заказ внешний: Формирование: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_EORecD - Обновление CHILD */
/* Справочник секций ^ Заказ внешний: Обработка: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_EORecD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORecD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Заказ внешний: Обработка: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_EppD - Обновление CHILD */
/* Справочник секций ^ Расходный документ в ценах прихода: Товары - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_EppD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EppD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Расходный документ в ценах прихода: Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_EstD - Обновление CHILD */
/* Справочник секций ^ Переоценка цен прихода: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_EstD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EstD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Переоценка цен прихода: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_ExcD - Обновление CHILD */
/* Справочник секций ^ Перемещение товара: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewSecID = i.SecID
          FROM t_ExcD a, inserted i, deleted d WHERE a.NewSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcD a, deleted d WHERE a.NewSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Перемещение товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_ExcD - Обновление CHILD */
/* Справочник секций ^ Перемещение товара: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_ExcD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Перемещение товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_ExpD - Обновление CHILD */
/* Справочник секций ^ Расходный документ: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_ExpD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExpD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Расходный документ: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_InvD - Обновление CHILD */
/* Справочник секций ^ Расходная накладная: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_InvD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_InvD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Расходная накладная: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_IOExpD - Обновление CHILD */
/* Справочник секций ^ Заказ внутренний: Обработка: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_IOExpD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExpD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Заказ внутренний: Обработка: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_IORecD - Обновление CHILD */
/* Справочник секций ^ Заказ внутренний: Формирование: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_IORecD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORecD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Заказ внутренний: Формирование: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_RecD - Обновление CHILD */
/* Справочник секций ^ Приход товара: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_RecD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RecD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Приход товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_Rem - Обновление CHILD */
/* Справочник секций ^ Остатки товара (Таблица) - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_Rem a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rem a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Остатки товара (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_RemD - Обновление CHILD */
/* Справочник секций ^ Остатки товара на дату (Таблица) - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_RemD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RemD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Остатки товара на дату (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_RetD - Обновление CHILD */
/* Справочник секций ^ Возврат товара от получателя: Товар - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_RetD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RetD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Возврат товара от получателя: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SaleD - Обновление CHILD */
/* Справочник секций ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_SaleD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SExpA - Обновление CHILD */
/* Справочник секций ^ Разукомплектация товара: Комплекты - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_SExpA a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpA a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Разукомплектация товара: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SExpD - Обновление CHILD */
/* Справочник секций ^ Разукомплектация товара: Составляющие - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubSecID = i.SecID
          FROM t_SExpD a, inserted i, deleted d WHERE a.SubSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpD a, deleted d WHERE a.SubSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Разукомплектация товара: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SPExpA - Обновление CHILD */
/* Справочник секций ^ Планирование: Разукомплектация: Комплекты - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_SPExpA a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpA a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Планирование: Разукомплектация: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SPExpD - Обновление CHILD */
/* Справочник секций ^ Планирование: Разукомплектация: Составляющие - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubSecID = i.SecID
          FROM t_SPExpD a, inserted i, deleted d WHERE a.SubSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpD a, deleted d WHERE a.SubSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Планирование: Разукомплектация: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SPRecA - Обновление CHILD */
/* Справочник секций ^ Планирование: Комплектация: Комплекты - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_SPRecA a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecA a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Планирование: Комплектация: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SPRecD - Обновление CHILD */
/* Справочник секций ^ Планирование: Комплектация: Составляющие - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubSecID = i.SecID
          FROM t_SPRecD a, inserted i, deleted d WHERE a.SubSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecD a, deleted d WHERE a.SubSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Планирование: Комплектация: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SRecA - Обновление CHILD */
/* Справочник секций ^ Комплектация товара: Комплекты - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_SRecA a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecA a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Комплектация товара: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_SRecD - Обновление CHILD */
/* Справочник секций ^ Комплектация товара: Составляющие - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubSecID = i.SecID
          FROM t_SRecD a, inserted i, deleted d WHERE a.SubSecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecD a, deleted d WHERE a.SubSecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Комплектация товара: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_VenD - Обновление CHILD */
/* Справочник секций ^ Инвентаризация товара: Партии - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_VenD a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_VenD a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Инвентаризация товара: Партии''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ t_zInP - Обновление CHILD */
/* Справочник секций ^ Входящие остатки товара - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SecID = i.SecID
          FROM t_zInP a, inserted i, deleted d WHERE a.SecID = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_zInP a, deleted d WHERE a.SecID = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Входящие остатки товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ z_UserVars - Обновление CHILD */
/* Справочник секций ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_SecID', a.VarValue = i.SecID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 't_SecID' AND a.VarValue = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 't_SecID' AND a.VarValue = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Secs ^ z_Vars - Обновление CHILD */
/* Справочник секций ^ Системные переменные - Обновление CHILD */
  IF UPDATE(SecID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_SecID', a.VarValue = i.SecID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 't_SecID' AND a.VarValue = d.SecID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 't_SecID' AND a.VarValue = d.SecID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник секций'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10320001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10320001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(SecID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10320001 AND l.PKValue = 
        '[' + cast(i.SecID as varchar(200)) + ']' AND i.SecID = d.SecID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10320001 AND l.PKValue = 
        '[' + cast(i.SecID as varchar(200)) + ']' AND i.SecID = d.SecID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10320001, ChID, 
          '[' + cast(d.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10320001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10320001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10320001, ChID, 
          '[' + cast(i.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(SecID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SecID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SecID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SecID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10320001 AND l.PKValue = 
          '[' + cast(d.SecID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SecID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10320001 AND l.PKValue = 
          '[' + cast(d.SecID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10320001, ChID, 
          '[' + cast(d.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10320001 AND PKValue IN (SELECT 
          '[' + cast(SecID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10320001 AND PKValue IN (SELECT 
          '[' + cast(SecID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10320001, ChID, 
          '[' + cast(i.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10320001, ChID, 
    '[' + cast(i.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Secs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Secs] ON [r_Secs]
FOR DELETE AS
/* r_Secs - Справочник секций - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Secs ^ r_CRMP - Проверка в CHILD */
/* Справочник секций ^ Справочник ЭККА - Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRMP a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 'r_CRMP', 3
      RETURN
    END

/* r_Secs ^ r_CRs - Проверка в CHILD */
/* Справочник секций ^ Справочник ЭККА - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRs a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 'r_CRs', 3
      RETURN
    END

/* r_Secs ^ t_AccD - Проверка в CHILD */
/* Справочник секций ^ Счет на оплату товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_AccD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_AccD', 3
      RETURN
    END

/* r_Secs ^ t_CRetD - Проверка в CHILD */
/* Справочник секций ^ Возврат товара поставщику: Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRetD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_CRetD', 3
      RETURN
    END

/* r_Secs ^ t_CRRetD - Проверка в CHILD */
/* Справочник секций ^ Возврат товара по чеку: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_CRRetD', 3
      RETURN
    END

/* r_Secs ^ t_CstD - Проверка в CHILD */
/* Справочник секций ^ Приход товара по ГТД: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CstD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_CstD', 3
      RETURN
    END

/* r_Secs ^ t_DisD - Проверка в CHILD */
/* Справочник секций ^ Распределение товара: Данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DisD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_DisD', 3
      RETURN
    END

/* r_Secs ^ t_DisDD - Проверка в CHILD */
/* Справочник секций ^ Распределение товара: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DisDD a WITH(NOLOCK), deleted d WHERE a.DetSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_DisDD', 3
      RETURN
    END

/* r_Secs ^ t_EOExpD - Проверка в CHILD */
/* Справочник секций ^ Заказ внешний: Формирование: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EOExpD', 3
      RETURN
    END

/* r_Secs ^ t_EOExpDD - Проверка в CHILD */
/* Справочник секций ^ Заказ внешний: Формирование: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpDD a WITH(NOLOCK), deleted d WHERE a.DetSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EOExpDD', 3
      RETURN
    END

/* r_Secs ^ t_EORecD - Проверка в CHILD */
/* Справочник секций ^ Заказ внешний: Обработка: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORecD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EORecD', 3
      RETURN
    END

/* r_Secs ^ t_EppD - Проверка в CHILD */
/* Справочник секций ^ Расходный документ в ценах прихода: Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EppD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EppD', 3
      RETURN
    END

/* r_Secs ^ t_EstD - Проверка в CHILD */
/* Справочник секций ^ Переоценка цен прихода: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EstD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EstD', 3
      RETURN
    END

/* r_Secs ^ t_ExcD - Проверка в CHILD */
/* Справочник секций ^ Перемещение товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExcD a WITH(NOLOCK), deleted d WHERE a.NewSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_ExcD', 3
      RETURN
    END

/* r_Secs ^ t_ExcD - Проверка в CHILD */
/* Справочник секций ^ Перемещение товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExcD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_ExcD', 3
      RETURN
    END

/* r_Secs ^ t_ExpD - Проверка в CHILD */
/* Справочник секций ^ Расходный документ: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ExpD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_ExpD', 3
      RETURN
    END

/* r_Secs ^ t_InvD - Проверка в CHILD */
/* Справочник секций ^ Расходная накладная: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_InvD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_InvD', 3
      RETURN
    END

/* r_Secs ^ t_IOExpD - Проверка в CHILD */
/* Справочник секций ^ Заказ внутренний: Обработка: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExpD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_IOExpD', 3
      RETURN
    END

/* r_Secs ^ t_IORecD - Проверка в CHILD */
/* Справочник секций ^ Заказ внутренний: Формирование: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORecD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_IORecD', 3
      RETURN
    END

/* r_Secs ^ t_RecD - Проверка в CHILD */
/* Справочник секций ^ Приход товара: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RecD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_RecD', 3
      RETURN
    END

/* r_Secs ^ t_Rem - Проверка в CHILD */
/* Справочник секций ^ Остатки товара (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rem a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_Rem', 3
      RETURN
    END

/* r_Secs ^ t_RemD - Проверка в CHILD */
/* Справочник секций ^ Остатки товара на дату (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RemD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_RemD', 3
      RETURN
    END

/* r_Secs ^ t_RetD - Проверка в CHILD */
/* Справочник секций ^ Возврат товара от получателя: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RetD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_RetD', 3
      RETURN
    END

/* r_Secs ^ t_SaleD - Проверка в CHILD */
/* Справочник секций ^ Продажа товара оператором: Продажи товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SaleD', 3
      RETURN
    END

/* r_Secs ^ t_SExpA - Проверка в CHILD */
/* Справочник секций ^ Разукомплектация товара: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExpA a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SExpA', 3
      RETURN
    END

/* r_Secs ^ t_SExpD - Проверка в CHILD */
/* Справочник секций ^ Разукомплектация товара: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExpD a WITH(NOLOCK), deleted d WHERE a.SubSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SExpD', 3
      RETURN
    END

/* r_Secs ^ t_SPExpA - Проверка в CHILD */
/* Справочник секций ^ Планирование: Разукомплектация: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExpA a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SPExpA', 3
      RETURN
    END

/* r_Secs ^ t_SPExpD - Проверка в CHILD */
/* Справочник секций ^ Планирование: Разукомплектация: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExpD a WITH(NOLOCK), deleted d WHERE a.SubSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SPExpD', 3
      RETURN
    END

/* r_Secs ^ t_SPRecA - Проверка в CHILD */
/* Справочник секций ^ Планирование: Комплектация: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRecA a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SPRecA', 3
      RETURN
    END

/* r_Secs ^ t_SPRecD - Проверка в CHILD */
/* Справочник секций ^ Планирование: Комплектация: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRecD a WITH(NOLOCK), deleted d WHERE a.SubSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SPRecD', 3
      RETURN
    END

/* r_Secs ^ t_SRecA - Проверка в CHILD */
/* Справочник секций ^ Комплектация товара: Комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRecA a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SRecA', 3
      RETURN
    END

/* r_Secs ^ t_SRecD - Проверка в CHILD */
/* Справочник секций ^ Комплектация товара: Составляющие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRecD a WITH(NOLOCK), deleted d WHERE a.SubSecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SRecD', 3
      RETURN
    END

/* r_Secs ^ t_VenD - Проверка в CHILD */
/* Справочник секций ^ Инвентаризация товара: Партии - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenD a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_VenD', 3
      RETURN
    END

/* r_Secs ^ t_zInP - Проверка в CHILD */
/* Справочник секций ^ Входящие остатки товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zInP a WITH(NOLOCK), deleted d WHERE a.SecID = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_zInP', 3
      RETURN
    END

/* r_Secs ^ z_UserVars - Проверка в CHILD */
/* Справочник секций ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_SecID' AND a.VarValue = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 'z_UserVars', 3
      RETURN
    END

/* r_Secs ^ z_Vars - Проверка в CHILD */
/* Справочник секций ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_SecID' AND a.VarValue = d.SecID)
    BEGIN
      EXEC z_RelationError 'r_Secs', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10320001 AND m.PKValue = 
    '[' + cast(i.SecID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10320001 AND m.PKValue = 
    '[' + cast(i.SecID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10320001, -ChID, 
    '[' + cast(d.SecID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10320 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Secs', N'Last', N'DELETE'
GO