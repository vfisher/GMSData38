CREATE TABLE [dbo].[b_zInH] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  [SumAC] [numeric](21, 9) NOT NULL,
  [GTranID] [int] NOT NULL,
  [D_GAccID] [int] NOT NULL,
  [C_GAccID] [int] NOT NULL,
  [D_CompID] [int] NOT NULL,
  [C_CompID] [int] NOT NULL,
  [D_EmpID] [int] NOT NULL,
  [C_EmpID] [int] NOT NULL,
  [D_CodeID1] [smallint] NOT NULL,
  [C_CodeID1] [smallint] NOT NULL,
  [D_CodeID2] [smallint] NOT NULL,
  [C_CodeID2] [smallint] NOT NULL,
  [D_CodeID3] [smallint] NOT NULL,
  [C_CodeID3] [smallint] NOT NULL,
  [D_CodeID4] [smallint] NOT NULL,
  [C_CodeID4] [smallint] NOT NULL,
  [D_CodeID5] [smallint] NOT NULL,
  [C_CodeID5] [smallint] NOT NULL,
  [D_StockID] [int] NOT NULL,
  [C_StockID] [int] NOT NULL,
  [D_ProdID] [int] NOT NULL,
  [C_ProdID] [int] NOT NULL,
  [D_AssID] [int] NOT NULL,
  [C_AssID] [int] NOT NULL,
  [D_GVolID] [int] NOT NULL,
  [C_GVolID] [int] NOT NULL,
  [D_Qty] [numeric](21, 9) NOT NULL,
  [C_Qty] [numeric](21, 9) NOT NULL,
  [DocID] [bigint] NOT NULL,
  [StateCode] [int] NOT NULL DEFAULT (0),
  [DocDate] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_b_zInH] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [C_AssID]
  ON [dbo].[b_zInH] ([C_AssID])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID1]
  ON [dbo].[b_zInH] ([C_CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID2]
  ON [dbo].[b_zInH] ([C_CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID3]
  ON [dbo].[b_zInH] ([C_CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID4]
  ON [dbo].[b_zInH] ([C_CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [C_CodeID5]
  ON [dbo].[b_zInH] ([C_CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [C_CompID]
  ON [dbo].[b_zInH] ([C_CompID])
  ON [PRIMARY]
GO

CREATE INDEX [C_EmpID]
  ON [dbo].[b_zInH] ([C_EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [C_GAccID]
  ON [dbo].[b_zInH] ([C_GAccID])
  ON [PRIMARY]
GO

CREATE INDEX [C_GVolID]
  ON [dbo].[b_zInH] ([C_GVolID])
  ON [PRIMARY]
GO

CREATE INDEX [C_ProdID]
  ON [dbo].[b_zInH] ([C_ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [C_StockID]
  ON [dbo].[b_zInH] ([C_StockID])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[b_zInH] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [D_AssID]
  ON [dbo].[b_zInH] ([D_AssID])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID1]
  ON [dbo].[b_zInH] ([D_CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID2]
  ON [dbo].[b_zInH] ([D_CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID3]
  ON [dbo].[b_zInH] ([D_CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID4]
  ON [dbo].[b_zInH] ([D_CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [D_CodeID5]
  ON [dbo].[b_zInH] ([D_CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [D_CompID]
  ON [dbo].[b_zInH] ([D_CompID])
  ON [PRIMARY]
GO

CREATE INDEX [D_EmpID]
  ON [dbo].[b_zInH] ([D_EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [D_GAccID]
  ON [dbo].[b_zInH] ([D_GAccID])
  ON [PRIMARY]
GO

CREATE INDEX [D_GVolID]
  ON [dbo].[b_zInH] ([D_GVolID])
  ON [PRIMARY]
GO

CREATE INDEX [D_ProdID]
  ON [dbo].[b_zInH] ([D_ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [D_StockID]
  ON [dbo].[b_zInH] ([D_StockID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[b_zInH] ([OurID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.KursCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.SumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_GAccID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_GAccID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_AssID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_AssID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_GVolID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_GVolID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.D_Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_zInH.C_Qty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_zInH] ON [b_zInH]
FOR DELETE AS
/* b_zInH - Ручные входящие - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 14909 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14909, a.ChID, a.StateCode) = 0)
      BEGIN
        DECLARE @Err2 varchar(200)
        SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Ручные входящие'))
        RAISERROR(@Err2, 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_zInH ^ z_DocShed - Удаление в CHILD */
/* Ручные входящие ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 14909 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14909001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14909001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14909001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14909 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_zInH', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_zInH] ON [b_zInH]
FOR UPDATE AS
/* b_zInH - Ручные входящие - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(14909, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      DECLARE @Err1 varchar(200)
      SELECT @Err1 = FORMATMESSAGE(dbo.zf_Translate('Переход в указанный статус невозможен (%s).'), dbo.zf_Translate('Ручные входящие'))
      RAISERROR(@Err1, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 14909, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('b_zInH', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(14909, a.ChID, a.StateCode) = 0)
      BEGIN
        DECLARE @Err2 varchar(200)
        SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Ручные входящие'))
        RAISERROR(@Err2, 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* b_zInH ^ r_Assets - Проверка в PARENT */
/* Ручные входящие ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(C_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Assets - Проверка в PARENT */
/* Ручные входящие ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(D_AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes1 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(C_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes1 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(D_CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes2 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(C_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes2 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(D_CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes3 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(C_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes3 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(D_CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes4 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(C_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes4 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(D_CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes5 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(C_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Codes5 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(D_CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Comps - Проверка в PARENT */
/* Ручные входящие ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(C_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Comps - Проверка в PARENT */
/* Ручные входящие ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(D_CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Currs - Проверка в PARENT */
/* Ручные входящие ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Emps - Проверка в PARENT */
/* Ручные входящие ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(C_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Emps - Проверка в PARENT */
/* Ручные входящие ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(D_EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_GAccs - Проверка в PARENT */
/* Ручные входящие ^ План счетов - Проверка в PARENT */
  IF UPDATE(C_GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_GAccs - Проверка в PARENT */
/* Ручные входящие ^ План счетов - Проверка в PARENT */
  IF UPDATE(D_GAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_GVols - Проверка в PARENT */
/* Ручные входящие ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(C_GVolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_GVolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_GVols - Проверка в PARENT */
/* Ручные входящие ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF UPDATE(D_GVolID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_GVolID NOT IN (SELECT GVolID FROM r_GVols))
      BEGIN
        EXEC z_RelationError 'r_GVols', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Ours - Проверка в PARENT */
/* Ручные входящие ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Prods - Проверка в PARENT */
/* Ручные входящие ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(C_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Prods - Проверка в PARENT */
/* Ручные входящие ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(D_ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_States - Проверка в PARENT */
/* Ручные входящие ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Stocks - Проверка в PARENT */
/* Ручные входящие ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(C_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ r_Stocks - Проверка в PARENT */
/* Ручные входящие ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(D_StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_zInH', 1
        RETURN
      END

/* b_zInH ^ z_DocShed - Обновление CHILD */
/* Ручные входящие ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 14909, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 14909 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 14909 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Ручные входящие'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14909 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14909 AND l.ParentChID = i.ChID
  END


/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14909001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14909001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14909001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14909001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14909001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14909001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14909001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14909001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14909001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_zInH', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_zInH] ON [b_zInH]
FOR INSERT AS
/* b_zInH - Ручные входящие - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(14909, i.StateCode) = 0)
    BEGIN
      DECLARE @Err1 varchar(200)
      SELECT @Err1 = FORMATMESSAGE(dbo.zf_Translate('Документ ''%s'' не может иметь указанный статус.'), dbo.zf_Translate('Ручные входящие'))
      RAISERROR(@Err1, 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* b_zInH ^ r_Assets - Проверка в PARENT */
/* Ручные входящие ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Assets - Проверка в PARENT */
/* Ручные входящие ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes1 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes1 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes2 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes2 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes3 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes3 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes4 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes4 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes5 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Codes5 - Проверка в PARENT */
/* Ручные входящие ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Comps - Проверка в PARENT */
/* Ручные входящие ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Comps - Проверка в PARENT */
/* Ручные входящие ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Currs - Проверка в PARENT */
/* Ручные входящие ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Emps - Проверка в PARENT */
/* Ручные входящие ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Emps - Проверка в PARENT */
/* Ручные входящие ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_GAccs - Проверка в PARENT */
/* Ручные входящие ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_GAccs - Проверка в PARENT */
/* Ручные входящие ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_GVols - Проверка в PARENT */
/* Ручные входящие ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_GVolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_GVols - Проверка в PARENT */
/* Ручные входящие ^ Справочник проводок: виды аналитики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_GVolID NOT IN (SELECT GVolID FROM r_GVols))
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Ours - Проверка в PARENT */
/* Ручные входящие ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Prods - Проверка в PARENT */
/* Ручные входящие ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Prods - Проверка в PARENT */
/* Ручные входящие ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_States - Проверка в PARENT */
/* Ручные входящие ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Stocks - Проверка в PARENT */
/* Ручные входящие ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.C_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInH', 0
      RETURN
    END

/* b_zInH ^ r_Stocks - Проверка в PARENT */
/* Ручные входящие ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.D_StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_zInH', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14909001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_zInH', N'Last', N'INSERT'
GO























































































































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO