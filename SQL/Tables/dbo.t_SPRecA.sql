CREATE TABLE [dbo].[t_SPRecA] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [UM] [varchar](50) NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [SetCostCC] [numeric](21, 9) NOT NULL,
  [SetValue1] [numeric](21, 9) NULL,
  [SetValue2] [numeric](21, 9) NULL,
  [SetValue3] [numeric](21, 9) NULL,
  [PriceCC_nt] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [Tax] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [PriceCC_wt] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [Extra] [numeric](21, 9) NULL,
  [PriceCC] [numeric](21, 9) NOT NULL,
  [NewPriceCC_nt] [numeric](21, 9) NOT NULL,
  [NewSumCC_nt] [numeric](21, 9) NOT NULL,
  [NewTax] [numeric](21, 9) NOT NULL,
  [NewTaxSum] [numeric](21, 9) NOT NULL,
  [NewPriceCC_wt] [numeric](21, 9) NOT NULL,
  [NewSumCC_wt] [numeric](21, 9) NOT NULL,
  [AChID] [bigint] NOT NULL,
  [BarCode] [varchar](42) NOT NULL,
  [SecID] [int] NOT NULL,
  CONSTRAINT [pk_t_SPRecA] PRIMARY KEY CLUSTERED ([AChID])
)
ON [PRIMARY]
GO

CREATE INDEX [BarCode]
  ON [dbo].[t_SPRecA] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_SPRecA] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_SPRecA] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_SPRecA] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_SPRecA] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [SetCostCC]
  ON [dbo].[t_SPRecA] ([SetCostCC])
  ON [PRIMARY]
GO

