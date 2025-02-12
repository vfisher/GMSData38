CREATE TABLE [dbo].[r_OursAC] (
  [OurID] [int] NOT NULL,
  [BankID] [int] NOT NULL,
  [AccountAC] [varchar](250) NOT NULL,
  [DefaultAccount] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [GAccID] [int] NOT NULL DEFAULT (0),
  [IBANCode] [varchar](34) NULL,
  [OldAccountAC] [varchar](20) NULL,
  CONSTRAINT [_pk_r_OursAC] PRIMARY KEY CLUSTERED ([OurID], [AccountAC])
)
ON [PRIMARY]
GO

CREATE INDEX [AccountAC]
  ON [dbo].[r_OursAC] ([AccountAC])
  ON [PRIMARY]
GO

CREATE INDEX [BankID]
  ON [dbo].[r_OursAC] ([BankID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[r_OursAC] ([OurID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OursAC.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OursAC.BankID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OursAC.DefaultAccount'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_r_OursAC] 
ON [dbo].[r_OursAC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(AccountAC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(AccountAC)    
      UPDATE oc 
      SET    oc.OldAccountAC = CASE  
                                    WHEN i.AccountAC LIKE '[a-Z][a-Z]%' AND d.AccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.AccountAC 
                                    ELSE i.OldAccountAC 
                               END 
      FROM   DELETED d 
            ,r_OursAC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.AccountAC=i.AccountAC) 
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_OursAC] ON [r_OursAC]
FOR INSERT AS
/* r_OursAC - Справочник внутренних фирм - Валютные счета - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OursAC ^ r_Banks - Проверка в PARENT */
/* Справочник внутренних фирм - Валютные счета ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_OursAC', 0
      RETURN
    END

/* r_OursAC ^ r_GAccs - Проверка в PARENT */
/* Справочник внутренних фирм - Валютные счета ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_OursAC', 0
      RETURN
    END

/* r_OursAC ^ r_Ours - Проверка в PARENT */
/* Справочник внутренних фирм - Валютные счета ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_OursAC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110003, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_OursAC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_OursAC] ON [r_OursAC]
FOR UPDATE AS
/* r_OursAC - Справочник внутренних фирм - Валютные счета - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OursAC ^ r_Banks - Проверка в PARENT */
/* Справочник внутренних фирм - Валютные счета ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'r_OursAC', 1
        RETURN
      END

/* r_OursAC ^ r_GAccs - Проверка в PARENT */
/* Справочник внутренних фирм - Валютные счета ^ План счетов - Проверка в PARENT */
  IF UPDATE(GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_OursAC', 1
        RETURN
      END

/* r_OursAC ^ r_Ours - Проверка в PARENT */
/* Справочник внутренних фирм - Валютные счета ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_OursAC', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldOurID int, @NewOurID int
  DECLARE @OldAccountAC varchar(250), @NewAccountAC varchar(250)

/* r_OursAC ^ b_BankExpAC - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Валютный счет: Расход - Обновление CHILD */
  IF UPDATE(OurID) OR UPDATE(AccountAC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID, a.AccountAC = i.AccountAC
          FROM b_BankExpAC a, inserted i, deleted d WHERE a.OurID = d.OurID AND a.AccountAC = d.AccountAC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_BankExpAC SET b_BankExpAC.OurID = @NewOurID FROM b_BankExpAC, deleted d WHERE b_BankExpAC.OurID = @OldOurID AND b_BankExpAC.AccountAC = d.AccountAC
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE b_BankExpAC SET b_BankExpAC.AccountAC = @NewAccountAC FROM b_BankExpAC, deleted d WHERE b_BankExpAC.AccountAC = @OldAccountAC AND b_BankExpAC.OurID = d.OurID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpAC a, deleted d WHERE a.OurID = d.OurID AND a.AccountAC = d.AccountAC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Валютный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ b_BankPayAC - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Валютное платежное поручение - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM b_BankPayAC a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE b_BankPayAC SET b_BankPayAC.AccountAC = @NewAccountAC FROM b_BankPayAC, deleted d WHERE b_BankPayAC.AccountAC = @OldAccountAC AND b_BankPayAC.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_BankPayAC SET b_BankPayAC.OurID = @NewOurID FROM b_BankPayAC, deleted d WHERE b_BankPayAC.OurID = @OldOurID AND b_BankPayAC.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayAC a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Валютное платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ b_BankRecAC - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Валютный счет: Приход - Обновление CHILD */
  IF UPDATE(OurID) OR UPDATE(AccountAC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID, a.AccountAC = i.AccountAC
          FROM b_BankRecAC a, inserted i, deleted d WHERE a.OurID = d.OurID AND a.AccountAC = d.AccountAC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_BankRecAC SET b_BankRecAC.OurID = @NewOurID FROM b_BankRecAC, deleted d WHERE b_BankRecAC.OurID = @OldOurID AND b_BankRecAC.AccountAC = d.AccountAC
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE b_BankRecAC SET b_BankRecAC.AccountAC = @NewAccountAC FROM b_BankRecAC, deleted d WHERE b_BankRecAC.AccountAC = @OldAccountAC AND b_BankRecAC.OurID = d.OurID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecAC a, deleted d WHERE a.OurID = d.OurID AND a.AccountAC = d.AccountAC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Валютный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ b_zInBA - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Валютный счет - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM b_zInBA a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE b_zInBA SET b_zInBA.AccountAC = @NewAccountAC FROM b_zInBA, deleted d WHERE b_zInBA.AccountAC = @OldAccountAC AND b_zInBA.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_zInBA SET b_zInBA.OurID = @NewOurID FROM b_zInBA, deleted d WHERE b_zInBA.OurID = @OldOurID AND b_zInBA.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBA a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Входящий баланс: Валютный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_CompCor - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Корректировка баланса предприятия - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_CompCor a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_CompCor SET c_CompCor.AccountAC = @NewAccountAC FROM c_CompCor, deleted d WHERE c_CompCor.AccountAC = @OldAccountAC AND c_CompCor.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_CompCor SET c_CompCor.OurID = @NewOurID FROM c_CompCor, deleted d WHERE c_CompCor.OurID = @OldOurID AND c_CompCor.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCor a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Корректировка баланса предприятия''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_CompCurr - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.AccountAC = @NewAccountAC FROM c_CompCurr, deleted d WHERE c_CompCurr.AccountAC = @OldAccountAC AND c_CompCurr.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.OurID = @NewOurID FROM c_CompCurr, deleted d WHERE c_CompCurr.OurID = @OldOurID AND c_CompCurr.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_CompCurr - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по предприятиям - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewAccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_CompCurr a, inserted i, deleted d WHERE a.NewAccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.NewAccountAC = @NewAccountAC FROM c_CompCurr, deleted d WHERE c_CompCurr.NewAccountAC = @OldAccountAC AND c_CompCurr.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_CompCurr SET c_CompCurr.OurID = @NewOurID FROM c_CompCurr, deleted d WHERE c_CompCurr.OurID = @OldOurID AND c_CompCurr.NewAccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompCurr a, deleted d WHERE a.NewAccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Обмен валюты по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_CompExp - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Расход денег по предприятиям - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_CompExp a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_CompExp SET c_CompExp.AccountAC = @NewAccountAC FROM c_CompExp, deleted d WHERE c_CompExp.AccountAC = @OldAccountAC AND c_CompExp.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_CompExp SET c_CompExp.OurID = @NewOurID FROM c_CompExp, deleted d WHERE c_CompExp.OurID = @OldOurID AND c_CompExp.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompExp a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Расход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_CompIn - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Предприятия (Финансы) - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_CompIn a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_CompIn SET c_CompIn.AccountAC = @NewAccountAC FROM c_CompIn, deleted d WHERE c_CompIn.AccountAC = @OldAccountAC AND c_CompIn.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_CompIn SET c_CompIn.OurID = @NewOurID FROM c_CompIn, deleted d WHERE c_CompIn.OurID = @OldOurID AND c_CompIn.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompIn a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Входящий баланс: Предприятия (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_CompRec - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Приход денег по предприятиям - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_CompRec a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_CompRec SET c_CompRec.AccountAC = @NewAccountAC FROM c_CompRec, deleted d WHERE c_CompRec.AccountAC = @OldAccountAC AND c_CompRec.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_CompRec SET c_CompRec.OurID = @NewOurID FROM c_CompRec, deleted d WHERE c_CompRec.OurID = @OldOurID AND c_CompRec.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_CompRec a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Приход денег по предприятиям''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpCor - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Корректировка баланса служащего - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpCor a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpCor SET c_EmpCor.AccountAC = @NewAccountAC FROM c_EmpCor, deleted d WHERE c_EmpCor.AccountAC = @OldAccountAC AND c_EmpCor.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpCor SET c_EmpCor.OurID = @NewOurID FROM c_EmpCor, deleted d WHERE c_EmpCor.OurID = @OldOurID AND c_EmpCor.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCor a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Корректировка баланса служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpCurr - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpCurr SET c_EmpCurr.AccountAC = @NewAccountAC FROM c_EmpCurr, deleted d WHERE c_EmpCurr.AccountAC = @OldAccountAC AND c_EmpCurr.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpCurr SET c_EmpCurr.OurID = @NewOurID FROM c_EmpCurr, deleted d WHERE c_EmpCurr.OurID = @OldOurID AND c_EmpCurr.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpCurr - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по служащим - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.NewAccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpCurr a, inserted i, deleted d WHERE a.NewAccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpCurr SET c_EmpCurr.NewAccountAC = @NewAccountAC FROM c_EmpCurr, deleted d WHERE c_EmpCurr.NewAccountAC = @OldAccountAC AND c_EmpCurr.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpCurr SET c_EmpCurr.OurID = @NewOurID FROM c_EmpCurr, deleted d WHERE c_EmpCurr.OurID = @OldOurID AND c_EmpCurr.NewAccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpCurr a, deleted d WHERE a.NewAccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Обмен валюты по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpExc - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Перемещение денег между служащими - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpExc a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpExc SET c_EmpExc.AccountAC = @NewAccountAC FROM c_EmpExc, deleted d WHERE c_EmpExc.AccountAC = @OldAccountAC AND c_EmpExc.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpExc SET c_EmpExc.OurID = @NewOurID FROM c_EmpExc, deleted d WHERE c_EmpExc.OurID = @OldOurID AND c_EmpExc.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExc a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Перемещение денег между служащими''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpExp - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Расход денег по служащим - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpExp a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpExp SET c_EmpExp.AccountAC = @NewAccountAC FROM c_EmpExp, deleted d WHERE c_EmpExp.AccountAC = @OldAccountAC AND c_EmpExp.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpExp SET c_EmpExp.OurID = @NewOurID FROM c_EmpExp, deleted d WHERE c_EmpExp.OurID = @OldOurID AND c_EmpExp.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpExp a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Расход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpIn - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Служащие (Финансы) - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpIn a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpIn SET c_EmpIn.AccountAC = @NewAccountAC FROM c_EmpIn, deleted d WHERE c_EmpIn.AccountAC = @OldAccountAC AND c_EmpIn.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpIn SET c_EmpIn.OurID = @NewOurID FROM c_EmpIn, deleted d WHERE c_EmpIn.OurID = @OldOurID AND c_EmpIn.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpIn a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Входящий баланс: Служащие (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpRec - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Приход денег по служащим - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpRec a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpRec SET c_EmpRec.AccountAC = @NewAccountAC FROM c_EmpRec, deleted d WHERE c_EmpRec.AccountAC = @OldAccountAC AND c_EmpRec.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpRec SET c_EmpRec.OurID = @NewOurID FROM c_EmpRec, deleted d WHERE c_EmpRec.OurID = @OldOurID AND c_EmpRec.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRec a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Приход денег по служащим''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_EmpRep - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Отчет служащего - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_EmpRep a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_EmpRep SET c_EmpRep.AccountAC = @NewAccountAC FROM c_EmpRep, deleted d WHERE c_EmpRep.AccountAC = @OldAccountAC AND c_EmpRep.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_EmpRep SET c_EmpRep.OurID = @NewOurID FROM c_EmpRep, deleted d WHERE c_EmpRep.OurID = @OldOurID AND c_EmpRep.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_EmpRep a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Отчет служащего''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_OurCor - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Корректировка баланса денег - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_OurCor a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_OurCor SET c_OurCor.AccountAC = @NewAccountAC FROM c_OurCor, deleted d WHERE c_OurCor.AccountAC = @OldAccountAC AND c_OurCor.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_OurCor SET c_OurCor.OurID = @NewOurID FROM c_OurCor, deleted d WHERE c_OurCor.OurID = @OldOurID AND c_OurCor.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_OurCor a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Корректировка баланса денег''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_OurIn - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Касса (Финансы) - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_OurIn a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_OurIn SET c_OurIn.AccountAC = @NewAccountAC FROM c_OurIn, deleted d WHERE c_OurIn.AccountAC = @OldAccountAC AND c_OurIn.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_OurIn SET c_OurIn.OurID = @NewOurID FROM c_OurIn, deleted d WHERE c_OurIn.OurID = @OldOurID AND c_OurIn.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_OurIn a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Входящий баланс: Касса (Финансы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_PlanExp - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Планирование: Расходы - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_PlanExp a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_PlanExp SET c_PlanExp.AccountAC = @NewAccountAC FROM c_PlanExp, deleted d WHERE c_PlanExp.AccountAC = @OldAccountAC AND c_PlanExp.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_PlanExp SET c_PlanExp.OurID = @NewOurID FROM c_PlanExp, deleted d WHERE c_PlanExp.OurID = @OldOurID AND c_PlanExp.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanExp a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Планирование: Расходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursAC ^ c_PlanRec - Обновление CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Планирование: Доходы - Обновление CHILD */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountAC = i.AccountAC, a.OurID = i.OurID
          FROM c_PlanRec a, inserted i, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountAC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountAC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountAC = AccountAC FROM deleted
          SELECT TOP 1 @NewAccountAC = AccountAC FROM inserted
          UPDATE c_PlanRec SET c_PlanRec.AccountAC = @NewAccountAC FROM c_PlanRec, deleted d WHERE c_PlanRec.AccountAC = @OldAccountAC AND c_PlanRec.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountAC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE c_PlanRec SET c_PlanRec.OurID = @NewOurID FROM c_PlanRec, deleted d WHERE c_PlanRec.OurID = @OldOurID AND c_PlanRec.AccountAC = d.AccountAC
        END
      ELSE IF EXISTS (SELECT * FROM c_PlanRec a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Валютные счета'' => ''Планирование: Доходы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(AccountAC)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, AccountAC FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, AccountAC FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccountAC as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10110003 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccountAC as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccountAC as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10110003 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccountAC as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10110003, m.ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID
          DELETE FROM z_LogCreate WHERE TableCode = 10110003 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AccountAC as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10110003 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AccountAC as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10110003, m.ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110003, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_OursAC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_OursAC] ON [r_OursAC]
FOR DELETE AS
/* r_OursAC - Справочник внутренних фирм - Валютные счета - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_OursAC ^ b_BankExpAC - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Валютный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpAC a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID AND a.AccountAC = d.AccountAC)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'b_BankExpAC', 3
      RETURN
    END

/* r_OursAC ^ b_BankPayAC - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Валютное платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayAC a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'b_BankPayAC', 3
      RETURN
    END

/* r_OursAC ^ b_BankRecAC - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Валютный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecAC a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID AND a.AccountAC = d.AccountAC)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'b_BankRecAC', 3
      RETURN
    END

/* r_OursAC ^ b_zInBA - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Валютный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBA a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'b_zInBA', 3
      RETURN
    END

/* r_OursAC ^ c_CompCor - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Корректировка баланса предприятия - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCor a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompCor', 3
      RETURN
    END

/* r_OursAC ^ c_CompCurr - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompCurr', 3
      RETURN
    END

/* r_OursAC ^ c_CompCurr - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompCurr a WITH(NOLOCK), deleted d WHERE a.NewAccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompCurr', 3
      RETURN
    END

/* r_OursAC ^ c_CompExp - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Расход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompExp a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompExp', 3
      RETURN
    END

/* r_OursAC ^ c_CompIn - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Предприятия (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompIn a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompIn', 3
      RETURN
    END

/* r_OursAC ^ c_CompRec - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Приход денег по предприятиям - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_CompRec a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_CompRec', 3
      RETURN
    END

/* r_OursAC ^ c_EmpCor - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Корректировка баланса служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCor a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpCor', 3
      RETURN
    END

/* r_OursAC ^ c_EmpCurr - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpCurr', 3
      RETURN
    END

/* r_OursAC ^ c_EmpCurr - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Обмен валюты по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpCurr a WITH(NOLOCK), deleted d WHERE a.NewAccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpCurr', 3
      RETURN
    END

/* r_OursAC ^ c_EmpExc - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Перемещение денег между служащими - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExc a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpExc', 3
      RETURN
    END

/* r_OursAC ^ c_EmpExp - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Расход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpExp a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpExp', 3
      RETURN
    END

/* r_OursAC ^ c_EmpIn - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Служащие (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpIn a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpIn', 3
      RETURN
    END

/* r_OursAC ^ c_EmpRec - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Приход денег по служащим - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRec a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpRec', 3
      RETURN
    END

/* r_OursAC ^ c_EmpRep - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Отчет служащего - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_EmpRep a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_EmpRep', 3
      RETURN
    END

/* r_OursAC ^ c_OurCor - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Корректировка баланса денег - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurCor a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_OurCor', 3
      RETURN
    END

/* r_OursAC ^ c_OurIn - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Входящий баланс: Касса (Финансы) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_OurIn a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_OurIn', 3
      RETURN
    END

/* r_OursAC ^ c_PlanExp - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Планирование: Расходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanExp a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_PlanExp', 3
      RETURN
    END

/* r_OursAC ^ c_PlanRec - Проверка в CHILD */
/* Справочник внутренних фирм - Валютные счета ^ Планирование: Доходы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM c_PlanRec a WITH(NOLOCK), deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'c_PlanRec', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10110003 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountAC as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10110003 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountAC as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10110003, m.ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.AccountAC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_OursAC', N'Last', N'DELETE'
GO