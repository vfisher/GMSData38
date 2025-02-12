CREATE TABLE [dbo].[t_MonIntExp] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [CRID] [smallint] NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [DocTime] [datetime] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [SumCC] [numeric](21, 9) NOT NULL,
  [Notes] [varchar](200) NULL,
  [OperID] [int] NOT NULL,
  [StateCode] [int] NOT NULL DEFAULT (0),
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](250) NULL,
  [GUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
  CONSTRAINT [pk_t_MonIntExp] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_MonIntExp] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_MonIntExp] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_MonIntExp] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_MonIntExp] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_MonIntExp] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[t_MonIntExp] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocTime]
  ON [dbo].[t_MonIntExp] ([DocTime])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_MonIntExp] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [r_CRMOt_MExp]
  ON [dbo].[t_MonIntExp] ([CRID], [OperID])
  ON [PRIMARY]
GO

CREATE INDEX [SumCC]
  ON [dbo].[t_MonIntExp] ([SumCC])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_MonIntExp] ([OurID], [DocID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.CRID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.SumCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_MonIntExp.OperID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_MonIntExp] ON [t_MonIntExp]
FOR DELETE AS
/* t_MonIntExp - Служебный расход денег - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11052 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11052, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Служебный расход денег'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_MonIntExp ^ t_CashRegInetCheques - Удаление в CHILD */
/* Служебный расход денег ^ Чеки электронного РРО - Удаление в CHILD */
  DELETE t_CashRegInetCheques FROM t_CashRegInetCheques a, deleted d WHERE a.DocCode = 11052 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_MonIntExp ^ z_DocLinks - Удаление в CHILD */
/* Служебный расход денег ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11052 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_MonIntExp ^ z_DocLinks - Проверка в CHILD */
/* Служебный расход денег ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 11052 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 't_MonIntExp', 'z_DocLinks', 3
      RETURN
    END

/* t_MonIntExp ^ z_DocShed - Удаление в CHILD */
/* Служебный расход денег ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11052 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11052 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_MonIntExp', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_MonIntExp] ON [t_MonIntExp]
FOR UPDATE AS
/* t_MonIntExp - Служебный расход денег - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11052, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Служебный расход денег).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11052, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
  DECLARE @StateCodePosID int
  SELECT @StateCodePosID = colid FROM syscolumns WHERE id = object_id('t_MonIntExp') AND name = 'StateCode'
  DECLARE @BytePos int
  DECLARE @UpdLen int
  DECLARE @FieldsChanged bit
  SET @FieldsChanged = 0
  SET @BytePos = CAST(CEILING(@StateCodePosID / 8.0) AS int)
  SET @UpdLen = LEN(COLUMNS_UPDATED())
  WHILE (@UpdLen > 0 AND @FieldsChanged = 0)
    BEGIN
      IF @UpdLen = @BytePos
        BEGIN
         IF CAST(SUBSTRING(COLUMNS_UPDATED(), @UpdLen, 1) AS Int) <> POWER(2, @StateCodePosID - (CEILING(@StateCodePosID / 8.0) - 1) * 8 - 1)
           SET @FieldsChanged = 1
        END
      ELSE
        IF CAST(SUBSTRING(COLUMNS_UPDATED(), @UpdLen, 1) AS Int) <> 0
          SET @FieldsChanged = 1
      SET @UpdLen = @UpdLen - 1
    END
  IF @FieldsChanged = 1
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11052, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Служебный расход денег'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_MonIntExp ^ r_Codes1 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_Codes2 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_Codes3 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_Codes4 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_Codes5 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_OperCRs - Проверка в PARENT */
/* Служебный расход денег ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF UPDATE(CRID) OR UPDATE(OperID)
    IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OperCRs', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_Ours - Проверка в PARENT */
/* Служебный расход денег ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ r_States - Проверка в PARENT */
/* Служебный расход денег ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_MonIntExp', 1
        RETURN
      END

/* t_MonIntExp ^ t_CashRegInetCheques - Обновление CHILD */
/* Служебный расход денег ^ Чеки электронного РРО - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11052, a.ChID = i.ChID
          FROM t_CashRegInetCheques a, inserted i, deleted d WHERE a.DocCode = 11052 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CashRegInetCheques a, deleted d WHERE a.DocCode = 11052 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Служебный расход денег'' => ''Чеки электронного РРО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_MonIntExp ^ z_DocLinks - Обновление CHILD */
/* Служебный расход денег ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 11052, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 11052 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11052 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Служебный расход денег'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_MonIntExp ^ z_DocLinks - Обновление CHILD */
/* Служебный расход денег ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 11052, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 11052 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 11052 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Служебный расход денег'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_MonIntExp ^ z_DocShed - Обновление CHILD */
/* Служебный расход денег ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11052, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11052 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11052 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Служебный расход денег'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11052 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11052 AND l.ParentChID = i.ChID
  END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_MonIntExp', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_MonIntExp] ON [t_MonIntExp]
FOR INSERT AS
/* t_MonIntExp - Служебный расход денег - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11052, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Служебный расход денег'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_MonIntExp ^ r_Codes1 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_Codes2 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_Codes3 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_Codes4 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_Codes5 - Проверка в PARENT */
/* Служебный расход денег ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_OperCRs - Проверка в PARENT */
/* Служебный расход денег ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_Ours - Проверка в PARENT */
/* Служебный расход денег ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_MonIntExp', 0
      RETURN
    END

/* t_MonIntExp ^ r_States - Проверка в PARENT */
/* Служебный расход денег ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_MonIntExp', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_MonIntExp', N'Last', N'INSERT'
GO











































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO