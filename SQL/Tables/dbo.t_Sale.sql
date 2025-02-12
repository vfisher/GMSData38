CREATE TABLE [dbo].[t_Sale] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
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
  [Discount] [numeric](21, 9) NOT NULL,
  [Notes] [varchar](200) NULL,
  [CRID] [smallint] NOT NULL,
  [OperID] [int] NOT NULL,
  [CreditID] [varchar](50) NULL,
  [DocTime] [datetime] NOT NULL,
  [EmpID] [int] NOT NULL DEFAULT (0),
  [IntDocID] [varchar](50) NULL,
  [CashSumCC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [ChangeSumCC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [CurrID] [smallint] NOT NULL DEFAULT (0),
  [TSumCC_nt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Sale__TSumCC_n__397AE25A] DEFAULT (0),
  [TTaxSum] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Sale__TTaxSum__3A6F0693] DEFAULT (0),
  [TSumCC_wt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Sale__TSumCC_w__3B632ACC] DEFAULT (0),
  [StateCode] [int] NOT NULL DEFAULT (0),
  [DeskCode] [int] NOT NULL DEFAULT (0),
  [Visitors] [int] NULL DEFAULT (0),
  [TPurSumCC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TPurTaxSum] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TPurSumCC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [DocCreateTime] [datetime] NULL CONSTRAINT [DF__t_Sale__DocCreat__66AFDD89] DEFAULT (getdate()),
  [TRealSum] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TLevySum] [numeric](21, 9) NOT NULL DEFAULT (0),
  [WPID] [int] NOT NULL DEFAULT (0),
  [DCardChID] [bigint] NOT NULL CONSTRAINT [DF__t_Sale__DCardChI__199B5009] DEFAULT (0),
  [ExtraInfo] [varchar](8000) NULL,
  [GUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
  [ChequeTypeID] [int] NOT NULL DEFAULT (1),
  CONSTRAINT [pk_t_Sale] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_Sale] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_Sale] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_Sale] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_Sale] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_Sale] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CompID]
  ON [dbo].[t_Sale] ([CompID])
  ON [PRIMARY]
GO

