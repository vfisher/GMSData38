CREATE TABLE [dbo].[r_Codes4] (
  [ChID] [bigint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeName4] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_Codes4] PRIMARY KEY CLUSTERED ([CodeID4])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Codes4] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CodeName4]
  ON [dbo].[r_Codes4] ([CodeName4])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Codes4.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Codes4.CodeID4'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Codes4] ON [r_Codes4]
FOR INSERT AS
/* r_Codes4 - Справочник признаков 4 - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10154001, ChID, 
    '[' + cast(i.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Codes4', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Codes4] ON [r_Codes4]
FOR UPDATE AS
/* r_Codes4 - Справочник признаков 4 - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Codes4 ^ r_CRMM - Обновление CHILD */
/* Справочник признаков 4 ^ Справочник ЭККА - Виды служебных операций - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM r_CRMM a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRMM a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Справочник ЭККА - Виды служебных операций''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ r_ProdME - Обновление CHILD */
/* Справочник признаков 4 ^ Справочник товаров - Затраты на комплекты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM r_ProdME a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdME a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Справочник товаров - Затраты на комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ r_GOperD - Обновление CHILD */
/* Справочник признаков 4 ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CodeID4 = i.CodeID4
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ r_GOperD - Обновление CHILD */
/* Справочник признаков 4 ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CodeID4 = i.CodeID4
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ r_Comps - Обновление CHILD */
/* Справочник признаков 4 ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM r_Comps a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Справочник предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ r_GAccs - Обновление CHILD */
/* Справочник признаков 4 ^ План счетов - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_CodeID4 = i.CodeID4
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_AExp - Обновление CHILD */
/* Справочник признаков 4 ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_AExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_ARec - Обновление CHILD */
/* Справочник признаков 4 ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_ARec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_ARepADP - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет валютный (ТМЦ) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCodeID4 = i.CodeID4
          FROM b_ARepADP a, inserted i, deleted d WHERE a.PCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADP a, deleted d WHERE a.PCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет валютный (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_ARepADS - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет валютный (Основные средства) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ACodeID4 = i.CodeID4
          FROM b_ARepADS a, inserted i, deleted d WHERE a.ACodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADS a, deleted d WHERE a.ACodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет валютный (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_ARepADV - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет валютный (Общие) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VCodeID4 = i.CodeID4
          FROM b_ARepADV a, inserted i, deleted d WHERE a.VCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADV a, deleted d WHERE a.VCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет валютный (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_BankExpAC - Обновление CHILD */
/* Справочник признаков 4 ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_BankExpCC - Обновление CHILD */
/* Справочник признаков 4 ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_BankPayAC - Обновление CHILD */
/* Справочник признаков 4 ^ Валютное платежное поручение - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_BankPayAC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayAC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Валютное платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_BankPayCC - Обновление CHILD */
/* Справочник признаков 4 ^ Платежное поручение - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_BankPayCC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayCC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_BankRecAC - Обновление CHILD */
/* Справочник признаков 4 ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_BankRecCC - Обновление CHILD */
/* Справочник признаков 4 ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CExp - Обновление CHILD */
/* Справочник признаков 4 ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_CExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CInv - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_CInv a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CRec - Обновление CHILD */
/* Справочник признаков 4 ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_CRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CRepADP - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет с признаками (ТМЦ) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCodeID4 = i.CodeID4
          FROM b_CRepADP a, inserted i, deleted d WHERE a.PCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADP a, deleted d WHERE a.PCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет с признаками (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CRepADS - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет с признаками (Основные средства) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ACodeID4 = i.CodeID4
          FROM b_CRepADS a, inserted i, deleted d WHERE a.ACodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADS a, deleted d WHERE a.ACodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет с признаками (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CRepADV - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет с признаками (Общие) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VCodeID4 = i.CodeID4
          FROM b_CRepADV a, inserted i, deleted d WHERE a.VCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADV a, deleted d WHERE a.VCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет с признаками (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_CRet - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_CRet a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_Cst - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_Cst a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_DStack - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_DStack a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_Exp - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_Exp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_GTranD - Обновление CHILD */
/* Справочник признаков 4 ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CodeID4 = i.CodeID4
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_GTranD - Обновление CHILD */
/* Справочник признаков 4 ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CodeID4 = i.CodeID4
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_Inv - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_Inv a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_LExp - Обновление CHILD */
/* Справочник признаков 4 ^ Зарплата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_LExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Зарплата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_LRec - Обновление CHILD */
/* Справочник признаков 4 ^ Зарплата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_LRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Зарплата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_PAcc - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_PAcc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_PCost - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_PCost a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_PEst - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Переоценка партий (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_PEst a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEst a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Переоценка партий (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_PExc - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_PExc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_PVen - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_PVen a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_Rec - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_Rec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_RepA - Обновление CHILD */
/* Справочник признаков 4 ^ Авансовый отчет (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_RepA a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepA a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Авансовый отчет (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_Ret - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_Ret a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SDep - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Амортизация: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SDep a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDep a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Амортизация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SExc - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SExc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SExp - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SInv - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SInv a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SPut - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SPut a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPut a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Ввод в эксплуатацию (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SRec - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SRepDP - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Ремонт (ТМЦ) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PCodeID4 = i.CodeID4
          FROM b_SRepDP a, inserted i, deleted d WHERE a.PCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRepDP a, deleted d WHERE a.PCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Ремонт (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SRepDV - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Ремонт (Общие затраты) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VCodeID4 = i.CodeID4
          FROM b_SRepDV a, inserted i, deleted d WHERE a.VCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRepDV a, deleted d WHERE a.VCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Ремонт (Общие затраты)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SVen - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Инвентаризация - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SVen a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVen a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Инвентаризация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_SWer - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Износ (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_SWer a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWer a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Износ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TExp - Обновление CHILD */
