CREATE TABLE [dbo].[t_CRRetD]
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
[BarCode] [varchar] (42) NOT NULL,
[SecID] [int] NOT NULL,
[SaleSrcPosID] [int] NULL,
[EmpID] [int] NOT NULL DEFAULT (0),
[CreateTime] [datetime] NOT NULL DEFAULT (getdate()),
[ModifyTime] [datetime] NOT NULL DEFAULT (getdate()),
[TaxTypeID] [int] NOT NULL DEFAULT ((0)),
[RealPrice] [numeric] (21, 9) NOT NULL,
[RealSum] [numeric] (21, 9) NOT NULL,
[CReasonID] [int] NOT NULL DEFAULT ((0)),
[MarkCode] [int] NULL DEFAULT ((0)),
[LevyMark] [varchar] (20) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_CRRetD] ON [dbo].[t_CRRetD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 17 - Обновление итогов в главной таблице */
/* t_CRRetD - Возврат товара по чеку: Товар */
/* t_CRRet - Возврат товара по чеку: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_CRRet WITH (NOLOCK), inserted m
     WHERE t_CRRet.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 18 - Текущие остатки товара */
/* t_CRRetD - Возврат товара по чеку: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_CRRet.OurID = r.OurID AND t_CRRet.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_CRRetD] ON [dbo].[t_CRRetD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 17 - Обновление итогов в главной таблице */
/* t_CRRetD - Возврат товара по чеку: Товар */
/* t_CRRet - Возврат товара по чеку: Заголовок */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(RealSum)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TRealSum = r.TRealSum + q.TRealSum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_CRRet WITH (NOLOCK), inserted m
     WHERE t_CRRet.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_CRRet WITH (NOLOCK), deleted m
     WHERE t_CRRet.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

/* 18 - Текущие остатки товара */
/* t_CRRetD - Возврат товара по чеку: Товар */
/* t_Rem - Остатки товара (Таблица) */

IF UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID) OR UPDATE(Qty)
BEGIN
  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), inserted m
  WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_CRRet.OurID = r.OurID AND t_CRRet.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_CRRet.OurID = r.OurID AND t_CRRet.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty + q.Qty
  FROM t_Rem r, 
    (SELECT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), inserted m
     WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID) q
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
CREATE TRIGGER [dbo].[TAU3_DEL_t_CRRetD] ON [dbo].[t_CRRetD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 17 - Обновление итогов в главной таблице */
/* t_CRRetD - Возврат товара по чеку: Товар */
/* t_CRRet - Возврат товара по чеку: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TRealSum = r.TRealSum - q.TRealSum
  FROM t_CRRet r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.RealSum), 0) TRealSum 
     FROM t_CRRet WITH (NOLOCK), deleted m
     WHERE t_CRRet.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

/* 18 - Текущие остатки товара */
/* t_CRRetD - Возврат товара по чеку: Товар */
/* t_Rem - Остатки товара (Таблица) */

  INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
  SELECT DISTINCT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 0, 0
  FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), deleted m
  WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
  AND (NOT EXISTS (SELECT TOP 1 1 FROM t_Rem r WITH (NOLOCK)
       WHERE t_CRRet.OurID = r.OurID AND t_CRRet.StockID = r.StockID AND m.SecID = r.SecID AND m.ProdID = r.ProdID AND m.PPID = r.PPID))
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.Qty = r.Qty - q.Qty
  FROM t_Rem r, 
    (SELECT t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID, 
       ISNULL(SUM(m.Qty), 0) Qty 
     FROM r_Prods WITH (NOLOCK), t_CRRet WITH (NOLOCK), deleted m
     WHERE m.ProdID = r_Prods.ProdID AND t_CRRet.ChID = m.ChID AND (r_Prods.InRems <> 0)
     GROUP BY t_CRRet.OurID, t_CRRet.StockID, m.SecID, m.ProdID, m.PPID) q
  WHERE q.OurID = r.OurID AND q.StockID = r.StockID AND q.SecID = r.SecID AND q.ProdID = r.ProdID AND q.PPID = r.PPID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel2_Upd_t_CRRetD] ON [dbo].[t_CRRetD]