CREATE INDEX [t_PInP_Tt_SPRecA]
  ON [dbo].[t_SPRecA] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_SPRecA] ([ChID], [SrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[t_SPRecA] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotalsNew]
  ON [dbo].[t_SPRecA] ([ChID], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SetCostCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SetValue1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SetValue2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SetValue3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.PriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.Tax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.PriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.Extra'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.PriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.NewPriceCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.NewSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.NewTax'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.NewTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.NewPriceCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.NewSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.AChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecA.SecID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SPRecA] ON [t_SPRecA]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 80 - Обновление итогов в главной таблице */
/* t_SPRecA - Планирование: Комплектация: Комплекты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPRec WITH (NOLOCK), inserted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 185 - Обновление итогов в главной таблице: Составляющие */
/* t_SPRecA - Планирование: Комплектация: Комплекты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt + q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum + q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt + q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt + q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum + q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt + q.TSubNewSumCC_wt
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(t_SPRecD.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(t_SPRecD.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(t_SPRecD.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(t_SPRecD.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(t_SPRecD.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(t_SPRecD.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SPRec WITH (NOLOCK), t_SPRecD WITH (NOLOCK), inserted m
     WHERE t_SPRec.ChID = m.ChID AND m.AChID = t_SPRecD.AChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SPRecA] ON [t_SPRecA]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 80 - Обновление итогов в главной таблице */
/* t_SPRecA - Планирование: Комплектация: Комплекты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(NewSumCC_nt) OR UPDATE(NewTaxSum) OR UPDATE(NewSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPRec WITH (NOLOCK), inserted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPRec WITH (NOLOCK), deleted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 185 - Обновление итогов в главной таблице: Составляющие */
/* t_SPRecA - Планирование: Комплектация: Комплекты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SPRecA] ON [t_SPRecA]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 80 - Обновление итогов в главной таблице */
/* t_SPRecA - Планирование: Комплектация: Комплекты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.NewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.NewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.NewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_SPRec WITH (NOLOCK), deleted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 185 - Обновление итогов в главной таблице: Составляющие */
/* t_SPRecA - Планирование: Комплектация: Комплекты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

  UPDATE r
  SET 
    r.TSubSumCC_nt = r.TSubSumCC_nt - q.TSubSumCC_nt, 
    r.TSubTaxSum = r.TSubTaxSum - q.TSubTaxSum, 
    r.TSubSumCC_wt = r.TSubSumCC_wt - q.TSubSumCC_wt, 
    r.TSubNewSumCC_nt = r.TSubNewSumCC_nt - q.TSubNewSumCC_nt, 
    r.TSubNewTaxSum = r.TSubNewTaxSum - q.TSubNewTaxSum, 
    r.TSubNewSumCC_wt = r.TSubNewSumCC_wt - q.TSubNewSumCC_wt
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(t_SPRecD.SubSumCC_nt), 0) TSubSumCC_nt,
       ISNULL(SUM(t_SPRecD.SubTaxSum), 0) TSubTaxSum,
       ISNULL(SUM(t_SPRecD.SubSumCC_wt), 0) TSubSumCC_wt,
       ISNULL(SUM(t_SPRecD.SubNewSumCC_nt), 0) TSubNewSumCC_nt,
       ISNULL(SUM(t_SPRecD.SubNewTaxSum), 0) TSubNewTaxSum,
       ISNULL(SUM(t_SPRecD.SubNewSumCC_wt), 0) TSubNewSumCC_wt 
     FROM t_SPRec WITH (NOLOCK), t_SPRecD WITH (NOLOCK), deleted m
     WHERE t_SPRec.ChID = m.ChID AND m.AChID = t_SPRecD.AChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SPRecA] ON [t_SPRecA]
FOR INSERT AS
/* t_SPRecA - Планирование: Комплектация: Комплекты - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SPRec a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SPRec a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SPRec a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11311, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Планирование: Комплектация'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SPRecA ^ r_Secs - Проверка в PARENT */
/* Планирование: Комплектация: Комплекты ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_SPRecA', 0
      RETURN
    END

/* t_SPRecA ^ t_PInP - Проверка в PARENT */
/* Планирование: Комплектация: Комплекты ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_SPRecA', 0
      RETURN
    END

/* t_SPRecA ^ t_SPRec - Проверка в PARENT */
/* Планирование: Комплектация: Комплекты ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SPRec))
    BEGIN
      EXEC z_RelationError 't_SPRec', 't_SPRecA', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11311003, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SPRecA', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SPRecA] ON [t_SPRecA]
FOR UPDATE AS
/* t_SPRecA - Планирование: Комплектация: Комплекты - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_SPRec a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SPRec a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SPRec a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11311, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Планирование: Комплектация'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SPRecA ^ r_Secs - Проверка в PARENT */
/* Планирование: Комплектация: Комплекты ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_SPRecA', 1
        RETURN
      END

/* t_SPRecA ^ t_PInP - Проверка в PARENT */
/* Планирование: Комплектация: Комплекты ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_SPRecA', 1
        RETURN
      END

/* t_SPRecA ^ t_SPRec - Проверка в PARENT */
/* Планирование: Комплектация: Комплекты ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SPRec))
      BEGIN
        EXEC z_RelationError 't_SPRec', 't_SPRecA', 1
        RETURN
      END

/* t_SPRecA ^ t_SPRecD - Обновление CHILD */
/* Планирование: Комплектация: Комплекты ^ Планирование: Комплектация: Составляющие - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_SPRecD a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecD a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Планирование: Комплектация: Комплекты'' => ''Планирование: Комплектация: Составляющие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_SPRecA ^ t_SPRecE - Обновление CHILD */
/* Планирование: Комплектация: Комплекты ^ Планирование: Комплектация: Затраты на комплекты - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_SPRecE a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SPRecE a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Планирование: Комплектация: Комплекты'' => ''Планирование: Комплектация: Затраты на комплекты''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11311003 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11311003 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(AChID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11311003 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11311003 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11311003, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11311003 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11311003 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11311003, ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11311003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11311003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11311003, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11311003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11311003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11311003, ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11311003, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SPRecA', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SPRecA] ON [t_SPRecA]
FOR DELETE AS
/* t_SPRecA - Планирование: Комплектация: Комплекты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_SPRec a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_SPRec a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Комплекты (t_SPRecA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_SPRec a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11311, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Планирование: Комплектация'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SPRecA ^ t_SPRecD - Удаление в CHILD */
/* Планирование: Комплектация: Комплекты ^ Планирование: Комплектация: Составляющие - Удаление в CHILD */
  DELETE t_SPRecD FROM t_SPRecD a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* t_SPRecA ^ t_SPRecE - Удаление в CHILD */
/* Планирование: Комплектация: Комплекты ^ Планирование: Комплектация: Затраты на комплекты - Удаление в CHILD */
  DELETE t_SPRecE FROM t_SPRecE a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11311003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11311003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11311003, -ChID, 
    '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SPRecA', N'Last', N'DELETE'
GO