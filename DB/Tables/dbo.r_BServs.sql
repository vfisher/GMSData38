CREATE TABLE [dbo].[r_BServs]
(
[ChID] [bigint] NOT NULL,
[BServID] [int] NOT NULL,
[BServName] [varchar] (200) NOT NULL,
[BankGrID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PayFormCode] [int] NOT NULL,
[POSBServID] [int] NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_BServs] ON [dbo].[r_BServs]
FOR INSERT AS
/* r_BServs - Справочник банковских услуг - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_BServs ^ r_BankGrs - Проверка в PARENT */
/* Справочник банковских услуг ^ Справочник банков - группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankGrID NOT IN (SELECT BankGrID FROM r_BankGrs))
    BEGIN
      EXEC z_RelationError 'r_BankGrs', 'r_BServs', 0
      RETURN
    END

/* r_BServs ^ r_PayForms - Проверка в PARENT */
/* Справочник банковских услуг ^ Справочник форм оплаты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PayFormCode NOT IN (SELECT PayFormCode FROM r_PayForms))
    BEGIN
      EXEC z_RelationError 'r_PayForms', 'r_BServs', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_BServs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_BServs] ON [dbo].[r_BServs]
FOR UPDATE AS
/* r_BServs - Справочник банковских услуг - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_BServs ^ r_BankGrs - Проверка в PARENT */
/* Справочник банковских услуг ^ Справочник банков - группы - Проверка в PARENT */
  IF UPDATE(BankGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankGrID NOT IN (SELECT BankGrID FROM r_BankGrs))
      BEGIN
        EXEC z_RelationError 'r_BankGrs', 'r_BServs', 1
        RETURN
      END

/* r_BServs ^ r_PayForms - Проверка в PARENT */
/* Справочник банковских услуг ^ Справочник форм оплаты - Проверка в PARENT */
  IF UPDATE(PayFormCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PayFormCode NOT IN (SELECT PayFormCode FROM r_PayForms))
      BEGIN
        EXEC z_RelationError 'r_PayForms', 'r_BServs', 1
        RETURN
      END

/* r_BServs ^ r_BServParams - Обновление CHILD */
/* Справочник банковских услуг ^ Справочник банковских услуг: параметры - Обновление CHILD */
  IF UPDATE(BServID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BServID = i.BServID
          FROM r_BServParams a, inserted i, deleted d WHERE a.BServID = d.BServID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_BServParams a, deleted d WHERE a.BServID = d.BServID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банковских услуг'' => ''Справочник банковских услуг: параметры''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_BServs ^ t_CRRetPays - Обновление CHILD */
/* Справочник банковских услуг ^ Возврат товара по чеку: Оплата - Обновление CHILD */
  IF UPDATE(BServID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BServID = i.BServID
          FROM t_CRRetPays a, inserted i, deleted d WHERE a.BServID = d.BServID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetPays a, deleted d WHERE a.BServID = d.BServID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банковских услуг'' => ''Возврат товара по чеку: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_BServs ^ t_SalePays - Обновление CHILD */
/* Справочник банковских услуг ^ Продажа товара оператором: Оплата - Обновление CHILD */
  IF UPDATE(BServID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BServID = i.BServID
          FROM t_SalePays a, inserted i, deleted d WHERE a.BServID = d.BServID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SalePays a, deleted d WHERE a.BServID = d.BServID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банковских услуг'' => ''Продажа товара оператором: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_BServs ^ t_SaleTempPays - Обновление CHILD */
/* Справочник банковских услуг ^ Временные данные продаж: Оплата - Обновление CHILD */
  IF UPDATE(BServID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.BServID = i.BServID
          FROM t_SaleTempPays a, inserted i, deleted d WHERE a.BServID = d.BServID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempPays a, deleted d WHERE a.BServID = d.BServID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник банковских услуг'' => ''Временные данные продаж: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_BServs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_BServs] ON [dbo].[r_BServs]
FOR DELETE AS
/* r_BServs - Справочник банковских услуг - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_BServs ^ r_BServParams - Проверка в CHILD */
/* Справочник банковских услуг ^ Справочник банковских услуг: параметры - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_BServParams a WITH(NOLOCK), deleted d WHERE a.BServID = d.BServID)
    BEGIN
      EXEC z_RelationError 'r_BServs', 'r_BServParams', 3
      RETURN
    END

/* r_BServs ^ t_CRRetPays - Проверка в CHILD */
/* Справочник банковских услуг ^ Возврат товара по чеку: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetPays a WITH(NOLOCK), deleted d WHERE a.BServID = d.BServID)
    BEGIN
      EXEC z_RelationError 'r_BServs', 't_CRRetPays', 3
      RETURN
    END

/* r_BServs ^ t_SalePays - Проверка в CHILD */
/* Справочник банковских услуг ^ Продажа товара оператором: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SalePays a WITH(NOLOCK), deleted d WHERE a.BServID = d.BServID)
    BEGIN
      EXEC z_RelationError 'r_BServs', 't_SalePays', 3
      RETURN
    END

/* r_BServs ^ t_SaleTempPays - Проверка в CHILD */
/* Справочник банковских услуг ^ Временные данные продаж: Оплата - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempPays a WITH(NOLOCK), deleted d WHERE a.BServID = d.BServID)
    BEGIN
      EXEC z_RelationError 'r_BServs', 't_SaleTempPays', 3
      RETURN
    END

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10103 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_BServs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_BServs] ADD CONSTRAINT [pk_r_BServs] PRIMARY KEY CLUSTERED ([BServID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BServName] ON [dbo].[r_BServs] ([BServName]) ON [PRIMARY]
GO
