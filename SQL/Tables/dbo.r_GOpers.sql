CREATE TABLE [dbo].[r_GOpers] (
  [ChID] [bigint] NOT NULL,
  [GOperID] [int] NOT NULL,
  [GOperName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [WasChanged] [bit] NULL,
  [GOperCID] [smallint] NOT NULL,
  [RevID] [int] NOT NULL DEFAULT (0),
  [RevName] [varchar](250) NULL,
  CONSTRAINT [pk_r_GOpers] PRIMARY KEY CLUSTERED ([GOperID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_GOpers] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperCID]
  ON [dbo].[r_GOpers] ([GOperCID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GOperName]
  ON [dbo].[r_GOpers] ([GOperName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOpers.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOpers.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOpers.WasChanged'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_GOpers.GOperCID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GOpers] ON [r_GOpers]
FOR INSERT AS
/* r_GOpers - Справочник проводок - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOpers ^ r_GOperC - Проверка в PARENT */
/* Справочник проводок ^ Справочник проводок: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperCID NOT IN (SELECT GOperCID FROM r_GOperC))
    BEGIN
      EXEC z_RelationError 'r_GOperC', 'r_GOpers', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10708001, ChID, 
    '[' + cast(i.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_GOpers', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GOpers] ON [r_GOpers]
FOR UPDATE AS
/* r_GOpers - Справочник проводок - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GOpers ^ r_GOperC - Проверка в PARENT */
/* Справочник проводок ^ Справочник проводок: категории - Проверка в PARENT */
  IF UPDATE(GOperCID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperCID NOT IN (SELECT GOperCID FROM r_GOperC))
      BEGIN
        EXEC z_RelationError 'r_GOperC', 'r_GOpers', 1
        RETURN
      END

/* r_GOpers ^ r_GOperD - Обновление CHILD */
/* Справочник проводок ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM r_GOperD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_AExp - Обновление CHILD */
/* Справочник проводок ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_AExp a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_ARec - Обновление CHILD */
/* Справочник проводок ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_ARec a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_ARepADP - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет валютный (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_ARepADP a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADP a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет валютный (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_ARepADS - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет валютный (Основные средства) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_ARepADS a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADS a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет валютный (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_ARepADV - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет валютный (Общие) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_ARepADV a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepADV a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет валютный (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_BankExpAC - Обновление CHILD */
/* Справочник проводок ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_BankExpCC - Обновление CHILD */
/* Справочник проводок ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_BankRecAC - Обновление CHILD */
/* Справочник проводок ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_BankRecCC - Обновление CHILD */
/* Справочник проводок ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CExp - Обновление CHILD */
/* Справочник проводок ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CExp a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CInvD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Расход по ГТД (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CInvD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInvD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Расход по ГТД (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CRec - Обновление CHILD */
/* Справочник проводок ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CRec a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CRepADP - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет с признаками (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CRepADP a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADP a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет с признаками (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CRepADS - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет с признаками (Основные средства) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CRepADS a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADS a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет с признаками (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CRepADV - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет с признаками (Общие) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CRepADV a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepADV a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет с признаками (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CRetD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Возврат поставщику (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CRetD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRetD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Возврат поставщику (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_CstD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Приход по ГТД (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_CstD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CstD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Приход по ГТД (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_DStack - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_DStack a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_ExpD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Внутренний расход (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_ExpD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ExpD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Внутренний расход (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_GOperDocs - Обновление CHILD */
/* Справочник проводок ^ Проводки для документов - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_GOperDocs a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GOperDocs a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Проводки для документов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_GTran - Обновление CHILD */
/* Справочник проводок ^ Таблица проводок (Общие данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_GTran a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTran a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Таблица проводок (Общие данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_InvD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Расходная накладная (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_InvD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_InvD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Расходная накладная (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_LExpD - Обновление CHILD */
/* Справочник проводок ^ Зарплата: Выплата (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_LExpD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LExpD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Зарплата: Выплата (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_LRecD - Обновление CHILD */
/* Справочник проводок ^ Зарплата: Начисление (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_LRecD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LRecD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Зарплата: Начисление (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PCostD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PCostD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Формирование себестоимости (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PCostDDExp - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PCostDDExp a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostDDExp a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Формирование себестоимости (Прочие расходы по позиции)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PCostDDExpProds - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PCostDDExpProds a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostDDExpProds a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PCostDExp - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (Прочие расходы) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PCostDExp a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostDExp a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Формирование себестоимости (Прочие расходы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PEstD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Переоценка партий (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PEstD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEstD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Переоценка партий (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PExcD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Перемещение (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PExcD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExcD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Перемещение (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_PVenA - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Инвентаризация (Итоги) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_PVenA a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVenA a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Инвентаризация (Итоги)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_RecD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Приход по накладной (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_RecD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RecD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Приход по накладной (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_RepADP - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_RepADP a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepADP a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_RepADS - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет (Основные средства) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_RepADS a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepADS a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет (Основные средства)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_RepADV - Обновление CHILD */
/* Справочник проводок ^ Авансовый отчет (Общие) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_RepADV a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepADV a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Авансовый отчет (Общие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_RetD - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Возврат от получателя (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_RetD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RetD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Возврат от получателя (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SDepD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Амортизация: Данные - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SDepD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDepD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Амортизация: Данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SExcD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Перемещение (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SExcD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExcD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Перемещение (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SExpD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Списание (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SExpD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExpD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Списание (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SInvD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Продажа (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SInvD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInvD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Продажа (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SPutD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Ввод в эксплуатацию (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SPutD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPutD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Ввод в эксплуатацию (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SRecD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Приход (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SRecD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRecD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Приход (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SRepDP - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Ремонт (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SRepDP a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRepDP a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Ремонт (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SRepDV - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Ремонт (Общие затраты) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SRepDV a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRepDV a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Ремонт (Общие затраты)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SVenD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Инвентаризация (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SVenD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVenD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Инвентаризация (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_SWerD - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Износ (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_SWerD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWerD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Износ (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TExp - Обновление CHILD */
/* Справочник проводок ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TExp a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TranC - Обновление CHILD */
/* Справочник проводок ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TranC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TranE - Обновление CHILD */
/* Справочник проводок ^ Проводка по служащему - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TranE a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranE a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Проводка по служащему''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TranP - Обновление CHILD */
/* Справочник проводок ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TranP a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TranS - Обновление CHILD */
/* Справочник проводок ^ Основные средства: Проводка - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TranS a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranS a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Основные средства: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TranV - Обновление CHILD */
/* Справочник проводок ^ Проводка общая - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TranV a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranV a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Проводка общая''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_TRec - Обновление CHILD */
/* Справочник проводок ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_TRec a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_WBillA - Обновление CHILD */
/* Справочник проводок ^ Путевой лист (ТМЦ) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_WBillA a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBillA a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Путевой лист (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInBA - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Валютный счет - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInBA a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBA a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Валютный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInBC - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Расчетный счет - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInBC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Расчетный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInC - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Предприятия - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInC a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInC a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInCA - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Касса - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInCA a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInCA a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Касса''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInE - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Служащие - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInE a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInE a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Служащие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInP - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: ТМЦ - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInP a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInP a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: ТМЦ''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInS - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Основные средства - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInS a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInS a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Основные средства''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ b_zInV - Обновление CHILD */
/* Справочник проводок ^ Входящий баланс: Общие данные - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM b_zInV a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInV a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Входящий баланс: Общие данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ p_CommunalTaxD - Обновление CHILD */
/* Справочник проводок ^ Коммунальный налог: Список - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM p_CommunalTaxD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTaxD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Коммунальный налог: Список''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ p_CommunalTaxDD - Обновление CHILD */
/* Справочник проводок ^ Коммунальный налог: Подробно - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM p_CommunalTaxDD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTaxDD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Коммунальный налог: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ p_LExpD - Обновление CHILD */
/* Справочник проводок ^ Заработная плата: Выплата (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM p_LExpD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExpD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Заработная плата: Выплата (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ p_LRecD - Обновление CHILD */
/* Справочник проводок ^ Заработная плата: Начисление (Данные) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM p_LRecD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Заработная плата: Начисление (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ p_LRecDCor - Обновление CHILD */
/* Справочник проводок ^ Заработная плата: Начисление (Корректировка выплат) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM p_LRecDCor a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDCor a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Заработная плата: Начисление (Корректировка выплат)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ p_LRecDD - Обновление CHILD */
/* Справочник проводок ^ Заработная плата: Начисление (Подробно) - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.GOperID = i.GOperID
          FROM p_LRecDD a, inserted i, deleted d WHERE a.GOperID = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecDD a, deleted d WHERE a.GOperID = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Заработная плата: Начисление (Подробно)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ z_Vars - Обновление CHILD */
/* Справочник проводок ^ Системные переменные - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'b_GLInTID', a.VarValue = i.GOperID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'b_GLInTID' AND a.VarValue = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'b_GLInTID' AND a.VarValue = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GOpers ^ z_Vars - Обновление CHILD */
/* Справочник проводок ^ Системные переменные - Обновление CHILD */
  IF UPDATE(GOperID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'b_GRPTID', a.VarValue = i.GOperID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'b_GRPTID' AND a.VarValue = d.GOperID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'b_GRPTID' AND a.VarValue = d.GOperID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10708001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10708001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(GOperID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10708001 AND l.PKValue = 
        '[' + cast(i.GOperID as varchar(200)) + ']' AND i.GOperID = d.GOperID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10708001 AND l.PKValue = 
        '[' + cast(i.GOperID as varchar(200)) + ']' AND i.GOperID = d.GOperID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10708001, ChID, 
          '[' + cast(d.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10708001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10708001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10708001, ChID, 
          '[' + cast(i.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(GOperID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GOperID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10708001 AND l.PKValue = 
          '[' + cast(d.GOperID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GOperID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10708001 AND l.PKValue = 
          '[' + cast(d.GOperID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10708001, ChID, 
          '[' + cast(d.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10708001 AND PKValue IN (SELECT 
          '[' + cast(GOperID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10708001 AND PKValue IN (SELECT 
          '[' + cast(GOperID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10708001, ChID, 
          '[' + cast(i.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10708001, ChID, 
    '[' + cast(i.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_GOpers', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GOpers] ON [r_GOpers]
FOR DELETE AS
/* r_GOpers - Справочник проводок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GOpers ^ r_GOperD - Удаление в CHILD */
/* Справочник проводок ^ Справочник проводок - Проводки - Удаление в CHILD */
  DELETE r_GOperD FROM r_GOperD a, deleted d WHERE a.GOperID = d.GOperID
  IF @@ERROR > 0 RETURN

/* r_GOpers ^ b_AExp - Проверка в CHILD */
/* Справочник проводок ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_AExp', 3
      RETURN
    END

/* r_GOpers ^ b_ARec - Проверка в CHILD */
/* Справочник проводок ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ARec', 3
      RETURN
    END

/* r_GOpers ^ b_ARepADP - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет валютный (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADP a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ARepADP', 3
      RETURN
    END

/* r_GOpers ^ b_ARepADS - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет валютный (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADS a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ARepADS', 3
      RETURN
    END

/* r_GOpers ^ b_ARepADV - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет валютный (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepADV a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ARepADV', 3
      RETURN
    END

/* r_GOpers ^ b_BankExpAC - Проверка в CHILD */
/* Справочник проводок ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_BankExpAC', 3
      RETURN
    END

/* r_GOpers ^ b_BankExpCC - Проверка в CHILD */
/* Справочник проводок ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_BankExpCC', 3
      RETURN
    END

/* r_GOpers ^ b_BankRecAC - Проверка в CHILD */
/* Справочник проводок ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_BankRecAC', 3
      RETURN
    END

/* r_GOpers ^ b_BankRecCC - Проверка в CHILD */
/* Справочник проводок ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_BankRecCC', 3
      RETURN
    END

/* r_GOpers ^ b_CExp - Проверка в CHILD */
/* Справочник проводок ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CExp', 3
      RETURN
    END

/* r_GOpers ^ b_CInvD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Расход по ГТД (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInvD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CInvD', 3
      RETURN
    END

/* r_GOpers ^ b_CRec - Проверка в CHILD */
/* Справочник проводок ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CRec', 3
      RETURN
    END

/* r_GOpers ^ b_CRepADP - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет с признаками (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADP a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CRepADP', 3
      RETURN
    END

/* r_GOpers ^ b_CRepADS - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет с признаками (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADS a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CRepADS', 3
      RETURN
    END

/* r_GOpers ^ b_CRepADV - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет с признаками (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepADV a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CRepADV', 3
      RETURN
    END

/* r_GOpers ^ b_CRetD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Возврат поставщику (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRetD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CRetD', 3
      RETURN
    END

/* r_GOpers ^ b_CstD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Приход по ГТД (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CstD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_CstD', 3
      RETURN
    END

/* r_GOpers ^ b_DStack - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_DStack', 3
      RETURN
    END

/* r_GOpers ^ b_ExpD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Внутренний расход (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ExpD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ExpD', 3
      RETURN
    END

/* r_GOpers ^ b_GOperDocs - Проверка в CHILD */
/* Справочник проводок ^ Проводки для документов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GOperDocs a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_GOperDocs', 3
      RETURN
    END

/* r_GOpers ^ b_GTran - Проверка в CHILD */
/* Справочник проводок ^ Таблица проводок (Общие данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTran a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_GTran', 3
      RETURN
    END

/* r_GOpers ^ b_InvD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Расходная накладная (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_InvD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_InvD', 3
      RETURN
    END

/* r_GOpers ^ b_LExpD - Проверка в CHILD */
/* Справочник проводок ^ Зарплата: Выплата (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LExpD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_LExpD', 3
      RETURN
    END

/* r_GOpers ^ b_LRecD - Проверка в CHILD */
/* Справочник проводок ^ Зарплата: Начисление (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LRecD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_LRecD', 3
      RETURN
    END

/* r_GOpers ^ b_PCostD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCostD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostD', 3
      RETURN
    END

/* r_GOpers ^ b_PCostDDExp - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCostDDExp a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostDDExp', 3
      RETURN
    END

/* r_GOpers ^ b_PCostDDExpProds - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCostDDExpProds a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostDDExpProds', 3
      RETURN
    END

/* r_GOpers ^ b_PCostDExp - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Формирование себестоимости (Прочие расходы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCostDExp a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostDExp', 3
      RETURN
    END

/* r_GOpers ^ b_PEstD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Переоценка партий (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEstD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PEstD', 3
      RETURN
    END

/* r_GOpers ^ b_PExcD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Перемещение (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExcD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PExcD', 3
      RETURN
    END

/* r_GOpers ^ b_PVenA - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Инвентаризация (Итоги) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVenA a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PVenA', 3
      RETURN
    END

/* r_GOpers ^ b_RecD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Приход по накладной (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RecD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RecD', 3
      RETURN
    END

/* r_GOpers ^ b_RepADP - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepADP a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RepADP', 3
      RETURN
    END

/* r_GOpers ^ b_RepADS - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет (Основные средства) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepADS a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RepADS', 3
      RETURN
    END

/* r_GOpers ^ b_RepADV - Проверка в CHILD */
/* Справочник проводок ^ Авансовый отчет (Общие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepADV a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RepADV', 3
      RETURN
    END

/* r_GOpers ^ b_RetD - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Возврат от получателя (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RetD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RetD', 3
      RETURN
    END

/* r_GOpers ^ b_SDepD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Амортизация: Данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDepD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SDepD', 3
      RETURN
    END

/* r_GOpers ^ b_SExcD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Перемещение (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExcD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SExcD', 3
      RETURN
    END

/* r_GOpers ^ b_SExpD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Списание (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExpD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SExpD', 3
      RETURN
    END

/* r_GOpers ^ b_SInvD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Продажа (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInvD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SInvD', 3
      RETURN
    END

/* r_GOpers ^ b_SPutD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Ввод в эксплуатацию (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPutD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SPutD', 3
      RETURN
    END

/* r_GOpers ^ b_SRecD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Приход (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRecD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SRecD', 3
      RETURN
    END

/* r_GOpers ^ b_SRepDP - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Ремонт (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRepDP a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SRepDP', 3
      RETURN
    END

/* r_GOpers ^ b_SRepDV - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Ремонт (Общие затраты) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRepDV a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SRepDV', 3
      RETURN
    END

/* r_GOpers ^ b_SVenD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Инвентаризация (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVenD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SVenD', 3
      RETURN
    END

/* r_GOpers ^ b_SWerD - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Износ (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWerD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SWerD', 3
      RETURN
    END

/* r_GOpers ^ b_TExp - Проверка в CHILD */
/* Справочник проводок ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TExp', 3
      RETURN
    END

/* r_GOpers ^ b_TranC - Проверка в CHILD */
/* Справочник проводок ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TranC', 3
      RETURN
    END

/* r_GOpers ^ b_TranE - Проверка в CHILD */
/* Справочник проводок ^ Проводка по служащему - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranE a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TranE', 3
      RETURN
    END

/* r_GOpers ^ b_TranP - Проверка в CHILD */
/* Справочник проводок ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TranP', 3
      RETURN
    END

/* r_GOpers ^ b_TranS - Проверка в CHILD */
/* Справочник проводок ^ Основные средства: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranS a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TranS', 3
      RETURN
    END

/* r_GOpers ^ b_TranV - Проверка в CHILD */
/* Справочник проводок ^ Проводка общая - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranV a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TranV', 3
      RETURN
    END

/* r_GOpers ^ b_TRec - Проверка в CHILD */
/* Справочник проводок ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_TRec', 3
      RETURN
    END

/* r_GOpers ^ b_WBillA - Проверка в CHILD */
/* Справочник проводок ^ Путевой лист (ТМЦ) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBillA a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_WBillA', 3
      RETURN
    END

/* r_GOpers ^ b_zInBA - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Валютный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBA a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInBA', 3
      RETURN
    END

/* r_GOpers ^ b_zInBC - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Расчетный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInBC', 3
      RETURN
    END

/* r_GOpers ^ b_zInC - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInC a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInC', 3
      RETURN
    END

/* r_GOpers ^ b_zInCA - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Касса - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInCA a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInCA', 3
      RETURN
    END

/* r_GOpers ^ b_zInE - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Служащие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInE a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInE', 3
      RETURN
    END

/* r_GOpers ^ b_zInP - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: ТМЦ - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInP a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInP', 3
      RETURN
    END

/* r_GOpers ^ b_zInS - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Основные средства - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInS a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInS', 3
      RETURN
    END

/* r_GOpers ^ b_zInV - Проверка в CHILD */
/* Справочник проводок ^ Входящий баланс: Общие данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInV a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInV', 3
      RETURN
    END

/* r_GOpers ^ p_CommunalTaxD - Проверка в CHILD */
/* Справочник проводок ^ Коммунальный налог: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTaxD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_CommunalTaxD', 3
      RETURN
    END

/* r_GOpers ^ p_CommunalTaxDD - Проверка в CHILD */
/* Справочник проводок ^ Коммунальный налог: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTaxDD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_CommunalTaxDD', 3
      RETURN
    END

/* r_GOpers ^ p_LExpD - Проверка в CHILD */
/* Справочник проводок ^ Заработная плата: Выплата (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExpD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_LExpD', 3
      RETURN
    END

/* r_GOpers ^ p_LRecD - Проверка в CHILD */
/* Справочник проводок ^ Заработная плата: Начисление (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_LRecD', 3
      RETURN
    END

/* r_GOpers ^ p_LRecDCor - Проверка в CHILD */
/* Справочник проводок ^ Заработная плата: Начисление (Корректировка выплат) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDCor a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_LRecDCor', 3
      RETURN
    END

/* r_GOpers ^ p_LRecDD - Проверка в CHILD */
/* Справочник проводок ^ Заработная плата: Начисление (Подробно) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecDD a WITH(NOLOCK), deleted d WHERE a.GOperID = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_LRecDD', 3
      RETURN
    END

/* r_GOpers ^ z_Vars - Проверка в CHILD */
/* Справочник проводок ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'b_GLInTID' AND a.VarValue = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'z_Vars', 3
      RETURN
    END

/* r_GOpers ^ z_Vars - Проверка в CHILD */
/* Справочник проводок ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'b_GRPTID' AND a.VarValue = d.GOperID)
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10708001 AND m.PKValue = 
    '[' + cast(i.GOperID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10708001 AND m.PKValue = 
    '[' + cast(i.GOperID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10708001, -ChID, 
    '[' + cast(d.GOperID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10708 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_GOpers', N'Last', N'DELETE'
GO