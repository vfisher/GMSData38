CREATE TABLE [dbo].[t_SRec]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[SubDocDate] [smalldatetime] NOT NULL,
[SubStockID] [int] NOT NULL,
[Value1] [numeric] (21, 9) NULL,
[Value2] [numeric] (21, 9) NULL,
[Value3] [numeric] (21, 9) NULL,
[CurrID] [smallint] NOT NULL DEFAULT (0),
[TCostSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TCostSum__7E251262] DEFAULT (0),
[TSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSumCC_n__7F19369B] DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TTaxSum__000D5AD4] DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSumCC_w__01017F0D] DEFAULT (0),
[TNewSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TNewSumC__01F5A346] DEFAULT (0),
[TNewTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TNewTaxS__02E9C77F] DEFAULT (0),
[TNewSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TNewSumC__03DDEBB8] DEFAULT (0),
[TSubSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubSumC__04D20FF1] DEFAULT (0),
[TSubTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubTaxS__05C6342A] DEFAULT (0),
[TSubSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubSumC__06BA5863] DEFAULT (0),
[TSubNewSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubNewS__07AE7C9C] DEFAULT (0),
[TSubNewTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubNewT__08A2A0D5] DEFAULT (0),
[TSubNewSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubNewS__0996C50E] DEFAULT (0),
[TSetSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSetSumC__0A8AE947] DEFAULT (0),
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SRec] ON [dbo].[t_SRec]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 87 - Текущие остатки товара: Комплекты */
/* t_SRec - Комплектация товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
  WHERE t_SRecA.ProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_SRecA.SecID = r.SecID AND t_SRecA.ProdID = r.ProdID AND t_SRecA.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
  WHERE t_SRecA.ProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_SRecA.SecID = r.SecID AND t_SRecA.ProdID = r.ProdID AND t_SRecA.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID, 
       ISNULL(SUM(t_SRecA.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), inserted m
     WHERE t_SRecA.ProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID, 
       ISNULL(SUM(t_SRecA.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
     WHERE t_SRecA.ProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 88 - Текущие остатки товара: Составляющие */
/* t_SRec - Комплектация товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(SubStockID)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), inserted m
  WHERE t_SRecD.SubProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.SubStockID = r.StockID AND t_SRecD.SubSecID = r.SecID AND t_SRecD.SubProdID = r.ProdID AND t_SRecD.SubPPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), deleted m
  WHERE t_SRecD.SubProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.SubStockID = r.StockID AND t_SRecD.SubSecID = r.SecID AND t_SRecD.SubProdID = r.ProdID AND t_SRecD.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID, 
       ISNULL(SUM(t_SRecD.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), deleted m
     WHERE t_SRecD.SubProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID, 
       ISNULL(SUM(t_SRecD.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), inserted m
     WHERE t_SRecD.SubProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SRec] ON [dbo].[t_SRec]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 87 - Текущие остатки товара: Комплекты */
/* t_SRec - Комплектация товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
  WHERE t_SRecA.ProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_SRecA.SecID = r.SecID AND t_SRecA.ProdID = r.ProdID AND t_SRecA.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID, 
       ISNULL(SUM(t_SRecA.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), deleted m
     WHERE t_SRecA.ProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 88 - Текущие остатки товара: Составляющие */
/* t_SRec - Комплектация товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), deleted m
  WHERE t_SRecD.SubProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.SubStockID = r.StockID AND t_SRecD.SubSecID = r.SecID AND t_SRecD.SubProdID = r.ProdID AND t_SRecD.SubPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID, 
       ISNULL(SUM(t_SRecD.SubQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), deleted m
     WHERE t_SRecD.SubProdID = r_Prods.ProdID AND m.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID) q
  WHERE q.OurID = r.OurID AND q.SubStockID = r.StockID AND q.SubSecID = r.SecID AND q.SubProdID = r.ProdID AND q.SubPPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SRec] ON [dbo].[t_SRec]
FOR INSERT AS
/* t_SRec - Комплектация товара: Заголовок - INSERT TRIGGER */
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
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11321, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Комплектация товара'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_SRec ^ r_Codes1 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Codes2 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Codes3 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Codes4 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Codes5 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Currs - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Emps - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Ours - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_States - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Stocks - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SRec', 0
      RETURN
    END

