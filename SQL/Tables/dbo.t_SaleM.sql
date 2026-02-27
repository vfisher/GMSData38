CREATE TABLE [dbo].[t_SaleM] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [ModCode] [int] NOT NULL,
  [ModQty] [int] NOT NULL,
  [SaleSrcPosID] [int] NULL,
  CONSTRAINT [pk_t_SaleM] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID], [ModCode])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_SaleM] ([ChID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SaleM] ON [t_SaleM]
FOR DELETE AS
/* t_SaleM - Продажа товара оператором: Модификаторы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, t_SaleD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, t_SaleD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, t_SaleD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, t_SaleD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Sale a, t_SaleD b, deleted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Продажа товара оператором'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SaleM', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SaleM] ON [t_SaleM]
FOR UPDATE AS
/* t_SaleM - Продажа товара оператором: Модификаторы - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, t_SaleD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, t_SaleD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, t_SaleD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, t_SaleD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, t_SaleD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, t_SaleD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Sale a, t_SaleD b, deleted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Продажа товара оператором'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SaleM ^ r_Mods - Проверка в PARENT */
/* Продажа товара оператором: Модификаторы ^ Справочник ресторана: модификаторы блюд - Проверка в PARENT */
  IF UPDATE(ModCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ModCode NOT IN (SELECT ModCode FROM r_Mods))
      BEGIN
        EXEC z_RelationError 'r_Mods', 't_SaleM', 1
        RETURN
      END

/* t_SaleM ^ t_SaleD - Проверка в PARENT */
/* Продажа товара оператором: Модификаторы ^ Продажа товара оператором: Продажи товара - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    IF (SELECT COUNT(*) FROM t_SaleD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_SaleD', 't_SaleM', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SaleM', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SaleM] ON [t_SaleM]
FOR INSERT AS
/* t_SaleM - Продажа товара оператором: Модификаторы - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, t_SaleD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Sale a, t_SaleD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Sale a, t_SaleD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Sale a, t_SaleD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Продажа товара оператором: Модификаторы'), 't_SaleM', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Sale a, t_SaleD b, inserted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.SrcPosID = b.SrcPosID) AND dbo.zf_CanChangeDoc(11035, a.ChID, a.StateCode) = 0)
    BEGIN
      DECLARE @Err2 varchar(200)
      SELECT @Err2 = FORMATMESSAGE(dbo.zf_Translate('Изменение документа ''%s'' в данном статусе запрещено.'), dbo.zf_Translate('Продажа товара оператором'))
      RAISERROR(@Err2, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_SaleM ^ r_Mods - Проверка в PARENT */
/* Продажа товара оператором: Модификаторы ^ Справочник ресторана: модификаторы блюд - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ModCode NOT IN (SELECT ModCode FROM r_Mods))
    BEGIN
      EXEC z_RelationError 'r_Mods', 't_SaleM', 0
      RETURN
    END

/* t_SaleM ^ t_SaleD - Проверка в PARENT */
/* Продажа товара оператором: Модификаторы ^ Продажа товара оператором: Продажи товара - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_SaleD m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.SrcPosID = m.SrcPosID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_SaleD', 't_SaleM', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SaleM', N'Last', N'INSERT'
GO



SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO