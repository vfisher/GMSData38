CREATE TABLE [dbo].[r_Ours] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [OurName] [varchar](200) NOT NULL,
  [Address] [varchar](200) NOT NULL,
  [PostIndex] [varchar](10) NOT NULL,
  [City] [varchar](200) NOT NULL,
  [Region] [varchar](200) NOT NULL,
  [Code] [varchar](20) NOT NULL,
  [TaxRegNo] [varchar](50) NOT NULL,
  [TaxCode] [varchar](20) NOT NULL,
  [OurDesc] [varchar](200) NULL,
  [Phone] [varchar](20) NULL,
  [Fax] [varchar](20) NULL,
  [OurShort] [varchar](200) NOT NULL,
  [Note1] [varchar](200) NULL,
  [Note2] [varchar](200) NULL,
  [Note3] [varchar](200) NULL,
  [Job1] [varchar](200) NULL,
  [Job2] [varchar](200) NULL,
  [Job3] [varchar](200) NULL,
  [DayBTime] [smalldatetime] NULL,
  [DayETime] [smalldatetime] NULL,
  [EvenBTime] [smalldatetime] NULL,
  [EvenETime] [smalldatetime] NULL,
  [EvenPayFac] [numeric](21, 9) NOT NULL,
  [NightBTime] [smalldatetime] NULL,
  [NightETime] [smalldatetime] NULL,
  [NightPayFac] [numeric](21, 9) NOT NULL,
  [OverPayFactor] [numeric](21, 9) NOT NULL,
  [ActType] [varchar](200) NULL,
  [FinForm] [varchar](200) NULL,
  [PropForm] [varchar](200) NULL,
  [EcActType] [varchar](200) NULL,
  [PensFundID] [varchar](200) NULL,
  [SocInsFundID] [varchar](200) NULL,
  [SocUnEFundID] [varchar](200) NULL,
  [SocAddFundID] [varchar](200) NULL,
  [MinExcPowerID] [varchar](200) NULL,
  [TaxNotes] [varchar](200) NULL,
  [TaxOKPO] [varchar](20) NULL,
  [ActTypeCVED] [varchar](200) NULL,
  [TerritoryID] [varchar](200) NULL,
  [ExcComRegNum] [varchar](200) NULL,
  [SysTaxType] [smallint] NOT NULL,
  [FixTaxPercent] [numeric](21, 9) NOT NULL,
  [TaxPayer] [bit] NOT NULL,
  [OurNameFull] [varchar](250) NOT NULL,
  [IsResident] [bit] NULL DEFAULT (1),
  [CROurName] [varchar](250) NULL,
  CONSTRAINT [pk_r_Ours] PRIMARY KEY CLUSTERED ([OurID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Ours] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [Code]
  ON [dbo].[r_Ours] ([Code])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [OurName]
  ON [dbo].[r_Ours] ([OurName])
  ON [PRIMARY]
GO

CREATE INDEX [TaxCode]
  ON [dbo].[r_Ours] ([TaxCode])
  ON [PRIMARY]
GO

CREATE INDEX [TaxOKPO]
  ON [dbo].[r_Ours] ([TaxOKPO])
  ON [PRIMARY]
GO

CREATE INDEX [TaxRegNo]
  ON [dbo].[r_Ours] ([TaxRegNo])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.EvenPayFac'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.NightPayFac'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.OverPayFactor'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.SysTaxType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Ours.FixTaxPercent'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Ours] ON [r_Ours]
FOR INSERT AS
/* r_Ours - Справочник внутренних фирм - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Ours', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Ours] ON [r_Ours]
FOR UPDATE AS
/* r_Ours - Справочник внутренних фирм - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Ours ^ r_CRSrvs - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник торговых серверов - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_CRSrvs a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRSrvs a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник торговых серверов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ r_EmpMO - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник служащих - Внутренние фирмы - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_EmpMO a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMO a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник служащих - Внутренние фирмы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ r_Assets - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник основных средств - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_Assets a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Assets a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник основных средств''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ r_OursAC - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник внутренних фирм - Валютные счета - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_OursAC a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OursAC a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник внутренних фирм - Валютные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ r_OursCC - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник внутренних фирм - Расчетные счета - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_OursCC a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OursCC a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник внутренних фирм - Расчетные счета''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ r_OurValues - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник внутренних фирм - Значения - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_OurValues a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OurValues a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник внутренних фирм - Значения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ r_DBIs - Обновление CHILD */
/* Справочник внутренних фирм ^ Справочник баз данных - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM r_DBIs a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DBIs a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Справочник баз данных''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Acc - Обновление CHILD */
/* Справочник внутренних фирм ^ Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Acc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Acc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_AExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Акт сдачи услуг - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_AExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_AExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Акт сдачи услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_ARec - Обновление CHILD */
/* Справочник внутренних фирм ^ Акт приемки услуг - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_ARec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Акт приемки услуг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_ARepA - Обновление CHILD */
/* Справочник внутренних фирм ^ Авансовый отчет валютный (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_ARepA a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepA a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Авансовый отчет валютный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_CExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_CExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_CInv - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_CInv a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_CRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_CRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_CRepA - Обновление CHILD */
/* Справочник внутренних фирм ^ Авансовый отчет с признаками (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_CRepA a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepA a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Авансовый отчет с признаками (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_CRet - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_CRet a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Cst - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Cst a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_DStack - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_DStack a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Exp - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Exp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_GTran - Обновление CHILD */
/* Справочник внутренних фирм ^ Таблица проводок (Общие данные) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_GTran a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTran a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Таблица проводок (Общие данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Inv - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Inv a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_LExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Зарплата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_LExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Зарплата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_LRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Зарплата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_LRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Зарплата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_PAcc - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_PAcc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_PCost - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_PCost a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_PEst - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Переоценка партий (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_PEst a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEst a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Переоценка партий (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_PExc - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_PExc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_PVen - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_PVen a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Rec - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Rec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Rem - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Текущие остатки (Данные) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Rem a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rem a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Текущие остатки (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_RemD - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Остатки на дату (Данные) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_RemD a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RemD a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Остатки на дату (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_RepA - Обновление CHILD */
/* Справочник внутренних фирм ^ Авансовый отчет (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_RepA a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepA a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Авансовый отчет (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_Ret - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_Ret a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SDep - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Амортизация: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SDep a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDep a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Амортизация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SExc - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SExc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SInv - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SInv a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SPut - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SPut a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPut a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Ввод в эксплуатацию (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SRep - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SRep a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SVen - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Инвентаризация - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SVen a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVen a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Инвентаризация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_SWer - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Износ (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_SWer a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWer a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Износ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Налоговые накладные: Исходящие - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Налоговые накладные: Исходящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TranC - Обновление CHILD */
/* Справочник внутренних фирм ^ Проводка по предприятию - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TranC a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranC a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Проводка по предприятию''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TranE - Обновление CHILD */
/* Справочник внутренних фирм ^ Проводка по служащему - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TranE a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranE a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Проводка по служащему''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TranH - Обновление CHILD */
/* Справочник внутренних фирм ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TranH a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TranP - Обновление CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TranP a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TranS - Обновление CHILD */
/* Справочник внутренних фирм ^ Основные средства: Проводка - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TranS a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranS a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Основные средства: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TranV - Обновление CHILD */
/* Справочник внутренних фирм ^ Проводка общая - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TranV a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranV a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Проводка общая''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_TRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Налоговые накладные: Входящие - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_TRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Налоговые накладные: Входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_WBill - Обновление CHILD */
/* Справочник внутренних фирм ^ Путевой лист - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_WBill a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInC - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Предприятия - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInC a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInC a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий баланс: Предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInCA - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Касса - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInCA a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInCA a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий баланс: Касса''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInE - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Служащие - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInE a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInE a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий баланс: Служащие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInH - Обновление CHILD */
/* Справочник внутренних фирм ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInH a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInP - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: ТМЦ - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInP a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInP a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий баланс: ТМЦ''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInS - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Основные средства - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInS a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInS a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий баланс: Основные средства''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ b_zInV - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Общие данные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM b_zInV a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInV a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий баланс: Общие данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ c_Sal - Обновление CHILD */
/* Справочник внутренних фирм ^ Начисление денег служащим (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM c_Sal a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_Sal a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Начисление денег служащим (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_CommunalTax - Обновление CHILD */
/* Справочник внутренних фирм ^ Коммунальный налог - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_CommunalTax a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CommunalTax a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Коммунальный налог''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_CWTime - Обновление CHILD */
/* Справочник внутренних фирм ^ Табель учета рабочего времени (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_CWTime a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTime a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Табель учета рабочего времени (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_CWTimeCor - Обновление CHILD */
/* Справочник внутренних фирм ^ Табель учета рабочего времени: Корректировка: Список - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_CWTimeCor a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeCor a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Табель учета рабочего времени: Корректировка: Список''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_DTran - Обновление CHILD */
/* Справочник внутренних фирм ^ Перенос рабочих дней - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_DTran a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_DTran a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Перенос рабочих дней''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EDis - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EDis a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EExc - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EExc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EGiv - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EGiv a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_ELeav - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Отпуск (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_ELeav a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeav a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Отпуск (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_ELeavCor - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Отпуск: Корректировка (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_ELeavCor a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavCor a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Отпуск: Корректировка (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EmpIn - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящие данные по служащим - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EmpIn a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpIn a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящие данные по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EmpSchedExt - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Дополнительный график работы (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EmpSchedExt a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExt a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Дополнительный график работы (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_ESic - Обновление CHILD */
/* Справочник внутренних фирм ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_ESic a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_ETrp - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_ETrp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EWri - Обновление CHILD */
/* Справочник внутренних фирм ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EWri a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_EWrk - Обновление CHILD */
/* Справочник внутренних фирм ^ Выполнение работ (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_EWrk a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrk a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Выполнение работ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_LeaveSched - Обновление CHILD */
/* Справочник внутренних фирм ^ Отпуск: Лимиты по видам (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_LeaveSched a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LeaveSched a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Отпуск: Лимиты по видам (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_LExc - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Кадровое перемещение списком (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_LExc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Кадровое перемещение списком (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_LExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Заработная плата: Выплата (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_LExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Заработная плата: Выплата (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_LMem - Обновление CHILD */
/* Справочник внутренних фирм ^ Штатное расписание (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_LMem a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LMem a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Штатное расписание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_LRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Заработная плата: Начисление (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_LRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Заработная плата: Начисление (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_LStr - Обновление CHILD */
/* Справочник внутренних фирм ^ Штатная численность сотрудников (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_LStr a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LStr a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Штатная численность сотрудников (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_OPWrk - Обновление CHILD */
/* Справочник внутренних фирм ^ Приказ: Производственный (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_OPWrk a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrk a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приказ: Производственный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_PostStruc - Обновление CHILD */
/* Справочник внутренних фирм ^ Структура должностей (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_PostStruc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_PostStruc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Структура должностей (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_SubStruc - Обновление CHILD */
/* Справочник внутренних фирм ^ Структура предприятия (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_SubStruc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_SubStruc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Структура предприятия (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_TSer - Обновление CHILD */
/* Справочник внутренних фирм ^ Командировочное удостоверение (Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_TSer a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_TSer a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Командировочное удостоверение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ p_WExc - Обновление CHILD */
/* Справочник внутренних фирм ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM p_WExc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Привлечение на другую работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Acc - Обновление CHILD */
/* Справочник внутренних фирм ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Acc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Cos - Обновление CHILD */
/* Справочник внутренних фирм ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Cos a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_CRet - Обновление CHILD */
/* Справочник внутренних фирм ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_CRet a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_CRRet - Обновление CHILD */
/* Справочник внутренних фирм ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_CRRet a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Cst - Обновление CHILD */
/* Справочник внутренних фирм ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Cst a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Cst2 - Обновление CHILD */
/* Справочник внутренних фирм ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Cst2 a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_DeskRes - Обновление CHILD */
/* Справочник внутренних фирм ^ Ресторан: Резервирование столиков - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_DeskRes a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DeskRes a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Ресторан: Резервирование столиков''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Dis - Обновление CHILD */
/* Справочник внутренних фирм ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Dis a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_DisDD - Обновление CHILD */
/* Справочник внутренних фирм ^ Распределение товара: Подробно - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetOurID = i.OurID
          FROM t_DisDD a, inserted i, deleted d WHERE a.DetOurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DisDD a, deleted d WHERE a.DetOurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Распределение товара: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_EOExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_EOExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_EOExpDD - Обновление CHILD */
