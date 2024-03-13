CREATE TABLE [dbo].[t_EstD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[NewPPID] [int] NOT NULL,
[NewPriceCC_nt] [numeric] (21, 9) NOT NULL,
[NewSumCC_nt] [numeric] (21, 9) NOT NULL,
[NewTax] [numeric] (21, 9) NOT NULL,
[NewTaxSum] [numeric] (21, 9) NOT NULL,
[NewPriceCC_wt] [numeric] (21, 9) NOT NULL,
[NewSumCC_wt] [numeric] (21, 9) NOT NULL,
[Extra] [numeric] (21, 9) NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[SecID] [int] NOT NULL,
[PriceAC_nt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[PriceAC_wt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[TaxAC] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[NewPriceAC_nt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[NewPriceAC_wt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[NewTaxAC] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SumAC_nt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[TaxSumAC] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SumAC_wt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[NewSumAC_nt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[NewTaxSumAC] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[NewSumAC_wt] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_EstD] ON [dbo].[t_EstD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 209 - Обновление итогов в главной таблице */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Est - Переоценка цен прихода: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt + q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC + q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt + q.TSumAC_wt, 
    r.TNewSumAC_nt = r.TNewSumAC_nt + q.TNewSumAC_nt, 
    r.TNewTaxSumAC = r.TNewTaxSumAC + q.TNewTaxSumAC, 
    r.TNewSumAC_wt = r.TNewSumAC_wt + q.TNewSumAC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_Est r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt,
       ISNULL(SUM(m.NewSumAC_nt), 0) TNewSumAC_nt,
       ISNULL(SUM(m.NewTaxSumAC), 0) TNewTaxSumAC,
       ISNULL(SUM(m.NewSumAC_wt), 0) TNewSumAC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Est WITH (NOLOCK), inserted m
     WHERE t_Est.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 56 - Текущие остатки товара - Приход */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.NewPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.NewPPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 57 - Текущие остатки товара - Расход */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_EstD] ON [dbo].[t_EstD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 209 - Обновление итогов в главной таблице */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Est - Переоценка цен прихода: Заголовок */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(SumAC_nt) OR UPDATE(TaxSumAC) OR UPDATE(SumAC_wt) OR UPDATE(NewSumAC_nt) OR UPDATE(NewTaxSumAC) OR UPDATE(NewSumAC_wt) OR UPDATE(NewSumCC_nt) OR UPDATE(NewTaxSum) OR UPDATE(NewSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt + q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC + q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt + q.TSumAC_wt, 
    r.TNewSumAC_nt = r.TNewSumAC_nt + q.TNewSumAC_nt, 
    r.TNewTaxSumAC = r.TNewTaxSumAC + q.TNewTaxSumAC, 
    r.TNewSumAC_wt = r.TNewSumAC_wt + q.TNewSumAC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_Est r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt,
       ISNULL(SUM(m.NewSumAC_nt), 0) TNewSumAC_nt,
       ISNULL(SUM(m.NewTaxSumAC), 0) TNewTaxSumAC,
       ISNULL(SUM(m.NewSumAC_wt), 0) TNewSumAC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Est WITH (NOLOCK), inserted m
     WHERE t_Est.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt - q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC - q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt - q.TSumAC_wt, 
    r.TNewSumAC_nt = r.TNewSumAC_nt - q.TNewSumAC_nt, 
    r.TNewTaxSumAC = r.TNewTaxSumAC - q.TNewTaxSumAC, 
    r.TNewSumAC_wt = r.TNewSumAC_wt - q.TNewSumAC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_Est r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt,
       ISNULL(SUM(m.NewSumAC_nt), 0) TNewSumAC_nt,
       ISNULL(SUM(m.NewTaxSumAC), 0) TNewTaxSumAC,
       ISNULL(SUM(m.NewSumAC_wt), 0) TNewSumAC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Est WITH (NOLOCK), deleted m
     WHERE t_Est.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 56 - Текущие остатки товара - Приход */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(NewPPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.NewPPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.NewPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.NewPPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.NewPPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 57 - Текущие остатки товара - Расход */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_EstD] ON [dbo].[t_EstD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 209 - Обновление итогов в главной таблице */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Est - Переоценка цен прихода: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumAC_nt = r.TSumAC_nt - q.TSumAC_nt, 
    r.TTaxSumAC = r.TTaxSumAC - q.TTaxSumAC, 
    r.TSumAC_wt = r.TSumAC_wt - q.TSumAC_wt, 
    r.TNewSumAC_nt = r.TNewSumAC_nt - q.TNewSumAC_nt, 
    r.TNewTaxSumAC = r.TNewTaxSumAC - q.TNewTaxSumAC, 
    r.TNewSumAC_wt = r.TNewSumAC_wt - q.TNewSumAC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_Est r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.SumAC_nt), 0) TSumAC_nt,
       ISNULL(SUM(m.TaxSumAC), 0) TTaxSumAC,
       ISNULL(SUM(m.SumAC_wt), 0) TSumAC_wt,
       ISNULL(SUM(m.NewSumAC_nt), 0) TNewSumAC_nt,
       ISNULL(SUM(m.NewTaxSumAC), 0) TNewTaxSumAC,
       ISNULL(SUM(m.NewSumAC_wt), 0) TNewSumAC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Est WITH (NOLOCK), deleted m
     WHERE t_Est.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 56 - Текущие остатки товара - Приход */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.NewPPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.NewPPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.NewPPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 57 - Текущие остатки товара - Расход */
/* t_EstD - Переоценка цен прихода: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_Est.OurID = r.OurID AND t_Est.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_Est WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_Est.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_Est.OurID, t_Est.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_EstD] ON [dbo].[t_EstD]
FOR INSERT AS
/* t_EstD - Переоценка цен прихода: Товар - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Est a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Est a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Est a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Est a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Est a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11031, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Переоценка цен прихода'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_EstD ^ r_Secs - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EstD', 0
      RETURN
    END

/* t_EstD ^ t_Est - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Est))
    BEGIN
      EXEC z_RelationError 't_Est', 't_EstD', 0
      RETURN
    END

/* t_EstD ^ t_PInP - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.NewPPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_EstD', 0
      RETURN
    END

/* t_EstD ^ t_PInP - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_EstD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11031002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_EstD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_EstD] ON [dbo].[t_EstD]
FOR UPDATE AS
/* t_EstD - Переоценка цен прихода: Товар - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Est a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Est a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Est a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Est a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Est a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Est a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Est a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11031, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Переоценка цен прихода'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_EstD ^ r_Secs - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_EstD', 1
        RETURN
      END

/* t_EstD ^ t_Est - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Переоценка цен прихода: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Est))
      BEGIN
        EXEC z_RelationError 't_Est', 't_EstD', 1
        RETURN
      END

/* t_EstD ^ t_PInP - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(NewPPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.NewPPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_EstD', 1
        RETURN
      END

/* t_EstD ^ t_PInP - Проверка в PARENT */
/* Переоценка цен прихода: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_EstD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11031002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11031002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11031002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11031002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11031002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11031002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11031002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11031002, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11031002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11031002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11031002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11031002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11031002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11031002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11031002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_EstD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_EstD] ON [dbo].[t_EstD]
FOR DELETE AS
/* t_EstD - Переоценка цен прихода: Товар - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Est a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Est a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Est a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Est a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Переоценка цен прихода: Товар (t_EstD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Est a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11031, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Переоценка цен прихода'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11031002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11031002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11031002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_EstD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_EstD] ADD CONSTRAINT [_pk_t_EstD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_EstD] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_EstD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[t_EstD] ([ChID], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_EstD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewPPID] ON [dbo].[t_EstD] ([NewPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_EstD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_EstD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInP_Tt_EstD] ON [dbo].[t_EstD] ([ProdID], [NewPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInPt_EstD] ON [dbo].[t_EstD] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_EstD] ([SecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[Extra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[NewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[Extra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EstD].[SecID]'
GO
