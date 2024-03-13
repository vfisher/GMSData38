CREATE TABLE [dbo].[p_CWTimeCor]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[WTSignID] [tinyint] NOT NULL,
[UseInWTime] [bit] NOT NULL,
[Notes] [varchar] (200) NOT NULL,
[StateCode] [int] NOT NULL,
[AppDate] [smalldatetime] NOT NULL,
[WorkHours] [numeric] (21, 9) NULL,
[EveningHours] [numeric] (21, 9) NULL,
[NightHours] [numeric] (21, 9) NULL,
[DayShiftCount] [tinyint] NULL,
[DayPayFactor] [numeric] (21, 9) NULL,
[OverTime] [numeric] (21, 9) NULL,
[OverPayFactor] [numeric] (21, 9) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_CWTimeCor] ON [dbo].[p_CWTimeCor]
FOR INSERT AS
/* p_CWTimeCor - Табель учета рабочего времени: Корректировка: Список - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_CWTimeCor ^ r_Codes1 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_Codes2 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_Codes3 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_Codes4 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_Codes5 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_Emps - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_Ours - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_States - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'p_CWTimeCor', 0
      RETURN
    END

/* p_CWTimeCor ^ r_WTSigns - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_CWTimeCor', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15050001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_p_CWTimeCor]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_CWTimeCor] ON [dbo].[p_CWTimeCor]
FOR UPDATE AS
/* p_CWTimeCor - Табель учета рабочего времени: Корректировка: Список - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* p_CWTimeCor ^ r_Codes1 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_Codes2 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_Codes3 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_Codes4 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_Codes5 - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_Emps - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_Ours - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_States - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ r_WTSigns - Проверка в PARENT */
/* Табель учета рабочего времени: Корректировка: Список ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF UPDATE(WTSignID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
      BEGIN
        EXEC z_RelationError 'r_WTSigns', 'p_CWTimeCor', 1
        RETURN
      END

/* p_CWTimeCor ^ z_DocLinks - Обновление CHILD */
/* Табель учета рабочего времени: Корректировка: Список ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 15050, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 15050 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15050 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Табель учета рабочего времени: Корректировка: Список'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* p_CWTimeCor ^ z_DocLinks - Обновление CHILD */
/* Табель учета рабочего времени: Корректировка: Список ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 15050, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 15050 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 15050 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Табель учета рабочего времени: Корректировка: Список'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 15050 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 15050 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 15050001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 15050001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(OurID) OR UPDATE(EmpID) OR UPDATE(AppDate))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15050001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.AppDate as varchar(200)) + ']' AND i.OurID = d.OurID AND i.EmpID = d.EmpID AND i.AppDate = d.AppDate
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15050001 AND l.PKValue = 
        '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.AppDate as varchar(200)) + ']' AND i.OurID = d.OurID AND i.EmpID = d.EmpID AND i.AppDate = d.AppDate
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15050001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15050001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15050001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15050001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(EmpID) OR UPDATE(AppDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, EmpID, AppDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, EmpID, AppDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AppDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15050001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AppDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AppDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15050001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AppDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15050001, ChID, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15050001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AppDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15050001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AppDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15050001, ChID, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15050001, ChID, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_p_CWTimeCor]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_CWTimeCor] ON [dbo].[p_CWTimeCor]
FOR DELETE AS
/* p_CWTimeCor - Табель учета рабочего времени: Корректировка: Список - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* p_CWTimeCor ^ z_DocLinks - Удаление в CHILD */
/* Табель учета рабочего времени: Корректировка: Список ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 15050 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* p_CWTimeCor ^ z_DocLinks - Проверка в CHILD */
/* Табель учета рабочего времени: Корректировка: Список ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 15050 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 'p_CWTimeCor', 'z_DocLinks', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15050001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AppDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15050001 AND m.PKValue = 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AppDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15050001, -ChID, 
    '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.AppDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 15050 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_p_CWTimeCor]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[p_CWTimeCor] ADD CONSTRAINT [pk_p_CWTimeCor] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [AppDate]) ON [PRIMARY]
GO