FOR UPDATE AS
/* t_CRRetD - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* t_CRRetD ^ z_LogDiscRec - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM z_LogDiscRec a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID AND a.DocCode = 11004
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.ChID = @NewChID FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.ChID = @OldChID AND z_LogDiscRec.SrcPosID = d.SrcPosID AND z_LogDiscRec.DocCode = 11004
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE z_LogDiscRec SET z_LogDiscRec.SrcPosID = @NewSrcPosID FROM z_LogDiscRec, deleted d WHERE z_LogDiscRec.SrcPosID = @OldSrcPosID AND z_LogDiscRec.ChID = d.ChID AND z_LogDiscRec.DocCode = 11004
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscRec a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''t_CRRetD'' => ''z_LogDiscRec''.', 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

  /* t_CRRetD ^ z_LogDiscExp - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM z_LogDiscExp a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID AND a.DocCode = 11004
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.ChID = @NewChID FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.ChID = @OldChID AND z_LogDiscExp.SrcPosID = d.SrcPosID AND z_LogDiscExp.DocCode = 11004
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE z_LogDiscExp SET z_LogDiscExp.SrcPosID = @NewSrcPosID FROM z_LogDiscExp, deleted d WHERE z_LogDiscExp.SrcPosID = @OldSrcPosID AND z_LogDiscExp.ChID = d.ChID AND z_LogDiscExp.DocCode = 11004
        END
      ELSE IF EXISTS (SELECT * FROM z_LogDiscExp a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''t_CRRetD'' => ''z_LogDiscExp''.', 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel3_Del_t_CRRetD] ON [dbo].[t_CRRetD]
FOR DELETE AS
/* t_CRRetD - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

  /* [t_CRRetD] ^ z_LogDiscRec - Удаление в CHILD */
  DELETE z_LogDiscRec FROM z_LogDiscRec m, deleted d 
  WHERE m.ChID = d.ChID AND m.DocCode = 11004 AND m.SrcPosID = d.SrcPosID 

  /* [t_CRRetD] ^ z_LogDiscExp - Удаление в CHILD */
  DELETE z_LogDiscExp FROM z_LogDiscExp m, deleted d 
  WHERE m.ChID = d.ChID AND m.DocCode = 11004 AND m.SrcPosID = d.SrcPosID 

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_CRRetD] ON [dbo].[t_CRRetD]
FOR INSERT AS
/* t_CRRetD - Возврат товара по чеку: Товар - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_CRRet a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_CRRet a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_CRRet a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_CRRet a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_CRRet a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11004, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Возврат товара по чеку'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_CRRetD ^ r_Emps - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 't_CRRetD', 0
      RETURN
    END

/* t_CRRetD ^ r_ProdMarks - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник товаров: маркировки - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.MarkCode IS NOT NULL AND i.MarkCode NOT IN (SELECT MarkCode FROM r_ProdMarks))
    BEGIN
      EXEC z_RelationError 'r_ProdMarks', 't_CRRetD', 0
      RETURN
    END

/* t_CRRetD ^ r_Secs - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_CRRetD', 0
      RETURN
    END

/* t_CRRetD ^ r_Taxes - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник НДС - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
    BEGIN
      EXEC z_RelationError 'r_Taxes', 't_CRRetD', 0
      RETURN
    END

/* t_CRRetD ^ r_Uni - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CReasonID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10702))
    BEGIN
      EXEC z_RelationErrorUni 't_CRRetD', 10702, 0
      RETURN
    END

/* t_CRRetD ^ t_CRRet - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 't_CRRetD', 0
      RETURN
    END

/* t_CRRetD ^ t_PInP - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_CRRetD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11004002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_CRRetD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_CRRetD] ON [dbo].[t_CRRetD]
FOR UPDATE AS
/* t_CRRetD - Возврат товара по чеку: Товар - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_CRRet a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_CRRet a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_CRRet a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_CRRet a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_CRRet a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_CRRet a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_CRRet a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11004, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Возврат товара по чеку'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_CRRetD ^ r_Emps - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 't_CRRetD', 1
        RETURN
      END

/* t_CRRetD ^ r_ProdMarks - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник товаров: маркировки - Проверка в PARENT */
  IF UPDATE(MarkCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.MarkCode IS NOT NULL AND i.MarkCode NOT IN (SELECT MarkCode FROM r_ProdMarks))
      BEGIN
        EXEC z_RelationError 'r_ProdMarks', 't_CRRetD', 1
        RETURN
      END

