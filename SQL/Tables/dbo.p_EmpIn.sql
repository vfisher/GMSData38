CREATE TABLE [dbo].[p_EmpIn] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [WorkAppDate] [smalldatetime] NOT NULL,
  [DisDate] [smalldatetime] NULL,
  [IndexBaseMonth] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_p_EmpIn] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [WorkAppDate])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[p_EmpIn] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_EmpIn] ON [p_EmpIn]
FOR INSERT AS
/* p_EmpIn - Входящие данные по служащим - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_EmpIn ^ r_Emps - Проверка в PARENT */
/* Входящие данные по служащим ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_EmpIn', 0
      RETURN
    END

/* p_EmpIn ^ r_Ours - Проверка в PARENT */
/* Входящие данные по служащим ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_EmpIn', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15901001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_EmpIn', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_EmpIn] ON [p_EmpIn]
FOR UPDATE AS
/* p_EmpIn - Входящие данные по служащим - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_EmpIn ^ r_Emps - Проверка в PARENT */
/* Входящие данные по служащим ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_EmpIn', 1
        RETURN
      END

/* p_EmpIn ^ r_Ours - Проверка в PARENT */
/* Входящие данные по служащим ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'p_EmpIn', 1
        RETURN
      END

/* p_EmpIn ^ p_EmpInLeavs - Обновление CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Отпуска - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM p_EmpInLeavs a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpInLeavs a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Входящие данные по служащим'' => ''Входящие данные по служащим: Отпуска''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EmpIn ^ p_EmpInLExp - Обновление CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Выплаты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM p_EmpInLExp a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpInLExp a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Входящие данные по служащим'' => ''Входящие данные по служащим: Выплаты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EmpIn ^ p_EmpInLRec - Обновление CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Начисления - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM p_EmpInLRec a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpInLRec a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Входящие данные по служащим'' => ''Входящие данные по служащим: Начисления''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_EmpIn ^ p_EmpInWTime - Обновление CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Отработанное время - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM p_EmpInWTime a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_EmpInWTime a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Входящие данные по служащим'' => ''Входящие данные по служащим: Отработанное время''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15901001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15901001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(OurID) OR UPDATE(EmpID) OR UPDATE(WorkAppDate))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15901001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.WorkAppDate as varchar(200)) + ']' AND i.OurID = d.OurID AND i.EmpID = d.EmpID AND i.WorkAppDate = d.WorkAppDate
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15901001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.WorkAppDate as varchar(200)) + ']' AND i.OurID = d.OurID AND i.EmpID = d.EmpID AND i.WorkAppDate = d.WorkAppDate
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15901001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15901001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15901001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15901001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(EmpID) OR UPDATE(WorkAppDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, EmpID, WorkAppDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, EmpID, WorkAppDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WorkAppDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15901001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WorkAppDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WorkAppDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15901001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WorkAppDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15901001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15901001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WorkAppDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15901001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WorkAppDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15901001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15901001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_EmpIn', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_EmpIn] ON [p_EmpIn]
FOR DELETE AS
/* p_EmpIn - Входящие данные по служащим - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* p_EmpIn ^ p_EmpInLeavs - Удаление в CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Отпуска - Удаление в CHILD */
  DELETE p_EmpInLeavs FROM p_EmpInLeavs a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_EmpIn ^ p_EmpInLExp - Удаление в CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Выплаты - Удаление в CHILD */
  DELETE p_EmpInLExp FROM p_EmpInLExp a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_EmpIn ^ p_EmpInLRec - Удаление в CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Начисления - Удаление в CHILD */
  DELETE p_EmpInLRec FROM p_EmpInLRec a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_EmpIn ^ p_EmpInWTime - Удаление в CHILD */
/* Входящие данные по служащим ^ Входящие данные по служащим: Отработанное время - Удаление в CHILD */
  DELETE p_EmpInWTime FROM p_EmpInWTime a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15901001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WorkAppDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15901001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WorkAppDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15901001, -ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.WorkAppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 15901 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_EmpIn', N'Last', N'DELETE'
GO