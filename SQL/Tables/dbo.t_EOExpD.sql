CREATE TABLE [dbo].[t_EOExpD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [UM] [varchar](50) NOT NULL,
  [PriceAC] [numeric](21, 9) NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [ExpQty] [numeric](21, 9) NOT NULL,
  [SumAC] [numeric](21, 9) NOT NULL,
  [NewQty] [numeric](21, 9) NOT NULL,
  [NewSumAC] [numeric](21, 9) NOT NULL,
  [RemQty] [numeric](21, 9) NOT NULL,
  [Extra] [numeric](21, 9) NOT NULL,
  [PriceCC] [numeric](21, 9) NOT NULL,
  [BarCode] [varchar](42) NOT NULL,
  [SecID] [int] NOT NULL,
  [ForeCastQty] [numeric](21, 9) NOT NULL,
  [PosExpDate] [smalldatetime] NULL,
  [NRemDays] [int] NOT NULL,
  [AChID] [bigint] NOT NULL,
  CONSTRAINT [pk_t_EOExpD] PRIMARY KEY CLUSTERED ([AChID])
)
ON [PRIMARY]
GO

CREATE INDEX [BarCode]
  ON [dbo].[t_EOExpD] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_EOExpD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [NewQty]
  ON [dbo].[t_EOExpD] ([NewQty])
  ON [PRIMARY]
GO

CREATE INDEX [NewSumAC]
  ON [dbo].[t_EOExpD] ([NewSumAC])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_EOExpD] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [Qty]
  ON [dbo].[t_EOExpD] ([Qty])
  ON [PRIMARY]
GO

CREATE INDEX [RemQty]
  ON [dbo].[t_EOExpD] ([RemQty])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[t_EOExpD] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [SumAC]
  ON [dbo].[t_EOExpD] ([SumAC])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[t_EOExpD] ([ChID], [SrcPosID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.PriceAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.ExpQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.SumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.NewQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.NewSumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.RemQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.Extra'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.PriceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.ForeCastQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.NRemDays'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_EOExpD.AChID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_EOExpD] ON [t_EOExpD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 65 - Обновление итогов в главной таблице */
/* t_EOExpD - Заказ внешний: Формирование: Товар */
/* t_EOExp - Заказ внешний: Формирование: Заголовок */

  UPDATE r
  SET 
    r.TSumAC = r.TSumAC + q.TSumAC, 
    r.TNewSumAC = r.TNewSumAC + q.TNewSumAC
  FROM t_EOExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumAC), 0) TSumAC,
       ISNULL(SUM(m.NewSumAC), 0) TNewSumAC 
     FROM t_EOExp WITH (NOLOCK), inserted m
     WHERE t_EOExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_EOExpD] ON [t_EOExpD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 65 - Обновление итогов в главной таблице */
/* t_EOExpD - Заказ внешний: Формирование: Товар */
/* t_EOExp - Заказ внешний: Формирование: Заголовок */

IF UPDATE(SumAC) OR UPDATE(NewSumAC)
BEGIN
  UPDATE r
  SET 
    r.TSumAC = r.TSumAC + q.TSumAC, 
    r.TNewSumAC = r.TNewSumAC + q.TNewSumAC
  FROM t_EOExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumAC), 0) TSumAC,
       ISNULL(SUM(m.NewSumAC), 0) TNewSumAC 
     FROM t_EOExp WITH (NOLOCK), inserted m
     WHERE t_EOExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumAC = r.TSumAC - q.TSumAC, 
    r.TNewSumAC = r.TNewSumAC - q.TNewSumAC
  FROM t_EOExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumAC), 0) TSumAC,
       ISNULL(SUM(m.NewSumAC), 0) TNewSumAC 
     FROM t_EOExp WITH (NOLOCK), deleted m
     WHERE t_EOExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_EOExpD] ON [t_EOExpD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 65 - Обновление итогов в главной таблице */
/* t_EOExpD - Заказ внешний: Формирование: Товар */
/* t_EOExp - Заказ внешний: Формирование: Заголовок */

  UPDATE r
  SET 
    r.TSumAC = r.TSumAC - q.TSumAC, 
    r.TNewSumAC = r.TNewSumAC - q.TNewSumAC
  FROM t_EOExp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumAC), 0) TSumAC,
       ISNULL(SUM(m.NewSumAC), 0) TNewSumAC 
     FROM t_EOExp WITH (NOLOCK), deleted m
     WHERE t_EOExp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_EOExpD] ON [t_EOExpD]
