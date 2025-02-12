CREATE TABLE [dbo].[b_PCost] (
  [ChID] [bigint] NOT NULL,
  [DocID] [bigint] NOT NULL,
  [IntDocID] [varchar](50) NULL,
  [DocDate] [smalldatetime] NOT NULL,
  [OurID] [int] NOT NULL,
  [CompID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [KursAC] [numeric](21, 9) NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [KursCC] [numeric](21, 9) NOT NULL,
  [EmpID] [int] NOT NULL,
  [Notes] [varchar](200) NULL,
  [StateCode] [int] NOT NULL,
  [TNewSumCC_nt] [numeric](21, 9) NOT NULL,
  [TNewSumCC_wt] [numeric](21, 9) NOT NULL,
  [TNewTaxSum] [numeric](21, 9) NOT NULL,
  [GPosID] [int] NOT NULL,
  [GTAccID] [int] NOT NULL,
  [GTSum_wt] [numeric](21, 9) NOT NULL,
  [GTTaxSum] [numeric](21, 9) NOT NULL,
  [GTCorrSum_wt] [numeric](21, 9) NOT NULL,
  [GTCorrTaxSum] [numeric](21, 9) NOT NULL,
  [GTAdvAccID] [int] NOT NULL,
  [GTAdvSum_wt] [numeric](21, 9) NOT NULL,
  [GTCorrAdvSum_wt] [numeric](21, 9) NOT NULL,
  [GTAdvTaxSum] [numeric](21, 9) NOT NULL,
  [GTCorrAdvTaxSum] [numeric](21, 9) NOT NULL,
  [TExpCostCC] [numeric](21, 9) NOT NULL,
  [TExpPosProdCostCC] [numeric](21, 9) NOT NULL,
  [TExpPosCostCC] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_b_PCost] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PCost] ON [b_PCost]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 189 - Текущие остатки товара - Приход */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
  WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PCostD.NewPPID = r.PPID AND b_PCostD.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
  WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PCostD.NewPPID = r.PPID AND b_PCostD.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID, 
       ISNULL(SUM(b_PCostD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID, 
       ISNULL(SUM(b_PCostD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 191 - Текущие остатки товара - Расход */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(OurID) OR UPDATE(StockID)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
  WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PCostD.PPID = r.PPID AND b_PCostD.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
  WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PCostD.PPID = r.PPID AND b_PCostD.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID, 
       ISNULL(SUM(b_PCostD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0)
     GROUP BY m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID, 
       ISNULL(SUM(b_PCostD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0)
     GROUP BY m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PCost] ON [b_PCost]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 189 - Текущие остатки товара - Приход */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
  WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PCostD.NewPPID = r.PPID AND b_PCostD.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID, 
       ISNULL(SUM(b_PCostD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, b_PCostD.NewPPID, b_PCostD.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 191 - Текущие остатки товара - Расход */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
  WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND b_PCostD.PPID = r.PPID AND b_PCostD.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID, 
       ISNULL(SUM(b_PCostD.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND m.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0)
     GROUP BY m.OurID, m.StockID, b_PCostD.PPID, b_PCostD.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PCost] ON [b_PCost]
FOR INSERT AS
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) - INSERT TRIGGER */
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
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCost ^ r_Codes1 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Codes2 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Codes3 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Codes4 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Codes5 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Comps - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
    BEGIN
      EXEC z_RelationError 'r_Comps', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Currs - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Emps - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_States - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
    BEGIN
      EXEC z_RelationError 'r_States', 'b_PCost', 0
      RETURN
    END

/* b_PCost ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_PCost', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PCost', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PCost] ON [b_PCost]
FOR UPDATE AS
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) - UPDATE TRIGGER */
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
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* b_PCost ^ r_Codes1 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Codes2 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Codes3 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Codes4 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Codes5 - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Comps - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник предприятий - Проверка в PARENT */
  IF UPDATE(CompID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CompID NOT IN (SELECT CompID FROM r_Comps))
      BEGIN
        EXEC z_RelationError 'r_Comps', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Currs - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Emps - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_States - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник статусов - Проверка в PARENT */
  IF UPDATE(StateCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StateCode NOT IN (SELECT StateCode FROM r_States))
      BEGIN
        EXEC z_RelationError 'r_States', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_PCost', 1
        RETURN
      END

/* b_PCost ^ b_PCostD - Обновление CHILD */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ ТМЦ: Формирование себестоимости (ТМЦ) - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM b_PCostD a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostD a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Формирование себестоимости (Заголовок)'' => ''ТМЦ: Формирование себестоимости (ТМЦ)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PCost ^ b_PCostDExp - Обновление CHILD */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ ТМЦ: Формирование себестоимости (Прочие расходы) - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID
          FROM b_PCostDExp a, inserted i, deleted d WHERE a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostDExp a, deleted d WHERE a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Формирование себестоимости (Заголовок)'' => ''ТМЦ: Формирование себестоимости (Прочие расходы)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 14125 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 14125 AND l.ParentChID = i.ChID
  END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PCost', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PCost] ON [b_PCost]
FOR DELETE AS
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) - DELETE TRIGGER */
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
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Заголовок) (b_PCost):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCost ^ b_PCostD - Удаление в CHILD */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ ТМЦ: Формирование себестоимости (ТМЦ) - Удаление в CHILD */
  DELETE b_PCostD FROM b_PCostD a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* b_PCost ^ b_PCostDExp - Удаление в CHILD */
/* ТМЦ: Формирование себестоимости (Заголовок) ^ ТМЦ: Формирование себестоимости (Прочие расходы) - Удаление в CHILD */
  DELETE b_PCostDExp FROM b_PCostDExp a, deleted d WHERE a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 14125 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PCost', N'Last', N'DELETE'
GO