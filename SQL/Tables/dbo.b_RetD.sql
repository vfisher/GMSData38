CREATE TABLE [dbo].[b_RetD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [UM] [varchar](50) NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [PriceCC_In] [numeric](21, 9) NOT NULL,
  [SumCC_In] [numeric](21, 9) NOT NULL,
  [GPosTSum_wt] [numeric](21, 9) NOT NULL,
  [GPosTTaxSum] [numeric](21, 9) NOT NULL,
  [RealPrice] [numeric](21, 9) NOT NULL,
  [RealSum] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_b_RetD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [b_PInPb_RetD]
  ON [dbo].[b_RetD] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_RetD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_RetD] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[b_RetD] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[b_RetD] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[b_RetD] ([ChID], [Qty], [SumCC_In], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.PriceCC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.SumCC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.GPosTSum_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RetD.GPosTTaxSum'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_RetD] ON [b_RetD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 125 - Обновление итогов в главной таблице */
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) */
/* b_Ret - ТМЦ: Возврат от получателя (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In + q.TSumCC_In, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM b_Ret r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Ret WITH (NOLOCK), inserted m
     WHERE b_Ret.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 162 - Текущие остатки товара */
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Ret.OurID = r.OurID AND b_Ret.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_RetD] ON [b_RetD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 125 - Обновление итогов в главной таблице */
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) */
/* b_Ret - ТМЦ: Возврат от получателя (Заголовок) */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(SumCC_In) OR UPDATE(RealSum)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In + q.TSumCC_In, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM b_Ret r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Ret WITH (NOLOCK), inserted m
     WHERE b_Ret.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In - q.TSumCC_In, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM b_Ret r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Ret WITH (NOLOCK), deleted m
     WHERE b_Ret.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 162 - Текущие остатки товара */
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(PPID) OR UPDATE(ProdID) OR UPDATE(Qty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Ret.OurID = r.OurID AND b_Ret.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Ret.OurID = r.OurID AND b_Ret.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_RetD] ON [b_RetD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 125 - Обновление итогов в главной таблице */
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) */
/* b_Ret - ТМЦ: Возврат от получателя (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In - q.TSumCC_In, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM b_Ret r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Ret WITH (NOLOCK), deleted m
     WHERE b_Ret.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 162 - Текущие остатки товара */
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Ret.OurID = r.OurID AND b_Ret.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Ret WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Ret.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Ret.OurID, b_Ret.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_RetD] ON [b_RetD]
FOR INSERT AS
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_Ret a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_Ret a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Ret a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Ret a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_Ret a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14103, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Возврат от получателя'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_RetD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_RetD', 0
      RETURN
    END

/* b_RetD ^ b_Ret - Проверка в PARENT */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_Ret))
    BEGIN
      EXEC z_RelationError 'b_Ret', 'b_RetD', 0
      RETURN
    END

/* b_RetD ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_RetD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14103002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_RetD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_RetD] ON [b_RetD]
FOR UPDATE AS
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_Ret a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_Ret a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Ret a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Ret a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Ret a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Ret a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_Ret a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14103, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Возврат от получателя'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_RetD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PInP', 'b_RetD', 1
        RETURN
      END

/* b_RetD ^ b_Ret - Проверка в PARENT */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ ТМЦ: Возврат от получателя (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_Ret))
      BEGIN
        EXEC z_RelationError 'b_Ret', 'b_RetD', 1
        RETURN
      END

/* b_RetD ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_RetD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* b_RetD ^ b_RetDLV - Обновление CHILD */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ ТМЦ: Возврат от получателя (Сборы по товару) - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM b_RetDLV a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE b_RetDLV SET b_RetDLV.ChID = @NewChID FROM b_RetDLV, deleted d WHERE b_RetDLV.ChID = @OldChID AND b_RetDLV.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE b_RetDLV SET b_RetDLV.SrcPosID = @NewSrcPosID FROM b_RetDLV, deleted d WHERE b_RetDLV.SrcPosID = @OldSrcPosID AND b_RetDLV.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM b_RetDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Возврат от получателя (ТМЦ)'' => ''ТМЦ: Возврат от получателя (Сборы по товару)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14103002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14103002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14103002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14103002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14103002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14103002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14103002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14103002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14103002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14103002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14103002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14103002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14103002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14103002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14103002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_RetD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_RetD] ON [b_RetD]
FOR DELETE AS
/* b_RetD - ТМЦ: Возврат от получателя (ТМЦ) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_Ret a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_Ret a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Ret a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Ret a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Возврат от получателя (ТМЦ) (b_RetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_Ret a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14103, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Возврат от получателя'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_RetD ^ b_RetDLV - Удаление в CHILD */
/* ТМЦ: Возврат от получателя (ТМЦ) ^ ТМЦ: Возврат от получателя (Сборы по товару) - Удаление в CHILD */
  DELETE b_RetDLV FROM b_RetDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14103002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14103002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14103002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_RetD', N'Last', N'DELETE'
GO