FOR INSERT AS
/* t_EOExpD - Заказ внешний: Формирование: Товар - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_EOExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_EOExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_EOExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_EOExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_EOExp a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11211, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Заказ внешний: Формирование'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_EOExpD ^ r_Prods - Проверка в PARENT */
/* Заказ внешний: Формирование: Товар ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_EOExpD', 0
      RETURN
    END

/* t_EOExpD ^ r_Secs - Проверка в PARENT */
/* Заказ внешний: Формирование: Товар ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_EOExpD', 0
      RETURN
    END

/* t_EOExpD ^ t_EOExp - Проверка в PARENT */
/* Заказ внешний: Формирование: Товар ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_EOExp))
    BEGIN
      EXEC z_RelationError 't_EOExp', 't_EOExpD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11211002, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_EOExpD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_EOExpD] ON [t_EOExpD]
FOR UPDATE AS
/* t_EOExpD - Заказ внешний: Формирование: Товар - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_EOExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_EOExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_EOExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_EOExp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_EOExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_EOExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_EOExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11211, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Заказ внешний: Формирование'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_EOExpD ^ r_Prods - Проверка в PARENT */
/* Заказ внешний: Формирование: Товар ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 't_EOExpD', 1
        RETURN
      END

/* t_EOExpD ^ r_Secs - Проверка в PARENT */
/* Заказ внешний: Формирование: Товар ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_EOExpD', 1
        RETURN
      END

/* t_EOExpD ^ t_EOExp - Проверка в PARENT */
/* Заказ внешний: Формирование: Товар ^ Заказ внешний: Формирование: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_EOExp))
      BEGIN
        EXEC z_RelationError 't_EOExp', 't_EOExpD', 1
        RETURN
      END

/* t_EOExpD ^ t_EOExpDD - Обновление CHILD */
/* Заказ внешний: Формирование: Товар ^ Заказ внешний: Формирование: Подробно - Обновление CHILD */
  IF UPDATE(AChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.AChID = i.AChID
          FROM t_EOExpDD a, inserted i, deleted d WHERE a.AChID = d.AChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_EOExpDD a, deleted d WHERE a.AChID = d.AChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Заказ внешний: Формирование: Товар'' => ''Заказ внешний: Формирование: Подробно''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11211002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11211002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(AChID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11211002 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11211002 AND l.PKValue = 
        '[' + cast(i.AChID as varchar(200)) + ']' AND i.AChID = d.AChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11211002, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11211002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11211002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11211002, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11211002 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11211002 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11211002, ChID, 
          '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11211002 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11211002 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11211002, ChID, 
          '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11211002, ChID, 
    '[' + cast(i.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_EOExpD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_EOExpD] ON [t_EOExpD]
FOR DELETE AS
/* t_EOExpD - Заказ внешний: Формирование: Товар - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_EOExp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_EOExp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_EOExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_EOExp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заказ внешний: Формирование: Товар (t_EOExpD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_EOExp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11211, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Заказ внешний: Формирование'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_EOExpD ^ t_EOExpDD - Удаление в CHILD */
/* Заказ внешний: Формирование: Товар ^ Заказ внешний: Формирование: Подробно - Удаление в CHILD */
  DELETE t_EOExpDD FROM t_EOExpDD a, deleted d WHERE a.AChID = d.AChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11211002 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11211002 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11211002, -ChID, 
    '[' + cast(d.AChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_EOExpD', N'Last', N'DELETE'
GO