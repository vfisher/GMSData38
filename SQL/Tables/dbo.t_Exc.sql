CREATE TABLE [dbo].[t_Exc] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [NewStockID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [EmpID] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  [SrcDocID] [varchar](250) NULL,
  [SrcDocDate] [smalldatetime] NULL,
  [CompID] [int] NOT NULL DEFAULT (0),
  [Discount] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exc__Discount__0E64D075] DEFAULT (0),
  [CurrID] [smallint] NOT NULL DEFAULT (0),
  [TSumCC_nt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exc__TSumCC_nt__238BA13B] DEFAULT (0),
  [TTaxSum] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exc__TTaxSum__247FC574] DEFAULT (0),
  [TSumCC_wt] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exc__TSumCC_wt__2573E9AD] DEFAULT (0),
  [TSpendSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exc__TSpendSum__26680DE6] DEFAULT (0),
  [TRouteSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_Exc__TRouteSum__275C321F] DEFAULT (0),
  [StateCode] [int] NOT NULL DEFAULT (0),
  [TSumAC_nt] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TTaxSumAC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TSumAC_wt] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_Exc] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_Exc] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_Exc] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_Exc] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_Exc] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_Exc] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [DocDate]
  ON [dbo].[t_Exc] ([DocDate])
  ON [PRIMARY]
GO