/* Справочник внутренних фирм ^ Заказ внешний: Формирование: Подробно - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetOurID = i.OurID
          FROM t_EOExpDD a, inserted i, deleted d WHERE a.DetOurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpDD a, deleted d WHERE a.DetOurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Заказ внешний: Формирование: Подробно''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Epp - Обновление CHILD */
/* Справочник внутренних фирм ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Epp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Est - Обновление CHILD */
/* Справочник внутренних фирм ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Est a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Exc - Обновление CHILD */
/* Справочник внутренних фирм ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Exc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Exp - Обновление CHILD */
/* Справочник внутренних фирм ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Exp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Inv - Обновление CHILD */
/* Справочник внутренних фирм ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Inv a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_IORec - Обновление CHILD */
/* Справочник внутренних фирм ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_IORec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_MonIntExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Служебный расход денег - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_MonIntExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Служебный расход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_MonIntRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Служебный приход денег - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_MonIntRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonIntRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Служебный приход денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_MonRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_MonRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Rec - Обновление CHILD */
/* Справочник внутренних фирм ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Rec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Rem - Обновление CHILD */
/* Справочник внутренних фирм ^ Остатки товара (Таблица) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Rem a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rem a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Остатки товара (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_RemD - Обновление CHILD */
/* Справочник внутренних фирм ^ Остатки товара на дату (Таблица) - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_RemD a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RemD a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Остатки товара на дату (Таблица)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_RestShift - Обновление CHILD */
/* Справочник внутренних фирм ^ Ресторан: Смена: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_RestShift a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RestShift a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Ресторан: Смена: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Ret - Обновление CHILD */
/* Справочник внутренних фирм ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Ret a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Sale - Обновление CHILD */
/* Справочник внутренних фирм ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Sale a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_SEst - Обновление CHILD */
/* Справочник внутренних фирм ^ Переоценка цен продажи: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_SEst a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEst a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Переоценка цен продажи: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_SExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_SExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Spec - Обновление CHILD */
/* Справочник внутренних фирм ^ Калькуляционная карта: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Spec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Spec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Калькуляционная карта: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_SPExp - Обновление CHILD */
/* Справочник внутренних фирм ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_SPExp a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_SPRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_SPRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_SRec - Обновление CHILD */
/* Справочник внутренних фирм ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_SRec a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_Ven - Обновление CHILD */
/* Справочник внутренних фирм ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_Ven a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_zInP - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящие остатки товара - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_zInP a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_zInP a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящие остатки товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ t_ZRepT - Обновление CHILD */
/* Справочник внутренних фирм ^ Z-отчеты плат. терминалов - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM t_ZRepT a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ZRepT a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Z-отчеты плат. терминалов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_Contracts - Обновление CHILD */
/* Справочник внутренних фирм ^ Договор - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_Contracts a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Contracts a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Договор''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_InAcc - Обновление CHILD */
/* Справочник внутренних фирм ^ Входящий счет на оплату - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_InAcc a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_InAcc a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Входящий счет на оплату''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_OpenAge - Обновление CHILD */
/* Справочник внутренних фирм ^ Открытый период: Фирмы - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_OpenAge a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_OpenAge a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Открытый период: Фирмы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_OpenAgeH - Обновление CHILD */
/* Справочник внутренних фирм ^ Открытый период: Фирмы: История - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_OpenAgeH a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_OpenAgeH a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Открытый период: Фирмы: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_UserOpenAge - Обновление CHILD */
/* Справочник внутренних фирм ^ Открытый период: Пользователи - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_UserOpenAge a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOpenAge a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Открытый период: Пользователи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_UserOpenAgeH - Обновление CHILD */
/* Справочник внутренних фирм ^ Открытый период: Пользователи: История - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_UserOpenAgeH a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOpenAgeH a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Открытый период: Пользователи: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_UserOurs - Обновление CHILD */
/* Справочник внутренних фирм ^ Доступные значения - Справочник внутренних фирм - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID
          FROM z_UserOurs a, inserted i, deleted d WHERE a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserOurs a, deleted d WHERE a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Доступные значения - Справочник внутренних фирм''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_UserVars - Обновление CHILD */
