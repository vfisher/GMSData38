CREATE TABLE [dbo].[r_Emps]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[EmpName] [varchar] (200) NOT NULL,
[UAEmpName] [varchar] (200) NOT NULL,
[EmpLastName] [varchar] (200) NULL,
[EmpFirstName] [varchar] (200) NULL,
[EmpParName] [varchar] (200) NULL,
[UAEmpLastName] [varchar] (200) NULL,
[UAEmpFirstName] [varchar] (200) NULL,
[UAEmpParName] [varchar] (200) NULL,
[EmpInitials] [varchar] (200) NULL,
[UAEmpInitials] [varchar] (200) NULL,
[TaxCode] [varchar] (50) NULL,
[EmpSex] [tinyint] NOT NULL,
[BirthDay] [smalldatetime] NULL,
[File1] [varchar] (200) NULL,
[File2] [varchar] (200) NULL,
[File3] [varchar] (200) NULL,
[Education] [smallint] NULL,
[FamilyStatus] [smallint] NULL,
[BirthPlace] [varchar] (200) NULL,
[Phone] [varchar] (20) NULL,
[InPhone] [varchar] (20) NULL,
[Mobile] [varchar] (200) NULL,
[EMail] [varchar] (200) NULL,
[Percent1] [numeric] (21, 9) NOT NULL,
[Percent2] [numeric] (21, 9) NOT NULL,
[Percent3] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[MilStatus] [smallint] NULL,
[MilFitness] [smallint] NULL,
[MilRank] [varchar] (200) NULL,
[MilSpecialCalc] [varchar] (200) NULL,
[MilProfes] [varchar] (200) NULL,
[MilCalcGrp] [varchar] (200) NULL,
[MilCalcCat] [varchar] (200) NULL,
[MilStaff] [varchar] (200) NULL,
[MilRegOffice] [varchar] (200) NULL,
[MilNum] [varchar] (20) NULL,
[PassNo] [varchar] (50) NULL,
[PassSer] [varchar] (50) NULL,
[PassDate] [smalldatetime] NULL,
[PassDept] [varchar] (200) NULL,
[DisNum] [varchar] (20) NULL,
[PensNum] [varchar] (20) NULL,
[WorkBookNo] [varchar] (50) NULL,
[WorkBookSer] [varchar] (50) NULL,
[PerFileNo] [varchar] (50) NULL,
[InStopList] [bit] NOT NULL,
[BarCode] [varchar] (250) NULL,
[ShiftPostID] [int] NOT NULL DEFAULT (0),
[IsCitizen] [bit] NOT NULL DEFAULT (1),
[CertInsurSer] [varchar] (250) NULL,
[CertInsurNum] [varchar] (250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Emps] ON [dbo].[r_Emps]
FOR INSERT AS
/* r_Emps - Справочник служащих - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpSex NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10011))
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10011, 0
      RETURN
    END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.Education IS NOT NULL AND i.Education NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10061))
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10061, 0
      RETURN
    END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.FamilyStatus IS NOT NULL AND i.FamilyStatus NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10062))
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10062, 0
      RETURN
    END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MilStatus IS NOT NULL AND i.MilStatus NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10063))
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10063, 0
      RETURN
    END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MilFitness IS NOT NULL AND i.MilFitness NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10064))
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10064, 0
      RETURN
    END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ShiftPostID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10606))
    BEGIN
      EXEC z_RelationErrorUni 'r_Emps', 10606, 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120001, ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Emps]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Emps] ON [dbo].[r_Emps]
FOR UPDATE AS
/* r_Emps - Справочник служащих - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(EmpSex)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpSex NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10011))
      BEGIN
        EXEC z_RelationErrorUni 'r_Emps', 10011, 1
        RETURN
      END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(Education)
    IF EXISTS (SELECT * FROM inserted i WHERE i.Education IS NOT NULL AND i.Education NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10061))
      BEGIN
        EXEC z_RelationErrorUni 'r_Emps', 10061, 1
        RETURN
      END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(FamilyStatus)
    IF EXISTS (SELECT * FROM inserted i WHERE i.FamilyStatus IS NOT NULL AND i.FamilyStatus NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10062))
      BEGIN
        EXEC z_RelationErrorUni 'r_Emps', 10062, 1
        RETURN
      END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(MilStatus)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MilStatus IS NOT NULL AND i.MilStatus NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10063))
      BEGIN
        EXEC z_RelationErrorUni 'r_Emps', 10063, 1
        RETURN
      END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(MilFitness)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MilFitness IS NOT NULL AND i.MilFitness NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10064))
      BEGIN
        EXEC z_RelationErrorUni 'r_Emps', 10064, 1
        RETURN
      END

/* r_Emps ^ r_Uni - Проверка в PARENT */
/* Справочник служащих ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(ShiftPostID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ShiftPostID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10606))
      BEGIN
        EXEC z_RelationErrorUni 'r_Emps', 10606, 1
        RETURN
      END

/* r_Emps ^ r_Opers - Обновление CHILD */
/* Справочник служащих ^ Справочник ЭККА: операторы - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_Opers a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Opers a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник ЭККА: операторы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_EmpAct - Обновление CHILD */
/* Справочник служащих ^ Справочник служащих - Трудовая деятельность - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_EmpAct a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpAct a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник служащих - Трудовая деятельность''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_EmpAdd - Обновление CHILD */
/* Справочник служащих ^ Справочник служащих - Прописка и место жительства - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_EmpAdd a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpAdd a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник служащих - Прописка и место жительства''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_EmpFiles - Обновление CHILD */
/* Справочник служащих ^ Справочник служащих: Документы - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_EmpFiles a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpFiles a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник служащих: Документы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_EmpKin - Обновление CHILD */
/* Справочник служащих ^ Справочник служащих - Члены семьи - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_EmpKin a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpKin a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник служащих - Члены семьи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_EmpMO - Обновление CHILD */
/* Справочник служащих ^ Справочник служащих - Внутренние фирмы - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_EmpMO a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMO a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник служащих - Внутренние фирмы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_Stocks - Обновление CHILD */
/* Справочник служащих ^ Справочник складов - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_Stocks a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Stocks a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник складов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_WPRoles - Обновление CHILD */
/* Справочник служащих ^ Справочник рабочих мест: роли - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PosEmpID = i.EmpID
          FROM r_WPRoles a, inserted i, deleted d WHERE a.PosEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_WPRoles a, deleted d WHERE a.PosEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник рабочих мест: роли''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_GOperD - Обновление CHILD */