CREATE INDEX [DocID]
  ON [dbo].[t_Exc] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[t_Exc] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [IntDocID]
  ON [dbo].[t_Exc] ([IntDocID])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[t_Exc] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [NewStockID]
  ON [dbo].[t_Exc] ([NewStockID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_Exc] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_Exc] ([StockID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_Exc] ([OurID], [DocID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.DocID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.NewStockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.CodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_Exc.EmpID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_Exc] ON [t_Exc]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 39 - Текущие остатки товара - Приход */
/* t_Exc - Перемещение товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(NewStockID)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), inserted m
  WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.NewStockID = r.StockID AND t_ExcD.NewSecID = r.SecID AND t_ExcD.ProdID = r.ProdID AND t_ExcD.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
  WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.NewStockID = r.StockID AND t_ExcD.NewSecID = r.SecID AND t_ExcD.ProdID = r.ProdID AND t_ExcD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID, 
       ISNULL(SUM(t_ExcD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), inserted m
     WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID, 
       ISNULL(SUM(t_ExcD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
     WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 40 - Текущие остатки товара - Расход */
/* t_Exc - Перемещение товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), inserted m
  WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_ExcD.SecID = r.SecID AND t_ExcD.ProdID = r.ProdID AND t_ExcD.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
  WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_ExcD.SecID = r.SecID AND t_ExcD.ProdID = r.ProdID AND t_ExcD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID, 
       ISNULL(SUM(t_ExcD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
     WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID, 
       ISNULL(SUM(t_ExcD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), inserted m
     WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_Exc] ON [t_Exc]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 39 - Текущие остатки товара - Приход */
/* t_Exc - Перемещение товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
  WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.NewStockID = r.StockID AND t_ExcD.NewSecID = r.SecID AND t_ExcD.ProdID = r.ProdID AND t_ExcD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID, 
       ISNULL(SUM(t_ExcD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
     WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID) q
  WHERE q.OurID = r.OurID AND q.NewStockID = r.StockID AND q.NewSecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 40 - Текущие остатки товара - Расход */
/* t_Exc - Перемещение товара: Заголовок */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
  WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND t_ExcD.SecID = r.SecID AND t_ExcD.ProdID = r.ProdID AND t_ExcD.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID, 
       ISNULL(SUM(t_ExcD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), deleted m
     WHERE t_ExcD.ProdID = r_Prods.ProdID AND m.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_Exc] ON [t_Exc]
FOR INSERT AS
/* t_Exc - Перемещение товара: Заголовок - INSERT TRIGGER */
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
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
  IF EXISTS(SELECT * FROM inserted i WHERE dbo.zf_IsValidDocState(11021, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Документ ''Перемещение товара'' не может иметь указанный статус.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END


/* t_Exc ^ r_Codes1 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Codes2 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Codes3 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Codes4 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Codes5 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Comps - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Currs - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Emps - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Ours - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_States - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Stocks - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Exc', 0
      RETURN
    END

/* t_Exc ^ r_Stocks - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.NewStockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_Exc', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11021001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_Exc', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_Exc] ON [t_Exc]
FOR UPDATE AS
/* t_Exc - Перемещение товара: Заголовок - UPDATE TRIGGER */
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
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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
  IF UPDATE(StateCode) AND EXISTS(SELECT * FROM inserted i, deleted d WHERE i.ChID = d.ChID AND dbo.zf_CanChangeState(11021, i.ChID, d.StateCode, i.StateCode) = 0)
    BEGIN
      RAISERROR ('Переход в указанный статус невозможен (Перемещение товара).', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  IF UPDATE(StateCode)
    BEGIN
      INSERT INTO z_LogState (StateRuleCode, DocCode, ChID, OldStateCode, NewStateCode, UserCode)
      SELECT s.StateRuleCode, 11021, i.ChID, d.StateCode, i.StateCode, dbo.zf_GetUserCode() FROM inserted i, deleted d, r_StateRules s
      WHERE i.ChID = d.ChID AND s.StateCodeFrom = d.StateCode AND s.StateCodeTo = i.StateCode
    END

/* Возможно ли редактирование документа */
  DECLARE @StateCodePosID int
  SELECT @StateCodePosID = colid FROM syscolumns WHERE id = object_id('t_Exc') AND name = 'StateCode'
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
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11021, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Перемещение товара'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Exc ^ r_Codes1 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Codes2 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Codes3 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Codes4 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Codes5 - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Comps - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Currs - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Emps - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Ours - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_States - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Stocks - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ r_Stocks - Проверка в PARENT */
/* Перемещение товара: Заголовок ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(NewStockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.NewStockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_Exc', 1
        RETURN
      END

/* t_Exc ^ t_ExcD - Обновление CHILD */
/* Перемещение товара: Заголовок ^ Перемещение товара: Товар - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_ExcD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перемещение товара: Заголовок'' => ''Перемещение товара: Товар''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exc ^ t_ExcRoutes - Обновление CHILD */
/* Перемещение товара: Заголовок ^ Перемещение товара: Маршрут - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_ExcRoutes a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcRoutes a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перемещение товара: Заголовок'' => ''Перемещение товара: Маршрут''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exc ^ t_ExcSpends - Обновление CHILD */
/* Перемещение товара: Заголовок ^ Перемещение товара: Затраты - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM t_ExcSpends a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_ExcSpends a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перемещение товара: Заголовок'' => ''Перемещение товара: Затраты''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exc ^ z_DocLinks - Обновление CHILD */
/* Перемещение товара: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChildDocCode = 11021, a.ChildChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ChildDocCode = 11021 AND a.ChildChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11021 AND a.ChildChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перемещение товара: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exc ^ z_DocLinks - Обновление CHILD */
/* Перемещение товара: Заголовок ^ Документы - Взаимосвязи - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ParentDocCode = 11021, a.ParentChID = i.ChID
          FROM z_DocLinks a, inserted i, deleted d WHERE a.ParentDocCode = 11021 AND a.ParentChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocLinks a, deleted d WHERE a.ParentDocCode = 11021 AND a.ParentChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перемещение товара: Заголовок'' => ''Документы - Взаимосвязи''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_Exc ^ z_DocShed - Обновление CHILD */
/* Перемещение товара: Заголовок ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11021, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11021 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11021 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Перемещение товара: Заголовок'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11021 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11021 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(DocID) OR UPDATE(IntDocID) OR UPDATE(DocDate) OR UPDATE(KursMC) OR UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(NewStockID) OR UPDATE(CodeID1) OR UPDATE(CodeID2) OR UPDATE(CodeID3) OR UPDATE(CodeID4) OR UPDATE(CodeID5) OR UPDATE(EmpID) OR UPDATE(Notes) OR UPDATE(SrcDocID) OR UPDATE(SrcDocDate) OR UPDATE(CompID) OR UPDATE(Discount) OR UPDATE(CurrID) OR UPDATE(StateCode) OR UPDATE(TSumAC_nt) OR UPDATE(TTaxSumAC) OR UPDATE(TSumAC_wt)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11021001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11021001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11021001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11021001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11021001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11021001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11021001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11021001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11021001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_Exc', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_Exc] ON [t_Exc]
FOR DELETE AS
/* t_Exc - Перемещение товара: Заголовок - DELETE TRIGGER */
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
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Перемещение товара: Заголовок (t_Exc):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Обработка статуса */
/* Удаление регистрации изменения статуса */
  DELETE z_LogState FROM z_LogState m, deleted i WHERE m.DocCode = 11021 AND m.ChID = i.ChID

/* Возможно ли редактирование документа */
    IF EXISTS(SELECT * FROM deleted a WHERE dbo.zf_CanChangeDoc(11021, a.ChID, a.StateCode) = 0)
      BEGIN
        RAISERROR ('Изменение документа ''Перемещение товара'' в данном статусе запрещено.', 18, 1)
        ROLLBACK TRAN
        RETURN
      END

/* t_Exc ^ t_ExcD - Удаление в CHILD */
/* Перемещение товара: Заголовок ^ Перемещение товара: Товар - Удаление в CHILD */
  DELETE t_ExcD FROM t_ExcD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exc ^ t_ExcRoutes - Удаление в CHILD */
/* Перемещение товара: Заголовок ^ Перемещение товара: Маршрут - Удаление в CHILD */
  DELETE t_ExcRoutes FROM t_ExcRoutes a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exc ^ t_ExcSpends - Удаление в CHILD */
/* Перемещение товара: Заголовок ^ Перемещение товара: Затраты - Удаление в CHILD */
  DELETE t_ExcSpends FROM t_ExcSpends a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exc ^ z_DocLinks - Удаление в CHILD */
/* Перемещение товара: Заголовок ^ Документы - Взаимосвязи - Удаление в CHILD */
  DELETE z_DocLinks FROM z_DocLinks a, deleted d WHERE a.ChildDocCode = 11021 AND a.ChildChID = d.ChID
  IF @@ERROR > 0 RETURN

/* t_Exc ^ z_DocLinks - Проверка в CHILD */
/* Перемещение товара: Заголовок ^ Документы - Взаимосвязи - Проверка в CHILD */
  IF EXISTS (SELECT * FROM z_DocLinks a WITH(NOLOCK), deleted d WHERE a.ParentDocCode = 11021 AND a.ParentChID = d.ChID)
    BEGIN
      EXEC z_RelationError 't_Exc', 'z_DocLinks', 3
      RETURN
    END

/* t_Exc ^ z_DocShed - Удаление в CHILD */
/* Перемещение товара: Заголовок ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11021 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11021001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11021001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11021001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11021 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_Exc', N'Last', N'DELETE'
GO