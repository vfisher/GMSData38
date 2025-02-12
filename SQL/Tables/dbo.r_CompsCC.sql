CREATE TABLE [dbo].[r_CompsCC] (
  [CompID] [int] NOT NULL,
  [BankID] [int] NOT NULL,
  [CompAccountCC] [varchar](250) NOT NULL,
  [DefaultAccount] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [IBANCode] [varchar](34) NULL,
  [OldCompAccountCC] [varchar](20) NULL,
  CONSTRAINT [_pk_r_CompsCC] PRIMARY KEY CLUSTERED ([CompID], [CompAccountCC])
)
ON [PRIMARY]
GO

CREATE INDEX [BankID]
  ON [dbo].[r_CompsCC] ([BankID])
  ON [PRIMARY]
GO

CREATE INDEX [CompAccountCC]
  ON [dbo].[r_CompsCC] ([CompAccountCC])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[r_CompsCC] ([CompID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompsCC.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompsCC.BankID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CompsCC.DefaultAccount'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Upd_r_CompsCC] 
ON [dbo].[r_CompsCC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(CompAccountCC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(CompAccountCC)    
      UPDATE oc 
      SET    oc.OldCompAccountCC = CASE  
                                    WHEN i.CompAccountCC LIKE '[a-Z][a-Z]%' AND d.CompAccountCC NOT LIKE '[a-Z][a-Z]%' THEN d.CompAccountCC 
                                    ELSE i.OldCompAccountCC 
                               END 
      FROM   DELETED d 
            ,r_CompsCC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.CompID=i.CompID AND oc.CompAccountCC=i.CompAccountCC) 
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CompsCC] ON [r_CompsCC]
FOR INSERT AS
/* r_CompsCC - Справочник предприятий - Расчетные счета - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompsCC ^ r_Banks - Проверка в PARENT */
/* Справочник предприятий - Расчетные счета ^ Справочник банков - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
    BEGIN
      EXEC z_RelationError 'r_Banks', 'r_CompsCC', 0
      RETURN
    END

/* r_CompsCC ^ r_Comps - Проверка в PARENT */
/* Справочник предприятий - Расчетные счета ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'r_CompsCC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250004, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CompsCC', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CompsCC] ON [r_CompsCC]
FOR UPDATE AS
/* r_CompsCC - Справочник предприятий - Расчетные счета - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CompsCC ^ r_Banks - Проверка в PARENT */
/* Справочник предприятий - Расчетные счета ^ Справочник банков - Проверка в PARENT */
  IF UPDATE(BankID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.BankID NOT IN (SELECT BankID FROM r_Banks))
      BEGIN
        EXEC z_RelationError 'r_Banks', 'r_CompsCC', 1
        RETURN
      END

/* r_CompsCC ^ r_Comps - Проверка в PARENT */
/* Справочник предприятий - Расчетные счета ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'r_CompsCC', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldCompID int, @NewCompID int
  DECLARE @OldCompAccountCC varchar(250), @NewCompAccountCC varchar(250)

/* r_CompsCC ^ b_BankExpCC - Обновление CHILD */
/* Справочник предприятий - Расчетные счета ^ Расчетный счет: Расход - Обновление CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAccountCC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID, a.CompAccountCC = i.CompAccountCC
          FROM b_BankExpCC a, inserted i, deleted d WHERE a.CompID = d.CompID AND a.CompAccountCC = d.CompAccountCC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompAccountCC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE b_BankExpCC SET b_BankExpCC.CompID = @NewCompID FROM b_BankExpCC, deleted d WHERE b_BankExpCC.CompID = @OldCompID AND b_BankExpCC.CompAccountCC = d.CompAccountCC
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountCC = CompAccountCC FROM deleted
          SELECT TOP 1 @NewCompAccountCC = CompAccountCC FROM inserted
          UPDATE b_BankExpCC SET b_BankExpCC.CompAccountCC = @NewCompAccountCC FROM b_BankExpCC, deleted d WHERE b_BankExpCC.CompAccountCC = @OldCompAccountCC AND b_BankExpCC.CompID = d.CompID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankExpCC a, deleted d WHERE a.CompID = d.CompID AND a.CompAccountCC = d.CompAccountCC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Расчетные счета'' => ''Расчетный счет: Расход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsCC ^ b_BankPayCC - Обновление CHILD */
/* Справочник предприятий - Расчетные счета ^ Платежное поручение - Обновление CHILD */
  IF UPDATE(CompAccountCC) OR UPDATE(CompID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompAccountCC = i.CompAccountCC, a.CompID = i.CompID
          FROM b_BankPayCC a, inserted i, deleted d WHERE a.CompAccountCC = d.CompAccountCC AND a.CompID = d.CompID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountCC = CompAccountCC FROM deleted
          SELECT TOP 1 @NewCompAccountCC = CompAccountCC FROM inserted
          UPDATE b_BankPayCC SET b_BankPayCC.CompAccountCC = @NewCompAccountCC FROM b_BankPayCC, deleted d WHERE b_BankPayCC.CompAccountCC = @OldCompAccountCC AND b_BankPayCC.CompID = d.CompID
        END
      ELSE IF NOT UPDATE(CompAccountCC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE b_BankPayCC SET b_BankPayCC.CompID = @NewCompID FROM b_BankPayCC, deleted d WHERE b_BankPayCC.CompID = @OldCompID AND b_BankPayCC.CompAccountCC = d.CompAccountCC
        END
      ELSE IF EXISTS (SELECT * FROM b_BankPayCC a, deleted d WHERE a.CompAccountCC = d.CompAccountCC AND a.CompID = d.CompID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Расчетные счета'' => ''Платежное поручение''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CompsCC ^ b_BankRecCC - Обновление CHILD */
/* Справочник предприятий - Расчетные счета ^ Расчетный счет: Приход - Обновление CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAccountCC)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CompID = i.CompID, a.CompAccountCC = i.CompAccountCC
          FROM b_BankRecCC a, inserted i, deleted d WHERE a.CompID = d.CompID AND a.CompAccountCC = d.CompAccountCC
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(CompAccountCC) AND (SELECT COUNT(DISTINCT CompID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompID = CompID FROM deleted
          SELECT TOP 1 @NewCompID = CompID FROM inserted
          UPDATE b_BankRecCC SET b_BankRecCC.CompID = @NewCompID FROM b_BankRecCC, deleted d WHERE b_BankRecCC.CompID = @OldCompID AND b_BankRecCC.CompAccountCC = d.CompAccountCC
        END
      ELSE IF NOT UPDATE(CompID) AND (SELECT COUNT(DISTINCT CompAccountCC) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT CompAccountCC) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldCompAccountCC = CompAccountCC FROM deleted
          SELECT TOP 1 @NewCompAccountCC = CompAccountCC FROM inserted
          UPDATE b_BankRecCC SET b_BankRecCC.CompAccountCC = @NewCompAccountCC FROM b_BankRecCC, deleted d WHERE b_BankRecCC.CompAccountCC = @OldCompAccountCC AND b_BankRecCC.CompID = d.CompID
        END
      ELSE IF EXISTS (SELECT * FROM b_BankRecCC a, deleted d WHERE a.CompID = d.CompID AND a.CompAccountCC = d.CompAccountCC)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник предприятий - Расчетные счета'' => ''Расчетный счет: Приход''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(CompID) OR UPDATE(CompAccountCC)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, CompAccountCC FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CompID, CompAccountCC FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompAccountCC as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10250004 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompAccountCC as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompAccountCC as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10250004 AND l.PKValue = 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompAccountCC as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10250004, m.ChID, 
          '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CompAccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID
          DELETE FROM z_LogCreate WHERE TableCode = 10250004 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompAccountCC as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10250004 AND PKValue IN (SELECT 
          '[' + cast(CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CompAccountCC as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10250004, m.ChID, 
          '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CompAccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10250004, m.ChID, 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Comps m ON m.CompID = i.CompID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CompsCC', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CompsCC] ON [r_CompsCC]
FOR DELETE AS
/* r_CompsCC - Справочник предприятий - Расчетные счета - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CompsCC ^ b_BankExpCC - Проверка в CHILD */
/* Справочник предприятий - Расчетные счета ^ Расчетный счет: Расход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankExpCC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAccountCC = d.CompAccountCC)
    BEGIN
      EXEC z_RelationError 'r_CompsCC', 'b_BankExpCC', 3
      RETURN
    END

/* r_CompsCC ^ b_BankPayCC - Проверка в CHILD */
/* Справочник предприятий - Расчетные счета ^ Платежное поручение - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankPayCC a WITH(NOLOCK), deleted d WHERE a.CompAccountCC = d.CompAccountCC AND a.CompID = d.CompID)
    BEGIN
      EXEC z_RelationError 'r_CompsCC', 'b_BankPayCC', 3
      RETURN
    END

/* r_CompsCC ^ b_BankRecCC - Проверка в CHILD */
/* Справочник предприятий - Расчетные счета ^ Расчетный счет: Приход - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_BankRecCC a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAccountCC = d.CompAccountCC)
    BEGIN
      EXEC z_RelationError 'r_CompsCC', 'b_BankRecCC', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10250004 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountCC as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10250004 AND m.PKValue = 
    '[' + cast(i.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CompAccountCC as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10250004, m.ChID, 
    '[' + cast(d.CompID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CompAccountCC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Comps m ON m.CompID = d.CompID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CompsCC', N'Last', N'DELETE'
GO