CREATE TABLE [dbo].[t_VenD_UM] (
  [ChID] [bigint] NOT NULL,
  [DetProdID] [int] NOT NULL,
  [DetUM] [varchar](50) NOT NULL,
  [QtyUM] [numeric](21, 9) NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [TQty] [numeric](21, 9) NOT NULL,
  CONSTRAINT [pk_t_VenD_UM] PRIMARY KEY CLUSTERED ([ChID], [DetProdID], [DetUM])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_VenD_UM] ON [t_VenD_UM]
FOR INSERT AS
/* t_VenD_UM - Инвентаризация товара: Виды упаковок - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, t_VenA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, t_VenA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, t_VenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, t_VenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Ven a, t_VenA b, inserted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND dbo.zf_CanChangeDoc(11022, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Инвентаризация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_VenD_UM ^ r_ProdMQ - Проверка в PARENT */
/* Инвентаризация товара: Виды упаковок ^ Справочник товаров - Виды упаковок - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_ProdMQ m WITH(NOLOCK), inserted i WHERE i.DetProdID = m.ProdID AND i.DetUM = m.UM) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_ProdMQ', 't_VenD_UM', 0
      RETURN
    END

/* t_VenD_UM ^ r_Prods - Проверка в PARENT */
/* Инвентаризация товара: Виды упаковок ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DetProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_VenD_UM', 0
      RETURN
    END

/* t_VenD_UM ^ t_VenA - Проверка в PARENT */
/* Инвентаризация товара: Виды упаковок ^ Инвентаризация товара: Товар - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_VenA m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DetProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_VenA', 't_VenD_UM', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11022006, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_VenD_UM', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_VenD_UM] ON [t_VenD_UM]
FOR UPDATE AS
/* t_VenD_UM - Инвентаризация товара: Виды упаковок - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, t_VenA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, t_VenA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, t_VenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, t_VenA b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, t_VenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, t_VenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Ven a, t_VenA b, deleted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND dbo.zf_CanChangeDoc(11022, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Инвентаризация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_VenD_UM ^ r_ProdMQ - Проверка в PARENT */
/* Инвентаризация товара: Виды упаковок ^ Справочник товаров - Виды упаковок - Проверка в PARENT */
  IF UPDATE(DetProdID) OR UPDATE(DetUM)
    IF (SELECT COUNT(*) FROM r_ProdMQ m WITH(NOLOCK), inserted i WHERE i.DetProdID = m.ProdID AND i.DetUM = m.UM) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_ProdMQ', 't_VenD_UM', 1
        RETURN
      END

/* t_VenD_UM ^ r_Prods - Проверка в PARENT */
/* Инвентаризация товара: Виды упаковок ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(DetProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DetProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 't_VenD_UM', 1
        RETURN
      END

/* t_VenD_UM ^ t_VenA - Проверка в PARENT */
/* Инвентаризация товара: Виды упаковок ^ Инвентаризация товара: Товар - Проверка в PARENT */
  IF UPDATE(ChID) OR UPDATE(DetProdID)
    IF (SELECT COUNT(*) FROM t_VenA m WITH(NOLOCK), inserted i WHERE i.ChID = m.ChID AND i.DetProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_VenA', 't_VenD_UM', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11022006 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11022006 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(DetProdID) OR UPDATE(DetUM))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11022006 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DetUM as varchar(200)) + ']' AND i.ChID = d.ChID AND i.DetProdID = d.DetProdID AND i.DetUM = d.DetUM
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11022006 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.DetUM as varchar(200)) + ']' AND i.ChID = d.ChID AND i.DetProdID = d.DetProdID AND i.DetUM = d.DetUM
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11022006, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11022006 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11022006 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11022006, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(DetProdID) OR UPDATE(DetUM)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, DetProdID, DetUM FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, DetProdID, DetUM FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetUM as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11022006 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetUM as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetUM as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11022006 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetUM as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11022006, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11022006 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetUM as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11022006 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetUM as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11022006, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11022006, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_VenD_UM', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_VenD_UM] ON [t_VenD_UM]
FOR DELETE AS
/* t_VenD_UM - Инвентаризация товара: Виды упаковок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, t_VenA b, inserted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Ven a, t_VenA b, deleted c  WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Ven a, t_VenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Ven a, t_VenA b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Инвентаризация товара: Виды упаковок (t_VenD_UM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Ven a, t_VenA b, deleted c WHERE (b.ChID = a.ChID) AND (c.ChID = b.ChID AND c.DetProdID = b.ProdID) AND dbo.zf_CanChangeDoc(11022, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Инвентаризация товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11022006 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetUM as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11022006 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetUM as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11022006, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DetProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DetUM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_VenD_UM', N'Last', N'DELETE'
GO