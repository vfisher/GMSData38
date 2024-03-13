CREATE TABLE [dbo].[r_States]
(
[ChID] [bigint] NOT NULL,
[StateCode] [int] NOT NULL,
[StateName] [varchar] (250) NOT NULL,
[StateInfo] [varchar] (250) NULL,
[CanChangeDoc] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_States] ON [dbo].[r_States]
FOR INSERT AS
/* r_States - Справочник статусов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10190001, ChID, 
    '[' + cast(i.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_States]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_States] ON [dbo].[r_States]
FOR UPDATE AS
/* r_States - Справочник статусов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_States ^ r_StateDocs - Обновление CHILD */
/* Справочник статусов ^ Справочник статусов: документы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM r_StateDocs a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StateDocs a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Справочник статусов: документы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ r_StateDocsChange - Обновление CHILD */
/* Справочник статусов ^ Справочник статусов: изменение документов - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM r_StateDocsChange a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StateDocsChange a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Справочник статусов: изменение документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ r_StateRules - Обновление CHILD */
/* Справочник статусов ^ Справочник статусов: правила - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCodeFrom = i.StateCode
          FROM r_StateRules a, inserted i, deleted d WHERE a.StateCodeFrom = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StateRules a, deleted d WHERE a.StateCodeFrom = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Справочник статусов: правила''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ r_StateRules - Обновление CHILD */
/* Справочник статусов ^ Справочник статусов: правила - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCodeTo = i.StateCode
          FROM r_StateRules a, inserted i, deleted d WHERE a.StateCodeTo = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_StateRules a, deleted d WHERE a.StateCodeTo = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Справочник статусов: правила''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_Acc - Обновление CHILD */
