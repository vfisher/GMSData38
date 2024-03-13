CREATE TABLE [dbo].[r_Levies]
(
[LevyID] [int] NOT NULL,
[LevyName] [varchar] (50) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Levies] ON [dbo].[r_Levies]
FOR UPDATE AS
/* r_Levies - Справочник сборов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Levies ^ r_ProdLV - Обновление CHILD */
/* Справочник сборов ^ Справочник товаров - Сборы - Обновление CHILD */
  IF UPDATE(LevyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LevyID = i.LevyID
          FROM r_ProdLV a, inserted i, deleted d WHERE a.LevyID = d.LevyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdLV a, deleted d WHERE a.LevyID = d.LevyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник сборов'' => ''Справочник товаров - Сборы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Levies ^ b_ExpDLV - Обновление CHILD */
/* Справочник сборов ^ ТМЦ: Внутренний расход (Сборы по товару) - Обновление CHILD */
  IF UPDATE(LevyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LevyID = i.LevyID
          FROM b_ExpDLV a, inserted i, deleted d WHERE a.LevyID = d.LevyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ExpDLV a, deleted d WHERE a.LevyID = d.LevyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник сборов'' => ''ТМЦ: Внутренний расход (Сборы по товару)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Levies ^ b_InvDLV - Обновление CHILD */
/* Справочник сборов ^ ТМЦ: Расходная накладная (Сборы по товару) - Обновление CHILD */
  IF UPDATE(LevyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LevyID = i.LevyID
          FROM b_InvDLV a, inserted i, deleted d WHERE a.LevyID = d.LevyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_InvDLV a, deleted d WHERE a.LevyID = d.LevyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник сборов'' => ''ТМЦ: Расходная накладная (Сборы по товару)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Levies ^ b_RetDLV - Обновление CHILD */
/* Справочник сборов ^ ТМЦ: Возврат от получателя (Сборы по товару) - Обновление CHILD */
  IF UPDATE(LevyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LevyID = i.LevyID
          FROM b_RetDLV a, inserted i, deleted d WHERE a.LevyID = d.LevyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RetDLV a, deleted d WHERE a.LevyID = d.LevyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник сборов'' => ''ТМЦ: Возврат от получателя (Сборы по товару)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Levies ^ t_CRRetDLV - Обновление CHILD */
/* Справочник сборов ^ Возврат товара по чеку: Сборы по товару - Обновление CHILD */
  IF UPDATE(LevyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LevyID = i.LevyID
          FROM t_CRRetDLV a, inserted i, deleted d WHERE a.LevyID = d.LevyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetDLV a, deleted d WHERE a.LevyID = d.LevyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник сборов'' => ''Возврат товара по чеку: Сборы по товару''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Levies ^ t_SaleDLV - Обновление CHILD */
/* Справочник сборов ^ Продажа товара оператором: Сборы по товару - Обновление CHILD */
  IF UPDATE(LevyID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.LevyID = i.LevyID
          FROM t_SaleDLV a, inserted i, deleted d WHERE a.LevyID = d.LevyID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleDLV a, deleted d WHERE a.LevyID = d.LevyID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник сборов'' => ''Продажа товара оператором: Сборы по товару''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Levies]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Levies] ON [dbo].[r_Levies]
FOR DELETE AS
/* r_Levies - Справочник сборов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Levies ^ r_ProdLV - Проверка в CHILD */
/* Справочник сборов ^ Справочник товаров - Сборы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdLV a WITH(NOLOCK), deleted d WHERE a.LevyID = d.LevyID)
    BEGIN
      EXEC z_RelationError 'r_Levies', 'r_ProdLV', 3
      RETURN
    END

/* r_Levies ^ b_ExpDLV - Проверка в CHILD */
/* Справочник сборов ^ ТМЦ: Внутренний расход (Сборы по товару) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ExpDLV a WITH(NOLOCK), deleted d WHERE a.LevyID = d.LevyID)
    BEGIN
      EXEC z_RelationError 'r_Levies', 'b_ExpDLV', 3
      RETURN
    END

/* r_Levies ^ b_InvDLV - Проверка в CHILD */
/* Справочник сборов ^ ТМЦ: Расходная накладная (Сборы по товару) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_InvDLV a WITH(NOLOCK), deleted d WHERE a.LevyID = d.LevyID)
    BEGIN
      EXEC z_RelationError 'r_Levies', 'b_InvDLV', 3
      RETURN
    END

/* r_Levies ^ b_RetDLV - Проверка в CHILD */
/* Справочник сборов ^ ТМЦ: Возврат от получателя (Сборы по товару) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RetDLV a WITH(NOLOCK), deleted d WHERE a.LevyID = d.LevyID)
    BEGIN
      EXEC z_RelationError 'r_Levies', 'b_RetDLV', 3
      RETURN
    END

/* r_Levies ^ t_CRRetDLV - Проверка в CHILD */
/* Справочник сборов ^ Возврат товара по чеку: Сборы по товару - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetDLV a WITH(NOLOCK), deleted d WHERE a.LevyID = d.LevyID)
    BEGIN
      EXEC z_RelationError 'r_Levies', 't_CRRetDLV', 3
      RETURN
    END

/* r_Levies ^ t_SaleDLV - Проверка в CHILD */
/* Справочник сборов ^ Продажа товара оператором: Сборы по товару - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleDLV a WITH(NOLOCK), deleted d WHERE a.LevyID = d.LevyID)
    BEGIN
      EXEC z_RelationError 'r_Levies', 't_SaleDLV', 3
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Levies]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Levies] ADD CONSTRAINT [pk_r_Levies] PRIMARY KEY CLUSTERED ([LevyID]) ON [PRIMARY]
GO
