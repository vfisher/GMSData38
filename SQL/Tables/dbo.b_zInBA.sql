CREATE TABLE [dbo].[b_zInBA] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [AccountAC] [varchar](250) NOT NULL,
  [SumAC] [numeric](21, 9) NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  [DocID] [bigint] NOT NULL,
  [StockID] [int] NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  CONSTRAINT [_pk_b_zInBA] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [AccountAC]
  ON [dbo].[b_zInBA] ([AccountAC])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[b_zInBA] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[b_zInBA] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[b_zInBA] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[b_zInBA] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[b_zInBA] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[b_zInBA] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_zInBA] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [KursCC]
  ON [dbo].[b_zInBA] ([KursCC])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[b_zInBA] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [r_OursACb_zInBA]
  ON [dbo].[b_zInBA] ([OurID], [AccountAC])
  ON [PRIMARY]
GO

CREATE INDEX [SumAC]
  ON [dbo].[b_zInBA] ([SumAC])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.SumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.KursCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInBA.GTranID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_zInBA] ON [b_zInBA]
FOR INSERT AS
/* b_zInBA - Входящий баланс: Валютный счет - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_zInBA ^ r_Codes1 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_Codes2 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_Codes3 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_Codes4 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_Codes5 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_Currs - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_GOpers - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_OursAC - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.AccountAC = m.AccountAC AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OursAC', 'b_zInBA', 0
      RETURN
    END

/* b_zInBA ^ r_Stocks - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInBA', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14902001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_zInBA', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_zInBA] ON [b_zInBA]
FOR UPDATE AS
/* b_zInBA - Входящий баланс: Валютный счет - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_zInBA ^ r_Codes1 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_Codes2 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_Codes3 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_Codes4 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_Codes5 - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_Currs - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_GOpers - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_OursAC - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник внутренних фирм - Валютные счета - Проверка в PARENT */
  IF UPDATE(AccountAC) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM r_OursAC m WITH(NOLOCK), inserted i WHERE i.AccountAC = m.AccountAC AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OursAC', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ r_Stocks - Проверка в PARENT */
/* Входящий баланс: Валютный счет ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_zInBA', 1
        RETURN
      END

/* b_zInBA ^ z_DocShed - Обновление CHILD */
/* Входящий баланс: Валютный счет ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14902, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14902 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14902 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Входящий баланс: Валютный счет'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14902 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14902 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14902001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14902001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14902001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14902001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14902001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14902001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14902001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14902001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14902001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_zInBA', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_zInBA] ON [b_zInBA]
FOR DELETE AS
/* b_zInBA - Входящий баланс: Валютный счет - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_zInBA ^ z_DocShed - Удаление в CHILD */
/* Входящий баланс: Валютный счет ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14902 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14902001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14902001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14902001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14902 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_zInBA', N'Last', N'DELETE'
GO