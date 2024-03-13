CREATE TABLE [dbo].[t_VenA]
(
[ChID] [bigint] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[TQty] [numeric] (21, 9) NOT NULL,
[TNewQty] [numeric] (21, 9) NOT NULL,
[TSumCC_nt] [numeric] (21, 9) NOT NULL,
[TTaxSum] [numeric] (21, 9) NOT NULL,
[TSumCC_wt] [numeric] (21, 9) NOT NULL,
[TNewSumCC_nt] [numeric] (21, 9) NOT NULL,
[TNewTaxSum] [numeric] (21, 9) NOT NULL,
[TNewSumCC_wt] [numeric] (21, 9) NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[Norma1] [numeric] (21, 9) NOT NULL,
[TSrcPosID] [int] NOT NULL,
[HandCorrected] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_VenA] ON [dbo].[t_VenA]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 48 - Обновление итогов в главной таблице */
/* t_VenA - Инвентаризация товара: Товар */
/* t_Ven - Инвентаризация товара: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_Ven r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Ven WITH (NOLOCK), inserted m
     WHERE t_Ven.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_VenA] ON [dbo].[t_VenA]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 48 - Обновление итогов в главной таблице */
/* t_VenA - Инвентаризация товара: Товар */
/* t_Ven - Инвентаризация товара: Заголовок */

IF UPDATE(TSumCC_nt) OR UPDATE(TTaxSum) OR UPDATE(TSumCC_wt) OR UPDATE(TNewSumCC_nt) OR UPDATE(TNewTaxSum) OR UPDATE(TNewSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt + q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum + q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt + q.TNewSumCC_wt
  FROM t_Ven r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Ven WITH (NOLOCK), inserted m
     WHERE t_Ven.ChID = m.ChID
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
  FROM t_Ven r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Ven WITH (NOLOCK), deleted m
     WHERE t_Ven.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_VenA] ON [dbo].[t_VenA]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 48 - Обновление итогов в главной таблице */
/* t_VenA - Инвентаризация товара: Товар */
/* t_Ven - Инвентаризация товара: Заголовок */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TNewSumCC_nt = r.TNewSumCC_nt - q.TNewSumCC_nt, 
    r.TNewTaxSum = r.TNewTaxSum - q.TNewTaxSum, 
    r.TNewSumCC_wt = r.TNewSumCC_wt - q.TNewSumCC_wt
  FROM t_Ven r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.TSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.TSumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.TNewSumCC_nt), 0) TNewSumCC_nt,
       ISNULL(SUM(m.TNewTaxSum), 0) TNewTaxSum,
       ISNULL(SUM(m.TNewSumCC_wt), 0) TNewSumCC_wt 
     FROM t_Ven WITH (NOLOCK), deleted m
     WHERE t_Ven.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_VenA] ON [dbo].[t_VenA]
FOR INSERT AS
/* t_VenA - Инвентаризация товара: Товар - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Ven a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11022, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Инвентаризация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_VenA ^ r_Prods - Проверка в PARENT */
/* Инвентаризация товара: Товар ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_VenA', 0
      RETURN
    END

/* t_VenA ^ t_Ven - Проверка в PARENT */
/* Инвентаризация товара: Товар ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Ven))
    BEGIN
      EXEC z_RelationError 't_Ven', 't_VenA', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11022002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_VenA]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_VenA] ON [dbo].[t_VenA]
FOR UPDATE AS
/* t_VenA - Инвентаризация товара: Товар - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Ven a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11022, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Инвентаризация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_VenA ^ r_Prods - Проверка в PARENT */
/* Инвентаризация товара: Товар ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 't_VenA', 1
        RETURN
      END

/* t_VenA ^ t_Ven - Проверка в PARENT */
/* Инвентаризация товара: Товар ^ Инвентаризация товара: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Ven))
      BEGIN
        EXEC z_RelationError 't_Ven', 't_VenA', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldChID bigint, @NewChID bigint
  DECLARE @OldProdID int, @NewProdID int

/* t_VenA ^ t_VenD - Обновление CHILD */
/* Инвентаризация товара: Товар ^ Инвентаризация товара: Партии - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DetProdID = i.ProdID
          FROM t_VenD a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_VenD SET t_VenD.ChID = @NewChID FROM t_VenD, deleted d WHERE t_VenD.ChID = @OldChID AND t_VenD.DetProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_VenD SET t_VenD.DetProdID = @NewProdID FROM t_VenD, deleted d WHERE t_VenD.DetProdID = @OldProdID AND t_VenD.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM t_VenD a, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Инвентаризация товара: Товар'' => ''Инвентаризация товара: Партии''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* t_VenA ^ t_VenD_UM - Обновление CHILD */
/* Инвентаризация товара: Товар ^ Инвентаризация товара: Виды упаковок - Обновление CHILD */
  IF UPDATE(ChID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ChID = i.ChID, a.DetProdID = i.ProdID
          FROM t_VenD_UM a, inserted i, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT ChID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ChID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldChID = ChID FROM deleted
          SELECT TOP 1 @NewChID = ChID FROM inserted
          UPDATE t_VenD_UM SET t_VenD_UM.ChID = @NewChID FROM t_VenD_UM, deleted d WHERE t_VenD_UM.ChID = @OldChID AND t_VenD_UM.DetProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(ChID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_VenD_UM SET t_VenD_UM.DetProdID = @NewProdID FROM t_VenD_UM, deleted d WHERE t_VenD_UM.DetProdID = @OldProdID AND t_VenD_UM.ChID = d.ChID
        END
      ELSE IF EXISTS (SELECT * FROM t_VenD_UM a, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Инвентаризация товара: Товар'' => ''Инвентаризация товара: Виды упаковок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */

  IF NOT(UPDATE(ChID) OR UPDATE(ProdID) OR UPDATE(UM) OR UPDATE(TQty) OR UPDATE(TNewQty) OR UPDATE(BarCode) OR UPDATE(Norma1) OR UPDATE(TSrcPosID) OR UPDATE(HandCorrected)) RETURN

/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11022002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11022002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(ProdID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11022002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.ProdID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.ProdID = d.ProdID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11022002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.ProdID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.ProdID = d.ProdID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11022002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11022002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11022002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11022002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(ProdID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, ProdID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, ProdID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11022002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11022002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11022002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11022002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11022002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11022002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11022002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_VenA]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_VenA] ON [dbo].[t_VenA]
FOR DELETE AS
/* t_VenA - Инвентаризация товара: Товар - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Товар (t_VenA):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Ven a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11022, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Инвентаризация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_VenA ^ t_VenD - Удаление в CHILD */
/* Инвентаризация товара: Товар ^ Инвентаризация товара: Партии - Удаление в CHILD */
  DELETE t_VenD FROM t_VenD a, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* t_VenA ^ t_VenD_UM - Удаление в CHILD */
/* Инвентаризация товара: Товар ^ Инвентаризация товара: Виды упаковок - Удаление в CHILD */
  DELETE t_VenD_UM FROM t_VenD_UM a, deleted d WHERE a.ChID = d.ChID AND a.DetProdID = d.ProdID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11022002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11022002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11022002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_VenA]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_VenA] ADD CONSTRAINT [_pk_t_VenA] PRIMARY KEY CLUSTERED ([ChID], [ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_VenA] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_VenA] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[t_VenA] ([ChID], [TSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_VenA] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZNewTotals] ON [dbo].[t_VenA] ([TNewSumCC_wt], [TTaxSum], [TSumCC_nt], [TNewQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TSrcPosID] ON [dbo].[t_VenA] ([TSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_VenA] ([TSumCC_wt], [TTaxSum], [TSumCC_nt], [TQty]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[Norma1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[Norma1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSrcPosID]'
GO