/* Справочник внутренних фирм ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_OurID', a.VarValue = i.OurID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 't_OurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 't_OurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_UserVars - Обновление CHILD */
/* Справочник внутренних фирм ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'b_OurID', a.VarValue = i.OurID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 'b_OurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 'b_OurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_UserVars - Обновление CHILD */
/* Справочник внутренних фирм ^ Пользователи - Переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'c_OurID', a.VarValue = i.OurID
          FROM z_UserVars a, inserted i, deleted d WHERE a.VarName = 'c_OurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_UserVars a, deleted d WHERE a.VarName = 'c_OurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Пользователи - Переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_Vars - Обновление CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'c_OurID', a.VarValue = i.OurID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'c_OurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'c_OurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_Vars - Обновление CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'OT_MainOurID', a.VarValue = i.OurID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'OT_MainOurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'OT_MainOurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_Vars - Обновление CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 'b_OurID', a.VarValue = i.OurID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 'b_OurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 'b_OurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Системные переменные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Ours ^ z_Vars - Обновление CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Обновление CHILD */
  IF UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.VarName = 't_OurID', a.VarValue = i.OurID
          FROM z_Vars a, inserted i, deleted d WHERE a.VarName = 't_OurID' AND a.VarValue = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Vars a, deleted d WHERE a.VarName = 't_OurID' AND a.VarValue = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм'' => ''Системные переменные''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10110001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10110001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(OurID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10110001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' AND i.OurID = d.OurID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10110001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' AND i.OurID = d.OurID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10110001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10110001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10110001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10110001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10110001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10110001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10110001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10110001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10110001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10110001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Ours', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Ours] ON [r_Ours]
FOR DELETE AS
/* r_Ours - Справочник внутренних фирм - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Ours ^ r_CRSrvs - Проверка в CHILD */
/* Справочник внутренних фирм ^ Справочник торговых серверов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRSrvs a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_CRSrvs', 3
      RETURN
    END

/* r_Ours ^ r_EmpMO - Проверка в CHILD */
/* Справочник внутренних фирм ^ Справочник служащих - Внутренние фирмы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_EmpMO a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_EmpMO', 3
      RETURN
    END

/* r_Ours ^ r_Assets - Проверка в CHILD */
/* Справочник внутренних фирм ^ Справочник основных средств - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Assets a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_Assets', 3
      RETURN
    END

/* r_Ours ^ r_OursAC - Удаление в CHILD */
/* Справочник внутренних фирм ^ Справочник внутренних фирм - Валютные счета - Удаление в CHILD */
  DELETE r_OursAC FROM r_OursAC a, deleted d WHERE a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_Ours ^ r_OursCC - Удаление в CHILD */
/* Справочник внутренних фирм ^ Справочник внутренних фирм - Расчетные счета - Удаление в CHILD */
  DELETE r_OursCC FROM r_OursCC a, deleted d WHERE a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_Ours ^ r_OurValues - Проверка в CHILD */
/* Справочник внутренних фирм ^ Справочник внутренних фирм - Значения - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OurValues a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_OurValues', 3
      RETURN
    END

/* r_Ours ^ r_DBIs - Проверка в CHILD */
/* Справочник внутренних фирм ^ Справочник баз данных - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DBIs a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_DBIs', 3
      RETURN
    END

/* r_Ours ^ b_Acc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Acc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Acc', 3
      RETURN
    END

/* r_Ours ^ b_AExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Акт сдачи услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_AExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_AExp', 3
      RETURN
    END

/* r_Ours ^ b_ARec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Акт приемки услуг - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_ARec', 3
      RETURN
    END

/* r_Ours ^ b_ARepA - Проверка в CHILD */
/* Справочник внутренних фирм ^ Авансовый отчет валютный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepA a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_ARepA', 3
      RETURN
    END

/* r_Ours ^ b_CExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_CExp', 3
      RETURN
    END

/* r_Ours ^ b_CInv - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_CInv', 3
      RETURN
    END

/* r_Ours ^ b_CRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_CRec', 3
      RETURN
    END

/* r_Ours ^ b_CRepA - Проверка в CHILD */
/* Справочник внутренних фирм ^ Авансовый отчет с признаками (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepA a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_CRepA', 3
      RETURN
    END

/* r_Ours ^ b_CRet - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_CRet', 3
      RETURN
    END

/* r_Ours ^ b_Cst - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Cst', 3
      RETURN
    END

/* r_Ours ^ b_DStack - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_DStack', 3
      RETURN
    END

/* r_Ours ^ b_Exp - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Exp', 3
      RETURN
    END

/* r_Ours ^ b_GTran - Проверка в CHILD */
/* Справочник внутренних фирм ^ Таблица проводок (Общие данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTran a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_GTran', 3
      RETURN
    END

/* r_Ours ^ b_Inv - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Inv', 3
      RETURN
    END

/* r_Ours ^ b_LExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Зарплата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_LExp', 3
      RETURN
    END

/* r_Ours ^ b_LRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Зарплата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_LRec', 3
      RETURN
    END

/* r_Ours ^ b_PAcc - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PAcc', 3
      RETURN
    END

/* r_Ours ^ b_PCost - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PCost', 3
      RETURN
    END

/* r_Ours ^ b_PEst - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEst a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PEst', 3
      RETURN
    END

/* r_Ours ^ b_PExc - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PExc', 3
      RETURN
    END

/* r_Ours ^ b_PVen - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PVen', 3
      RETURN
    END

/* r_Ours ^ b_Rec - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Rec', 3
      RETURN
    END

/* r_Ours ^ b_Rem - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Текущие остатки (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rem a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Rem', 3
      RETURN
    END

/* r_Ours ^ b_RemD - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Остатки на дату (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RemD a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_RemD', 3
      RETURN
    END

/* r_Ours ^ b_RepA - Проверка в CHILD */
/* Справочник внутренних фирм ^ Авансовый отчет (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepA a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_RepA', 3
      RETURN
    END

/* r_Ours ^ b_Ret - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_Ret', 3
      RETURN
    END

/* r_Ours ^ b_SDep - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Амортизация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDep a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SDep', 3
      RETURN
    END

/* r_Ours ^ b_SExc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SExc', 3
      RETURN
    END

/* r_Ours ^ b_SExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SExp', 3
      RETURN
    END

/* r_Ours ^ b_SInv - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SInv', 3
      RETURN
    END

/* r_Ours ^ b_SPut - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPut a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SPut', 3
      RETURN
    END

/* r_Ours ^ b_SRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SRec', 3
      RETURN
    END

/* r_Ours ^ b_SRep - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SRep', 3
      RETURN
    END

/* r_Ours ^ b_SVen - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Инвентаризация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVen a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SVen', 3
      RETURN
    END

/* r_Ours ^ b_SWer - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Износ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWer a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_SWer', 3
      RETURN
    END

/* r_Ours ^ b_TExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Налоговые накладные: Исходящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TExp', 3
      RETURN
    END

/* r_Ours ^ b_TranC - Проверка в CHILD */
/* Справочник внутренних фирм ^ Проводка по предприятию - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranC a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranC', 3
      RETURN
    END

/* r_Ours ^ b_TranE - Проверка в CHILD */
/* Справочник внутренних фирм ^ Проводка по служащему - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranE a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranE', 3
      RETURN
    END

/* r_Ours ^ b_TranH - Проверка в CHILD */
/* Справочник внутренних фирм ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranH', 3
      RETURN
    END

/* r_Ours ^ b_TranP - Проверка в CHILD */
/* Справочник внутренних фирм ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranP', 3
      RETURN
    END

/* r_Ours ^ b_TranS - Проверка в CHILD */
/* Справочник внутренних фирм ^ Основные средства: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranS a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranS', 3
      RETURN
    END

/* r_Ours ^ b_TranV - Проверка в CHILD */
/* Справочник внутренних фирм ^ Проводка общая - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranV a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TranV', 3
      RETURN
    END

/* r_Ours ^ b_TRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Налоговые накладные: Входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_TRec', 3
      RETURN
    END

/* r_Ours ^ b_WBill - Проверка в CHILD */
/* Справочник внутренних фирм ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_WBill', 3
      RETURN
    END

/* r_Ours ^ b_zInC - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInC a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInC', 3
      RETURN
    END

/* r_Ours ^ b_zInCA - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Касса - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInCA a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInCA', 3
      RETURN
    END

/* r_Ours ^ b_zInE - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Служащие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInE a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInE', 3
      RETURN
    END

/* r_Ours ^ b_zInH - Проверка в CHILD */
/* Справочник внутренних фирм ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInH', 3
      RETURN
    END

/* r_Ours ^ b_zInP - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: ТМЦ - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInP a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInP', 3
      RETURN
    END

/* r_Ours ^ b_zInS - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Основные средства - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInS a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInS', 3
      RETURN
    END

/* r_Ours ^ b_zInV - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий баланс: Общие данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInV a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInV', 3
      RETURN
    END

/* r_Ours ^ c_Sal - Проверка в CHILD */
/* Справочник внутренних фирм ^ Начисление денег служащим (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_Sal a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'c_Sal', 3
      RETURN
    END

/* r_Ours ^ p_CommunalTax - Проверка в CHILD */
/* Справочник внутренних фирм ^ Коммунальный налог - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CommunalTax a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_CommunalTax', 3
      RETURN
    END

/* r_Ours ^ p_CWTime - Проверка в CHILD */
/* Справочник внутренних фирм ^ Табель учета рабочего времени (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTime a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_CWTime', 3
      RETURN
    END

/* r_Ours ^ p_CWTimeCor - Проверка в CHILD */
/* Справочник внутренних фирм ^ Табель учета рабочего времени: Корректировка: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeCor a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_CWTimeCor', 3
      RETURN
    END

/* r_Ours ^ p_DTran - Проверка в CHILD */
/* Справочник внутренних фирм ^ Перенос рабочих дней - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_DTran a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_DTran', 3
      RETURN
    END

/* r_Ours ^ p_EDis - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EDis', 3
      RETURN
    END

/* r_Ours ^ p_EExc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EExc', 3
      RETURN
    END

/* r_Ours ^ p_EGiv - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EGiv', 3
      RETURN
    END

/* r_Ours ^ p_ELeav - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Отпуск (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeav a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_ELeav', 3
      RETURN
    END

/* r_Ours ^ p_ELeavCor - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavCor a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_ELeavCor', 3
      RETURN
    END

/* r_Ours ^ p_EmpIn - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящие данные по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpIn a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EmpIn', 3
      RETURN
    END

/* r_Ours ^ p_EmpSchedExt - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Дополнительный график работы (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExt a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EmpSchedExt', 3
      RETURN
    END

/* r_Ours ^ p_ESic - Проверка в CHILD */
/* Справочник внутренних фирм ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_ESic', 3
      RETURN
    END

/* r_Ours ^ p_ETrp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_ETrp', 3
      RETURN
    END

/* r_Ours ^ p_EWri - Проверка в CHILD */
/* Справочник внутренних фирм ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EWri', 3
      RETURN
    END

/* r_Ours ^ p_EWrk - Проверка в CHILD */
/* Справочник внутренних фирм ^ Выполнение работ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrk a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EWrk', 3
      RETURN
    END

/* r_Ours ^ p_LeaveSched - Проверка в CHILD */
/* Справочник внутренних фирм ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LeaveSched a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_LeaveSched', 3
      RETURN
    END

/* r_Ours ^ p_LExc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Кадровое перемещение списком (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_LExc', 3
      RETURN
    END

/* r_Ours ^ p_LExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Заработная плата: Выплата (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_LExp', 3
      RETURN
    END

/* r_Ours ^ p_LMem - Проверка в CHILD */
/* Справочник внутренних фирм ^ Штатное расписание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LMem a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_LMem', 3
      RETURN
    END

/* r_Ours ^ p_LRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Заработная плата: Начисление (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_LRec', 3
      RETURN
    END

/* r_Ours ^ p_LStr - Проверка в CHILD */
/* Справочник внутренних фирм ^ Штатная численность сотрудников (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LStr a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_LStr', 3
      RETURN
    END

/* r_Ours ^ p_OPWrk - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приказ: Производственный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrk a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_OPWrk', 3
      RETURN
    END

/* r_Ours ^ p_PostStruc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Структура должностей (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_PostStruc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_PostStruc', 3
      RETURN
    END

/* r_Ours ^ p_SubStruc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Структура предприятия (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_SubStruc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_SubStruc', 3
      RETURN
    END

/* r_Ours ^ p_TSer - Проверка в CHILD */
/* Справочник внутренних фирм ^ Командировочное удостоверение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_TSer a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_TSer', 3
      RETURN
    END

/* r_Ours ^ p_WExc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_WExc', 3
      RETURN
    END

/* r_Ours ^ t_Acc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Acc', 3
      RETURN
    END

/* r_Ours ^ t_Cos - Проверка в CHILD */
/* Справочник внутренних фирм ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Cos', 3
      RETURN
    END

/* r_Ours ^ t_CRet - Проверка в CHILD */
/* Справочник внутренних фирм ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_CRet', 3
      RETURN
    END

/* r_Ours ^ t_CRRet - Проверка в CHILD */
/* Справочник внутренних фирм ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_CRRet', 3
      RETURN
    END

/* r_Ours ^ t_Cst - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Cst', 3
      RETURN
    END

/* r_Ours ^ t_Cst2 - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Cst2', 3
      RETURN
    END

/* r_Ours ^ t_DeskRes - Проверка в CHILD */
/* Справочник внутренних фирм ^ Ресторан: Резервирование столиков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DeskRes a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_DeskRes', 3
      RETURN
    END

/* r_Ours ^ t_Dis - Проверка в CHILD */
/* Справочник внутренних фирм ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Dis', 3
      RETURN
    END

/* r_Ours ^ t_DisDD - Проверка в CHILD */
/* Справочник внутренних фирм ^ Распределение товара: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DisDD a WITH(NOLOCK), deleted d WHERE a.DetOurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_DisDD', 3
      RETURN
    END

/* r_Ours ^ t_EOExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_EOExp', 3
      RETURN
    END

/* r_Ours ^ t_EOExpDD - Проверка в CHILD */
/* Справочник внутренних фирм ^ Заказ внешний: Формирование: Подробно - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExpDD a WITH(NOLOCK), deleted d WHERE a.DetOurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_EOExpDD', 3
      RETURN
    END

/* r_Ours ^ t_Epp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Epp', 3
      RETURN
    END

/* r_Ours ^ t_Est - Проверка в CHILD */
/* Справочник внутренних фирм ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Est', 3
      RETURN
    END

/* r_Ours ^ t_Exc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Exc', 3
      RETURN
    END

/* r_Ours ^ t_Exp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Exp', 3
      RETURN
    END

/* r_Ours ^ t_Inv - Проверка в CHILD */
/* Справочник внутренних фирм ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Inv', 3
      RETURN
    END

/* r_Ours ^ t_IORec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_IORec', 3
      RETURN
    END

/* r_Ours ^ t_MonIntExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Служебный расход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_MonIntExp', 3
      RETURN
    END

/* r_Ours ^ t_MonIntRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Служебный приход денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonIntRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_MonIntRec', 3
      RETURN
    END

/* r_Ours ^ t_MonRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_MonRec', 3
      RETURN
    END

/* r_Ours ^ t_Rec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Rec', 3
      RETURN
    END

/* r_Ours ^ t_Rem - Проверка в CHILD */
/* Справочник внутренних фирм ^ Остатки товара (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rem a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Rem', 3
      RETURN
    END

/* r_Ours ^ t_RemD - Проверка в CHILD */
/* Справочник внутренних фирм ^ Остатки товара на дату (Таблица) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RemD a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_RemD', 3
      RETURN
    END

/* r_Ours ^ t_RestShift - Проверка в CHILD */
/* Справочник внутренних фирм ^ Ресторан: Смена: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RestShift a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_RestShift', 3
      RETURN
    END

/* r_Ours ^ t_Ret - Проверка в CHILD */
/* Справочник внутренних фирм ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Ret', 3
      RETURN
    END

/* r_Ours ^ t_Sale - Проверка в CHILD */
/* Справочник внутренних фирм ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Sale', 3
      RETURN
    END

/* r_Ours ^ t_SEst - Проверка в CHILD */
/* Справочник внутренних фирм ^ Переоценка цен продажи: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEst a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_SEst', 3
      RETURN
    END

/* r_Ours ^ t_SExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_SExp', 3
      RETURN
    END

/* r_Ours ^ t_Spec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Калькуляционная карта: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Spec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Spec', 3
      RETURN
    END

/* r_Ours ^ t_SPExp - Проверка в CHILD */
/* Справочник внутренних фирм ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_SPExp', 3
      RETURN
    END

/* r_Ours ^ t_SPRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_SPRec', 3
      RETURN
    END

/* r_Ours ^ t_SRec - Проверка в CHILD */
/* Справочник внутренних фирм ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_SRec', 3
      RETURN
    END

/* r_Ours ^ t_Ven - Проверка в CHILD */
/* Справочник внутренних фирм ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Ven', 3
      RETURN
    END

/* r_Ours ^ t_zInP - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящие остатки товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zInP a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_zInP', 3
      RETURN
    END

/* r_Ours ^ t_ZRepT - Проверка в CHILD */
/* Справочник внутренних фирм ^ Z-отчеты плат. терминалов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_ZRepT a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_ZRepT', 3
      RETURN
    END

/* r_Ours ^ z_Contracts - Проверка в CHILD */
/* Справочник внутренних фирм ^ Договор - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Contracts a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Contracts', 3
      RETURN
    END

/* r_Ours ^ z_InAcc - Проверка в CHILD */
/* Справочник внутренних фирм ^ Входящий счет на оплату - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_InAcc a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_InAcc', 3
      RETURN
    END

/* r_Ours ^ z_OpenAge - Проверка в CHILD */
/* Справочник внутренних фирм ^ Открытый период: Фирмы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_OpenAge a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_OpenAge', 3
      RETURN
    END

/* r_Ours ^ z_OpenAgeH - Проверка в CHILD */
/* Справочник внутренних фирм ^ Открытый период: Фирмы: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_OpenAgeH a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_OpenAgeH', 3
      RETURN
    END

/* r_Ours ^ z_UserOpenAge - Проверка в CHILD */
/* Справочник внутренних фирм ^ Открытый период: Пользователи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserOpenAge a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserOpenAge', 3
      RETURN
    END

/* r_Ours ^ z_UserOpenAgeH - Проверка в CHILD */
/* Справочник внутренних фирм ^ Открытый период: Пользователи: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserOpenAgeH a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserOpenAgeH', 3
      RETURN
    END

/* r_Ours ^ z_UserOurs - Удаление в CHILD */
/* Справочник внутренних фирм ^ Доступные значения - Справочник внутренних фирм - Удаление в CHILD */
  DELETE z_UserOurs FROM z_UserOurs a, deleted d WHERE a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_Ours ^ z_UserVars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_OurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserVars', 3
      RETURN
    END

/* r_Ours ^ z_UserVars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 'b_OurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserVars', 3
      RETURN
    END

/* r_Ours ^ z_UserVars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Пользователи - Переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_UserVars a WITH(NOLOCK), deleted d WHERE a.VarName = 'c_OurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_UserVars', 3
      RETURN
    END

/* r_Ours ^ z_Vars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'c_OurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 3
      RETURN
    END

/* r_Ours ^ z_Vars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'OT_MainOurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 3
      RETURN
    END

/* r_Ours ^ z_Vars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 'b_OurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 3
      RETURN
    END

/* r_Ours ^ z_Vars - Проверка в CHILD */
/* Справочник внутренних фирм ^ Системные переменные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Vars a WITH(NOLOCK), deleted d WHERE a.VarName = 't_OurID' AND a.VarValue = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_Ours', 'z_Vars', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10110001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10110001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10110001, -ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10110 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Ours', N'Last', N'DELETE'
GO