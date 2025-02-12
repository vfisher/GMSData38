CREATE TABLE [dbo].[t_zInP] (
  [ChID] [bigint] NOT NULL,
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [SecID] [int] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [KursMC] [numeric](21, 9) NOT NULL,
  [CodeID1] [smallint] NOT NULL,
  [CodeID2] [smallint] NOT NULL,
  [CodeID3] [smallint] NOT NULL,
  [CodeID4] [smallint] NOT NULL,
  [CodeID5] [smallint] NOT NULL,
  [Notes] [varchar](200) NULL,
  [DocID] [bigint] NOT NULL,
  [DocDate] [smalldatetime] NOT NULL,
  CONSTRAINT [pk_t_zInP] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CodeID1]
  ON [dbo].[t_zInP] ([CodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID2]
  ON [dbo].[t_zInP] ([CodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID3]
  ON [dbo].[t_zInP] ([CodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID4]
  ON [dbo].[t_zInP] ([CodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CodeID5]
  ON [dbo].[t_zInP] ([CodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [KursMC]
  ON [dbo].[t_zInP] ([KursMC])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[t_zInP] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_zInP] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_zInP] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [Qty]
  ON [dbo].[t_zInP] ([Qty])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_zInP] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[t_zInP] ([StockID])
  ON [PRIMARY]
GO

CREATE INDEX [SumCC_nt]
  ON [dbo].[t_zInP] ([SumCC_nt])
  ON [PRIMARY]
GO

CREATE INDEX [SumCC_wt]
  ON [dbo].[t_zInP] ([SumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInPt_zInP]
  ON [dbo].[t_zInP] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [TaxSum]
  ON [dbo].[t_zInP] ([TaxSum])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_zInP] ([OurID], [StockID], [SecID], [ProdID], [PPID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.KursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.CodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.CodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.CodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.CodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_zInP.CodeID5'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_zInP] ON [t_zInP]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 103 - Текущие остатки товара */
/* t_zInP - Входящие остатки товара */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_zInP] ON [t_zInP]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 103 - Текущие остатки товара */
/* t_zInP - Входящие остатки товара */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), inserted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), inserted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_zInP] ON [t_zInP]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 103 - Текущие остатки товара */
/* t_zInP - Входящие остатки товара */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), deleted m
  WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE m.OurID = r.OurID AND m.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), deleted m
     WHERE t_PInP.ProdID = r_Prods.ProdID AND m.ProdID = t_PInP.ProdID AND m.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
     GROUP BY m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_zInP] ON [t_zInP]
FOR INSERT AS
/* t_zInP - Входящие остатки товара - INSERT TRIGGER */
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
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_zInP ^ r_Codes1 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Codes2 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Codes3 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Codes4 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Codes5 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Ours - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Secs - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ r_Stocks - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_zInP', 0
      RETURN
    END

/* t_zInP ^ t_PInP - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_zInP', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11901001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_zInP', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_zInP] ON [t_zInP]
FOR UPDATE AS
/* t_zInP - Входящие остатки товара - UPDATE TRIGGER */
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
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM inserted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* t_zInP ^ r_Codes1 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Codes2 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Codes3 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Codes4 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Codes5 - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Ours - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Secs - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ r_Stocks - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ t_PInP - Проверка в PARENT */
/* Входящие остатки товара ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_zInP', 1
        RETURN
      END

/* t_zInP ^ z_DocShed - Обновление CHILD */
/* Входящие остатки товара ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11901, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11901 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11901 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Входящие остатки товара'' => ''Документы - Процессы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Обновления информации о документе в связях */
IF UPDATE(DocDate) OR UPDATE(DocID)
  BEGIN
    UPDATE l SET l.ChildDocID = i.DocID, l.ChildDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ChildDocCode = 11901 AND l.ChildChID = i.ChID

    UPDATE l SET l.ParentDocID = i.DocID, l.ParentDocDate = i.DocDate
    FROM z_DocLinks l, inserted i WHERE l.ParentDocCode = 11901 AND l.ParentChID = i.ChID
  END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11901001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11901001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11901001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11901001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11901001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11901001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11901001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11901001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11901001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_zInP', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_zInP] ON [t_zInP]
FOR DELETE AS
/* t_zInP - Входящие остатки товара - DELETE TRIGGER */
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
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM deleted a , @OpenAges AS t WHERE t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Входящие остатки товара (t_zInP):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_zInP ^ z_DocShed - Удаление в CHILD */
/* Входящие остатки товара ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11901 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11901001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11901001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11901001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11901 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_zInP', N'Last', N'DELETE'
GO