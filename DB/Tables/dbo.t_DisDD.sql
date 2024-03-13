CREATE TABLE [dbo].[t_DisDD]
(
[AChID] [bigint] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[DetOurID] [int] NOT NULL,
[DetStockID] [int] NOT NULL,
[DetRemQty] [numeric] (21, 9) NOT NULL,
[DetNewQty] [numeric] (21, 9) NOT NULL,
[DetSupQty] [numeric] (21, 9) NOT NULL,
[DetExpQty] [numeric] (21, 9) NOT NULL,
[DestDisQty] [numeric] (21, 9) NOT NULL,
[DetSecID] [int] NOT NULL,
[DestDocID] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_DisDD] ON [dbo].[t_DisDD]
FOR INSERT AS
/* t_DisDD - Распределение товара: Подробно - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Dis a, t_DisD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Dis a, t_DisD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Dis a, t_DisD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Dis a, t_DisD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Dis a, t_DisD b, inserted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11231, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Распределение товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_DisDD ^ r_Ours - Проверка в PARENT */
/* Распределение товара: Подробно ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DetOurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_DisDD', 0
      RETURN
    END

/* t_DisDD ^ r_Secs - Проверка в PARENT */
/* Распределение товара: Подробно ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DetSecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_DisDD', 0
      RETURN
    END

/* t_DisDD ^ r_Stocks - Проверка в PARENT */
/* Распределение товара: Подробно ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DetStockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_DisDD', 0
      RETURN
    END

/* t_DisDD ^ t_DisD - Проверка в PARENT */
/* Распределение товара: Подробно ^ Распределение товара: Данные - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM t_DisD))
    BEGIN
      EXEC z_RelationError 't_DisD', 't_DisDD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11231003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_DisDD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_DisDD] ON [dbo].[t_DisDD]
FOR UPDATE AS
/* t_DisDD - Распределение товара: Подробно - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Dis a, t_DisD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Dis a, t_DisD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Dis a, t_DisD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Dis a, t_DisD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Dis a, t_DisD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Dis a, t_DisD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Dis a, t_DisD b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11231, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Распределение товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_DisDD ^ r_Ours - Проверка в PARENT */
/* Распределение товара: Подробно ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(DetOurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DetOurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_DisDD', 1
        RETURN
      END

/* t_DisDD ^ r_Secs - Проверка в PARENT */
/* Распределение товара: Подробно ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(DetSecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DetSecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_DisDD', 1
        RETURN
      END

/* t_DisDD ^ r_Stocks - Проверка в PARENT */
/* Распределение товара: Подробно ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(DetStockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DetStockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_DisDD', 1
        RETURN
      END

/* t_DisDD ^ t_DisD - Проверка в PARENT */
/* Распределение товара: Подробно ^ Распределение товара: Данные - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM t_DisD))
      BEGIN
        EXEC z_RelationError 't_DisD', 't_DisDD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID) OR UPDATE(DetSrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, DetSrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, DetSrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11231003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11231003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11231003, 0, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11231003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetSrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11231003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetSrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11231003, 0, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11231003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_DisDD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_DisDD] ON [dbo].[t_DisDD]
FOR DELETE AS
/* t_DisDD - Распределение товара: Подробно - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Dis a, t_DisD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Dis a, t_DisD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Dis a, t_DisD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Dis a, t_DisD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Распределение товара: Подробно (t_DisDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Dis a, t_DisD b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(11231, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Распределение товара'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11231003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11231003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11231003, 0, 
    '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_DisDD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_DisDD] ADD CONSTRAINT [_pk_t_DisDD] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_DisDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetOurID] ON [dbo].[t_DisDD] ([DetOurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetSecID] ON [dbo].[t_DisDD] ([DetSecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetStockID] ON [dbo].[t_DisDD] ([DetStockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetOurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetRemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSupQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetExpQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DestDisQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetOurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetRemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSupQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetExpQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DestDisQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_DisDD].[DetSecID]'
GO