/* Справочник признаков 4 ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranC - Обновление CHILD */
/* Справочник признаков 4 ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TranC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranE - Обновление CHILD */
/* Справочник признаков 4 ^ Проводка по служащему - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TranE a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranE a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Проводка по служащему''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranH - Обновление CHILD */
/* Справочник признаков 4 ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CodeID4 = i.CodeID4
          FROM b_TranH a, inserted i, deleted d WHERE a.C_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranH - Обновление CHILD */
/* Справочник признаков 4 ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CodeID4 = i.CodeID4
          FROM b_TranH a, inserted i, deleted d WHERE a.D_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranP - Обновление CHILD */
/* Справочник признаков 4 ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TranP a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranS - Обновление CHILD */
/* Справочник признаков 4 ^ Основные средства: Проводка - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TranS a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranS a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Основные средства: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TranV - Обновление CHILD */
/* Справочник признаков 4 ^ Проводка общая - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TranV a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranV a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Проводка общая''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_TRec - Обновление CHILD */
/* Справочник признаков 4 ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_TRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_WBill - Обновление CHILD */
/* Справочник признаков 4 ^ Путевой лист - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_WBill a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInBA - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Валютный счет - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInBA a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBA a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Валютный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInBC - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Расчетный счет - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInBC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Расчетный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInC - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Предприятия - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInC a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInC a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInCA - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Касса - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInCA a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInCA a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Касса''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInE - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Служащие - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInE a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInE a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Служащие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInH - Обновление CHILD */
/* Справочник признаков 4 ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_CodeID4 = i.CodeID4
          FROM b_zInH a, inserted i, deleted d WHERE a.C_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInH - Обновление CHILD */
/* Справочник признаков 4 ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_CodeID4 = i.CodeID4
          FROM b_zInH a, inserted i, deleted d WHERE a.D_CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInP - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: ТМЦ - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInP a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInP a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: ТМЦ''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInS - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Основные средства - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInS a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInS a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Основные средства''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ b_zInV - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Общие данные - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM b_zInV a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInV a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Общие данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_CompCor - Обновление CHILD */
/* Справочник признаков 4 ^ Корректировка баланса предприятия - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_CompCor a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCor a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Корректировка баланса предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_CompCurr - Обновление CHILD */
/* Справочник признаков 4 ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_CompCurr a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_CompExp - Обновление CHILD */
/* Справочник признаков 4 ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_CompExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_CompIn - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Предприятия (Финансы) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_CompIn a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompIn a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Предприятия (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_CompRec - Обновление CHILD */
/* Справочник признаков 4 ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_CompRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpCor - Обновление CHILD */
/* Справочник признаков 4 ^ Корректировка баланса служащего - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpCor a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCor a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Корректировка баланса служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpCurr - Обновление CHILD */
/* Справочник признаков 4 ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpExc - Обновление CHILD */
/* Справочник признаков 4 ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpExc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpExp - Обновление CHILD */
/* Справочник признаков 4 ^ Расход денег по служащим - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpIn - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Служащие (Финансы) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpIn a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpIn a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Служащие (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpRec - Обновление CHILD */
/* Справочник признаков 4 ^ Приход денег по служащим - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_EmpRep - Обновление CHILD */
/* Справочник признаков 4 ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_EmpRep a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_OurCor - Обновление CHILD */
/* Справочник признаков 4 ^ Корректировка баланса денег - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_OurCor a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurCor a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Корректировка баланса денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_OurIn - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Касса (Финансы) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_OurIn a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurIn a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий баланс: Касса (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_PlanExp - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_PlanExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_PlanRec - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_PlanRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ c_Sal - Обновление CHILD */
/* Справочник признаков 4 ^ Начисление денег служащим (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM c_Sal a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_Sal a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Начисление денег служащим (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_CommunalTax - Обновление CHILD */
/* Справочник признаков 4 ^ Коммунальный налог - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_CommunalTax a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTax a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Коммунальный налог''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_CWTime - Обновление CHILD */
/* Справочник признаков 4 ^ Табель учета рабочего времени (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_CWTime a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTime a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Табель учета рабочего времени (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_CWTimeCor - Обновление CHILD */
/* Справочник признаков 4 ^ Табель учета рабочего времени: Корректировка: Список - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_CWTimeCor a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeCor a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Табель учета рабочего времени: Корректировка: Список''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_EDis - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_EDis a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_EExc - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_EExc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_EGiv - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_EGiv a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_ELeav - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Отпуск (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_ELeav a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeav a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Отпуск (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_ELeavCor - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Отпуск: Корректировка (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_ELeavCor a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavCor a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Отпуск: Корректировка (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_EmpSchedExt - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Дополнительный график работы (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_EmpSchedExt a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExt a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Дополнительный график работы (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_ESic - Обновление CHILD */
/* Справочник признаков 4 ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_ESic a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_ETrp - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_ETrp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_EWri - Обновление CHILD */
/* Справочник признаков 4 ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_EWri a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_EWrk - Обновление CHILD */
/* Справочник признаков 4 ^ Выполнение работ (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_EWrk a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrk a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Выполнение работ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_LeaveSched - Обновление CHILD */
/* Справочник признаков 4 ^ Отпуск: Лимиты по видам (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_LeaveSched a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LeaveSched a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Отпуск: Лимиты по видам (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_LExc - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Кадровое перемещение списком (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_LExc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Кадровое перемещение списком (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_LExp - Обновление CHILD */
/* Справочник признаков 4 ^ Заработная плата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_LExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Заработная плата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_LMem - Обновление CHILD */
/* Справочник признаков 4 ^ Штатное расписание (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_LMem a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LMem a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Штатное расписание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_LRec - Обновление CHILD */
/* Справочник признаков 4 ^ Заработная плата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_LRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Заработная плата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_LStr - Обновление CHILD */
/* Справочник признаков 4 ^ Штатная численность сотрудников (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_LStr a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LStr a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Штатная численность сотрудников (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_OPWrk - Обновление CHILD */
/* Справочник признаков 4 ^ Приказ: Производственный (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_OPWrk a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrk a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приказ: Производственный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_PostStruc - Обновление CHILD */
/* Справочник признаков 4 ^ Структура должностей (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_PostStruc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_PostStruc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Структура должностей (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_SubStruc - Обновление CHILD */
/* Справочник признаков 4 ^ Структура предприятия (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_SubStruc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_SubStruc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Структура предприятия (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_TSer - Обновление CHILD */
/* Справочник признаков 4 ^ Командировочное удостоверение (Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_TSer a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_TSer a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Командировочное удостоверение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ p_WExc - Обновление CHILD */
/* Справочник признаков 4 ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM p_WExc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Привлечение на другую работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Acc - Обновление CHILD */
/* Справочник признаков 4 ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Acc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Cos - Обновление CHILD */
/* Справочник признаков 4 ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Cos a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_CRet - Обновление CHILD */
/* Справочник признаков 4 ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_CRet a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_CRRet - Обновление CHILD */
/* Справочник признаков 4 ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_CRRet a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Cst - Обновление CHILD */
/* Справочник признаков 4 ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Cst a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Cst2 - Обновление CHILD */
/* Справочник признаков 4 ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Cst2 a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_DeskRes - Обновление CHILD */
/* Справочник признаков 4 ^ Ресторан: Резервирование столиков - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_DeskRes a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DeskRes a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Ресторан: Резервирование столиков''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Dis - Обновление CHILD */
/* Справочник признаков 4 ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Dis a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_EOExp - Обновление CHILD */
/* Справочник признаков 4 ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_EOExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_EORec - Обновление CHILD */
/* Справочник признаков 4 ^ Заказ внешний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_EORec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Заказ внешний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Epp - Обновление CHILD */
/* Справочник признаков 4 ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Epp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Est - Обновление CHILD */
/* Справочник признаков 4 ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Est a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Exc - Обновление CHILD */
/* Справочник признаков 4 ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Exc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Exp - Обновление CHILD */
/* Справочник признаков 4 ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Exp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Inv - Обновление CHILD */
/* Справочник признаков 4 ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Inv a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_IOExp - Обновление CHILD */
/* Справочник признаков 4 ^ Заказ внутренний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_IOExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Заказ внутренний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_IORec - Обновление CHILD */
/* Справочник признаков 4 ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_IORec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_MonIntExp - Обновление CHILD */
/* Справочник признаков 4 ^ Служебный расход денег - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_MonIntExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Служебный расход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_MonIntRec - Обновление CHILD */
/* Справочник признаков 4 ^ Служебный приход денег - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_MonIntRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Служебный приход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_MonRec - Обновление CHILD */
/* Справочник признаков 4 ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_MonRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Rec - Обновление CHILD */
/* Справочник признаков 4 ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Rec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_RestShift - Обновление CHILD */
/* Справочник признаков 4 ^ Ресторан: Смена: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_RestShift a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RestShift a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Ресторан: Смена: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Ret - Обновление CHILD */
/* Справочник признаков 4 ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Ret a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Sale - Обновление CHILD */
/* Справочник признаков 4 ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Sale a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SaleTemp - Проверка в CHILD */
/* Справочник признаков 4 ^ Временные данные продаж: Заголовок - Проверка в CHILD */
  IF UPDATE(CodeID4) IF EXISTS (SELECT * FROM t_SaleTemp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SaleTemp', 2
      RETURN
    END

/* r_Codes4 ^ t_SEst - Обновление CHILD */
/* Справочник признаков 4 ^ Переоценка цен продажи: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_SEst a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEst a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Переоценка цен продажи: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SExp - Обновление CHILD */
/* Справочник признаков 4 ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_SExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SExpE - Обновление CHILD */
/* Справочник признаков 4 ^ Разукомплектация товара: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SetCodeID4 = i.CodeID4
          FROM t_SExpE a, inserted i, deleted d WHERE a.SetCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpE a, deleted d WHERE a.SetCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Разукомплектация товара: Затраты на комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SExpM - Обновление CHILD */
/* Справочник признаков 4 ^ Разукомплектация товара: Общие Затраты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CostCodeID4 = i.CodeID4
          FROM t_SExpM a, inserted i, deleted d WHERE a.CostCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExpM a, deleted d WHERE a.CostCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Разукомплектация товара: Общие Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SPExp - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_SPExp a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SPExpE - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Разукомплектация: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SetCodeID4 = i.CodeID4
          FROM t_SPExpE a, inserted i, deleted d WHERE a.SetCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpE a, deleted d WHERE a.SetCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Разукомплектация: Затраты на комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SPExpM - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Разукомплектация: Общие Затраты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CostCodeID4 = i.CodeID4
          FROM t_SPExpM a, inserted i, deleted d WHERE a.CostCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExpM a, deleted d WHERE a.CostCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Разукомплектация: Общие Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SPRec - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_SPRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SPRecE - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Комплектация: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SetCodeID4 = i.CodeID4
          FROM t_SPRecE a, inserted i, deleted d WHERE a.SetCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecE a, deleted d WHERE a.SetCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Комплектация: Затраты на комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SPRecM - Обновление CHILD */
/* Справочник признаков 4 ^ Планирование: Комплектация: Общие Затраты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CostCodeID4 = i.CodeID4
          FROM t_SPRecM a, inserted i, deleted d WHERE a.CostCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecM a, deleted d WHERE a.CostCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Планирование: Комплектация: Общие Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SRec - Обновление CHILD */
/* Справочник признаков 4 ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_SRec a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SRecE - Обновление CHILD */
/* Справочник признаков 4 ^ Комплектация товара: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SetCodeID4 = i.CodeID4
          FROM t_SRecE a, inserted i, deleted d WHERE a.SetCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecE a, deleted d WHERE a.SetCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Комплектация товара: Затраты на комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_SRecM - Обновление CHILD */
/* Справочник признаков 4 ^ Комплектация товара: Общие Затраты - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CostCodeID4 = i.CodeID4
          FROM t_SRecM a, inserted i, deleted d WHERE a.CostCodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecM a, deleted d WHERE a.CostCodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Комплектация товара: Общие Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_Ven - Обновление CHILD */
/* Справочник признаков 4 ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_Ven a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ t_zInP - Обновление CHILD */
/* Справочник признаков 4 ^ Входящие остатки товара - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM t_zInP a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_zInP a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящие остатки товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ z_Contracts - Обновление CHILD */
/* Справочник признаков 4 ^ Договор - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM z_Contracts a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Contracts a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Договор''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ z_InAcc - Обновление CHILD */
/* Справочник признаков 4 ^ Входящий счет на оплату - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM z_InAcc a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_InAcc a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Входящий счет на оплату''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ z_UserCodes4 - Обновление CHILD */
/* Справочник признаков 4 ^ Доступные значения - Справочник признаков 4 - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CodeID4 = i.CodeID4
          FROM z_UserCodes4 a, inserted i, deleted d WHERE a.CodeID4 = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserCodes4 a, deleted d WHERE a.CodeID4 = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Доступные значения - Справочник признаков 4''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Codes4 ^ z_Vars - Обновление CHILD */
/* Справочник признаков 4 ^ Системные переменные - Обновление CHILD */
  IF UPDATE(CodeID4)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_ManualSRecCode', a.VarValue = i.CodeID4
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 't_ManualSRecCode' AND a.VarValue = d.CodeID4
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 't_ManualSRecCode' AND a.VarValue = d.CodeID4)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник признаков 4'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10154001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10154001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CodeID4))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10154001 AND l.PKValue = 
        '[' + cast(i.CodeID4 as varchar(200)) + ']' AND i.CodeID4 = d.CodeID4
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10154001 AND l.PKValue = 
        '[' + cast(i.CodeID4 as varchar(200)) + ']' AND i.CodeID4 = d.CodeID4
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10154001, ChID, 
          '[' + cast(d.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10154001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10154001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10154001, ChID, 
          '[' + cast(i.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CodeID4)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CodeID4 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CodeID4 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CodeID4 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10154001 AND l.PKValue = 
          '[' + cast(d.CodeID4 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CodeID4 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10154001 AND l.PKValue = 
          '[' + cast(d.CodeID4 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10154001, ChID, 
          '[' + cast(d.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10154001 AND PKValue IN (SELECT 
          '[' + cast(CodeID4 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10154001 AND PKValue IN (SELECT 
          '[' + cast(CodeID4 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10154001, ChID, 
          '[' + cast(i.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10154001, ChID, 
    '[' + cast(i.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Codes4', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Codes4] ON [r_Codes4]
FOR DELETE AS
/* r_Codes4 - Справочник признаков 4 - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Codes4 ^ r_CRMM - Проверка в CHILD */
/* Справочник признаков 4 ^ Справочник ЭККА - Виды служебных операций - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRMM a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_CRMM', 3
      RETURN
    END

/* r_Codes4 ^ r_ProdME - Проверка в CHILD */
/* Справочник признаков 4 ^ Справочник товаров - Затраты на комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdME a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_ProdME', 3
      RETURN
    END

/* r_Codes4 ^ r_GOperD - Проверка в CHILD */
/* Справочник признаков 4 ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_GOperD', 3
      RETURN
    END

/* r_Codes4 ^ r_GOperD - Проверка в CHILD */
/* Справочник признаков 4 ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_GOperD', 3
      RETURN
    END

/* r_Codes4 ^ r_Comps - Проверка в CHILD */
/* Справочник признаков 4 ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_Comps', 3
      RETURN
    END

/* r_Codes4 ^ r_GAccs - Проверка в CHILD */
/* Справочник признаков 4 ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'r_GAccs', 3
      RETURN
    END

/* r_Codes4 ^ b_AExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_AExp', 3
      RETURN
    END

/* r_Codes4 ^ b_ARec - Проверка в CHILD */
/* Справочник признаков 4 ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_ARec', 3
      RETURN
    END

/* r_Codes4 ^ b_ARepADP - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет валютный (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADP a WITH(NOLOCK), deleted d WHERE a.PCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_ARepADP', 3
      RETURN
    END

/* r_Codes4 ^ b_ARepADS - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет валютный (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADS a WITH(NOLOCK), deleted d WHERE a.ACodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_ARepADS', 3
      RETURN
    END

/* r_Codes4 ^ b_ARepADV - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет валютный (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADV a WITH(NOLOCK), deleted d WHERE a.VCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_ARepADV', 3
      RETURN
    END

/* r_Codes4 ^ b_BankExpAC - Проверка в CHILD */
/* Справочник признаков 4 ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankExpAC', 3
      RETURN
    END

/* r_Codes4 ^ b_BankExpCC - Проверка в CHILD */
/* Справочник признаков 4 ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankExpCC', 3
      RETURN
    END

/* r_Codes4 ^ b_BankPayAC - Проверка в CHILD */
/* Справочник признаков 4 ^ Валютное платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayAC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankPayAC', 3
      RETURN
    END

/* r_Codes4 ^ b_BankPayCC - Проверка в CHILD */
/* Справочник признаков 4 ^ Платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayCC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankPayCC', 3
      RETURN
    END

/* r_Codes4 ^ b_BankRecAC - Проверка в CHILD */
/* Справочник признаков 4 ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankRecAC', 3
      RETURN
    END

/* r_Codes4 ^ b_BankRecCC - Проверка в CHILD */
/* Справочник признаков 4 ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_BankRecCC', 3
      RETURN
    END

/* r_Codes4 ^ b_CExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CExp', 3
      RETURN
    END

/* r_Codes4 ^ b_CInv - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CInv', 3
      RETURN
    END

/* r_Codes4 ^ b_CRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CRec', 3
      RETURN
    END

/* r_Codes4 ^ b_CRepADP - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет с признаками (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADP a WITH(NOLOCK), deleted d WHERE a.PCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CRepADP', 3
      RETURN
    END

/* r_Codes4 ^ b_CRepADS - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет с признаками (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADS a WITH(NOLOCK), deleted d WHERE a.ACodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CRepADS', 3
      RETURN
    END

/* r_Codes4 ^ b_CRepADV - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет с признаками (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADV a WITH(NOLOCK), deleted d WHERE a.VCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CRepADV', 3
      RETURN
    END

/* r_Codes4 ^ b_CRet - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_CRet', 3
      RETURN
    END

/* r_Codes4 ^ b_Cst - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_Cst', 3
      RETURN
    END

/* r_Codes4 ^ b_DStack - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_DStack', 3
      RETURN
    END

/* r_Codes4 ^ b_Exp - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_Exp', 3
      RETURN
    END

/* r_Codes4 ^ b_GTranD - Проверка в CHILD */
/* Справочник признаков 4 ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_GTranD', 3
      RETURN
    END

/* r_Codes4 ^ b_GTranD - Проверка в CHILD */
/* Справочник признаков 4 ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_GTranD', 3
      RETURN
    END

/* r_Codes4 ^ b_Inv - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_Inv', 3
      RETURN
    END

/* r_Codes4 ^ b_LExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Зарплата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_LExp', 3
      RETURN
    END

/* r_Codes4 ^ b_LRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Зарплата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_LRec', 3
      RETURN
    END

/* r_Codes4 ^ b_PAcc - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PAcc', 3
      RETURN
    END

/* r_Codes4 ^ b_PCost - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PCost', 3
      RETURN
    END

/* r_Codes4 ^ b_PEst - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEst a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PEst', 3
      RETURN
    END

/* r_Codes4 ^ b_PExc - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PExc', 3
      RETURN
    END

/* r_Codes4 ^ b_PVen - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PVen', 3
      RETURN
    END

/* r_Codes4 ^ b_Rec - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_Rec', 3
      RETURN
    END

/* r_Codes4 ^ b_RepA - Проверка в CHILD */
/* Справочник признаков 4 ^ Авансовый отчет (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepA a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_RepA', 3
      RETURN
    END

/* r_Codes4 ^ b_Ret - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_Ret', 3
      RETURN
    END

/* r_Codes4 ^ b_SDep - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Амортизация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDep a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SDep', 3
      RETURN
    END

/* r_Codes4 ^ b_SExc - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SExc', 3
      RETURN
    END

/* r_Codes4 ^ b_SExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SExp', 3
      RETURN
    END

/* r_Codes4 ^ b_SInv - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SInv', 3
      RETURN
    END

/* r_Codes4 ^ b_SPut - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPut a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SPut', 3
      RETURN
    END

/* r_Codes4 ^ b_SRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SRec', 3
      RETURN
    END

/* r_Codes4 ^ b_SRepDP - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Ремонт (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRepDP a WITH(NOLOCK), deleted d WHERE a.PCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SRepDP', 3
      RETURN
    END

/* r_Codes4 ^ b_SRepDV - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Ремонт (Общие затраты) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRepDV a WITH(NOLOCK), deleted d WHERE a.VCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SRepDV', 3
      RETURN
    END

/* r_Codes4 ^ b_SVen - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Инвентаризация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVen a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SVen', 3
      RETURN
    END

/* r_Codes4 ^ b_SWer - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Износ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWer a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SWer', 3
      RETURN
    END

/* r_Codes4 ^ b_TExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TExp', 3
      RETURN
    END

/* r_Codes4 ^ b_TranC - Проверка в CHILD */
/* Справочник признаков 4 ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranC', 3
      RETURN
    END

/* r_Codes4 ^ b_TranE - Проверка в CHILD */
/* Справочник признаков 4 ^ Проводка по служащему - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranE a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranE', 3
      RETURN
    END

/* r_Codes4 ^ b_TranH - Проверка в CHILD */
/* Справочник признаков 4 ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranH', 3
      RETURN
    END

/* r_Codes4 ^ b_TranH - Проверка в CHILD */
/* Справочник признаков 4 ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranH', 3
      RETURN
    END

/* r_Codes4 ^ b_TranP - Проверка в CHILD */
/* Справочник признаков 4 ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranP', 3
      RETURN
    END

/* r_Codes4 ^ b_TranS - Проверка в CHILD */
/* Справочник признаков 4 ^ Основные средства: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranS a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranS', 3
      RETURN
    END

/* r_Codes4 ^ b_TranV - Проверка в CHILD */
/* Справочник признаков 4 ^ Проводка общая - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranV a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TranV', 3
      RETURN
    END

/* r_Codes4 ^ b_TRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_TRec', 3
      RETURN
    END

/* r_Codes4 ^ b_WBill - Проверка в CHILD */
/* Справочник признаков 4 ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_WBill', 3
      RETURN
    END

/* r_Codes4 ^ b_zInBA - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Валютный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBA a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInBA', 3
      RETURN
    END

/* r_Codes4 ^ b_zInBC - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Расчетный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInBC', 3
      RETURN
    END

/* r_Codes4 ^ b_zInC - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInC a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInC', 3
      RETURN
    END

/* r_Codes4 ^ b_zInCA - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Касса - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInCA a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInCA', 3
      RETURN
    END

/* r_Codes4 ^ b_zInE - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Служащие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInE a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInE', 3
      RETURN
    END

/* r_Codes4 ^ b_zInH - Проверка в CHILD */
/* Справочник признаков 4 ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInH', 3
      RETURN
    END

/* r_Codes4 ^ b_zInH - Проверка в CHILD */
/* Справочник признаков 4 ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInH', 3
      RETURN
    END

/* r_Codes4 ^ b_zInP - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: ТМЦ - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInP a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInP', 3
      RETURN
    END

/* r_Codes4 ^ b_zInS - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Основные средства - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInS a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInS', 3
      RETURN
    END

/* r_Codes4 ^ b_zInV - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Общие данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInV a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInV', 3
      RETURN
    END

/* r_Codes4 ^ c_CompCor - Проверка в CHILD */
/* Справочник признаков 4 ^ Корректировка баланса предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCor a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_CompCor', 3
      RETURN
    END

/* r_Codes4 ^ c_CompCurr - Проверка в CHILD */
/* Справочник признаков 4 ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_CompCurr', 3
      RETURN
    END

/* r_Codes4 ^ c_CompExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_CompExp', 3
      RETURN
    END

/* r_Codes4 ^ c_CompIn - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Предприятия (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompIn a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_CompIn', 3
      RETURN
    END

/* r_Codes4 ^ c_CompRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_CompRec', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpCor - Проверка в CHILD */
/* Справочник признаков 4 ^ Корректировка баланса служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCor a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpCor', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpCurr - Проверка в CHILD */
/* Справочник признаков 4 ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpCurr', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpExc - Проверка в CHILD */
/* Справочник признаков 4 ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpExc', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Расход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpExp', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpIn - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Служащие (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpIn a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpIn', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Приход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpRec', 3
      RETURN
    END

/* r_Codes4 ^ c_EmpRep - Проверка в CHILD */
/* Справочник признаков 4 ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_EmpRep', 3
      RETURN
    END

/* r_Codes4 ^ c_OurCor - Проверка в CHILD */
/* Справочник признаков 4 ^ Корректировка баланса денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurCor a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_OurCor', 3
      RETURN
    END

/* r_Codes4 ^ c_OurIn - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий баланс: Касса (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurIn a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_OurIn', 3
      RETURN
    END

/* r_Codes4 ^ c_PlanExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_PlanExp', 3
      RETURN
    END

/* r_Codes4 ^ c_PlanRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_PlanRec', 3
      RETURN
    END

/* r_Codes4 ^ c_Sal - Проверка в CHILD */
/* Справочник признаков 4 ^ Начисление денег служащим (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_Sal a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'c_Sal', 3
      RETURN
    END

/* r_Codes4 ^ p_CommunalTax - Проверка в CHILD */
/* Справочник признаков 4 ^ Коммунальный налог - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTax a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_CommunalTax', 3
      RETURN
    END

/* r_Codes4 ^ p_CWTime - Проверка в CHILD */
/* Справочник признаков 4 ^ Табель учета рабочего времени (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTime a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_CWTime', 3
      RETURN
    END

/* r_Codes4 ^ p_CWTimeCor - Проверка в CHILD */
/* Справочник признаков 4 ^ Табель учета рабочего времени: Корректировка: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeCor a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_CWTimeCor', 3
      RETURN
    END

/* r_Codes4 ^ p_EDis - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EDis', 3
      RETURN
    END

/* r_Codes4 ^ p_EExc - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EExc', 3
      RETURN
    END

/* r_Codes4 ^ p_EGiv - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EGiv', 3
      RETURN
    END

/* r_Codes4 ^ p_ELeav - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Отпуск (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeav a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_ELeav', 3
      RETURN
    END

/* r_Codes4 ^ p_ELeavCor - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavCor a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_ELeavCor', 3
      RETURN
    END

/* r_Codes4 ^ p_EmpSchedExt - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Дополнительный график работы (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExt a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EmpSchedExt', 3
      RETURN
    END

/* r_Codes4 ^ p_ESic - Проверка в CHILD */
/* Справочник признаков 4 ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_ESic', 3
      RETURN
    END

/* r_Codes4 ^ p_ETrp - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_ETrp', 3
      RETURN
    END

/* r_Codes4 ^ p_EWri - Проверка в CHILD */
/* Справочник признаков 4 ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EWri', 3
      RETURN
    END

/* r_Codes4 ^ p_EWrk - Проверка в CHILD */
/* Справочник признаков 4 ^ Выполнение работ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrk a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_EWrk', 3
      RETURN
    END

/* r_Codes4 ^ p_LeaveSched - Проверка в CHILD */
/* Справочник признаков 4 ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LeaveSched a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_LeaveSched', 3
      RETURN
    END

/* r_Codes4 ^ p_LExc - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_LExc', 3
      RETURN
    END

/* r_Codes4 ^ p_LExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Заработная плата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_LExp', 3
      RETURN
    END

/* r_Codes4 ^ p_LMem - Проверка в CHILD */
/* Справочник признаков 4 ^ Штатное расписание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LMem a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_LMem', 3
      RETURN
    END

/* r_Codes4 ^ p_LRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Заработная плата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_LRec', 3
      RETURN
    END

/* r_Codes4 ^ p_LStr - Проверка в CHILD */
/* Справочник признаков 4 ^ Штатная численность сотрудников (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LStr a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_LStr', 3
      RETURN
    END

/* r_Codes4 ^ p_OPWrk - Проверка в CHILD */
/* Справочник признаков 4 ^ Приказ: Производственный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrk a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_OPWrk', 3
      RETURN
    END

/* r_Codes4 ^ p_PostStruc - Проверка в CHILD */
/* Справочник признаков 4 ^ Структура должностей (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_PostStruc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_PostStruc', 3
      RETURN
    END

/* r_Codes4 ^ p_SubStruc - Проверка в CHILD */
/* Справочник признаков 4 ^ Структура предприятия (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_SubStruc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_SubStruc', 3
      RETURN
    END

/* r_Codes4 ^ p_TSer - Проверка в CHILD */
/* Справочник признаков 4 ^ Командировочное удостоверение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_TSer a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_TSer', 3
      RETURN
    END

/* r_Codes4 ^ p_WExc - Проверка в CHILD */
/* Справочник признаков 4 ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_WExc', 3
      RETURN
    END

/* r_Codes4 ^ t_Acc - Проверка в CHILD */
/* Справочник признаков 4 ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Acc', 3
      RETURN
    END

/* r_Codes4 ^ t_Cos - Проверка в CHILD */
/* Справочник признаков 4 ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Cos', 3
      RETURN
    END

/* r_Codes4 ^ t_CRet - Проверка в CHILD */
/* Справочник признаков 4 ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_CRet', 3
      RETURN
    END

/* r_Codes4 ^ t_CRRet - Проверка в CHILD */
/* Справочник признаков 4 ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_CRRet', 3
      RETURN
    END

/* r_Codes4 ^ t_Cst - Проверка в CHILD */
/* Справочник признаков 4 ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Cst', 3
      RETURN
    END

/* r_Codes4 ^ t_Cst2 - Проверка в CHILD */
/* Справочник признаков 4 ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Cst2', 3
      RETURN
    END

/* r_Codes4 ^ t_DeskRes - Проверка в CHILD */
/* Справочник признаков 4 ^ Ресторан: Резервирование столиков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DeskRes a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_DeskRes', 3
      RETURN
    END

/* r_Codes4 ^ t_Dis - Проверка в CHILD */
/* Справочник признаков 4 ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Dis', 3
      RETURN
    END

/* r_Codes4 ^ t_EOExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_EOExp', 3
      RETURN
    END

/* r_Codes4 ^ t_EORec - Проверка в CHILD */
/* Справочник признаков 4 ^ Заказ внешний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_EORec', 3
      RETURN
    END

/* r_Codes4 ^ t_Epp - Проверка в CHILD */
/* Справочник признаков 4 ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Epp', 3
      RETURN
    END

/* r_Codes4 ^ t_Est - Проверка в CHILD */
/* Справочник признаков 4 ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Est', 3
      RETURN
    END

/* r_Codes4 ^ t_Exc - Проверка в CHILD */
/* Справочник признаков 4 ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Exc', 3
      RETURN
    END

/* r_Codes4 ^ t_Exp - Проверка в CHILD */
/* Справочник признаков 4 ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Exp', 3
      RETURN
    END

/* r_Codes4 ^ t_Inv - Проверка в CHILD */
/* Справочник признаков 4 ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Inv', 3
      RETURN
    END

/* r_Codes4 ^ t_IOExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Заказ внутренний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_IOExp', 3
      RETURN
    END

/* r_Codes4 ^ t_IORec - Проверка в CHILD */
/* Справочник признаков 4 ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_IORec', 3
      RETURN
    END

/* r_Codes4 ^ t_MonIntExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Служебный расход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_MonIntExp', 3
      RETURN
    END

/* r_Codes4 ^ t_MonIntRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Служебный приход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_MonIntRec', 3
      RETURN
    END

/* r_Codes4 ^ t_MonRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_MonRec', 3
      RETURN
    END

/* r_Codes4 ^ t_Rec - Проверка в CHILD */
/* Справочник признаков 4 ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Rec', 3
      RETURN
    END

/* r_Codes4 ^ t_RestShift - Проверка в CHILD */
/* Справочник признаков 4 ^ Ресторан: Смена: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RestShift a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_RestShift', 3
      RETURN
    END

/* r_Codes4 ^ t_Ret - Проверка в CHILD */
/* Справочник признаков 4 ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Ret', 3
      RETURN
    END

/* r_Codes4 ^ t_Sale - Проверка в CHILD */
/* Справочник признаков 4 ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Sale', 3
      RETURN
    END

/* r_Codes4 ^ t_SaleTemp - Удаление в CHILD */
/* Справочник признаков 4 ^ Временные данные продаж: Заголовок - Удаление в CHILD */
  DELETE t_SaleTemp FROM t_SaleTemp a, deleted d WHERE a.CodeID4 = d.CodeID4
  IF @@ERROR > 0 RETURN

/* r_Codes4 ^ t_SEst - Проверка в CHILD */
/* Справочник признаков 4 ^ Переоценка цен продажи: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEst a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SEst', 3
      RETURN
    END

/* r_Codes4 ^ t_SExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SExp', 3
      RETURN
    END

/* r_Codes4 ^ t_SExpE - Проверка в CHILD */
/* Справочник признаков 4 ^ Разукомплектация товара: Затраты на комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExpE a WITH(NOLOCK), deleted d WHERE a.SetCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SExpE', 3
      RETURN
    END

/* r_Codes4 ^ t_SExpM - Проверка в CHILD */
/* Справочник признаков 4 ^ Разукомплектация товара: Общие Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExpM a WITH(NOLOCK), deleted d WHERE a.CostCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SExpM', 3
      RETURN
    END

/* r_Codes4 ^ t_SPExp - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPExp', 3
      RETURN
    END

/* r_Codes4 ^ t_SPExpE - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Разукомплектация: Затраты на комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExpE a WITH(NOLOCK), deleted d WHERE a.SetCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPExpE', 3
      RETURN
    END

/* r_Codes4 ^ t_SPExpM - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Разукомплектация: Общие Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExpM a WITH(NOLOCK), deleted d WHERE a.CostCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPExpM', 3
      RETURN
    END

/* r_Codes4 ^ t_SPRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPRec', 3
      RETURN
    END

/* r_Codes4 ^ t_SPRecE - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Комплектация: Затраты на комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRecE a WITH(NOLOCK), deleted d WHERE a.SetCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPRecE', 3
      RETURN
    END

/* r_Codes4 ^ t_SPRecM - Проверка в CHILD */
/* Справочник признаков 4 ^ Планирование: Комплектация: Общие Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRecM a WITH(NOLOCK), deleted d WHERE a.CostCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPRecM', 3
      RETURN
    END

/* r_Codes4 ^ t_SRec - Проверка в CHILD */
/* Справочник признаков 4 ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SRec', 3
      RETURN
    END

/* r_Codes4 ^ t_SRecE - Проверка в CHILD */
/* Справочник признаков 4 ^ Комплектация товара: Затраты на комплекты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRecE a WITH(NOLOCK), deleted d WHERE a.SetCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SRecE', 3
      RETURN
    END

/* r_Codes4 ^ t_SRecM - Проверка в CHILD */
/* Справочник признаков 4 ^ Комплектация товара: Общие Затраты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRecM a WITH(NOLOCK), deleted d WHERE a.CostCodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SRecM', 3
      RETURN
    END

/* r_Codes4 ^ t_Ven - Проверка в CHILD */
/* Справочник признаков 4 ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Ven', 3
      RETURN
    END

/* r_Codes4 ^ t_zInP - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящие остатки товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zInP a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_zInP', 3
      RETURN
    END

/* r_Codes4 ^ z_Contracts - Проверка в CHILD */
/* Справочник признаков 4 ^ Договор - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Contracts a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'z_Contracts', 3
      RETURN
    END

/* r_Codes4 ^ z_InAcc - Проверка в CHILD */
/* Справочник признаков 4 ^ Входящий счет на оплату - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_InAcc a WITH(NOLOCK), deleted d WHERE a.CodeID4 = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'z_InAcc', 3
      RETURN
    END

/* r_Codes4 ^ z_UserCodes4 - Удаление в CHILD */
/* Справочник признаков 4 ^ Доступные значения - Справочник признаков 4 - Удаление в CHILD */
  DELETE z_UserCodes4 FROM z_UserCodes4 a, deleted d WHERE a.CodeID4 = d.CodeID4
  IF @@ERROR > 0 RETURN

/* r_Codes4 ^ z_Vars - Проверка в CHILD */
/* Справочник признаков 4 ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_ManualSRecCode' AND a.VarValue = d.CodeID4)
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10154001 AND m.PKValue = 
    '[' + cast(i.CodeID4 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10154001 AND m.PKValue = 
    '[' + cast(i.CodeID4 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10154001, -ChID, 
    '[' + cast(d.CodeID4 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10154 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Codes4', N'Last', N'DELETE'
GO