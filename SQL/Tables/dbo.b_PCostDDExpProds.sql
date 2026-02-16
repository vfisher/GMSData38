CREATE TABLE [dbo].[b_PCostDDExpProds] (
  [AChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [DetProdID] [int] NOT NULL,
  [DetPPID] [int] NOT NULL,
  [DetUM] [varchar](10) NULL,
  [DetQty] [numeric](21, 9) NOT NULL,
  [DetPriceCC_nt] [numeric](21, 9) NOT NULL,
  [DetSumCC_nt] [numeric](21, 9) NOT NULL,
  [DetTax] [numeric](21, 9) NOT NULL,
  [DetTaxSum] [numeric](21, 9) NOT NULL,
  [DetPriceCC_wt] [numeric](21, 9) NOT NULL,
  [DetSumCC_wt] [numeric](21, 9) NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  CONSTRAINT [pk_b_PCostDDExpProds] PRIMARY KEY CLUSTERED ([AChID], [SrcPosID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PCostDDExpProds] ON [b_PCostDDExpProds]
FOR DELETE AS
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, b_PCostD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, b_PCostD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PCostDDExpProds', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PCostDDExpProds] ON [b_PCostDDExpProds]
FOR UPDATE AS
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, b_PCostD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, b_PCostD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, b_PCostD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCostDDExpProds ^ b_PCostD - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) ^ ТМЦ: Формирование себестоимости (ТМЦ) - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM b_PCostD))
      BEGIN
        EXEC z_RelationError 'b_PCostD', 'b_PCostDDExpProds', 1
        RETURN
      END

/* b_PCostDDExpProds ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_PCostDDExpProds', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PCostDDExpProds', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PCostDDExpProds] ON [b_PCostDDExpProds]
FOR INSERT AS
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, b_PCostD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, b_PCostD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, b_PCostD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)'), 'b_PCostDDExpProds', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCostDDExpProds ^ b_PCostD - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) ^ ТМЦ: Формирование себестоимости (ТМЦ) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM b_PCostD))
    BEGIN
      EXEC z_RelationError 'b_PCostD', 'b_PCostDDExpProds', 0
      RETURN
    END

/* b_PCostDDExpProds ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostDDExpProds', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PCostDDExpProds', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PCostDDExpProds] ON [b_PCostDDExpProds]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 193 - Обновление итогов в главной таблице */
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */

  UPDATE r
  SET 
    r.ExpPosProdCostCC = r.ExpPosProdCostCC - q.ExpPosProdCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosProdCostCC 
     FROM b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 192 - Текущие остатки товара - Расход */
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (StockID, PPID, OurID, ProdID, Qty)
  SELECT DISTINCT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
  WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.StockID = r.StockID AND m.DetPPID = r.PPID AND b_PCost.OurID = r.OurID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 
       ISNULL(SUM(m.DetQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
     WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID) q
  WHERE q.StockID = r.StockID AND q.DetPPID = r.PPID AND q.OurID = r.OurID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PCostDDExpProds] ON [b_PCostDDExpProds]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 193 - Обновление итогов в главной таблице */
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */

IF UPDATE(DetSumCC_nt)
BEGIN
  UPDATE r
  SET 
    r.ExpPosProdCostCC = r.ExpPosProdCostCC - q.ExpPosProdCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosProdCostCC 
     FROM b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.ExpPosProdCostCC = r.ExpPosProdCostCC + q.ExpPosProdCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosProdCostCC 
     FROM b_PCostD WITH (NOLOCK), inserted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 192 - Текущие остатки товара - Расход */
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(DetPPID) OR UPDATE(DetProdID) OR UPDATE(DetQty)
BEGIN
  INSERT INTO b_Rem (StockID, PPID, OurID, ProdID, Qty)
  SELECT DISTINCT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
  WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.StockID = r.StockID AND m.DetPPID = r.PPID AND b_PCost.OurID = r.OurID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (StockID, PPID, OurID, ProdID, Qty)
  SELECT DISTINCT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
  WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.StockID = r.StockID AND m.DetPPID = r.PPID AND b_PCost.OurID = r.OurID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 
       ISNULL(SUM(m.DetQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
     WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID) q
  WHERE q.StockID = r.StockID AND q.DetPPID = r.PPID AND q.OurID = r.OurID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 
       ISNULL(SUM(m.DetQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), deleted m
     WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID) q
  WHERE q.StockID = r.StockID AND q.DetPPID = r.PPID AND q.OurID = r.OurID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_PCostDDExpProds] ON [b_PCostDDExpProds]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 193 - Обновление итогов в главной таблице */
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */

  UPDATE r
  SET 
    r.ExpPosProdCostCC = r.ExpPosProdCostCC + q.ExpPosProdCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosProdCostCC 
     FROM b_PCostD WITH (NOLOCK), inserted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 192 - Текущие остатки товара - Расход */
/* b_PCostDDExpProds - ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (StockID, PPID, OurID, ProdID, Qty)
  SELECT DISTINCT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
  WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.StockID = r.StockID AND m.DetPPID = r.PPID AND b_PCost.OurID = r.OurID AND m.DetProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID, 
       ISNULL(SUM(m.DetQty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), inserted m
     WHERE m.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = m.AChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.StockID, m.DetPPID, b_PCost.OurID, m.DetProdID) q
  WHERE q.StockID = r.StockID AND q.DetPPID = r.PPID AND q.OurID = r.OurID AND q.DetProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO