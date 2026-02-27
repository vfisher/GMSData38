CREATE TABLE [dbo].[b_PCostD] (
  [ChID] [bigint] NOT NULL,
  [AChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [UM] [varchar](50) NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [PPID] [int] NOT NULL,
  [PriceCC] [numeric](21, 9) NOT NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [NewPPID] [int] NOT NULL,
  [NewPriceCC_nt] [numeric](21, 9) NOT NULL,
  [NewSumCC_nt] [numeric](21, 9) NOT NULL,
  [NewPriceCC_wt] [numeric](21, 9) NOT NULL,
  [NewSumCC_wt] [numeric](21, 9) NOT NULL,
  [NewTax] [numeric](21, 9) NOT NULL,
  [NewTaxSum] [numeric](21, 9) NOT NULL,
  [ExpCostCC] [numeric](21, 9) NOT NULL,
  [ExpPosProdCostCC] [numeric](21, 9) NOT NULL,
  [ExpPosCostCC] [numeric](21, 9) NOT NULL,
  [GPosTSum_wt] [numeric](21, 9) NOT NULL,
  [GPosTTaxSum] [numeric](21, 9) NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  CONSTRAINT [pk_b_PCostD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PCostD] ON [b_PCostD]
FOR DELETE AS
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* b_PCostD ^ b_PCostDDExp - Удаление в CHILD */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - Удаление в CHILD */
  DELETE b_PCostDDExp FROM b_PCostDDExp a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* b_PCostD ^ b_PCostDDExpProds - Удаление в CHILD */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - Удаление в CHILD */
  DELETE b_PCostDDExpProds FROM b_PCostDDExpProds a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_PCostD', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PCostD] ON [b_PCostD]
FOR UPDATE AS
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCostD ^ b_PCost - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_PCost))
      BEGIN
        EXEC z_RelationError 'b_PCost', 'b_PCostD', 1
        RETURN
      END

/* b_PCostD ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_PCostD', 1
        RETURN
      END

/* b_PCostD ^ r_Prods - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'b_PCostD', 1
        RETURN
      END

/* b_PCostD ^ b_PCostDDExp - Обновление CHILD */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM b_PCostDDExp a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostDDExp a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Формирование себестоимости (ТМЦ)'' => ''ТМЦ: Формирование себестоимости (Прочие расходы по позиции)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* b_PCostD ^ b_PCostDDExpProds - Обновление CHILD */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM b_PCostDDExpProds a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_PCostDDExpProds a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''ТМЦ: Формирование себестоимости (ТМЦ)'' => ''ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_PCostD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PCostD] ON [b_PCostD]
FOR INSERT AS
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_PCost a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('ТМЦ: Формирование себестоимости (ТМЦ)'), 'b_PCostD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCostD ^ b_PCost - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ ТМЦ: Формирование себестоимости (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_PCost))
    BEGIN
      EXEC z_RelationError 'b_PCost', 'b_PCostD', 0
      RETURN
    END

/* b_PCostD ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostD', 0
      RETURN
    END

/* b_PCostD ^ r_Prods - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (ТМЦ) ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'b_PCostD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_PCostD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PCostD] ON [b_PCostD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 196 - Обновление итогов в главной таблице */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */

  UPDATE r
  SET 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt, 
    r.TExpPosProdCostCC = r.TExpPosProdCostCC - q.TExpPosProdCostCC, 
    r.TExpPosCostCC = r.TExpPosCostCC - q.TExpPosCostCC
  FROM b_PCost r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt,
       ISNULL(SUM(m.ExpPosProdCostCC), 0) TExpPosProdCostCC,
       ISNULL(SUM(m.ExpPosCostCC), 0) TExpPosCostCC 
     FROM b_PCost WITH (NOLOCK), deleted m
     WHERE b_PCost.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 188 - Текущие остатки товара - Приход */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.NewPPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 190 - Текущие остатки товара - Расход */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PCostD] ON [b_PCostD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 196 - Обновление итогов в главной таблице */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */

IF UPDATE(NewSumCC_nt) OR UPDATE(NewTaxSum) OR UPDATE(NewSumCC_wt) OR UPDATE(ExpPosProdCostCC) OR UPDATE(ExpPosCostCC)
BEGIN
  UPDATE r
  SET 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt, 
    r.TExpPosProdCostCC = r.TExpPosProdCostCC - q.TExpPosProdCostCC, 
    r.TExpPosCostCC = r.TExpPosCostCC - q.TExpPosCostCC
  FROM b_PCost r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt,
       ISNULL(SUM(m.ExpPosProdCostCC), 0) TExpPosProdCostCC,
       ISNULL(SUM(m.ExpPosCostCC), 0) TExpPosCostCC 
     FROM b_PCost WITH (NOLOCK), deleted m
     WHERE b_PCost.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt, 
    r.TExpPosProdCostCC = r.TExpPosProdCostCC + q.TExpPosProdCostCC, 
    r.TExpPosCostCC = r.TExpPosCostCC + q.TExpPosCostCC
  FROM b_PCost r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt,
       ISNULL(SUM(m.ExpPosProdCostCC), 0) TExpPosProdCostCC,
       ISNULL(SUM(m.ExpPosCostCC), 0) TExpPosCostCC 
     FROM b_PCost WITH (NOLOCK), inserted m
     WHERE b_PCost.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 188 - Текущие остатки товара - Приход */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(NewPPID) OR UPDATE(ProdID) OR UPDATE(Qty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.NewPPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.NewPPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 190 - Текущие остатки товара - Расход */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

IF UPDATE(PPID) OR UPDATE(ProdID) OR UPDATE(Qty)
BEGIN
  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_PCostD] ON [b_PCostD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 196 - Обновление итогов в главной таблице */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_PCost - ТМЦ: Формирование себестоимости (Заголовок) */

  UPDATE r
  SET 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt, 
    r.TExpPosProdCostCC = r.TExpPosProdCostCC + q.TExpPosProdCostCC, 
    r.TExpPosCostCC = r.TExpPosCostCC + q.TExpPosCostCC
  FROM b_PCost r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt,
       ISNULL(SUM(m.ExpPosProdCostCC), 0) TExpPosProdCostCC,
       ISNULL(SUM(m.ExpPosCostCC), 0) TExpPosCostCC 
     FROM b_PCost WITH (NOLOCK), inserted m
     WHERE b_PCost.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 188 - Текущие остатки товара - Приход */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.NewPPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.NewPPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.NewPPID = r.PPID AND q.ProdID = r.ProdID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 190 - Текущие остатки товара - Расход */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */
/* b_Rem - ТМЦ: Текущие остатки (Данные) */

  INSERT INTO b_Rem (OurID, StockID, PPID, ProdID, Qty)
  SELECT DISTINCT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 0
  FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM b_Rem r WITH (NOLOCK)
       WHERE b_PCost.OurID = r.OurID AND b_PCost.StockID = r.StockID AND m.PPID = r.PPID AND m.ProdID = r.ProdID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM b_Rem r, 
    (SELECT b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND b_PCost.ChID = m.ChID AND (r_Prods.InRems <> 0) AND (m.PPID <> 0)
     GROUP BY b_PCost.OurID, b_PCost.StockID, m.PPID, m.ProdID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.PPID = r.PPID AND q.ProdID = r.ProdID
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