/* Справочник статусов ^ Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_Acc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Acc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_AExp - Обновление CHILD */
/* Справочник статусов ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_AExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_ARec - Обновление CHILD */
/* Справочник статусов ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_ARec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_ARepA - Обновление CHILD */
/* Справочник статусов ^ Авансовый отчет валютный (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_ARepA a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepA a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Авансовый отчет валютный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_BankExpAC - Обновление CHILD */
/* Справочник статусов ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_BankExpCC - Обновление CHILD */
/* Справочник статусов ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_BankPayAC - Обновление CHILD */
/* Справочник статусов ^ Валютное платежное поручение - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_BankPayAC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayAC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Валютное платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_BankPayCC - Обновление CHILD */
/* Справочник статусов ^ Платежное поручение - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_BankPayCC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayCC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_BankRecAC - Обновление CHILD */
/* Справочник статусов ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_BankRecCC - Обновление CHILD */
/* Справочник статусов ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_CExp - Обновление CHILD */
/* Справочник статусов ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_CExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_CInv - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_CInv a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_CRec - Обновление CHILD */
/* Справочник статусов ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_CRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_CRepA - Обновление CHILD */
/* Справочник статусов ^ Авансовый отчет с признаками (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_CRepA a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepA a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Авансовый отчет с признаками (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_CRet - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_CRet a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_Cst - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_Cst a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_DStack - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_DStack a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_Exp - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_Exp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_Inv - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_Inv a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_LExp - Обновление CHILD */
/* Справочник статусов ^ Зарплата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_LExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Зарплата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_LRec - Обновление CHILD */
/* Справочник статусов ^ Зарплата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_LRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Зарплата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_PAcc - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_PAcc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_PCost - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_PCost a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_PEst - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Переоценка партий (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_PEst a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEst a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Переоценка партий (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_PExc - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_PExc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_PVen - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_PVen a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_Rec - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_Rec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_RepA - Обновление CHILD */
/* Справочник статусов ^ Авансовый отчет (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_RepA a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepA a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Авансовый отчет (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_Ret - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_Ret a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SDep - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Амортизация: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SDep a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDep a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Амортизация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SExc - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SExc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SExp - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SInv - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SInv a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SPut - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SPut a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPut a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Ввод в эксплуатацию (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SRec - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SRep - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SRep a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SVen - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Инвентаризация - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SVen a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVen a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Инвентаризация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_SWer - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Износ (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_SWer a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWer a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Износ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TExp - Обновление CHILD */
/* Справочник статусов ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TranC - Обновление CHILD */
/* Справочник статусов ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TranC a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TranE - Обновление CHILD */
/* Справочник статусов ^ Проводка по служащему - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TranE a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranE a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Проводка по служащему''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TranH - Обновление CHILD */
/* Справочник статусов ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TranH a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TranP - Обновление CHILD */
/* Справочник статусов ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TranP a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TranS - Обновление CHILD */
/* Справочник статусов ^ Основные средства: Проводка - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TranS a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranS a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Основные средства: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TranV - Обновление CHILD */
/* Справочник статусов ^ Проводка общая - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TranV a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranV a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Проводка общая''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_TRec - Обновление CHILD */
/* Справочник статусов ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_TRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_WBill - Обновление CHILD */
/* Справочник статусов ^ Путевой лист - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_WBill a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ b_zInH - Обновление CHILD */
/* Справочник статусов ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM b_zInH a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_CompCor - Обновление CHILD */
/* Справочник статусов ^ Корректировка баланса предприятия - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_CompCor a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCor a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Корректировка баланса предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_CompCurr - Обновление CHILD */
/* Справочник статусов ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_CompCurr a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_CompExp - Обновление CHILD */
/* Справочник статусов ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_CompExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_CompRec - Обновление CHILD */
/* Справочник статусов ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_CompRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_EmpCor - Обновление CHILD */
/* Справочник статусов ^ Корректировка баланса служащего - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_EmpCor a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCor a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Корректировка баланса служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_EmpCurr - Обновление CHILD */
/* Справочник статусов ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_EmpExc - Обновление CHILD */
/* Справочник статусов ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_EmpExc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_EmpExp - Обновление CHILD */
/* Справочник статусов ^ Расход денег по служащим - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_EmpExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_EmpRec - Обновление CHILD */
/* Справочник статусов ^ Приход денег по служащим - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_EmpRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_EmpRep - Обновление CHILD */
/* Справочник статусов ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_EmpRep a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_OurCor - Обновление CHILD */
/* Справочник статусов ^ Корректировка баланса денег - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_OurCor a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_OurCor a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Корректировка баланса денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_PlanExp - Обновление CHILD */
/* Справочник статусов ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_PlanExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_PlanRec - Обновление CHILD */
/* Справочник статусов ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_PlanRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ c_Sal - Обновление CHILD */
/* Справочник статусов ^ Начисление денег служащим (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM c_Sal a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_Sal a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Начисление денег служащим (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_CommunalTax - Обновление CHILD */
/* Справочник статусов ^ Коммунальный налог - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_CommunalTax a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTax a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Коммунальный налог''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_CWTime - Обновление CHILD */
/* Справочник статусов ^ Табель учета рабочего времени (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_CWTime a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTime a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Табель учета рабочего времени (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_CWTimeCor - Обновление CHILD */
/* Справочник статусов ^ Табель учета рабочего времени: Корректировка: Список - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_CWTimeCor a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeCor a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Табель учета рабочего времени: Корректировка: Список''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_DTran - Обновление CHILD */
/* Справочник статусов ^ Перенос рабочих дней - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_DTran a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_DTran a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Перенос рабочих дней''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_EDis - Обновление CHILD */
/* Справочник статусов ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_EDis a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_EExc - Обновление CHILD */
/* Справочник статусов ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_EExc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_EGiv - Обновление CHILD */
/* Справочник статусов ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_EGiv a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_ELeav - Обновление CHILD */
/* Справочник статусов ^ Приказ: Отпуск (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_ELeav a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeav a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Отпуск (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_ELeavCor - Обновление CHILD */
/* Справочник статусов ^ Приказ: Отпуск: Корректировка (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_ELeavCor a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavCor a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Отпуск: Корректировка (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_EmpSchedExt - Обновление CHILD */
/* Справочник статусов ^ Приказ: Дополнительный график работы (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_EmpSchedExt a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExt a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Дополнительный график работы (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_ESic - Обновление CHILD */
/* Справочник статусов ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_ESic a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_ETrp - Обновление CHILD */
/* Справочник статусов ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_ETrp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_EWri - Обновление CHILD */
/* Справочник статусов ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_EWri a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_EWrk - Обновление CHILD */
/* Справочник статусов ^ Выполнение работ (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_EWrk a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrk a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Выполнение работ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_LExc - Обновление CHILD */
/* Справочник статусов ^ Приказ: Кадровое перемещение списком (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_LExc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Кадровое перемещение списком (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_LExp - Обновление CHILD */
/* Справочник статусов ^ Заработная плата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_LExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Заработная плата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_LMem - Обновление CHILD */
/* Справочник статусов ^ Штатное расписание (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_LMem a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LMem a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Штатное расписание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_LRec - Обновление CHILD */
/* Справочник статусов ^ Заработная плата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_LRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Заработная плата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_LStr - Обновление CHILD */
/* Справочник статусов ^ Штатная численность сотрудников (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_LStr a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LStr a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Штатная численность сотрудников (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_OPWrk - Обновление CHILD */
/* Справочник статусов ^ Приказ: Производственный (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_OPWrk a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrk a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приказ: Производственный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_PostStruc - Обновление CHILD */
/* Справочник статусов ^ Структура должностей (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_PostStruc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_PostStruc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Структура должностей (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_SubStruc - Обновление CHILD */
/* Справочник статусов ^ Структура предприятия (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_SubStruc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_SubStruc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Структура предприятия (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_TSer - Обновление CHILD */
/* Справочник статусов ^ Командировочное удостоверение (Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_TSer a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_TSer a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Командировочное удостоверение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ p_WExc - Обновление CHILD */
/* Справочник статусов ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM p_WExc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Привлечение на другую работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ r_DocShedD - Обновление CHILD */
/* Справочник статусов ^ Шаблоны процессов: Детали - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM r_DocShedD a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DocShedD a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Шаблоны процессов: Детали''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Acc - Обновление CHILD */
/* Справочник статусов ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Acc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Cos - Обновление CHILD */
/* Справочник статусов ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Cos a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_CRet - Обновление CHILD */
/* Справочник статусов ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_CRet a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_CRRet - Обновление CHILD */
/* Справочник статусов ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_CRRet a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Cst - Обновление CHILD */
/* Справочник статусов ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Cst a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Cst2 - Обновление CHILD */
/* Справочник статусов ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Cst2 a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Dis - Обновление CHILD */
/* Справочник статусов ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Dis a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_EOExp - Обновление CHILD */
/* Справочник статусов ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_EOExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_EORec - Обновление CHILD */
/* Справочник статусов ^ Заказ внешний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_EORec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Заказ внешний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Epp - Обновление CHILD */
/* Справочник статусов ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Epp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Est - Обновление CHILD */
/* Справочник статусов ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Est a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Exc - Обновление CHILD */
/* Справочник статусов ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Exc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Exp - Обновление CHILD */
/* Справочник статусов ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Exp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Inv - Обновление CHILD */
/* Справочник статусов ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Inv a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_IOExp - Обновление CHILD */
/* Справочник статусов ^ Заказ внутренний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_IOExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Заказ внутренний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_IORec - Обновление CHILD */
/* Справочник статусов ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_IORec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_MonIntExp - Обновление CHILD */
/* Справочник статусов ^ Служебный расход денег - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_MonIntExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Служебный расход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_MonIntRec - Обновление CHILD */
/* Справочник статусов ^ Служебный приход денег - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_MonIntRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Служебный приход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_MonRec - Обновление CHILD */
/* Справочник статусов ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_MonRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Rec - Обновление CHILD */
/* Справочник статусов ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Rec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_RestShift - Обновление CHILD */
/* Справочник статусов ^ Ресторан: Смена: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_RestShift a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RestShift a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Ресторан: Смена: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Ret - Обновление CHILD */
/* Справочник статусов ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Ret a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Sale - Обновление CHILD */
/* Справочник статусов ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Sale a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_SEst - Обновление CHILD */
/* Справочник статусов ^ Переоценка цен продажи: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_SEst a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEst a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Переоценка цен продажи: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_SExp - Обновление CHILD */
/* Справочник статусов ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_SExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Spec - Обновление CHILD */
/* Справочник статусов ^ Калькуляционная карта: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Spec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Spec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Калькуляционная карта: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_SPExp - Обновление CHILD */
/* Справочник статусов ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_SPExp a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_SPRec - Обновление CHILD */
/* Справочник статусов ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_SPRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_SRec - Обновление CHILD */
/* Справочник статусов ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_SRec a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ t_Ven - Обновление CHILD */
/* Справочник статусов ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM t_Ven a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_DocShed - Обновление CHILD */
/* Справочник статусов ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM z_DocShed a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_DocShed - Обновление CHILD */
/* Справочник статусов ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCodeFrom = i.StateCode
          FROM z_DocShed a, inserted i, deleted d WHERE a.StateCodeFrom = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.StateCodeFrom = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_InAcc - Обновление CHILD */
