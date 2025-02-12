CREATE TABLE [dbo].[r_EmpMO] (
  [OurID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [Official] [bit] NOT NULL,
  [BankID] [int] NOT NULL,
  [CardAcc] [varchar](200) NULL,
  [CSalary] [numeric](21, 9) NOT NULL,
  [BOldSalary] [numeric](21, 9) NOT NULL,
  [BOldJoint] [bit] NOT NULL,
  [InsurSenYears] [tinyint] NOT NULL,
  [InsurSenMonths] [tinyint] NOT NULL,
  [InsurSenDays] [smallint] NOT NULL,
  [BOldAcceptDate] [smalldatetime] NULL,
  [BOldDismissDate] [smalldatetime] NULL,
  [BOldAlimonyPrc] [numeric](21, 9) NOT NULL,
  [BOldDepID] [smallint] NOT NULL,
  [BOldJobDesc] [varchar](200) NULL,
  [BOldPersCat] [tinyint] NOT NULL,
  [EmpState] [tinyint] NULL,
  [HandCWTime] [bit] NOT NULL,
  [IntEmpID] [varchar](50) NOT NULL CONSTRAINT [DF__r_EmpMO__IntEmpI__0EF2D90D] DEFAULT (0),
  CONSTRAINT [_pk_r_EmpMO] PRIMARY KEY CLUSTERED ([OurID], [EmpID])
)
ON [PRIMARY]
GO

CREATE INDEX [BankID]
  ON [dbo].[r_EmpMO] ([BankID])
  ON [PRIMARY]
GO

CREATE INDEX [BOldDepID]
  ON [dbo].[r_EmpMO] ([BOldDepID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[r_EmpMO] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[r_EmpMO] ([OurID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[r_EmpMO] ([OurID], [IntEmpID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.Official'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.BankID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.CSalary'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.BOldSalary'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.BOldJoint'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.InsurSenYears'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.InsurSenMonths'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.InsurSenDays'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.BOldAlimonyPrc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.BOldDepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.BOldPersCat'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.EmpState'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_EmpMO.HandCWTime'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_EmpMO] ON [r_EmpMO]
FOR INSERT AS
/* r_EmpMO - Справочник служащих - Внутренние фирмы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpMO ^ r_Banks - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_EmpMO', 0
      RETURN
    END

/* r_EmpMO ^ r_Deps - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BOldDepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_EmpMO', 0
      RETURN
    END

/* r_EmpMO ^ r_Emps - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'r_EmpMO', 0
      RETURN
    END

/* r_EmpMO ^ r_Ours - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_EmpMO', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120002, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_EmpMO', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_EmpMO] ON [r_EmpMO]
FOR UPDATE AS
/* r_EmpMO - Справочник служащих - Внутренние фирмы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_EmpMO ^ r_Banks - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'r_EmpMO', 1
        RETURN
      END

/* r_EmpMO ^ r_Deps - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(BOldDepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BOldDepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'r_EmpMO', 1
        RETURN
      END

/* r_EmpMO ^ r_Emps - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'r_EmpMO', 1
        RETURN
      END

/* r_EmpMO ^ r_Ours - Проверка в PARENT */
/* Справочник служащих - Внутренние фирмы ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_EmpMO', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldEmpID int, @NewEmpID int
  DECLARE @OldOurID int, @NewOurID int

/* r_EmpMO ^ r_EmpAcc - Обновление CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Дополнительные периодические расходы - Обновление CHILD */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID, a.OurID = i.OurID
          FROM r_EmpAcc a, inserted i, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT EmpID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpID = EmpID FROM deleted
          SELECT TOP 1 @NewEmpID = EmpID FROM inserted
          UPDATE r_EmpAcc SET r_EmpAcc.EmpID = @NewEmpID FROM r_EmpAcc, deleted d WHERE r_EmpAcc.EmpID = @OldEmpID AND r_EmpAcc.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(EmpID) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE r_EmpAcc SET r_EmpAcc.OurID = @NewOurID FROM r_EmpAcc, deleted d WHERE r_EmpAcc.OurID = @OldOurID AND r_EmpAcc.EmpID = d.EmpID
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpAcc a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих - Внутренние фирмы'' => ''Справочник служащих - Дополнительные периодические расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_EmpMO ^ r_EmpInc - Обновление CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Дополнительные периодические доходы - Обновление CHILD */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID, a.OurID = i.OurID
          FROM r_EmpInc a, inserted i, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT EmpID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpID = EmpID FROM deleted
          SELECT TOP 1 @NewEmpID = EmpID FROM inserted
          UPDATE r_EmpInc SET r_EmpInc.EmpID = @NewEmpID FROM r_EmpInc, deleted d WHERE r_EmpInc.EmpID = @OldEmpID AND r_EmpInc.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(EmpID) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE r_EmpInc SET r_EmpInc.OurID = @NewOurID FROM r_EmpInc, deleted d WHERE r_EmpInc.OurID = @OldOurID AND r_EmpInc.EmpID = d.EmpID
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpInc a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих - Внутренние фирмы'' => ''Справочник служащих - Дополнительные периодические доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_EmpMO ^ r_EmpMP - Обновление CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Список льгот - Обновление CHILD */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID, a.OurID = i.OurID
          FROM r_EmpMP a, inserted i, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT EmpID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpID = EmpID FROM deleted
          SELECT TOP 1 @NewEmpID = EmpID FROM inserted
          UPDATE r_EmpMP SET r_EmpMP.EmpID = @NewEmpID FROM r_EmpMP, deleted d WHERE r_EmpMP.EmpID = @OldEmpID AND r_EmpMP.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(EmpID) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE r_EmpMP SET r_EmpMP.OurID = @NewOurID FROM r_EmpMP, deleted d WHERE r_EmpMP.OurID = @OldOurID AND r_EmpMP.EmpID = d.EmpID
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMP a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих - Внутренние фирмы'' => ''Справочник служащих - Список льгот''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_EmpMO ^ r_EmpMPst - Обновление CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Должности и оплата труда - Обновление CHILD */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID, a.OurID = i.OurID
          FROM r_EmpMPst a, inserted i, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT EmpID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpID = EmpID FROM deleted
          SELECT TOP 1 @NewEmpID = EmpID FROM inserted
          UPDATE r_EmpMPst SET r_EmpMPst.EmpID = @NewEmpID FROM r_EmpMPst, deleted d WHERE r_EmpMPst.EmpID = @OldEmpID AND r_EmpMPst.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(EmpID) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE r_EmpMPst SET r_EmpMPst.OurID = @NewOurID FROM r_EmpMPst, deleted d WHERE r_EmpMPst.OurID = @OldOurID AND r_EmpMPst.EmpID = d.EmpID
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpMPst a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих - Внутренние фирмы'' => ''Справочник служащих - Должности и оплата труда''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_EmpMO ^ r_EmpNames - Обновление CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих: Изменение ФИО - Обновление CHILD */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.EmpID = i.EmpID, a.OurID = i.OurID
          FROM r_EmpNames a, inserted i, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT EmpID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT EmpID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldEmpID = EmpID FROM deleted
          SELECT TOP 1 @NewEmpID = EmpID FROM inserted
          UPDATE r_EmpNames SET r_EmpNames.EmpID = @NewEmpID FROM r_EmpNames, deleted d WHERE r_EmpNames.EmpID = @OldEmpID AND r_EmpNames.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(EmpID) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE r_EmpNames SET r_EmpNames.OurID = @NewOurID FROM r_EmpNames, deleted d WHERE r_EmpNames.OurID = @OldOurID AND r_EmpNames.EmpID = d.EmpID
        END
      ELSE IF EXISTS (SELECT * FROM r_EmpNames a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник служащих - Внутренние фирмы'' => ''Справочник служащих: Изменение ФИО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(EmpID) OR UPDATE(OurID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, OurID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT EmpID, OurID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10120002 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10120002 AND l.PKValue = 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10120002, m.ChID, 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID
          DELETE FROM z_LogCreate WHERE TableCode = 10120002 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OurID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10120002 AND PKValue IN (SELECT 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(OurID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10120002, m.ChID, 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10120002, m.ChID, 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Emps m ON m.EmpID = i.EmpID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_EmpMO', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_EmpMO] ON [r_EmpMO]
FOR DELETE AS
/* r_EmpMO - Справочник служащих - Внутренние фирмы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_EmpMO ^ r_EmpAcc - Удаление в CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Дополнительные периодические расходы - Удаление в CHILD */
  DELETE r_EmpAcc FROM r_EmpAcc a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_EmpMO ^ r_EmpInc - Удаление в CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Дополнительные периодические доходы - Удаление в CHILD */
  DELETE r_EmpInc FROM r_EmpInc a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_EmpMO ^ r_EmpMP - Удаление в CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Список льгот - Удаление в CHILD */
  DELETE r_EmpMP FROM r_EmpMP a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_EmpMO ^ r_EmpMPst - Удаление в CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих - Должности и оплата труда - Удаление в CHILD */
  DELETE r_EmpMPst FROM r_EmpMPst a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* r_EmpMO ^ r_EmpNames - Удаление в CHILD */
/* Справочник служащих - Внутренние фирмы ^ Справочник служащих: Изменение ФИО - Удаление в CHILD */
  DELETE r_EmpNames FROM r_EmpNames a, deleted d WHERE a.EmpID = d.EmpID AND a.OurID = d.OurID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10120002 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10120002 AND m.PKValue = 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.OurID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10120002, m.ChID, 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.OurID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Emps m ON m.EmpID = d.EmpID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_EmpMO', N'Last', N'DELETE'
GO