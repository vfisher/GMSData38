﻿CREATE TABLE [dbo].[t_Exp] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [CompID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [Discount] [numeric](21, 9) NULL,
  [PayDelay] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  [SrcDocID] [varchar](250) NULL,
  [SrcDocDate] [smalldatetime] NULL,
  [LetAttor] [varchar](200) NULL,
  [MorePrc] [numeric](21, 9) NULL,
  [CurrID] [smallint] NOT NULL DEFAULT (0),
  [TSumCC_nt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exp__TSumCC_nt__1819EE8F] DEFAULT (0),
  [TTaxSum] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exp__TTaxSum__190E12C8] DEFAULT (0),
  [TSumCC_wt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exp__TSumCC_wt__1A023701] DEFAULT (0),
  [TSpendSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exp__TSpendSum__1AF65B3A] DEFAULT (0),
  [TRouteSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exp__TRouteSum__1BEA7F73] DEFAULT (0),
  [StateCode] [int] NOT NULL DEFAULT (0),
  [TSumAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TTaxSumAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TSumAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_Exp] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_Exp] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_Exp] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_Exp] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_Exp] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_Exp] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[t_Exp] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[t_Exp] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[t_Exp] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[t_Exp] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID]
  ON [dbo].[t_Exp] ([IntDocID])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[t_Exp] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_Exp] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [PayDelay]
  ON [dbo].[t_Exp] ([PayDelay])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_Exp] ([StockID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_Exp] ([OurID], [DocID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.DocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.Discount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.PayDelay'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exp.EmpID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_Exp] ON [t_Exp]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 29 - Текущие остатки товара */
/* t_Exp - Расходный документ: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), inserted m
  WHERE t_ExpD.ProdID = r_Prods.ProdID AND m.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_ExpD.SecID = r.SecID AND t_ExpD.ProdID = r.ProdID AND t_ExpD.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), deleted m
  WHERE t_ExpD.ProdID = r_Prods.ProdID AND m.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_ExpD.SecID = r.SecID AND t_ExpD.ProdID = r.ProdID AND t_ExpD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID, 
       ISNULL(SUM(t_ExpD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), deleted m
     WHERE t_ExpD.ProdID = r_Prods.ProdID AND m.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID, 
       ISNULL(SUM(t_ExpD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), inserted m
     WHERE t_ExpD.ProdID = r_Prods.ProdID AND m.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_Exp] ON [t_Exp]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 29 - Текущие остатки товара */
/* t_Exp - Расходный документ: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), deleted m
  WHERE t_ExpD.ProdID = r_Prods.ProdID AND m.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_ExpD.SecID = r.SecID AND t_ExpD.ProdID = r.ProdID AND t_ExpD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID, 
       ISNULL(SUM(t_ExpD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), deleted m
     WHERE t_ExpD.ProdID = r_Prods.ProdID AND m.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_Exp] ON [t_Exp]
FOR INSERT AS
/* t_Exp - Расходный документ: Заголовок - INSERT TRIGGER */
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
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11015, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Расходный документ'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_Exp ^ r_Codes1 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Codes2 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Codes3 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Codes4 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Codes5 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Comps - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Currs - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Emps - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Ours - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_States - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_Exp', 0
      RETURN
    END

/* t_Exp ^ r_Stocks - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Exp', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11015001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_Exp', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_Exp] ON [t_Exp]
FOR UPDATE AS
/* t_Exp - Расходный документ: Заголовок - UPDATE TRIGGER */
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
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11015, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Расходный документ).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11015, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
  DECLARE @StateCodePosID int
  SELECT @StateCodePosID = colid FROM syscolumns WHERE id = object_id('t_Exp') AND name = 'StateCode'
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
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11015, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Расходный документ'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Exp ^ r_Codes1 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Codes2 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Codes3 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Codes4 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Codes5 - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Comps - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Currs - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Emps - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Ours - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_States - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ r_Stocks - Проверка в PARENT */
/* Расходный документ: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_Exp', 1
        RETURN
      END

/* t_Exp ^ t_ExpD - Обновление CHILD */
/* Расходный документ: Заголовок ^ Расходный документ: Товар - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_ExpD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExpD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Расходный документ: Заголовок'' => ''Расходный документ: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exp ^ t_ExpRoutes - Обновление CHILD */
/* Расходный документ: Заголовок ^ Расходный документ: Маршрут - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_ExpRoutes a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExpRoutes a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Расходный документ: Заголовок'' => ''Расходный документ: Маршрут''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exp ^ t_ExpSpends - Обновление CHILD */
/* Расходный документ: Заголовок ^ Расходный документ: Затраты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_ExpSpends a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExpSpends a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Расходный документ: Заголовок'' => ''Расходный документ: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exp ^ z_DocLinks - Обновление CHILD */
/* Расходный документ: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 11015, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 11015 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11015 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Расходный документ: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exp ^ z_DocLinks - Обновление CHILD */
/* Расходный документ: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 11015, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 11015 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 11015 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Расходный документ: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exp ^ z_DocShed - Обновление CHILD */
/* Расходный документ: Заголовок ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11015, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11015 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11015 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Расходный документ: Заголовок'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11015 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11015 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(DocID) OR UPDATE(IntDocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(CompID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(Discount) OR UPDATE(PayDelay) OR UPDATE(EmpID) OR UPDATE(Notes) OR UPDATE(SrcDocID) OR UPDATE(SrcDocDate) OR UPDATE(LetAttor) OR UPDATE(MorePrc) OR UPDATE(CurrID) OR UPDATE(StateCode) OR UPDATE(TSumAC_nt) OR UPDATE(TTaxSumAC) OR UPDATE(TSumAC_wt)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11015001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11015001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11015001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11015001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11015001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11015001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11015001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11015001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11015001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_Exp', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_Exp] ON [t_Exp]
FOR DELETE AS
/* t_Exp - Расходный документ: Заголовок - DELETE TRIGGER */
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
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Заголовок (t_Exp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11015 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11015, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Расходный документ'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Exp ^ t_ExpD - Удаление в CHILD */
/* Расходный документ: Заголовок ^ Расходный документ: Товар - Удаление в CHILD */
  DELETE t_ExpD FROM t_ExpD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exp ^ t_ExpRoutes - Удаление в CHILD */
/* Расходный документ: Заголовок ^ Расходный документ: Маршрут - Удаление в CHILD */
  DELETE t_ExpRoutes FROM t_ExpRoutes a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exp ^ t_ExpSpends - Удаление в CHILD */
/* Расходный документ: Заголовок ^ Расходный документ: Затраты - Удаление в CHILD */
  DELETE t_ExpSpends FROM t_ExpSpends a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exp ^ z_DocLinks - Удаление в CHILD */
/* Расходный документ: Заголовок ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11015 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exp ^ z_DocLinks - Проверка в CHILD */
/* Расходный документ: Заголовок ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 11015 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 't_Exp', 'z_DocLinks', 3
      RETURN
    END

/* t_Exp ^ z_DocShed - Удаление в CHILD */
/* Расходный документ: Заголовок ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11015 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11015001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11015001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11015001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11015 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_Exp', N'Last', N'DELETE'
GO