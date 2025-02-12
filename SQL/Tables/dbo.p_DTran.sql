CREATE TABLE [dbo].[p_DTran] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [DepID] [smallint] NOT NULL,
  [NotUseSubID] [bit] NULL,
  [NotUseDepID] [bit] NULL,
  [TranDate] [smalldatetime] NOT NULL,
  [TranType] [tinyint] NOT NULL,
  [DestDate] [smalldatetime] NULL,
  [DatePayFac] [numeric](21, 9) NOT NULL,
  [WTSignID] [tinyint] NOT NULL,
  [Notes] [varchar](200) NULL,
  [StateCode] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_p_DTran] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [DepID]
  ON [dbo].[p_DTran] ([DepID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[p_DTran] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_DTran] ([SubID])
  ON [PRIMARY]
GO

CREATE INDEX [TranDate]
  ON [dbo].[p_DTran] ([TranDate])
  ON [PRIMARY]
GO

CREATE INDEX [WTSignID]
  ON [dbo].[p_DTran] ([WTSignID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.SubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.DepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.NotUseSubID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.NotUseDepID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.TranType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.DatePayFac'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.p_DTran.WTSignID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_DTran] ON [p_DTran]
FOR INSERT AS
/* p_DTran - Перенос рабочих дней - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(15090, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Перенос рабочих дней'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* p_DTran ^ r_Deps - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_DTran', 0
      RETURN
    END

/* p_DTran ^ r_Ours - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_DTran', 0
      RETURN
    END

/* p_DTran ^ r_States - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'p_DTran', 0
      RETURN
    END

/* p_DTran ^ r_Subs - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_DTran', 0
      RETURN
    END

/* p_DTran ^ r_WTSigns - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_DTran', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15090001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_DTran', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_DTran] ON [p_DTran]
FOR UPDATE AS
/* p_DTran - Перенос рабочих дней - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(15090, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Перенос рабочих дней).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 15090, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('p_DTran', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(15090, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Перенос рабочих дней'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* p_DTran ^ r_Deps - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_DTran', 1
        RETURN
      END

/* p_DTran ^ r_Ours - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'p_DTran', 1
        RETURN
      END

/* p_DTran ^ r_States - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'p_DTran', 1
        RETURN
      END

/* p_DTran ^ r_Subs - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_DTran', 1
        RETURN
      END

/* p_DTran ^ r_WTSigns - Проверка в PARENT */
/* Перенос рабочих дней ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF UPDATE(WTSignID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
      BEGIN
        EXEC z_RelationError 'r_WTSigns', 'p_DTran', 1
        RETURN
      END

/* p_DTran ^ z_DocLinks - Обновление CHILD */
/* Перенос рабочих дней ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 15090, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 15090 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15090 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перенос рабочих дней'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_DTran ^ z_DocLinks - Обновление CHILD */
/* Перенос рабочих дней ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 15090, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 15090 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 15090 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перенос рабочих дней'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_DTran ^ z_DocShed - Обновление CHILD */
/* Перенос рабочих дней ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 15090, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 15090 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 15090 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перенос рабочих дней'' => ''Документы - Процессы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15090001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15090001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15090001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15090001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15090001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15090001, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15090001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15090001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15090001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_DTran', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_DTran] ON [p_DTran]
FOR DELETE AS
/* p_DTran - Перенос рабочих дней - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 15090 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(15090, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Перенос рабочих дней'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* p_DTran ^ z_DocLinks - Удаление в CHILD */
/* Перенос рабочих дней ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15090 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_DTran ^ z_DocLinks - Проверка в CHILD */
/* Перенос рабочих дней ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 15090 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'p_DTran', 'z_DocLinks', 3
      RETURN
    END

/* p_DTran ^ z_DocShed - Удаление в CHILD */
/* Перенос рабочих дней ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 15090 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15090001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15090001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15090001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 15090 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_DTran', N'Last', N'DELETE'
GO