/* Справочник служащих ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_EmpID = i.EmpID
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_GOperD - Обновление CHILD */
/* Справочник служащих ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_EmpID = i.EmpID
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_Comps - Обновление CHILD */
/* Справочник служащих ^ Справочник предприятий - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_Comps a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Comps a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник предприятий''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_Users - Обновление CHILD */
/* Справочник служащих ^ Справочник пользователей - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_Users a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Users a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник пользователей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_AssetH - Обновление CHILD */
/* Справочник служащих ^ Справочник основных средств: История - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_AssetH a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_AssetH a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник основных средств: История''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_Executors - Обновление CHILD */
/* Справочник служащих ^ Справочник исполнителей - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM r_Executors a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Executors a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Справочник исполнителей''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ r_GAccs - Обновление CHILD */
/* Справочник служащих ^ План счетов - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_EmpID = i.EmpID
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_ARepA - Обновление CHILD */
/* Справочник служащих ^ Авансовый отчет валютный (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_ARepA a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_ARepA a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Авансовый отчет валютный (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_BankExpAC - Обновление CHILD */
/* Справочник служащих ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_BankExpCC - Обновление CHILD */
/* Справочник служащих ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_BankRecAC - Обновление CHILD */
/* Справочник служащих ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_BankRecCC - Обновление CHILD */
/* Справочник служащих ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CExp - Обновление CHILD */
/* Справочник служащих ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CashEmpID = i.EmpID
          FROM b_CExp a, inserted i, deleted d WHERE a.CashEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.CashEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CExp - Обновление CHILD */
/* Справочник служащих ^ Кассовый ордер: Расход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_CExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Кассовый ордер: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CInv - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Расход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_CInv a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CInv a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Расход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CRec - Обновление CHILD */
/* Справочник служащих ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CashEmpID = i.EmpID
          FROM b_CRec a, inserted i, deleted d WHERE a.CashEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.CashEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CRec - Обновление CHILD */
/* Справочник служащих ^ Кассовый ордер: Приход - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_CRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Кассовый ордер: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CRepA - Обновление CHILD */
/* Справочник служащих ^ Авансовый отчет с признаками (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_CRepA a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRepA a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Авансовый отчет с признаками (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_CRet - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Возврат поставщику (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_CRet a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_CRet a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Возврат поставщику (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_Cst - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Приход по ГТД (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_Cst a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Cst a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Приход по ГТД (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_DStack - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Суммовой учет - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_DStack a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_DStack a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Суммовой учет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_Exp - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Внутренний расход (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_Exp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Exp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Внутренний расход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_GTranD - Обновление CHILD */
/* Справочник служащих ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_EmpID = i.EmpID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_GTranD - Обновление CHILD */
/* Справочник служащих ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_EmpID = i.EmpID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_Inv - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Расходная накладная (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_Inv a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Inv a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Расходная накладная (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_LExpD - Обновление CHILD */
/* Справочник служащих ^ Зарплата: Выплата (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_LExpD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LExpD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Зарплата: Выплата (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_LRecD - Обновление CHILD */
/* Справочник служащих ^ Зарплата: Начисление (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_LRecD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_LRecD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Зарплата: Начисление (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_PAcc - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Счет на оплату (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_PAcc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PAcc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Счет на оплату (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_PCost - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Формирование себестоимости (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_PCost a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCost a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Формирование себестоимости (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_PEst - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Переоценка партий (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_PEst a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PEst a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Переоценка партий (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_PExc - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_PExc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PExc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_PVen - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Инвентаризация (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_PVen a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PVen a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Инвентаризация (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_Rec - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Приход по накладной (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_Rec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Rec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Приход по накладной (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_RepA - Обновление CHILD */
/* Справочник служащих ^ Авансовый отчет (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_RepA a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_RepA a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Авансовый отчет (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_Ret - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Возврат от получателя (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_Ret a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_Ret a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Возврат от получателя (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SDep - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Амортизация: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SDep a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SDep a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Амортизация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SExc - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SExc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SExc - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Перемещение (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewEmpID = i.EmpID
          FROM b_SExc a, inserted i, deleted d WHERE a.NewEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExc a, deleted d WHERE a.NewEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Перемещение (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SExp - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Списание (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Списание (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SInv - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Продажа (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SInv a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SInv a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Продажа (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SPut - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SPut a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SPut a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Ввод в эксплуатацию (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SRec - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Приход (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Приход (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SRep - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Ремонт (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SRep a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SRep a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Ремонт (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SVen - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Инвентаризация - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SVen a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SVen a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Инвентаризация''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_SWer - Обновление CHILD */
/* Справочник служащих ^ Основные средства: Износ (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_SWer a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_SWer a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Основные средства: Износ (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_TranE - Обновление CHILD */
/* Справочник служащих ^ Проводка по служащему - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_TranE a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranE a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Проводка по служащему''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_TranH - Обновление CHILD */
/* Справочник служащих ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_EmpID = i.EmpID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_TranH - Обновление CHILD */
/* Справочник служащих ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_EmpID = i.EmpID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_TranP - Обновление CHILD */
/* Справочник служащих ^ ТМЦ: Проводка - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_TranP a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranP a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''ТМЦ: Проводка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_WBill - Обновление CHILD */
/* Справочник служащих ^ Путевой лист - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_WBill a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_zInE - Обновление CHILD */
/* Справочник служащих ^ Входящий баланс: Служащие - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_zInE a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInE a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Входящий баланс: Служащие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_zInH - Обновление CHILD */
/* Справочник служащих ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_EmpID = i.EmpID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_zInH - Обновление CHILD */
/* Справочник служащих ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_EmpID = i.EmpID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_zInP - Обновление CHILD */
/* Справочник служащих ^ Входящий баланс: ТМЦ - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_zInP a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInP a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Входящий баланс: ТМЦ''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ b_zInS - Обновление CHILD */
/* Справочник служащих ^ Входящий баланс: Основные средства - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM b_zInS a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInS a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Входящий баланс: Основные средства''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_CompExp - Обновление CHILD */
/* Справочник служащих ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_CompExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_CompRec - Обновление CHILD */
/* Справочник служащих ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_CompRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpCor - Обновление CHILD */
/* Справочник служащих ^ Корректировка баланса служащего - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpCor a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCor a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Корректировка баланса служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpCurr - Обновление CHILD */
/* Справочник служащих ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpExc - Обновление CHILD */
/* Справочник служащих ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpExc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpExc - Обновление CHILD */
/* Справочник служащих ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewEmpID = i.EmpID
          FROM c_EmpExc a, inserted i, deleted d WHERE a.NewEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.NewEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpExp - Обновление CHILD */
/* Справочник служащих ^ Расход денег по служащим - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpIn - Обновление CHILD */
/* Справочник служащих ^ Входящий баланс: Служащие (Финансы) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpIn a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpIn a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Входящий баланс: Служащие (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpRec - Обновление CHILD */
/* Справочник служащих ^ Приход денег по служащим - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_EmpRep - Обновление CHILD */
/* Справочник служащих ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_EmpRep a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_PlanExp - Обновление CHILD */
/* Справочник служащих ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_PlanExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_PlanRec - Обновление CHILD */
/* Справочник служащих ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_PlanRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ c_SalD - Обновление CHILD */
/* Справочник служащих ^ Начисление денег служащим (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM c_SalD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM c_SalD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Начисление денег служащим (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_CWTimeCor - Обновление CHILD */
/* Справочник служащих ^ Табель учета рабочего времени: Корректировка: Список - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_CWTimeCor a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeCor a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Табель учета рабочего времени: Корректировка: Список''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_CWTimeD - Обновление CHILD */
/* Справочник служащих ^ Табель учета рабочего времени (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_CWTimeD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Табель учета рабочего времени (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EDis - Обновление CHILD */
/* Справочник служащих ^ Приказ: Увольнение - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EDis a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EDis a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Увольнение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EExc - Обновление CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DecreeEmpID = i.EmpID
          FROM p_EExc a, inserted i, deleted d WHERE a.DecreeEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.DecreeEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EExc - Обновление CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EExc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EExc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Кадровое перемещение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EGiv - Обновление CHILD */
/* Справочник служащих ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DecreeEmpID = i.EmpID
          FROM p_EGiv a, inserted i, deleted d WHERE a.DecreeEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.DecreeEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EGiv - Обновление CHILD */
/* Справочник служащих ^ Приказ: Прием на работу - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EGiv a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EGiv a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Прием на работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_ELeavCorD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Отпуск: Корректировка (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_ELeavCorD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavCorD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Отпуск: Корректировка (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_ELeavD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Отпуск (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_ELeavD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ELeavD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Отпуск (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EmpIn - Обновление CHILD */
/* Справочник служащих ^ Входящие данные по служащим - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EmpIn a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpIn a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Входящие данные по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EmpSchedExt - Обновление CHILD */
/* Справочник служащих ^ Приказ: Дополнительный график работы (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EmpSchedExt a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExt a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Дополнительный график работы (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EmpSchedExtD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Дополнительный график работы (Список) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EmpSchedExtD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExtD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Дополнительный график работы (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EmpSchedExtD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Дополнительный график работы (Список) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SubEmpID = i.EmpID
          FROM p_EmpSchedExtD a, inserted i, deleted d WHERE a.SubEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpSchedExtD a, deleted d WHERE a.SubEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Дополнительный график работы (Список)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_ESic - Обновление CHILD */
/* Справочник служащих ^ Больничный лист (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_ESic a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ESic a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Больничный лист (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_ETrp - Обновление CHILD */
/* Справочник служащих ^ Приказ: Командировка - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_ETrp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_ETrp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Командировка''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EWri - Обновление CHILD */
/* Справочник служащих ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AddrEmpID = i.EmpID
          FROM p_EWri a, inserted i, deleted d WHERE a.AddrEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.AddrEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EWri - Обновление CHILD */
/* Справочник служащих ^ Исполнительный лист - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EWri a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWri a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Исполнительный лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_EWrkD - Обновление CHILD */
/* Справочник служащих ^ Выполнение работ (Служащие) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_EWrkD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EWrkD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Выполнение работ (Служащие)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_LeaveSched - Обновление CHILD */
/* Справочник служащих ^ Отпуск: Лимиты по видам (Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_LeaveSched a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LeaveSched a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Отпуск: Лимиты по видам (Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_LExcD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DecreeEmpID = i.EmpID
          FROM p_LExcD a, inserted i, deleted d WHERE a.DecreeEmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE a.DecreeEmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_LExcD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение списком (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_LExcD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExcD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Кадровое перемещение списком (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_LExpD - Обновление CHILD */