CREATE INDEX [CRID_DocTime]
  ON [dbo].[t_Sale] ([CRID], [DocTime])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[t_Sale] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[t_Sale] ([DocID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [GUID]
  ON [dbo].[t_Sale] ([GUID])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[t_Sale] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_Sale] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [r_CRMOt_Sale]
  ON [dbo].[t_Sale] ([CRID], [OperID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_Sale] ([StockID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_Sale] ([OurID], [DocID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.DocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CompID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.Discount'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.CRID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Sale.OperID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_Sale] ON [t_Sale]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 58 - Текущие остатки товара */
/* t_Sale - Продажа товара оператором: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), inserted m
  WHERE t_SaleD.ProdID = r_Prods.ProdID AND m.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_SaleD.SecID = r.SecID AND t_SaleD.ProdID = r.ProdID AND t_SaleD.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), deleted m
  WHERE t_SaleD.ProdID = r_Prods.ProdID AND m.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_SaleD.SecID = r.SecID AND t_SaleD.ProdID = r.ProdID AND t_SaleD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID, 
       ISNULL(SUM(t_SaleD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), deleted m
     WHERE t_SaleD.ProdID = r_Prods.ProdID AND m.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID, 
       ISNULL(SUM(t_SaleD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), inserted m
     WHERE t_SaleD.ProdID = r_Prods.ProdID AND m.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_Sale] ON [t_Sale]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 58 - Текущие остатки товара */
/* t_Sale - Продажа товара оператором: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), deleted m
  WHERE t_SaleD.ProdID = r_Prods.ProdID AND m.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_SaleD.SecID = r.SecID AND t_SaleD.ProdID = r.ProdID AND t_SaleD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID, 
       ISNULL(SUM(t_SaleD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), deleted m
     WHERE t_SaleD.ProdID = r_Prods.ProdID AND m.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel2_Upd_t_Sale] ON [t_Sale]
FOR UPDATE AS
/* t_Sale - Продажа товара оператором: Заголовок - UPDATE TRIGGER */
BEGIN
  SET NOCOUNT ON

  /* t_Sale ^ t_Booking - Проверка в PARENT */
  /* Временные данные продаж: Заголовок ^ Заявки - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS(SELECT TOP 1 1 FROM t_Booking a, deleted d WHERE a.DocCode = 11035 AND a.DocChID = d.ChID)
      EXEC z_RelationError 't_Sale', 't_Booking', 2

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel3_Del_t_Sale] ON [t_Sale]
FOR DELETE AS
/* t_Sale - Продажа товара оператором: Заголовок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON
  /* t_Sale ^ t_Booking - Удаление в CHILD */
  /* Продажа товара оператором: Заголовок ^ Документы - Заявки - Удаление в CHILD */
  DELETE t_Booking FROM t_Booking a, deleted d WHERE a.DocCode = 11035 AND a.DocChID = d.ChID
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_Sale] ON [t_Sale]
FOR INSERT AS
/* t_Sale - Продажа товара оператором: Заголовок - INSERT TRIGGER */
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
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11035, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Продажа товара оператором'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_Sale ^ r_Codes1 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Codes2 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Codes3 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Codes4 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Codes5 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Comps - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Currs - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Desks - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник ресторана: столики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DeskCode NOT IN (SELECT DeskCode FROM r_Desks))
    BEGIN
      EXEC z_RelationError 'r_Desks', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Emps - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_OperCRs - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_OperCRs', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Ours - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_States - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_Sale', 0
      RETURN
    END

/* t_Sale ^ r_Stocks - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Sale', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11035001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_Sale', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_Sale] ON [t_Sale]
FOR UPDATE AS
/* t_Sale - Продажа товара оператором: Заголовок - UPDATE TRIGGER */
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
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11035, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Продажа товара оператором).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11035, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
  DECLARE @StateCodePosID int
  SELECT @StateCodePosID = colid FROM syscolumns WHERE id = object_id('t_Sale') AND name = 'StateCode'
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
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Продажа товара оператором'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Sale ^ r_Codes1 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Codes2 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Codes3 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Codes4 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Codes5 - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Comps - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Currs - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Desks - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник ресторана: столики - Проверка в PARENT */
  IF UPDATE(DeskCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DeskCode NOT IN (SELECT DeskCode FROM r_Desks))
      BEGIN
        EXEC z_RelationError 'r_Desks', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Emps - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_OperCRs - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник ЭККА - Операторы ЭККА - Проверка в PARENT */
  IF UPDATE(CRID) OR UPDATE(OperID)
    IF (SELECT COUNT(*) FROM r_OperCRs m WITH(NOLOCK), inserted i WHERE i.CRID = m.CRID AND i.OperID = m.OperID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_OperCRs', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Ours - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_States - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ r_Stocks - Проверка в PARENT */
/* Продажа товара оператором: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_Sale', 1
        RETURN
      END

/* t_Sale ^ t_CashBack - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Выдача наличных держателям ЭПС - Обновление CHILD */
  IF UPDATE(DocID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SaleSrcDocID = i.DocID
          FROM t_CashBack a, inserted i, deleted d WHERE a.SaleSrcDocID = d.DocID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CashBack a, deleted d WHERE a.SaleSrcDocID = d.DocID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Выдача наличных держателям ЭПС''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ t_CashRegInetCheques - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Чеки электронного РРО - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11035, a.ChID = i.ChID
          FROM t_CashRegInetCheques a, inserted i, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_CashRegInetCheques a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Чеки электронного РРО''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ t_SaleC - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Продажа товара оператором: Отмены продаж - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SaleC a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleC a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Продажа товара оператором: Отмены продаж''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ t_SaleD - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Продажа товара оператором: Продажи товара - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SaleD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Продажа товара оператором: Продажи товара''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ t_SalePays - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Продажа товара оператором: Оплата - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SalePays a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SalePays a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Продажа товара оператором: Оплата''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ z_DocDC - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Дисконтные карты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11035, a.ChID = i.ChID
          FROM z_DocDC a, inserted i, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocDC a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Документы - Дисконтные карты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ z_DocLinks - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 11035, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 11035 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11035 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ z_DocLinks - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 11035, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 11035 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 11035 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ z_DocShed - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11035, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ z_LogDiscExpP - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Регистрация действий - Скидки - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11035, a.ChID = i.ChID
          FROM z_LogDiscExpP a, inserted i, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExpP a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Регистрация действий - Скидки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Sale ^ z_LogProcessings - Обновление CHILD */
/* Продажа товара оператором: Заголовок ^ Регистрация действий – Процессинг - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11035, a.ChID = i.ChID
          FROM z_LogProcessings a, inserted i, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_LogProcessings a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Продажа товара оператором: Заголовок'' => ''Регистрация действий – Процессинг''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11035 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11035 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */

  IF NOT(UPDATE(DocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(CompID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(Discount) OR UPDATE(Notes) OR UPDATE(CRID) OR UPDATE(OperID) OR UPDATE(CreditID) OR UPDATE(DocTime) OR UPDATE(EmpID) OR UPDATE(IntDocID) OR UPDATE(CashSumCC) OR UPDATE(ChangeSumCC) OR UPDATE(CurrID) OR UPDATE(StateCode) OR UPDATE(DeskCode) OR UPDATE(Visitors) OR UPDATE(DocCreateTime) OR UPDATE(WPID) OR UPDATE(DCardChID) OR UPDATE(ExtraInfo) OR UPDATE(GUID) OR UPDATE(ChequeTypeID)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11035001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11035001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11035001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11035001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11035001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11035001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11035001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11035001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11035001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_Sale', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_Sale] ON [t_Sale]
FOR DELETE AS
/* t_Sale - Продажа товара оператором: Заголовок - DELETE TRIGGER */
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
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Продажа товара оператором: Заголовок (t_Sale):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11035 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Продажа товара оператором'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Sale ^ t_CashBack - Проверка в CHILD */
/* Продажа товара оператором: Заголовок ^ Выдача наличных держателям ЭПС - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_CashBack a WITH(NOLOCK), deleted d WHERE a.SaleSrcDocID = d.DocID)
    BEGIN
      EXEC z_RelationError 't_Sale', 't_CashBack', 3
      RETURN
    END

/* t_Sale ^ t_CashRegInetCheques - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Чеки электронного РРО - Удаление в CHILD */
  DELETE t_CashRegInetCheques FROM t_CashRegInetCheques a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ t_SaleC - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Продажа товара оператором: Отмены продаж - Удаление в CHILD */
  DELETE t_SaleC FROM t_SaleC a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ t_SaleD - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Продажа товара оператором: Продажи товара - Удаление в CHILD */
  DELETE t_SaleD FROM t_SaleD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ t_SalePays - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Продажа товара оператором: Оплата - Удаление в CHILD */
  DELETE t_SalePays FROM t_SalePays a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ z_DocDC - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Дисконтные карты - Удаление в CHILD */
  DELETE z_DocDC FROM z_DocDC a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ z_DocLinks - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11035 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ z_DocLinks - Проверка в CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 11035 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 't_Sale', 'z_DocLinks', 3
      RETURN
    END

/* t_Sale ^ z_DocShed - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ z_LogDiscExpP - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Регистрация действий - Скидки - Удаление в CHILD */
  DELETE z_LogDiscExpP FROM z_LogDiscExpP a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Sale ^ z_LogProcessings - Удаление в CHILD */
/* Продажа товара оператором: Заголовок ^ Регистрация действий – Процессинг - Удаление в CHILD */
  DELETE z_LogProcessings FROM z_LogProcessings a, deleted d WHERE a.DocCode = 11035 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11035001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11035001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11035001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11035 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_Sale', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[t_Sale]
  ADD CONSTRAINT [FK_t_Sale_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO