CREATE TABLE [dbo].[r_CompsAC] (
  [CompID] [int] NOT NULL,
  [BankID] [int] NOT NULL,
  [CompAccountAC] [varchar](250) NOT NULL,
  [DefaultAccount] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [IBANCode] [varchar](34) NULL,
  [OldCompAccountAC] [varchar](20) NULL,
  CONSTRAINT [_pk_r_CompsAC] PRIMARY KEY CLUSTERED ([CompID], [CompAccountAC])
)
ON [PRIMARY]
GO

CREATE INDEX [BankID]
  ON [dbo].[r_CompsAC] ([BankID])
  ON [PRIMARY]
GO

CREATE INDEX [CompAccountAC]
  ON [dbo].[r_CompsAC] ([CompAccountAC])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[r_CompsAC] ([CompID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompsAC.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompsAC.BankID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompsAC.DefaultAccount'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_r_CompsAC] 
ON [dbo].[r_CompsAC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(CompAccountAC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(CompAccountAC)    
      UPDATE oc 
      SET    oc.OldCompAccountAC = CASE  
                                    WHEN i.CompAccountAC LIKE '[a-Z][a-Z]%' AND d.CompAccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.CompAccountAC 
                                    ELSE i.OldCompAccountAC 
                               END 
      FROM   DELETED d 
            ,r_CompsAC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.CompID=i.CompID AND oc.CompAccountAC=i.CompAccountAC) 
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompsAC] ON [r_CompsAC]
FOR INSERT AS
/* r_CompsAC - Справочник предприятий - Валютные счета - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompsAC ^ r_Banks - Проверка в PARENT */
/* Справочник предприятий - Валютные счета ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_CompsAC', 0
      RETURN
    END

/* r_CompsAC ^ r_Comps - Проверка в PARENT */
/* Справочник предприятий - Валютные счета ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_CompsAC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250003, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompsAC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompsAC] ON [r_CompsAC]
FOR UPDATE AS
/* r_CompsAC - Справочник предприятий - Валютные счета - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompsAC ^ r_Banks - Проверка в PARENT */
/* Справочник предприятий - Валютные счета ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'r_CompsAC', 1
        RETURN
      END

/* r_CompsAC ^ r_Comps - Проверка в PARENT */
/* Справочник предприятий - Валютные счета ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_CompsAC', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldCompID int, @NewCompID int
  DECLARE @OldCompAccountAC varchar(250), @NewCompAccountAC varchar(250)

/* r_CompsAC ^ b_BankExpAC - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAccountAC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID, a.CompAccountAC = i.CompAccountAC
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.CompID = d.CompID AND a.CompAccountAC = d.CompAccountAC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE b_BankExpAC SET b_BankExpAC.CompID = @NewCompID FROM b_BankExpAC, deleted d WHERE b_BankExpAC.CompID = @OldCompID AND b_BankExpAC.CompAccountAC = d.CompAccountAC
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE b_BankExpAC SET b_BankExpAC.CompAccountAC = @NewCompAccountAC FROM b_BankExpAC, deleted d WHERE b_BankExpAC.CompAccountAC = @OldCompAccountAC AND b_BankExpAC.CompID = d.CompID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.CompID = d.CompID AND a.CompAccountAC = d.CompAccountAC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ b_BankPayAC - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Валютное платежное поручение - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM b_BankPayAC a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE b_BankPayAC SET b_BankPayAC.CompAccountAC = @NewCompAccountAC FROM b_BankPayAC, deleted d WHERE b_BankPayAC.CompAccountAC = @OldCompAccountAC AND b_BankPayAC.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE b_BankPayAC SET b_BankPayAC.CompID = @NewCompID FROM b_BankPayAC, deleted d WHERE b_BankPayAC.CompID = @OldCompID AND b_BankPayAC.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayAC a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Валютное платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ b_BankRecAC - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAccountAC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID, a.CompAccountAC = i.CompAccountAC
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.CompID = d.CompID AND a.CompAccountAC = d.CompAccountAC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE b_BankRecAC SET b_BankRecAC.CompID = @NewCompID FROM b_BankRecAC, deleted d WHERE b_BankRecAC.CompID = @OldCompID AND b_BankRecAC.CompAccountAC = d.CompAccountAC
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE b_BankRecAC SET b_BankRecAC.CompAccountAC = @NewCompAccountAC FROM b_BankRecAC, deleted d WHERE b_BankRecAC.CompAccountAC = @OldCompAccountAC AND b_BankRecAC.CompID = d.CompID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.CompID = d.CompID AND a.CompAccountAC = d.CompAccountAC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_CompCor - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Корректировка баланса предприятия - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_CompCor a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_CompCor SET c_CompCor.CompAccountAC = @NewCompAccountAC FROM c_CompCor, deleted d WHERE c_CompCor.CompAccountAC = @OldCompAccountAC AND c_CompCor.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_CompCor SET c_CompCor.CompID = @NewCompID FROM c_CompCor, deleted d WHERE c_CompCor.CompID = @OldCompID AND c_CompCor.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCor a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Корректировка баланса предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_CompCurr - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.CompAccountAC = @NewCompAccountAC FROM c_CompCurr, deleted d WHERE c_CompCurr.CompAccountAC = @OldCompAccountAC AND c_CompCurr.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.CompID = @NewCompID FROM c_CompCurr, deleted d WHERE c_CompCurr.CompID = @OldCompID AND c_CompCurr.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_CompCurr - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewCompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.NewCompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.NewCompAccountAC = @NewCompAccountAC FROM c_CompCurr, deleted d WHERE c_CompCurr.NewCompAccountAC = @OldCompAccountAC AND c_CompCurr.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.CompID = @NewCompID FROM c_CompCurr, deleted d WHERE c_CompCurr.CompID = @OldCompID AND c_CompCurr.NewCompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.NewCompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_CompExp - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_CompExp a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_CompExp SET c_CompExp.CompAccountAC = @NewCompAccountAC FROM c_CompExp, deleted d WHERE c_CompExp.CompAccountAC = @OldCompAccountAC AND c_CompExp.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_CompExp SET c_CompExp.CompID = @NewCompID FROM c_CompExp, deleted d WHERE c_CompExp.CompID = @OldCompID AND c_CompExp.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_CompIn - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Входящий баланс: Предприятия (Финансы) - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_CompIn a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_CompIn SET c_CompIn.CompAccountAC = @NewCompAccountAC FROM c_CompIn, deleted d WHERE c_CompIn.CompAccountAC = @OldCompAccountAC AND c_CompIn.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_CompIn SET c_CompIn.CompID = @NewCompID FROM c_CompIn, deleted d WHERE c_CompIn.CompID = @OldCompID AND c_CompIn.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompIn a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Входящий баланс: Предприятия (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_CompRec - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_CompRec a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_CompRec SET c_CompRec.CompAccountAC = @NewCompAccountAC FROM c_CompRec, deleted d WHERE c_CompRec.CompAccountAC = @OldCompAccountAC AND c_CompRec.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_CompRec SET c_CompRec.CompID = @NewCompID FROM c_CompRec, deleted d WHERE c_CompRec.CompID = @OldCompID AND c_CompRec.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_EmpRep - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_EmpRep a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_EmpRep SET c_EmpRep.CompAccountAC = @NewCompAccountAC FROM c_EmpRep, deleted d WHERE c_EmpRep.CompAccountAC = @OldCompAccountAC AND c_EmpRep.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_EmpRep SET c_EmpRep.CompID = @NewCompID FROM c_EmpRep, deleted d WHERE c_EmpRep.CompID = @OldCompID AND c_EmpRep.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_PlanExp - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_PlanExp a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_PlanExp SET c_PlanExp.CompAccountAC = @NewCompAccountAC FROM c_PlanExp, deleted d WHERE c_PlanExp.CompAccountAC = @OldCompAccountAC AND c_PlanExp.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_PlanExp SET c_PlanExp.CompID = @NewCompID FROM c_PlanExp, deleted d WHERE c_PlanExp.CompID = @OldCompID AND c_PlanExp.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsAC ^ c_PlanRec - Обновление CHILD */
/* Справочник предприятий - Валютные счета ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(CompAccountAC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountAC = i.CompAccountAC, a.CompID = i.CompID
          FROM c_PlanRec a, inserted i, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountAC = CompAccountAC FROM deleted
          SELECT TOP 1 @NewCompAccountAC = CompAccountAC FROM inserted
          UPDATE c_PlanRec SET c_PlanRec.CompAccountAC = @NewCompAccountAC FROM c_PlanRec, deleted d WHERE c_PlanRec.CompAccountAC = @OldCompAccountAC AND c_PlanRec.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountAC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE c_PlanRec SET c_PlanRec.CompID = @NewCompID FROM c_PlanRec, deleted d WHERE c_PlanRec.CompID = @OldCompID AND c_PlanRec.CompAccountAC = d.CompAccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Валютные счета'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CompID) OR UPDATE(CompAccountAC)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, CompAccountAC FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, CompAccountAC FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompAccountAC as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250003 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompAccountAC as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompAccountAC as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250003 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompAccountAC as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250003, m.ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompAccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID
          DELETE FROM z_LogCreate WHERE TableCode = 10250003 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompAccountAC as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250003 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompAccountAC as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250003, m.ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompAccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250003, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompsAC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompsAC] ON [r_CompsAC]
FOR DELETE AS
/* r_CompsAC - Справочник предприятий - Валютные счета - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompsAC ^ b_BankExpAC - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAccountAC = d.CompAccountAC)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'b_BankExpAC', 3
      RETURN
    END

/* r_CompsAC ^ b_BankPayAC - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Валютное платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayAC a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'b_BankPayAC', 3
      RETURN
    END

/* r_CompsAC ^ b_BankRecAC - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAccountAC = d.CompAccountAC)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'b_BankRecAC', 3
      RETURN
    END

/* r_CompsAC ^ c_CompCor - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Корректировка баланса предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCor a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompCor', 3
      RETURN
    END

/* r_CompsAC ^ c_CompCurr - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompCurr', 3
      RETURN
    END

/* r_CompsAC ^ c_CompCurr - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.NewCompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompCurr', 3
      RETURN
    END

/* r_CompsAC ^ c_CompExp - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompExp', 3
      RETURN
    END

/* r_CompsAC ^ c_CompIn - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Входящий баланс: Предприятия (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompIn a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompIn', 3
      RETURN
    END

/* r_CompsAC ^ c_CompRec - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_CompRec', 3
      RETURN
    END

/* r_CompsAC ^ c_EmpRep - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_EmpRep', 3
      RETURN
    END

/* r_CompsAC ^ c_PlanExp - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_PlanExp', 3
      RETURN
    END

/* r_CompsAC ^ c_PlanRec - Проверка в CHILD */
/* Справочник предприятий - Валютные счета ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.CompAccountAC = d.CompAccountAC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsAC', 'c_PlanRec', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10250003 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountAC as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10250003 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountAC as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10250003, m.ChID, 
    '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CompAccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompsAC', N'Last', N'DELETE'
GO