/* t_SRec ^ r_Stocks - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubStockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_SRec', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11321001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_SRec]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SRec] ON [dbo].[t_SRec]
FOR UPDATE AS
/* t_SRec - Комплектация товара: Заголовок - UPDATE TRIGGER */
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
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11321, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Комплектация товара).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11321, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
DECLARE @ColumnsUpdated VARBINARY(255)
SET @ColumnsUpdated = COLUMNS_UPDATED()
IF EXISTS(SELECT 1 FROM dbo.zf_GetFieldsUpdated('t_SRec', @ColumnsUpdated) WHERE [name] <> 'StateCode')
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11321, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Комплектация товара'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_SRec ^ r_Codes1 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Codes2 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Codes3 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Codes4 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Codes5 - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Currs - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Emps - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Ours - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_States - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Stocks - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ r_Stocks - Проверка в PARENT */
/* Комплектация товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(SubStockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubStockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_SRec', 1
        RETURN
      END

/* t_SRec ^ t_SRecA - Обновление CHILD */
/* Комплектация товара: Заголовок ^ Комплектация товара: Комплекты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SRecA a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecA a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Комплектация товара: Заголовок'' => ''Комплектация товара: Комплекты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SRec ^ t_SRecM - Обновление CHILD */
/* Комплектация товара: Заголовок ^ Комплектация товара: Общие Затраты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_SRecM a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SRecM a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Комплектация товара: Заголовок'' => ''Комплектация товара: Общие Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SRec ^ z_DocLinks - Обновление CHILD */
/* Комплектация товара: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 11321, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 11321 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11321 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Комплектация товара: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SRec ^ z_DocLinks - Обновление CHILD */
/* Комплектация товара: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 11321, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 11321 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 11321 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Комплектация товара: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SRec ^ z_DocShed - Обновление CHILD */
/* Комплектация товара: Заголовок ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11321, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11321 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11321 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Комплектация товара: Заголовок'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11321 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11321 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(DocID) OR UPDATE(IntDocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(EmpID) OR UPDATE(Notes) OR UPDATE(SubDocDate) OR UPDATE(SubStockID) OR UPDATE(Value1) OR UPDATE(Value2) OR UPDATE(Value3) OR UPDATE(CurrID) OR UPDATE(StateCode)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11321001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11321001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11321001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11321001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11321001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11321001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11321001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11321001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11321001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_SRec]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SRec] ON [dbo].[t_SRec]
FOR DELETE AS
/* t_SRec - Комплектация товара: Заголовок - DELETE TRIGGER */
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
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Комплектация товара: Заголовок (t_SRec):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11321 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11321, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Комплектация товара'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_SRec ^ t_SRecA - Удаление в CHILD */
/* Комплектация товара: Заголовок ^ Комплектация товара: Комплекты - Удаление в CHILD */
  DELETE t_SRecA FROM t_SRecA a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SRec ^ t_SRecM - Удаление в CHILD */
/* Комплектация товара: Заголовок ^ Комплектация товара: Общие Затраты - Удаление в CHILD */
  DELETE t_SRecM FROM t_SRecM a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SRec ^ z_DocLinks - Удаление в CHILD */
/* Комплектация товара: Заголовок ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11321 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_SRec ^ z_DocLinks - Проверка в CHILD */
/* Комплектация товара: Заголовок ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 11321 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 't_SRec', 'z_DocLinks', 3
      RETURN
    END

/* t_SRec ^ z_DocShed - Удаление в CHILD */
/* Комплектация товара: Заголовок ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11321 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11321001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11321001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11321001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11321 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_SRec]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_SRec] ADD CONSTRAINT [pk_t_SRec] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_SRec] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_SRec] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_SRec] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_SRec] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_SRec] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_SRec] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_SRec] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_SRec] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[t_SRec] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[t_SRec] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_SRec] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_SRec] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_SRec] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubDocDate] ON [dbo].[t_SRec] ([SubDocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubStockID] ON [dbo].[t_SRec] ([SubStockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[SubStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[SubStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value3]'
GO
