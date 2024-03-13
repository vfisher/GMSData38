CREATE TABLE [dbo].[b_InvD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[PriceCC_In] [numeric] (21, 9) NOT NULL,
[SumCC_In] [numeric] (21, 9) NOT NULL,
[GPosTSum_wt] [numeric] (21, 9) NOT NULL,
[GPosTTaxSum] [numeric] (21, 9) NOT NULL,
[RealPrice] [numeric] (21, 9) NOT NULL,
[RealSum] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_InvD] ON [dbo].[b_InvD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 115 - Обновление итогов в главной таблице */
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) */
/* b_Inv - ТМЦ: Расходная накладная (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In + q.TSumCC_In, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Inv WITH (NOLOCK), inserted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 148 - Текущие остатки товара */
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Inv.OurID = r.OurID AND b_Inv.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_InvD] ON [dbo].[b_InvD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 115 - Обновление итогов в главной таблице */
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) */
/* b_Inv - ТМЦ: Расходная накладная (Заголовок) */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(SumCC_In) OR UPDATE(RealSum)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In + q.TSumCC_In, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Inv WITH (NOLOCK), inserted m
     WHERE b_Inv.ChID = m.ChID
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
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Inv WITH (NOLOCK), deleted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 148 - Текущие остатки товара */
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(PPID) OR UPDATE(ProdID) OR UPDATE(Qty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Inv.OurID = r.OurID AND b_Inv.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Inv.OurID = r.OurID AND b_Inv.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_InvD] ON [dbo].[b_InvD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 115 - Обновление итогов в главной таблице */
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) */
/* b_Inv - ТМЦ: Расходная накладная (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumCC_In = r.TSumCC_In - q.TSumCC_In, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM b_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumCC_In), 0) TSumCC_In,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM b_Inv WITH (NOLOCK), deleted m
     WHERE b_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 148 - Текущие остатки товара */
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_Inv.OurID = r.OurID AND b_Inv.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_Inv WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_Inv.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_Inv.OurID, b_Inv.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_InvD] ON [dbo].[b_InvD]
FOR INSERT AS
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_Inv a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_Inv a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Inv a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Inv a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_Inv a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14111, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Расходная накладная'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_InvD ^ b_Inv - Проверка в PARENT */
/* ТМЦ: Расходная накладная (ТМЦ) ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_Inv))
    BEGIN
      EXEC z_RelationError 'b_Inv', 'b_InvD', 0
      RETURN
    END

/* b_InvD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Расходная накладная (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_InvD', 0
      RETURN
    END

/* b_InvD ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Расходная накладная (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_InvD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14111002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_InvD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_InvD] ON [dbo].[b_InvD]
FOR UPDATE AS
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_Inv a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_Inv a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Inv a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Inv a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Inv a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Inv a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_Inv a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14111, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Расходная накладная'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_InvD ^ b_Inv - Проверка в PARENT */
/* ТМЦ: Расходная накладная (ТМЦ) ^ ТМЦ: Расходная накладная (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_Inv))
      BEGIN
        EXEC z_RelationError 'b_Inv', 'b_InvD', 1
        RETURN
      END

/* b_InvD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Расходная накладная (ТМЦ) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PInP', 'b_InvD', 1
        RETURN
      END

/* b_InvD ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Расходная накладная (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_InvD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* b_InvD ^ b_InvDLV - Обновление CHILD */
/* ТМЦ: Расходная накладная (ТМЦ) ^ ТМЦ: Расходная накладная (Сборы по товару) - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM b_InvDLV a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE b_InvDLV SET b_InvDLV.ChID = @NewChID FROM b_InvDLV, deleted d WHERE b_InvDLV.ChID = @OldChID AND b_InvDLV.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE b_InvDLV SET b_InvDLV.SrcPosID = @NewSrcPosID FROM b_InvDLV, deleted d WHERE b_InvDLV.SrcPosID = @OldSrcPosID AND b_InvDLV.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM b_InvDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Расходная накладная (ТМЦ)'' => ''ТМЦ: Расходная накладная (Сборы по товару)''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14111002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14111002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14111002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14111002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14111002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14111002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14111002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14111002, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14111002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14111002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14111002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14111002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14111002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14111002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14111002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_InvD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_InvD] ON [dbo].[b_InvD]
FOR DELETE AS
/* b_InvD - ТМЦ: Расходная накладная (ТМЦ) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_Inv a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_Inv a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_Inv a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_Inv a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Расходная накладная (ТМЦ) (b_InvD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_Inv a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14111, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''ТМЦ: Расходная накладная'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_InvD ^ b_InvDLV - Удаление в CHILD */
/* ТМЦ: Расходная накладная (ТМЦ) ^ ТМЦ: Расходная накладная (Сборы по товару) - Удаление в CHILD */
  DELETE b_InvDLV FROM b_InvDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14111002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14111002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14111002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_InvD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_InvD] ADD CONSTRAINT [_pk_b_InvD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_InvD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_InvD] ([ChID], [Qty], [SumCC_In], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_InvD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[b_InvD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_InvD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_InvD] ON [dbo].[b_InvD] ([ProdID], [PPID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PriceCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SumCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GPosTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GPosTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[PriceCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[SumCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GPosTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_InvD].[GPosTTaxSum]'
GO