/* Справочник служащих ^ Заработная плата: Выплата (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_LExpD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LExpD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Заработная плата: Выплата (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_LRecD - Обновление CHILD */
/* Справочник служащих ^ Заработная плата: Начисление (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_LRecD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_LRecD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Заработная плата: Начисление (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_OPWrkD - Обновление CHILD */
/* Справочник служащих ^ Приказ: Производственный (Данные) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_OPWrkD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_OPWrkD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приказ: Производственный (Данные)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ p_WExc - Обновление CHILD */
/* Справочник служащих ^ Привлечение на другую работу - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM p_WExc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_WExc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Привлечение на другую работу''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Acc - Обновление CHILD */
/* Справочник служащих ^ Счет на оплату товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Acc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Acc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Счет на оплату товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Cos - Обновление CHILD */
/* Справочник служащих ^ Формирование себестоимости: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Cos a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cos a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Формирование себестоимости: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_CRet - Обновление CHILD */
/* Справочник служащих ^ Возврат товара поставщику: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_CRet a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRet a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Возврат товара поставщику: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_CRRet - Обновление CHILD */
/* Справочник служащих ^ Возврат товара по чеку: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_CRRet a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRet a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Возврат товара по чеку: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_CRRetD - Обновление CHILD */
/* Справочник служащих ^ Возврат товара по чеку: Товар - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_CRRetD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Возврат товара по чеку: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Cst - Обновление CHILD */
/* Справочник служащих ^ Приход товара по ГТД: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Cst a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приход товара по ГТД: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Cst2 - Обновление CHILD */
/* Справочник служащих ^ Приход товара по ГТД (новый)(Заголовок) - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Cst2 a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Cst2 a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приход товара по ГТД (новый)(Заголовок)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_DeskRes - Обновление CHILD */
/* Справочник служащих ^ Ресторан: Резервирование столиков - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_DeskRes a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DeskRes a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ресторан: Резервирование столиков''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Dis - Обновление CHILD */
/* Справочник служащих ^ Распределение товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Dis a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Dis a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Распределение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_EOExp - Обновление CHILD */
/* Справочник служащих ^ Заказ внешний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_EOExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Заказ внешний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_EORec - Обновление CHILD */
/* Справочник служащих ^ Заказ внешний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_EORec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Заказ внешний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Epp - Обновление CHILD */
/* Справочник служащих ^ Расходный документ в ценах прихода: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Epp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Epp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расходный документ в ценах прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Est - Обновление CHILD */
/* Справочник служащих ^ Переоценка цен прихода: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Est a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Est a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Переоценка цен прихода: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Exc - Обновление CHILD */
/* Справочник служащих ^ Перемещение товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Exc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Перемещение товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Exp - Обновление CHILD */
/* Справочник служащих ^ Расходный документ: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Exp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Exp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расходный документ: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Inv - Обновление CHILD */
/* Справочник служащих ^ Расходная накладная: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Inv a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Inv a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Расходная накладная: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_IOExp - Обновление CHILD */
/* Справочник служащих ^ Заказ внутренний: Обработка: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_IOExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IOExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Заказ внутренний: Обработка: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_IORec - Обновление CHILD */
/* Справочник служащих ^ Заказ внутренний: Формирование: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_IORec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_IORec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Заказ внутренний: Формирование: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_MonRec - Обновление CHILD */
/* Справочник служащих ^ Прием наличных денег на склад - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_MonRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_MonRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Прием наличных денег на склад''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Rec - Обновление CHILD */
/* Справочник служащих ^ Приход товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Rec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Rec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Приход товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_RestShift - Обновление CHILD */
/* Справочник служащих ^ Ресторан: Смена: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_RestShift a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RestShift a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ресторан: Смена: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_RestShiftD - Обновление CHILD */
/* Справочник служащих ^ Ресторан: Смена: Персонал - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_RestShiftD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_RestShiftD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Ресторан: Смена: Персонал''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Ret - Обновление CHILD */
/* Справочник служащих ^ Возврат товара от получателя: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Ret a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ret a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Возврат товара от получателя: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Sale - Обновление CHILD */
/* Справочник служащих ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Sale a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SaleC - Обновление CHILD */
/* Справочник служащих ^ Продажа товара оператором: Отмены продаж - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SaleC a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleC a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Продажа товара оператором: Отмены продаж''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SaleD - Обновление CHILD */
/* Справочник служащих ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SaleD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SaleTempD - Обновление CHILD */
/* Справочник служащих ^ Временные данные продаж: Товар - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SaleTempD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Временные данные продаж: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SEstD - Обновление CHILD */
/* Справочник служащих ^ Переоценка цен продажи: Товар - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SEstD a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SEstD a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Переоценка цен продажи: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SExp - Обновление CHILD */
/* Справочник служащих ^ Разукомплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Разукомплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Spec - Обновление CHILD */
/* Справочник служащих ^ Калькуляционная карта: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Spec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Spec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Калькуляционная карта: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SPExp - Обновление CHILD */
/* Справочник служащих ^ Планирование: Разукомплектация: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SPExp a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPExp a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Планирование: Разукомплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SPRec - Обновление CHILD */
/* Справочник служащих ^ Планирование: Комплектация: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SPRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Планирование: Комплектация: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_SRec - Обновление CHILD */
/* Справочник служащих ^ Комплектация товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_SRec a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRec a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Комплектация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ t_Ven - Обновление CHILD */
/* Справочник служащих ^ Инвентаризация товара: Заголовок - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM t_Ven a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Ven a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Инвентаризация товара: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ z_Contracts - Обновление CHILD */
/* Справочник служащих ^ Договор - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM z_Contracts a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_Contracts a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Договор''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Emps ^ z_InAcc - Обновление CHILD */
/* Справочник служащих ^ Входящий счет на оплату - Обновление CHILD */
  IF UPDATE(EmpID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID
          FROM z_InAcc a, inserted i, deleted d WHERE a.EmpID = d.EmpID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_InAcc a, deleted d WHERE a.EmpID = d.EmpID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих'' => ''Входящий счет на оплату''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10120001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10120001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(EmpID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120001 AND l.PKValue = 
        '[' + cast(i.EmpID as varchar(200)) + ']' AND i.EmpID = d.EmpID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120001 AND l.PKValue = 
        '[' + cast(i.EmpID as varchar(200)) + ']' AND i.EmpID = d.EmpID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120001, ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10120001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120001, ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(EmpID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120001 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120001 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120001, ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10120001 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120001 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120001, ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120001, ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Emps]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Emps] ON [dbo].[r_Emps]
FOR DELETE AS
/* r_Emps - Справочник служащих - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Emps ^ r_Opers - Проверка в CHILD */
/* Справочник служащих ^ Справочник ЭККА: операторы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Opers a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Opers', 3
      RETURN
    END

/* r_Emps ^ r_EmpAct - Удаление в CHILD */
/* Справочник служащих ^ Справочник служащих - Трудовая деятельность - Удаление в CHILD */
  DELETE r_EmpAct FROM r_EmpAct a, deleted d WHERE a.EmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ r_EmpAdd - Удаление в CHILD */
/* Справочник служащих ^ Справочник служащих - Прописка и место жительства - Удаление в CHILD */
  DELETE r_EmpAdd FROM r_EmpAdd a, deleted d WHERE a.EmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ r_EmpFiles - Удаление в CHILD */
/* Справочник служащих ^ Справочник служащих: Документы - Удаление в CHILD */
  DELETE r_EmpFiles FROM r_EmpFiles a, deleted d WHERE a.EmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ r_EmpKin - Удаление в CHILD */
/* Справочник служащих ^ Справочник служащих - Члены семьи - Удаление в CHILD */
  DELETE r_EmpKin FROM r_EmpKin a, deleted d WHERE a.EmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ r_EmpMO - Удаление в CHILD */
/* Справочник служащих ^ Справочник служащих - Внутренние фирмы - Удаление в CHILD */
  DELETE r_EmpMO FROM r_EmpMO a, deleted d WHERE a.EmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ r_Stocks - Проверка в CHILD */
/* Справочник служащих ^ Справочник складов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Stocks a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Stocks', 3
      RETURN
    END

/* r_Emps ^ r_WPRoles - Проверка в CHILD */
/* Справочник служащих ^ Справочник рабочих мест: роли - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_WPRoles a WITH(NOLOCK), deleted d WHERE a.PosEmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_WPRoles', 3
      RETURN
    END

/* r_Emps ^ r_GOperD - Проверка в CHILD */
/* Справочник служащих ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_GOperD', 3
      RETURN
    END

/* r_Emps ^ r_GOperD - Проверка в CHILD */
/* Справочник служащих ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_GOperD', 3
      RETURN
    END

/* r_Emps ^ r_Comps - Проверка в CHILD */
/* Справочник служащих ^ Справочник предприятий - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Comps a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Comps', 3
      RETURN
    END

/* r_Emps ^ r_Users - Проверка в CHILD */
/* Справочник служащих ^ Справочник пользователей - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Users a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Users', 3
      RETURN
    END

/* r_Emps ^ r_AssetH - Проверка в CHILD */
/* Справочник служащих ^ Справочник основных средств: История - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_AssetH a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_AssetH', 3
      RETURN
    END

/* r_Emps ^ r_Executors - Проверка в CHILD */
/* Справочник служащих ^ Справочник исполнителей - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Executors a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_Executors', 3
      RETURN
    END

/* r_Emps ^ r_GAccs - Проверка в CHILD */
/* Справочник служащих ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_GAccs', 3
      RETURN
    END

/* r_Emps ^ b_ARepA - Проверка в CHILD */
/* Справочник служащих ^ Авансовый отчет валютный (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_ARepA a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_ARepA', 3
      RETURN
    END

/* r_Emps ^ b_BankExpAC - Проверка в CHILD */
/* Справочник служащих ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_BankExpAC', 3
      RETURN
    END

/* r_Emps ^ b_BankExpCC - Проверка в CHILD */
/* Справочник служащих ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_BankExpCC', 3
      RETURN
    END

/* r_Emps ^ b_BankRecAC - Проверка в CHILD */
/* Справочник служащих ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_BankRecAC', 3
      RETURN
    END

/* r_Emps ^ b_BankRecCC - Проверка в CHILD */
/* Справочник служащих ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_BankRecCC', 3
      RETURN
    END

/* r_Emps ^ b_CExp - Проверка в CHILD */
/* Справочник служащих ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.CashEmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CExp', 3
      RETURN
    END

/* r_Emps ^ b_CExp - Проверка в CHILD */
/* Справочник служащих ^ Кассовый ордер: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CExp', 3
      RETURN
    END

/* r_Emps ^ b_CInv - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Расход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CInv a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CInv', 3
      RETURN
    END

/* r_Emps ^ b_CRec - Проверка в CHILD */
/* Справочник служащих ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.CashEmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CRec', 3
      RETURN
    END

/* r_Emps ^ b_CRec - Проверка в CHILD */
/* Справочник служащих ^ Кассовый ордер: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CRec', 3
      RETURN
    END

/* r_Emps ^ b_CRepA - Проверка в CHILD */
/* Справочник служащих ^ Авансовый отчет с признаками (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRepA a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CRepA', 3
      RETURN
    END

/* r_Emps ^ b_CRet - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Возврат поставщику (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_CRet a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_CRet', 3
      RETURN
    END

/* r_Emps ^ b_Cst - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Приход по ГТД (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Cst a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_Cst', 3
      RETURN
    END

/* r_Emps ^ b_DStack - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Суммовой учет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_DStack a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_DStack', 3
      RETURN
    END

/* r_Emps ^ b_Exp - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Внутренний расход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Exp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_Exp', 3
      RETURN
    END

/* r_Emps ^ b_GTranD - Проверка в CHILD */
/* Справочник служащих ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_GTranD', 3
      RETURN
    END

/* r_Emps ^ b_GTranD - Проверка в CHILD */
/* Справочник служащих ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_GTranD', 3
      RETURN
    END

/* r_Emps ^ b_Inv - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Inv a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_Inv', 3
      RETURN
    END

/* r_Emps ^ b_LExpD - Проверка в CHILD */
/* Справочник служащих ^ Зарплата: Выплата (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LExpD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_LExpD', 3
      RETURN
    END

/* r_Emps ^ b_LRecD - Проверка в CHILD */
/* Справочник служащих ^ Зарплата: Начисление (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_LRecD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_LRecD', 3
      RETURN
    END

/* r_Emps ^ b_PAcc - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Счет на оплату (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PAcc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PAcc', 3
      RETURN
    END

/* r_Emps ^ b_PCost - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PCost a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PCost', 3
      RETURN
    END

/* r_Emps ^ b_PEst - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Переоценка партий (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PEst a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PEst', 3
      RETURN
    END

/* r_Emps ^ b_PExc - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PExc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PExc', 3
      RETURN
    END

/* r_Emps ^ b_PVen - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Инвентаризация (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_PVen a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PVen', 3
      RETURN
    END

/* r_Emps ^ b_Rec - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Приход по накладной (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Rec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_Rec', 3
      RETURN
    END

/* r_Emps ^ b_RepA - Проверка в CHILD */
/* Справочник служащих ^ Авансовый отчет (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_RepA a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_RepA', 3
      RETURN
    END

/* r_Emps ^ b_Ret - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_Ret a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_Ret', 3
      RETURN
    END

/* r_Emps ^ b_SDep - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Амортизация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SDep a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SDep', 3
      RETURN
    END

/* r_Emps ^ b_SExc - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SExc', 3
      RETURN
    END

/* r_Emps ^ b_SExc - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Перемещение (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExc a WITH(NOLOCK), deleted d WHERE a.NewEmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SExc', 3
      RETURN
    END

/* r_Emps ^ b_SExp - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Списание (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SExp', 3
      RETURN
    END

/* r_Emps ^ b_SInv - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Продажа (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SInv a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SInv', 3
      RETURN
    END

/* r_Emps ^ b_SPut - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Ввод в эксплуатацию (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SPut a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SPut', 3
      RETURN
    END

/* r_Emps ^ b_SRec - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Приход (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SRec', 3
      RETURN
    END

/* r_Emps ^ b_SRep - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Ремонт (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SRep a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SRep', 3
      RETURN
    END

/* r_Emps ^ b_SVen - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Инвентаризация - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SVen a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SVen', 3
      RETURN
    END

/* r_Emps ^ b_SWer - Проверка в CHILD */
/* Справочник служащих ^ Основные средства: Износ (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_SWer a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_SWer', 3
      RETURN
    END

/* r_Emps ^ b_TranE - Проверка в CHILD */
/* Справочник служащих ^ Проводка по служащему - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranE a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_TranE', 3
      RETURN
    END

/* r_Emps ^ b_TranH - Проверка в CHILD */
/* Справочник служащих ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_TranH', 3
      RETURN
    END

/* r_Emps ^ b_TranH - Проверка в CHILD */
/* Справочник служащих ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_TranH', 3
      RETURN
    END

/* r_Emps ^ b_TranP - Проверка в CHILD */
/* Справочник служащих ^ ТМЦ: Проводка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranP a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_TranP', 3
      RETURN
    END

/* r_Emps ^ b_WBill - Проверка в CHILD */
/* Справочник служащих ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_WBill', 3
      RETURN
    END

/* r_Emps ^ b_zInE - Проверка в CHILD */
/* Справочник служащих ^ Входящий баланс: Служащие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInE a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInE', 3
      RETURN
    END

/* r_Emps ^ b_zInH - Проверка в CHILD */
/* Справочник служащих ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInH', 3
      RETURN
    END

/* r_Emps ^ b_zInH - Проверка в CHILD */
/* Справочник служащих ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInH', 3
      RETURN
    END

/* r_Emps ^ b_zInP - Проверка в CHILD */
/* Справочник служащих ^ Входящий баланс: ТМЦ - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInP a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInP', 3
      RETURN
    END

/* r_Emps ^ b_zInS - Проверка в CHILD */
/* Справочник служащих ^ Входящий баланс: Основные средства - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInS a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInS', 3
      RETURN
    END

/* r_Emps ^ c_CompExp - Проверка в CHILD */
/* Справочник служащих ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_CompExp', 3
      RETURN
    END

/* r_Emps ^ c_CompRec - Проверка в CHILD */
/* Справочник служащих ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_CompRec', 3
      RETURN
    END

/* r_Emps ^ c_EmpCor - Проверка в CHILD */
/* Справочник служащих ^ Корректировка баланса служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCor a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpCor', 3
      RETURN
    END

/* r_Emps ^ c_EmpCurr - Проверка в CHILD */
/* Справочник служащих ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpCurr', 3
      RETURN
    END

/* r_Emps ^ c_EmpExc - Проверка в CHILD */
/* Справочник служащих ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpExc', 3
      RETURN
    END

/* r_Emps ^ c_EmpExc - Проверка в CHILD */
/* Справочник служащих ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.NewEmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpExc', 3
      RETURN
    END

/* r_Emps ^ c_EmpExp - Проверка в CHILD */
/* Справочник служащих ^ Расход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpExp', 3
      RETURN
    END

/* r_Emps ^ c_EmpIn - Проверка в CHILD */
/* Справочник служащих ^ Входящий баланс: Служащие (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpIn a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpIn', 3
      RETURN
    END

/* r_Emps ^ c_EmpRec - Проверка в CHILD */
/* Справочник служащих ^ Приход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpRec', 3
      RETURN
    END

/* r_Emps ^ c_EmpRep - Проверка в CHILD */
/* Справочник служащих ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_EmpRep', 3
      RETURN
    END

/* r_Emps ^ c_PlanExp - Проверка в CHILD */
/* Справочник служащих ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_PlanExp', 3
      RETURN
    END

/* r_Emps ^ c_PlanRec - Проверка в CHILD */
/* Справочник служащих ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_PlanRec', 3
      RETURN
    END

/* r_Emps ^ c_SalD - Проверка в CHILD */
/* Справочник служащих ^ Начисление денег служащим (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_SalD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_SalD', 3
      RETURN
    END

/* r_Emps ^ p_CWTimeCor - Проверка в CHILD */
/* Справочник служащих ^ Табель учета рабочего времени: Корректировка: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeCor a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_CWTimeCor', 3
      RETURN
    END

/* r_Emps ^ p_CWTimeD - Проверка в CHILD */
/* Справочник служащих ^ Табель учета рабочего времени (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_CWTimeD', 3
      RETURN
    END

/* r_Emps ^ p_EDis - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Увольнение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EDis a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EDis', 3
      RETURN
    END

/* r_Emps ^ p_EExc - Удаление в CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение - Удаление в CHILD */
  DELETE p_EExc FROM p_EExc a, deleted d WHERE a.DecreeEmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ p_EExc - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EExc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EExc', 3
      RETURN
    END

/* r_Emps ^ p_EGiv - Удаление в CHILD */
/* Справочник служащих ^ Приказ: Прием на работу - Удаление в CHILD */
  DELETE p_EGiv FROM p_EGiv a, deleted d WHERE a.DecreeEmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ p_EGiv - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Прием на работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EGiv a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EGiv', 3
      RETURN
    END

/* r_Emps ^ p_ELeavCorD - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Отпуск: Корректировка (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavCorD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_ELeavCorD', 3
      RETURN
    END

/* r_Emps ^ p_ELeavD - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Отпуск (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ELeavD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_ELeavD', 3
      RETURN
    END

/* r_Emps ^ p_EmpIn - Проверка в CHILD */
/* Справочник служащих ^ Входящие данные по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpIn a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EmpIn', 3
      RETURN
    END

/* r_Emps ^ p_EmpSchedExt - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Дополнительный график работы (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExt a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EmpSchedExt', 3
      RETURN
    END

/* r_Emps ^ p_EmpSchedExtD - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Дополнительный график работы (Список) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EmpSchedExtD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EmpSchedExtD', 3
      RETURN
    END

/* r_Emps ^ p_EmpSchedExtD - Удаление в CHILD */
/* Справочник служащих ^ Приказ: Дополнительный график работы (Список) - Удаление в CHILD */
  DELETE p_EmpSchedExtD FROM p_EmpSchedExtD a, deleted d WHERE a.SubEmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ p_ESic - Проверка в CHILD */
/* Справочник служащих ^ Больничный лист (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ESic a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_ESic', 3
      RETURN
    END

/* r_Emps ^ p_ETrp - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Командировка - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_ETrp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_ETrp', 3
      RETURN
    END

/* r_Emps ^ p_EWri - Проверка в CHILD */
/* Справочник служащих ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.AddrEmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EWri', 3
      RETURN
    END

/* r_Emps ^ p_EWri - Проверка в CHILD */
/* Справочник служащих ^ Исполнительный лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWri a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EWri', 3
      RETURN
    END

/* r_Emps ^ p_EWrkD - Проверка в CHILD */
/* Справочник служащих ^ Выполнение работ (Служащие) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_EWrkD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EWrkD', 3
      RETURN
    END

/* r_Emps ^ p_LeaveSched - Проверка в CHILD */
/* Справочник служащих ^ Отпуск: Лимиты по видам (Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LeaveSched a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_LeaveSched', 3
      RETURN
    END

/* r_Emps ^ p_LExcD - Удаление в CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение списком (Данные) - Удаление в CHILD */
  DELETE p_LExcD FROM p_LExcD a, deleted d WHERE a.DecreeEmpID = d.EmpID
  IF @@ERROR > 0 RETURN

/* r_Emps ^ p_LExcD - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Кадровое перемещение списком (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExcD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_LExcD', 3
      RETURN
    END

/* r_Emps ^ p_LExpD - Проверка в CHILD */
/* Справочник служащих ^ Заработная плата: Выплата (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LExpD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_LExpD', 3
      RETURN
    END

/* r_Emps ^ p_LRecD - Проверка в CHILD */
/* Справочник служащих ^ Заработная плата: Начисление (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_LRecD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_LRecD', 3
      RETURN
    END

/* r_Emps ^ p_OPWrkD - Проверка в CHILD */
/* Справочник служащих ^ Приказ: Производственный (Данные) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_OPWrkD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_OPWrkD', 3
      RETURN
    END

/* r_Emps ^ p_WExc - Проверка в CHILD */
/* Справочник служащих ^ Привлечение на другую работу - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_WExc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_WExc', 3
      RETURN
    END

/* r_Emps ^ t_Acc - Проверка в CHILD */
/* Справочник служащих ^ Счет на оплату товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Acc', 3
      RETURN
    END

/* r_Emps ^ t_Cos - Проверка в CHILD */
/* Справочник служащих ^ Формирование себестоимости: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cos a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Cos', 3
      RETURN
    END

/* r_Emps ^ t_CRet - Проверка в CHILD */
/* Справочник служащих ^ Возврат товара поставщику: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRet a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_CRet', 3
      RETURN
    END

/* r_Emps ^ t_CRRet - Проверка в CHILD */
/* Справочник служащих ^ Возврат товара по чеку: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRet a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_CRRet', 3
      RETURN
    END

/* r_Emps ^ t_CRRetD - Проверка в CHILD */
/* Справочник служащих ^ Возврат товара по чеку: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CRRetD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_CRRetD', 3
      RETURN
    END

/* r_Emps ^ t_Cst - Проверка в CHILD */
/* Справочник служащих ^ Приход товара по ГТД: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Cst', 3
      RETURN
    END

/* r_Emps ^ t_Cst2 - Проверка в CHILD */
/* Справочник служащих ^ Приход товара по ГТД (новый)(Заголовок) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Cst2 a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Cst2', 3
      RETURN
    END

/* r_Emps ^ t_DeskRes - Проверка в CHILD */
/* Справочник служащих ^ Ресторан: Резервирование столиков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DeskRes a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_DeskRes', 3
      RETURN
    END

/* r_Emps ^ t_Dis - Проверка в CHILD */
/* Справочник служащих ^ Распределение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Dis a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Dis', 3
      RETURN
    END

/* r_Emps ^ t_EOExp - Проверка в CHILD */
/* Справочник служащих ^ Заказ внешний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EOExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_EOExp', 3
      RETURN
    END

/* r_Emps ^ t_EORec - Проверка в CHILD */
/* Справочник служащих ^ Заказ внешний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_EORec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_EORec', 3
      RETURN
    END

/* r_Emps ^ t_Epp - Проверка в CHILD */
/* Справочник служащих ^ Расходный документ в ценах прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Epp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Epp', 3
      RETURN
    END

/* r_Emps ^ t_Est - Проверка в CHILD */
/* Справочник служащих ^ Переоценка цен прихода: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Est a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Est', 3
      RETURN
    END

/* r_Emps ^ t_Exc - Проверка в CHILD */
/* Справочник служащих ^ Перемещение товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Exc', 3
      RETURN
    END

/* r_Emps ^ t_Exp - Проверка в CHILD */
/* Справочник служащих ^ Расходный документ: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Exp', 3
      RETURN
    END

/* r_Emps ^ t_Inv - Проверка в CHILD */
/* Справочник служащих ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Inv', 3
      RETURN
    END

/* r_Emps ^ t_IOExp - Проверка в CHILD */
/* Справочник служащих ^ Заказ внутренний: Обработка: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_IOExp', 3
      RETURN
    END

/* r_Emps ^ t_IORec - Проверка в CHILD */
/* Справочник служащих ^ Заказ внутренний: Формирование: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_IORec', 3
      RETURN
    END

/* r_Emps ^ t_MonRec - Проверка в CHILD */
/* Справочник служащих ^ Прием наличных денег на склад - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_MonRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_MonRec', 3
      RETURN
    END

/* r_Emps ^ t_Rec - Проверка в CHILD */
/* Справочник служащих ^ Приход товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Rec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Rec', 3
      RETURN
    END

/* r_Emps ^ t_RestShift - Проверка в CHILD */
/* Справочник служащих ^ Ресторан: Смена: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RestShift a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_RestShift', 3
      RETURN
    END

/* r_Emps ^ t_RestShiftD - Проверка в CHILD */
/* Справочник служащих ^ Ресторан: Смена: Персонал - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_RestShiftD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_RestShiftD', 3
      RETURN
    END

/* r_Emps ^ t_Ret - Проверка в CHILD */
/* Справочник служащих ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Ret', 3
      RETURN
    END

/* r_Emps ^ t_Sale - Проверка в CHILD */
/* Справочник служащих ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Sale', 3
      RETURN
    END

/* r_Emps ^ t_SaleC - Проверка в CHILD */
/* Справочник служащих ^ Продажа товара оператором: Отмены продаж - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleC a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SaleC', 3
      RETURN
    END

/* r_Emps ^ t_SaleD - Проверка в CHILD */
/* Справочник служащих ^ Продажа товара оператором: Продажи товара - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SaleD', 3
      RETURN
    END

/* r_Emps ^ t_SaleTempD - Проверка в CHILD */
/* Справочник служащих ^ Временные данные продаж: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SaleTempD', 3
      RETURN
    END

/* r_Emps ^ t_SEstD - Проверка в CHILD */
/* Справочник служащих ^ Переоценка цен продажи: Товар - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SEstD a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SEstD', 3
      RETURN
    END

/* r_Emps ^ t_SExp - Проверка в CHILD */
/* Справочник служащих ^ Разукомплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SExp', 3
      RETURN
    END

/* r_Emps ^ t_Spec - Проверка в CHILD */
/* Справочник служащих ^ Калькуляционная карта: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Spec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Spec', 3
      RETURN
    END

/* r_Emps ^ t_SPExp - Проверка в CHILD */
/* Справочник служащих ^ Планирование: Разукомплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPExp a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SPExp', 3
      RETURN
    END

/* r_Emps ^ t_SPRec - Проверка в CHILD */
/* Справочник служащих ^ Планирование: Комплектация: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SPRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SPRec', 3
      RETURN
    END

/* r_Emps ^ t_SRec - Проверка в CHILD */
/* Справочник служащих ^ Комплектация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SRec a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SRec', 3
      RETURN
    END

/* r_Emps ^ t_Ven - Проверка в CHILD */
/* Справочник служащих ^ Инвентаризация товара: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Ven a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Ven', 3
      RETURN
    END

/* r_Emps ^ z_Contracts - Проверка в CHILD */
/* Справочник служащих ^ Договор - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_Contracts a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'z_Contracts', 3
      RETURN
    END

/* r_Emps ^ z_InAcc - Проверка в CHILD */
/* Справочник служащих ^ Входящий счет на оплату - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_InAcc a WITH(NOLOCK), deleted d WHERE a.EmpID = d.EmpID)
    BEGIN
      EXEC z_RelationError 'r_Emps', 'z_InAcc', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120001 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120001 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120001, -ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10120 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Emps]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Emps] ADD CONSTRAINT [pk_r_Emps] PRIMARY KEY CLUSTERED ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CertInsurNum] ON [dbo].[r_Emps] ([CertInsurNum]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CertInsurSer] ON [dbo].[r_Emps] ([CertInsurSer]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Emps] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [EmpName] ON [dbo].[r_Emps] ([EmpName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[EmpSex]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Education]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[FamilyStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[MilStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[MilFitness]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[InStopList]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[EmpSex]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Education]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[FamilyStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[MilStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[MilFitness]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[InStopList]'
GO
