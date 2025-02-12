CREATE TABLE [dbo].[r_OursCC] (
  [OurID] [int] NOT NULL,
  [BankID] [int] NOT NULL,
  [AccountCC] [varchar](250) NOT NULL,
  [DefaultAccount] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [GAccID] [int] NOT NULL DEFAULT (0),
  [IBANCode] [varchar](34) NULL,
  [OldAccountCC] [varchar](20) NULL,
  CONSTRAINT [_pk_r_OursCC] PRIMARY KEY CLUSTERED ([OurID], [AccountCC])
)
ON [PRIMARY]
GO

CREATE INDEX [AccountCC]
  ON [dbo].[r_OursCC] ([AccountCC])
  ON [PRIMARY]
GO

CREATE INDEX [BankID]
  ON [dbo].[r_OursCC] ([BankID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[r_OursCC] ([OurID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OursCC.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OursCC.BankID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_OursCC.DefaultAccount'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_r_OursCC] 
ON [dbo].[r_OursCC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(AccountCC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(AccountCC)    
      UPDATE oc 
      SET    oc.OldAccountCC = CASE  
                                    WHEN i.AccountCC LIKE '[a-Z][a-Z]%' AND d.AccountCC NOT LIKE '[a-Z][a-Z]%' THEN d.AccountCC 
                                    ELSE i.OldAccountCC 
                               END 
      FROM   DELETED d 
            ,r_OursCC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.AccountCC=i.AccountCC) 
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_OursCC] ON [r_OursCC]
FOR INSERT AS
/* r_OursCC - Справочник внутренних фирм - Расчетные счета - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OursCC ^ r_Banks - Проверка в PARENT */
/* Справочник внутренних фирм - Расчетные счета ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_OursCC', 0
      RETURN
    END

/* r_OursCC ^ r_GAccs - Проверка в PARENT */
/* Справочник внутренних фирм - Расчетные счета ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'r_OursCC', 0
      RETURN
    END

/* r_OursCC ^ r_Ours - Проверка в PARENT */
/* Справочник внутренних фирм - Расчетные счета ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_OursCC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110002, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_OursCC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_OursCC] ON [r_OursCC]
FOR UPDATE AS
/* r_OursCC - Справочник внутренних фирм - Расчетные счета - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_OursCC ^ r_Banks - Проверка в PARENT */
/* Справочник внутренних фирм - Расчетные счета ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'r_OursCC', 1
        RETURN
      END

/* r_OursCC ^ r_GAccs - Проверка в PARENT */
/* Справочник внутренних фирм - Расчетные счета ^ План счетов - Проверка в PARENT */
  IF UPDATE(GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'r_OursCC', 1
        RETURN
      END

/* r_OursCC ^ r_Ours - Проверка в PARENT */
/* Справочник внутренних фирм - Расчетные счета ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_OursCC', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldOurID int, @NewOurID int
  DECLARE @OldAccountCC varchar(250), @NewAccountCC varchar(250)

/* r_OursCC ^ b_BankExpCC - Обновление CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(OurID) OR UPDATE(AccountCC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID, a.AccountCC = i.AccountCC
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.OurID = d.OurID AND a.AccountCC = d.AccountCC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(AccountCC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_BankExpCC SET b_BankExpCC.OurID = @NewOurID FROM b_BankExpCC, deleted d WHERE b_BankExpCC.OurID = @OldOurID AND b_BankExpCC.AccountCC = d.AccountCC
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountCC = AccountCC FROM deleted
          SELECT TOP 1 @NewAccountCC = AccountCC FROM inserted
          UPDATE b_BankExpCC SET b_BankExpCC.AccountCC = @NewAccountCC FROM b_BankExpCC, deleted d WHERE b_BankExpCC.AccountCC = @OldAccountCC AND b_BankExpCC.OurID = d.OurID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.OurID = d.OurID AND a.AccountCC = d.AccountCC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Расчетные счета'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursCC ^ b_BankPayCC - Обновление CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Платежное поручение - Обновление CHILD */
  IF UPDATE(AccountCC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountCC = i.AccountCC, a.OurID = i.OurID
          FROM b_BankPayCC a, inserted i, deleted d WHERE a.AccountCC = d.AccountCC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountCC = AccountCC FROM deleted
          SELECT TOP 1 @NewAccountCC = AccountCC FROM inserted
          UPDATE b_BankPayCC SET b_BankPayCC.AccountCC = @NewAccountCC FROM b_BankPayCC, deleted d WHERE b_BankPayCC.AccountCC = @OldAccountCC AND b_BankPayCC.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountCC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_BankPayCC SET b_BankPayCC.OurID = @NewOurID FROM b_BankPayCC, deleted d WHERE b_BankPayCC.OurID = @OldOurID AND b_BankPayCC.AccountCC = d.AccountCC
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayCC a, deleted d WHERE a.AccountCC = d.AccountCC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Расчетные счета'' => ''Платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursCC ^ b_BankRecCC - Обновление CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(OurID) OR UPDATE(AccountCC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.OurID = i.OurID, a.AccountCC = i.AccountCC
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.OurID = d.OurID AND a.AccountCC = d.AccountCC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(AccountCC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_BankRecCC SET b_BankRecCC.OurID = @NewOurID FROM b_BankRecCC, deleted d WHERE b_BankRecCC.OurID = @OldOurID AND b_BankRecCC.AccountCC = d.AccountCC
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountCC = AccountCC FROM deleted
          SELECT TOP 1 @NewAccountCC = AccountCC FROM inserted
          UPDATE b_BankRecCC SET b_BankRecCC.AccountCC = @NewAccountCC FROM b_BankRecCC, deleted d WHERE b_BankRecCC.AccountCC = @OldAccountCC AND b_BankRecCC.OurID = d.OurID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.OurID = d.OurID AND a.AccountCC = d.AccountCC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Расчетные счета'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_OursCC ^ b_zInBC - Обновление CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Входящий баланс: Расчетный счет - Обновление CHILD */
  IF UPDATE(AccountCC) OR UPDATE(OurID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AccountCC = i.AccountCC, a.OurID = i.OurID
          FROM b_zInBC a, inserted i, deleted d WHERE a.AccountCC = d.AccountCC AND a.OurID = d.OurID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(OurID) AND (SELECT COUNT(DISTINCT AccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT AccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldAccountCC = AccountCC FROM deleted
          SELECT TOP 1 @NewAccountCC = AccountCC FROM inserted
          UPDATE b_zInBC SET b_zInBC.AccountCC = @NewAccountCC FROM b_zInBC, deleted d WHERE b_zInBC.AccountCC = @OldAccountCC AND b_zInBC.OurID = d.OurID
        END
      ELSE IF NOT UPDATE(AccountCC) AND (SELECT COUNT(DISTINCT OurID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT OurID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldOurID = OurID FROM deleted
          SELECT TOP 1 @NewOurID = OurID FROM inserted
          UPDATE b_zInBC SET b_zInBC.OurID = @NewOurID FROM b_zInBC, deleted d WHERE b_zInBC.OurID = @OldOurID AND b_zInBC.AccountCC = d.AccountCC
        END
      ELSE IF EXISTS (SELECT * FROM b_zInBC a, deleted d WHERE a.AccountCC = d.AccountCC AND a.OurID = d.OurID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник внутренних фирм - Расчетные счета'' => ''Входящий баланс: Расчетный счет''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(AccountCC)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, AccountCC FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, AccountCC FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccountCC as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10110002 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccountCC as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccountCC as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10110002 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccountCC as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10110002, m.ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID
          DELETE FROM z_LogCreate WHERE TableCode = 10110002 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AccountCC as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10110002 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AccountCC as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10110002, m.ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10110002, m.ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Ours m ON m.OurID = i.OurID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_OursCC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_OursCC] ON [r_OursCC]
FOR DELETE AS
/* r_OursCC - Справочник внутренних фирм - Расчетные счета - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_OursCC ^ b_BankExpCC - Проверка в CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID AND a.AccountCC = d.AccountCC)
    BEGIN
      EXEC z_RelationError 'r_OursCC', 'b_BankExpCC', 3
      RETURN
    END

/* r_OursCC ^ b_BankPayCC - Проверка в CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayCC a WITH(NOLOCK), deleted d WHERE a.AccountCC = d.AccountCC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursCC', 'b_BankPayCC', 3
      RETURN
    END

/* r_OursCC ^ b_BankRecCC - Проверка в CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.OurID = d.OurID AND a.AccountCC = d.AccountCC)
    BEGIN
      EXEC z_RelationError 'r_OursCC', 'b_BankRecCC', 3
      RETURN
    END

/* r_OursCC ^ b_zInBC - Проверка в CHILD */
/* Справочник внутренних фирм - Расчетные счета ^ Входящий баланс: Расчетный счет - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInBC a WITH(NOLOCK), deleted d WHERE a.AccountCC = d.AccountCC AND a.OurID = d.OurID)
    BEGIN
      EXEC z_RelationError 'r_OursCC', 'b_zInBC', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10110002 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountCC as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10110002 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AccountCC as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10110002, m.ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.AccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Ours m ON m.OurID = d.OurID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_OursCC', N'Last', N'DELETE'
GO