/* t_CRRetD ^ r_Secs - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_CRRetD', 1
        RETURN
      END

/* t_CRRetD ^ r_Taxes - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник НДС - Проверка в PARENT */
  IF UPDATE(TaxTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.TaxTypeID NOT IN (SELECT TaxTypeID FROM r_Taxes))
      BEGIN
        EXEC z_RelationError 'r_Taxes', 't_CRRetD', 1
        RETURN
      END

/* t_CRRetD ^ r_Uni - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(CReasonID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CReasonID NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10702))
      BEGIN
        EXEC z_RelationErrorUni 't_CRRetD', 10702, 1
        RETURN
      END

/* t_CRRetD ^ t_CRRet - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 't_CRRetD', 1
        RETURN
      END

/* t_CRRetD ^ t_PInP - Проверка в PARENT */
/* Возврат товара по чеку: Товар ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_CRRetD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldSrcPosID int, @NewSrcPosID int

/* t_CRRetD ^ t_CRRetDLV - Обновление CHILD */
/* Возврат товара по чеку: Товар ^ Возврат товара по чеку: Сборы по товару - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.SrcPosID = i.SrcPosID
          FROM t_CRRetDLV a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(SrcPosID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_CRRetDLV SET t_CRRetDLV.ChID = @NewChID FROM t_CRRetDLV, deleted d WHERE t_CRRetDLV.ChID = @OldChID AND t_CRRetDLV.SrcPosID = d.SrcPosID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT SrcPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT SrcPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldSrcPosID = SrcPosID FROM deleted
          SELECT TOP 1 @NewSrcPosID = SrcPosID FROM inserted
          UPDATE t_CRRetDLV SET t_CRRetDLV.SrcPosID = @NewSrcPosID FROM t_CRRetDLV, deleted d WHERE t_CRRetDLV.SrcPosID = @OldSrcPosID AND t_CRRetDLV.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM t_CRRetDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Возврат товара по чеку: Товар'' => ''Возврат товара по чеку: Сборы по товару''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11004002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11004002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11004002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11004002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11004002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11004002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11004002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11004002, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11004002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11004002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11004002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11004002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11004002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11004002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11004002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_CRRetD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_CRRetD] ON [dbo].[t_CRRetD]
FOR DELETE AS
/* t_CRRetD - Возврат товара по чеку: Товар - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_CRRet a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_CRRet a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_CRRet a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_CRRet a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Возврат товара по чеку: Товар (t_CRRetD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_CRRet a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11004, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Возврат товара по чеку'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_CRRetD ^ t_CRRetDLV - Удаление в CHILD */
/* Возврат товара по чеку: Товар ^ Возврат товара по чеку: Сборы по товару - Удаление в CHILD */
  DELETE t_CRRetDLV FROM t_CRRetDLV a, deleted d WHERE a.ChID = d.ChID AND a.SrcPosID = d.SrcPosID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11004002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11004002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11004002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_CRRetD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_CRRetD] ADD CONSTRAINT [_pk_t_CRRetD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_CRRetD] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_CRRetD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_CRRetD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_CRRetD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_CRRetD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInPt_CRRetD] ON [dbo].[t_CRRetD] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_CRRetD] ([SecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CRRetD].[SecID]'
GO
