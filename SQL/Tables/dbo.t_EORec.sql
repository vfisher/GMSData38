﻿CREATE TABLE [dbo].[t_EORec] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [CompID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [Discount] [numeric](21, 9) NOT NULL,
  [PayDelay] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  [CurrID] [smallint] NOT NULL,
  [InDocID] [bigint] NOT NULL,
  [ExpDate] [smalldatetime] NULL,
  [ExpSN] [bit] NOT NULL,
  [NotDate] [smalldatetime] NULL,
  [NotSN] [bit] NOT NULL,
  [TranAC] [numeric](21, 9) NULL,
  [MoreAC] [numeric](21, 9) NULL,
  [TSumAC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_EORec__TSumAC__4C8DB6CE] DEFAULT (0),
  [TSpendSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_EORec__TSpendS__4D81DB07] DEFAULT (0),
  [TRouteSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_EORec__TRouteS__4E75FF40] DEFAULT (0),
  [StateCode] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_EORec] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[t_EORec] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_EORec] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_EORec] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_EORec] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_EORec] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_EORec] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[t_EORec] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[t_EORec] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[t_EORec] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[t_EORec] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[t_EORec] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID]
  ON [dbo].[t_EORec] ([IntDocID])
  ON [PRIMARY]
GO

CREATE INDEX [KursCC]
  ON [dbo].[t_EORec] ([KursCC])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[t_EORec] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [PayDelay]
  ON [dbo].[t_EORec] ([PayDelay])
  ON [PRIMARY]
GO

CREATE INDEX [SrcDocID]
  ON [dbo].[t_EORec] ([InDocID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_EORec] ([StockID])
  ON [PRIMARY]
GO

CREATE INDEX [t_EOExpt_EORec]
  ON [dbo].[t_EORec] ([OurID], [InDocID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_EORec] ([OurID], [DocID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.DocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.KursCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.Discount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.PayDelay'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.InDocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.ExpSN'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.NotSN'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.TranAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EORec.MoreAC'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_EORec] ON [t_EORec]
FOR INSERT AS
/* t_EORec - Заказ внешний: Обработка: Заголовок - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM inserted a 

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM deleted a 

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11212, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Заказ внешний: Обработка'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_EORec ^ r_Codes1 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Codes2 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Codes3 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Codes4 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Codes5 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Comps - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Currs - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Emps - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_States - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ r_Stocks - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_EORec', 0
      RETURN
    END

/* t_EORec ^ t_EOExp - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_EOExp m WITH(NOLOCK), inserted i WHERE i.InDocID = m.DocID AND i.OurID = m.OurID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_EOExp', 't_EORec', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11212001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_EORec', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_EORec] ON [t_EORec]
FOR UPDATE AS
/* t_EORec - Заказ внешний: Обработка: Заголовок - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM inserted a 

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM deleted a 

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли изменить дату документа */
  IF UPDATE(DocDate) 
    BEGIN
      DECLARE @OldTaxPercent numeric(21, 9)
      DECLARE @NewTaxPercent numeric(21, 9)
      SELECT @OldTaxPercent = dbo.zf_GetTaxPercentByDate(0, (SELECT DocDate FROM deleted)), @NewTaxPercent = dbo.zf_GetTaxPercentByDate(0, (SELECT DocDate FROM inserted))
      IF @OldTaxPercent <> @NewTaxPercent
        BEGIN
          RAISERROR ('Изменение даты документа невозможно (Различные налоговые ставки).', 18, 1)
          ROLLBACK TRAN
          RETURN 
        END
    END  

/* Обработка статуса */
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11212, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Заказ внешний: Обработка).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11212, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('t_EORec', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11212, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Заказ внешний: Обработка'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_EORec ^ r_Codes1 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Codes2 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Codes3 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Codes4 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Codes5 - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Comps - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Currs - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Emps - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_States - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ r_Stocks - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ t_EOExp - Проверка в PARENT */
/* Заказ внешний: Обработка: Заголовок ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(InDocID) OR UPDATE(OurID)
    IF (SELECT COUNT(*) FROM t_EOExp m WITH(NOLOCK), inserted i WHERE i.InDocID = m.DocID AND i.OurID = m.OurID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_EOExp', 't_EORec', 1
        RETURN
      END

/* t_EORec ^ t_EORecD - Обновление CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Заказ внешний: Обработка: Товар - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_EORecD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EORecD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Заказ внешний: Обработка: Заголовок'' => ''Заказ внешний: Обработка: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_EORec ^ z_DocLinks - Обновление CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 11212, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 11212 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11212 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Заказ внешний: Обработка: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_EORec ^ z_DocLinks - Обновление CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 11212, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 11212 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 11212 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Заказ внешний: Обработка: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_EORec ^ z_DocShed - Обновление CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11212, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11212 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11212 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Заказ внешний: Обработка: Заголовок'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11212 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11212 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(DocID) OR UPDATE(IntDocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(KursCC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(CompID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(Discount) OR UPDATE(PayDelay) OR UPDATE(EmpID) OR UPDATE(Notes) OR UPDATE(CurrID) OR UPDATE(InDocID) OR UPDATE(ExpDate) OR UPDATE(ExpSN) OR UPDATE(NotDate) OR UPDATE(NotSN) OR UPDATE(TranAC) OR UPDATE(MoreAC) OR UPDATE(StateCode)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11212001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11212001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11212001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11212001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11212001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11212001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11212001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11212001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11212001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_EORec', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_EORec] ON [t_EORec]
FOR DELETE AS
/* t_EORec - Заказ внешний: Обработка: Заголовок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM inserted a 

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM deleted a 

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Обработка: Заголовок (t_EORec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11212 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11212, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Заказ внешний: Обработка'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_EORec ^ t_EORecD - Удаление в CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Заказ внешний: Обработка: Товар - Удаление в CHILD */
  DELETE t_EORecD FROM t_EORecD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_EORec ^ z_DocLinks - Удаление в CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11212 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_EORec ^ z_DocLinks - Проверка в CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 11212 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 't_EORec', 'z_DocLinks', 3
      RETURN
    END

/* t_EORec ^ z_DocShed - Удаление в CHILD */
/* Заказ внешний: Обработка: Заголовок ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11212 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11212001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11212001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11212001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11212 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_EORec', N'Last', N'DELETE'
GO