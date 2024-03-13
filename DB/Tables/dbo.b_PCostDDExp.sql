CREATE TABLE [dbo].[b_PCostDDExp]
(
[AChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DetSumCC_nt] [numeric] (21, 9) NOT NULL,
[DetTaxSum] [numeric] (21, 9) NOT NULL,
[DetSumCC_wt] [numeric] (21, 9) NOT NULL,
[DetNote] [varchar] (200) NOT NULL,
[DetCompID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_PCostDDExp] ON [dbo].[b_PCostDDExp]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 194 - Обновление итогов в главной таблице */
/* b_PCostDDExp - ТМЦ: Формирование себестоимости (Прочие расходы по позиции) */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */

  UPDATE r
  SET 
    r.ExpPosCostCC = r.ExpPosCostCC + q.ExpPosCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosCostCC 
     FROM b_PCostD WITH (NOLOCK), inserted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_PCostDDExp] ON [dbo].[b_PCostDDExp]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 194 - Обновление итогов в главной таблице */
/* b_PCostDDExp - ТМЦ: Формирование себестоимости (Прочие расходы по позиции) */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */

IF UPDATE(DetSumCC_nt)
BEGIN
  UPDATE r
  SET 
    r.ExpPosCostCC = r.ExpPosCostCC - q.ExpPosCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosCostCC 
     FROM b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.ExpPosCostCC = r.ExpPosCostCC + q.ExpPosCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosCostCC 
     FROM b_PCostD WITH (NOLOCK), inserted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_PCostDDExp] ON [dbo].[b_PCostDDExp]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 194 - Обновление итогов в главной таблице */
/* b_PCostDDExp - ТМЦ: Формирование себестоимости (Прочие расходы по позиции) */
/* b_PCostD - ТМЦ: Формирование себестоимости (ТМЦ) */

  UPDATE r
  SET 
    r.ExpPosCostCC = r.ExpPosCostCC - q.ExpPosCostCC
  FROM b_PCostD r, 
    (SELECT m.AChID, 
       ISNULL(SUM(m.DetSumCC_nt), 0) ExpPosCostCC 
     FROM b_PCostD WITH (NOLOCK), deleted m
     WHERE b_PCostD.AChID = m.AChID
     GROUP BY m.AChID) q
  WHERE q.AChID = r.AChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_PCostDDExp] ON [dbo].[b_PCostDDExp]
FOR INSERT AS
/* b_PCostDDExp - ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - INSERT TRIGGER */
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
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCostDDExp ^ b_PCostD - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Прочие расходы по позиции) ^ ТМЦ: Формирование себестоимости (ТМЦ) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM b_PCostD))
    BEGIN
      EXEC z_RelationError 'b_PCostD', 'b_PCostDDExp', 0
      RETURN
    END

/* b_PCostDDExp ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Прочие расходы по позиции) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_PCostDDExp', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_b_PCostDDExp]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_PCostDDExp] ON [dbo].[b_PCostDDExp]
FOR UPDATE AS
/* b_PCostDDExp - ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - UPDATE TRIGGER */
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
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_PCostDDExp ^ b_PCostD - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Прочие расходы по позиции) ^ ТМЦ: Формирование себестоимости (ТМЦ) - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM b_PCostD))
      BEGIN
        EXEC z_RelationError 'b_PCostD', 'b_PCostDDExp', 1
        RETURN
      END

/* b_PCostDDExp ^ r_GOpers - Проверка в PARENT */
/* ТМЦ: Формирование себестоимости (Прочие расходы по позиции) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_PCostDDExp', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_b_PCostDDExp]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_PCostDDExp] ON [dbo].[b_PCostDDExp]
FOR DELETE AS
/* b_PCostDDExp - ТМЦ: Формирование себестоимости (Прочие расходы по позиции) - DELETE TRIGGER */
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
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_PCost a, b_PCostD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'ТМЦ: Формирование себестоимости (Прочие расходы по позиции) (b_PCostDDExp):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_b_PCostDDExp]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[b_PCostDDExp] ADD CONSTRAINT [pk_b_PCostDDExp] PRIMARY KEY CLUSTERED ([AChID], [SrcPosID]) ON [PRIMARY]
GO