/* Справочник статусов ^ Входящий счет на оплату - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM z_InAcc a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_InAcc a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Входящий счет на оплату''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_LogState - Обновление CHILD */
/* Справочник статусов ^ Регистрация действий - Статусы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewStateCode = i.StateCode
          FROM z_LogState a, inserted i, deleted d WHERE a.NewStateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogState a, deleted d WHERE a.NewStateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Регистрация действий - Статусы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_LogState - Обновление CHILD */
/* Справочник статусов ^ Регистрация действий - Статусы - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OldStateCode = i.StateCode
          FROM z_LogState a, inserted i, deleted d WHERE a.OldStateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogState a, deleted d WHERE a.OldStateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Регистрация действий - Статусы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_Vars - Обновление CHILD */
/* Справочник статусов ^ Системные переменные - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_ChequeStateCode', a.VarValue = i.StateCode
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 't_ChequeStateCode' AND a.VarValue = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 't_ChequeStateCode' AND a.VarValue = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_States ^ z_WCopy - Обновление CHILD */
/* Справочник статусов ^ Мастер Копирования - Обновление CHILD */
  IF UPDATE(StateCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.StateCode = i.StateCode
          FROM z_WCopy a, inserted i, deleted d WHERE a.StateCode = d.StateCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_WCopy a, deleted d WHERE a.StateCode = d.StateCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник статусов'' => ''Мастер Копирования''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10190001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10190001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(StateCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10190001 AND l.PKValue = 
        '[' + cast(i.StateCode as varchar(200)) + ']' AND i.StateCode = d.StateCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10190001 AND l.PKValue = 
        '[' + cast(i.StateCode as varchar(200)) + ']' AND i.StateCode = d.StateCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10190001, ChID, 
          '[' + cast(d.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10190001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10190001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10190001, ChID, 
          '[' + cast(i.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(StateCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT StateCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT StateCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.StateCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10190001 AND l.PKValue = 
          '[' + cast(d.StateCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.StateCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10190001 AND l.PKValue = 
          '[' + cast(d.StateCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10190001, ChID, 
          '[' + cast(d.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10190001 AND PKValue IN (SELECT 
          '[' + cast(StateCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10190001 AND PKValue IN (SELECT 
          '[' + cast(StateCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10190001, ChID, 
          '[' + cast(i.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10190001, ChID, 
    '[' + cast(i.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_States]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_States] ON [dbo].[r_States]
FOR DELETE AS
/* r_States - Справочник статусов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_States ^ r_StateDocs - Удаление в CHILD */
/* Справочник статусов ^ Справочник статусов: документы - Удаление в CHILD */
  DELETE r_StateDocs FROM r_StateDocs a, deleted d WHERE a.StateCode = d.StateCode
  IF @@ERROR > 0 RETURN

/* r_States ^ r_StateDocsChange - Удаление в CHILD */
/* Справочник статусов ^ Справочник статусов: изменение документов - Удаление в CHILD */
  DELETE r_StateDocsChange FROM r_StateDocsChange a, deleted d WHERE a.StateCode = d.StateCode
  IF @@ERROR > 0 RETURN

/* r_States ^ r_StateRules - Удаление в CHILD */
/* Справочник статусов ^ Справочник статусов: правила - Удаление в CHILD */
  DELETE r_StateRules FROM r_StateRules a, deleted d WHERE a.StateCodeFrom = d.StateCode
  IF @@ERROR > 0 RETURN

/* r_States ^ r_StateRules - Удаление в CHILD */
/* Справочник статусов ^ Справочник статусов: правила - Удаление в CHILD */
  DELETE r_StateRules FROM r_StateRules a, deleted d WHERE a.StateCodeTo = d.StateCode
  IF @@ERROR > 0 RETURN

/* r_States ^ b_Acc - Проверка в CHILD */
/* Справочник статусов ^ Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Acc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_Acc', 3
      RETURN
    END

/* r_States ^ b_AExp - Проверка в CHILD */
/* Справочник статусов ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_AExp', 3
      RETURN
    END

/* r_States ^ b_ARec - Проверка в CHILD */
/* Справочник статусов ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_ARec', 3
      RETURN
    END

/* r_States ^ b_ARepA - Проверка в CHILD */
/* Справочник статусов ^ Авансовый отчет валютный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepA a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_ARepA', 3
      RETURN
    END

/* r_States ^ b_BankExpAC - Проверка в CHILD */
/* Справочник статусов ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankExpAC', 3
      RETURN
    END

/* r_States ^ b_BankExpCC - Проверка в CHILD */
/* Справочник статусов ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankExpCC', 3
      RETURN
    END

/* r_States ^ b_BankPayAC - Проверка в CHILD */
/* Справочник статусов ^ Валютное платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayAC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankPayAC', 3
      RETURN
    END

/* r_States ^ b_BankPayCC - Проверка в CHILD */
/* Справочник статусов ^ Платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayCC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankPayCC', 3
      RETURN
    END

/* r_States ^ b_BankRecAC - Проверка в CHILD */
/* Справочник статусов ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankRecAC', 3
      RETURN
    END

/* r_States ^ b_BankRecCC - Проверка в CHILD */
/* Справочник статусов ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_BankRecCC', 3
      RETURN
    END

/* r_States ^ b_CExp - Проверка в CHILD */
/* Справочник статусов ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_CExp', 3
      RETURN
    END

/* r_States ^ b_CInv - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_CInv', 3
      RETURN
    END

/* r_States ^ b_CRec - Проверка в CHILD */
/* Справочник статусов ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_CRec', 3
      RETURN
    END

/* r_States ^ b_CRepA - Проверка в CHILD */
/* Справочник статусов ^ Авансовый отчет с признаками (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepA a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_CRepA', 3
      RETURN
    END

/* r_States ^ b_CRet - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_CRet', 3
      RETURN
    END

/* r_States ^ b_Cst - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_Cst', 3
      RETURN
    END

/* r_States ^ b_DStack - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_DStack', 3
      RETURN
    END

/* r_States ^ b_Exp - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_Exp', 3
      RETURN
    END

/* r_States ^ b_Inv - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_Inv', 3
      RETURN
    END

/* r_States ^ b_LExp - Проверка в CHILD */
/* Справочник статусов ^ Зарплата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_LExp', 3
      RETURN
    END

/* r_States ^ b_LRec - Проверка в CHILD */
/* Справочник статусов ^ Зарплата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_LRec', 3
      RETURN
    END

/* r_States ^ b_PAcc - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PAcc', 3
      RETURN
    END

/* r_States ^ b_PCost - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PCost', 3
      RETURN
    END

/* r_States ^ b_PEst - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEst a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PEst', 3
      RETURN
    END

/* r_States ^ b_PExc - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PExc', 3
      RETURN
    END

/* r_States ^ b_PVen - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PVen', 3
      RETURN
    END

/* r_States ^ b_Rec - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_Rec', 3
      RETURN
    END

/* r_States ^ b_RepA - Проверка в CHILD */
/* Справочник статусов ^ Авансовый отчет (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepA a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_RepA', 3
      RETURN
    END

/* r_States ^ b_Ret - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_Ret', 3
      RETURN
    END

/* r_States ^ b_SDep - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Амортизация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDep a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SDep', 3
      RETURN
    END

/* r_States ^ b_SExc - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SExc', 3
      RETURN
    END

/* r_States ^ b_SExp - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SExp', 3
      RETURN
    END

/* r_States ^ b_SInv - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SInv', 3
      RETURN
    END

/* r_States ^ b_SPut - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPut a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SPut', 3
      RETURN
    END

/* r_States ^ b_SRec - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SRec', 3
      RETURN
    END

/* r_States ^ b_SRep - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SRep', 3
      RETURN
    END

/* r_States ^ b_SVen - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Инвентаризация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVen a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SVen', 3
      RETURN
    END

/* r_States ^ b_SWer - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Износ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWer a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_SWer', 3
      RETURN
    END

/* r_States ^ b_TExp - Проверка в CHILD */
/* Справочник статусов ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TExp', 3
      RETURN
    END

/* r_States ^ b_TranC - Проверка в CHILD */
/* Справочник статусов ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranC', 3
      RETURN
    END

/* r_States ^ b_TranE - Проверка в CHILD */
/* Справочник статусов ^ Проводка по служащему - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranE a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranE', 3
      RETURN
    END

/* r_States ^ b_TranH - Проверка в CHILD */
/* Справочник статусов ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranH', 3
      RETURN
    END

/* r_States ^ b_TranP - Проверка в CHILD */
/* Справочник статусов ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranP', 3
      RETURN
    END

/* r_States ^ b_TranS - Проверка в CHILD */
/* Справочник статусов ^ Основные средства: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranS a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranS', 3
      RETURN
    END

/* r_States ^ b_TranV - Проверка в CHILD */
/* Справочник статусов ^ Проводка общая - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranV a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TranV', 3
      RETURN
    END

/* r_States ^ b_TRec - Проверка в CHILD */
/* Справочник статусов ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_TRec', 3
      RETURN
    END

/* r_States ^ b_WBill - Проверка в CHILD */
/* Справочник статусов ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_WBill', 3
      RETURN
    END

/* r_States ^ b_zInH - Проверка в CHILD */
/* Справочник статусов ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'b_zInH', 3
      RETURN
    END

/* r_States ^ c_CompCor - Проверка в CHILD */
/* Справочник статусов ^ Корректировка баланса предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCor a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_CompCor', 3
      RETURN
    END

/* r_States ^ c_CompCurr - Проверка в CHILD */
/* Справочник статусов ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_CompCurr', 3
      RETURN
    END

/* r_States ^ c_CompExp - Проверка в CHILD */
/* Справочник статусов ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_CompExp', 3
      RETURN
    END

/* r_States ^ c_CompRec - Проверка в CHILD */
/* Справочник статусов ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_CompRec', 3
      RETURN
    END

/* r_States ^ c_EmpCor - Проверка в CHILD */
/* Справочник статусов ^ Корректировка баланса служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCor a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_EmpCor', 3
      RETURN
    END

/* r_States ^ c_EmpCurr - Проверка в CHILD */
/* Справочник статусов ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_EmpCurr', 3
      RETURN
    END

/* r_States ^ c_EmpExc - Проверка в CHILD */
/* Справочник статусов ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_EmpExc', 3
      RETURN
    END

/* r_States ^ c_EmpExp - Проверка в CHILD */
/* Справочник статусов ^ Расход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_EmpExp', 3
      RETURN
    END

/* r_States ^ c_EmpRec - Проверка в CHILD */
/* Справочник статусов ^ Приход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_EmpRec', 3
      RETURN
    END

/* r_States ^ c_EmpRep - Проверка в CHILD */
/* Справочник статусов ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_EmpRep', 3
      RETURN
    END

/* r_States ^ c_OurCor - Проверка в CHILD */
/* Справочник статусов ^ Корректировка баланса денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurCor a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_OurCor', 3
      RETURN
    END

/* r_States ^ c_PlanExp - Проверка в CHILD */
/* Справочник статусов ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_PlanExp', 3
      RETURN
    END

/* r_States ^ c_PlanRec - Проверка в CHILD */
/* Справочник статусов ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_PlanRec', 3
      RETURN
    END

/* r_States ^ c_Sal - Проверка в CHILD */
/* Справочник статусов ^ Начисление денег служащим (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_Sal a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'c_Sal', 3
      RETURN
    END

/* r_States ^ p_CommunalTax - Проверка в CHILD */
/* Справочник статусов ^ Коммунальный налог - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTax a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_CommunalTax', 3
      RETURN
    END

/* r_States ^ p_CWTime - Проверка в CHILD */
/* Справочник статусов ^ Табель учета рабочего времени (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTime a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_CWTime', 3
      RETURN
    END

/* r_States ^ p_CWTimeCor - Проверка в CHILD */
/* Справочник статусов ^ Табель учета рабочего времени: Корректировка: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeCor a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_CWTimeCor', 3
      RETURN
    END

/* r_States ^ p_DTran - Проверка в CHILD */
/* Справочник статусов ^ Перенос рабочих дней - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_DTran a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_DTran', 3
      RETURN
    END

/* r_States ^ p_EDis - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EDis', 3
      RETURN
    END

/* r_States ^ p_EExc - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EExc', 3
      RETURN
    END

/* r_States ^ p_EGiv - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EGiv', 3
      RETURN
    END

/* r_States ^ p_ELeav - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Отпуск (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeav a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_ELeav', 3
      RETURN
    END

/* r_States ^ p_ELeavCor - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavCor a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_ELeavCor', 3
      RETURN
    END

/* r_States ^ p_EmpSchedExt - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Дополнительный график работы (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExt a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EmpSchedExt', 3
      RETURN
    END

/* r_States ^ p_ESic - Проверка в CHILD */
/* Справочник статусов ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_ESic', 3
      RETURN
    END

/* r_States ^ p_ETrp - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_ETrp', 3
      RETURN
    END

/* r_States ^ p_EWri - Проверка в CHILD */
/* Справочник статусов ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EWri', 3
      RETURN
    END

/* r_States ^ p_EWrk - Проверка в CHILD */
/* Справочник статусов ^ Выполнение работ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrk a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_EWrk', 3
      RETURN
    END

/* r_States ^ p_LExc - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_LExc', 3
      RETURN
    END

/* r_States ^ p_LExp - Проверка в CHILD */
/* Справочник статусов ^ Заработная плата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_LExp', 3
      RETURN
    END

/* r_States ^ p_LMem - Проверка в CHILD */
/* Справочник статусов ^ Штатное расписание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LMem a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_LMem', 3
      RETURN
    END

/* r_States ^ p_LRec - Проверка в CHILD */
/* Справочник статусов ^ Заработная плата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_LRec', 3
      RETURN
    END

/* r_States ^ p_LStr - Проверка в CHILD */
/* Справочник статусов ^ Штатная численность сотрудников (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LStr a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_LStr', 3
      RETURN
    END

/* r_States ^ p_OPWrk - Проверка в CHILD */
/* Справочник статусов ^ Приказ: Производственный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrk a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_OPWrk', 3
      RETURN
    END

/* r_States ^ p_PostStruc - Проверка в CHILD */
/* Справочник статусов ^ Структура должностей (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_PostStruc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_PostStruc', 3
      RETURN
    END

/* r_States ^ p_SubStruc - Проверка в CHILD */
/* Справочник статусов ^ Структура предприятия (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_SubStruc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_SubStruc', 3
      RETURN
    END

/* r_States ^ p_TSer - Проверка в CHILD */
/* Справочник статусов ^ Командировочное удостоверение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_TSer a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_TSer', 3
      RETURN
    END

/* r_States ^ p_WExc - Проверка в CHILD */
/* Справочник статусов ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'p_WExc', 3
      RETURN
    END

/* r_States ^ r_DocShedD - Проверка в CHILD */
/* Справочник статусов ^ Шаблоны процессов: Детали - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DocShedD a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'r_DocShedD', 3
      RETURN
    END

/* r_States ^ t_Acc - Проверка в CHILD */
/* Справочник статусов ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Acc', 3
      RETURN
    END

/* r_States ^ t_Cos - Проверка в CHILD */
/* Справочник статусов ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Cos', 3
      RETURN
    END

/* r_States ^ t_CRet - Проверка в CHILD */
/* Справочник статусов ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_CRet', 3
      RETURN
    END

/* r_States ^ t_CRRet - Проверка в CHILD */
/* Справочник статусов ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_CRRet', 3
      RETURN
    END

/* r_States ^ t_Cst - Проверка в CHILD */
/* Справочник статусов ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Cst', 3
      RETURN
    END

/* r_States ^ t_Cst2 - Проверка в CHILD */
/* Справочник статусов ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Cst2', 3
      RETURN
    END

/* r_States ^ t_Dis - Проверка в CHILD */
/* Справочник статусов ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Dis', 3
      RETURN
    END

/* r_States ^ t_EOExp - Проверка в CHILD */
/* Справочник статусов ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_EOExp', 3
      RETURN
    END

/* r_States ^ t_EORec - Проверка в CHILD */
/* Справочник статусов ^ Заказ внешний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_EORec', 3
      RETURN
    END

/* r_States ^ t_Epp - Проверка в CHILD */
/* Справочник статусов ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Epp', 3
      RETURN
    END

/* r_States ^ t_Est - Проверка в CHILD */
/* Справочник статусов ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Est', 3
      RETURN
    END

/* r_States ^ t_Exc - Проверка в CHILD */
/* Справочник статусов ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Exc', 3
      RETURN
    END

/* r_States ^ t_Exp - Проверка в CHILD */
/* Справочник статусов ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Exp', 3
      RETURN
    END

/* r_States ^ t_Inv - Проверка в CHILD */
/* Справочник статусов ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Inv', 3
      RETURN
    END

/* r_States ^ t_IOExp - Проверка в CHILD */
/* Справочник статусов ^ Заказ внутренний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_IOExp', 3
      RETURN
    END

/* r_States ^ t_IORec - Проверка в CHILD */
/* Справочник статусов ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_IORec', 3
      RETURN
    END

/* r_States ^ t_MonIntExp - Проверка в CHILD */
/* Справочник статусов ^ Служебный расход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_MonIntExp', 3
      RETURN
    END

/* r_States ^ t_MonIntRec - Проверка в CHILD */
/* Справочник статусов ^ Служебный приход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_MonIntRec', 3
      RETURN
    END

/* r_States ^ t_MonRec - Проверка в CHILD */
/* Справочник статусов ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_MonRec', 3
      RETURN
    END

/* r_States ^ t_Rec - Проверка в CHILD */
/* Справочник статусов ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Rec', 3
      RETURN
    END

/* r_States ^ t_RestShift - Проверка в CHILD */
/* Справочник статусов ^ Ресторан: Смена: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RestShift a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_RestShift', 3
      RETURN
    END

/* r_States ^ t_Ret - Проверка в CHILD */
/* Справочник статусов ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Ret', 3
      RETURN
    END

/* r_States ^ t_Sale - Проверка в CHILD */
/* Справочник статусов ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Sale', 3
      RETURN
    END

/* r_States ^ t_SEst - Проверка в CHILD */
/* Справочник статусов ^ Переоценка цен продажи: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEst a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_SEst', 3
      RETURN
    END

/* r_States ^ t_SExp - Проверка в CHILD */
/* Справочник статусов ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_SExp', 3
      RETURN
    END

/* r_States ^ t_Spec - Проверка в CHILD */
/* Справочник статусов ^ Калькуляционная карта: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Spec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Spec', 3
      RETURN
    END

/* r_States ^ t_SPExp - Проверка в CHILD */
/* Справочник статусов ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_SPExp', 3
      RETURN
    END

/* r_States ^ t_SPRec - Проверка в CHILD */
/* Справочник статусов ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_SPRec', 3
      RETURN
    END

/* r_States ^ t_SRec - Проверка в CHILD */
/* Справочник статусов ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_SRec', 3
      RETURN
    END

/* r_States ^ t_Ven - Проверка в CHILD */
/* Справочник статусов ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 't_Ven', 3
      RETURN
    END

/* r_States ^ z_DocShed - Проверка в CHILD */
/* Справочник статусов ^ Документы - Процессы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocShed a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'z_DocShed', 3
      RETURN
    END

/* r_States ^ z_DocShed - Проверка в CHILD */
/* Справочник статусов ^ Документы - Процессы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocShed a WITH(NOLOCK), deleted d WHERE a.StateCodeFrom = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'z_DocShed', 3
      RETURN
    END

/* r_States ^ z_InAcc - Проверка в CHILD */
/* Справочник статусов ^ Входящий счет на оплату - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_InAcc a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'z_InAcc', 3
      RETURN
    END

/* r_States ^ z_LogState - Удаление в CHILD */
/* Справочник статусов ^ Регистрация действий - Статусы - Удаление в CHILD */
  DELETE z_LogState FROM z_LogState a, deleted d WHERE a.NewStateCode = d.StateCode
  IF @@ERROR > 0 RETURN

/* r_States ^ z_LogState - Удаление в CHILD */
/* Справочник статусов ^ Регистрация действий - Статусы - Удаление в CHILD */
  DELETE z_LogState FROM z_LogState a, deleted d WHERE a.OldStateCode = d.StateCode
  IF @@ERROR > 0 RETURN

/* r_States ^ z_Vars - Проверка в CHILD */
/* Справочник статусов ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_ChequeStateCode' AND a.VarValue = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'z_Vars', 3
      RETURN
    END

/* r_States ^ z_WCopy - Проверка в CHILD */
/* Справочник статусов ^ Мастер Копирования - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_WCopy a WITH(NOLOCK), deleted d WHERE a.StateCode = d.StateCode)
    BEGIN
      EXEC z_RelationError 'r_States', 'z_WCopy', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10190001 AND m.PKValue = 
    '[' + cast(i.StateCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10190001 AND m.PKValue = 
    '[' + cast(i.StateCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10190001, -ChID, 
    '[' + cast(d.StateCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10190 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_States]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_States] ADD CONSTRAINT [pk_r_States] PRIMARY KEY CLUSTERED ([StateCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_States] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [StateName] ON [dbo].[r_States] ([StateName]) ON [PRIMARY]
GO
