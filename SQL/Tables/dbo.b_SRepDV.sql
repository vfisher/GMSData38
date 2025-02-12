CREATE TABLE [dbo].[b_SRepDV] (
  [ChID] [bigint] NOT NULL,
  [VSrcPosID] [int] NOT NULL,
  [DocDesc] [varchar](200) NOT NULL,
  [VCodeID1] [smallint] NOT NULL,
  [VCodeID2] [smallint] NOT NULL,
  [VCodeID3] [smallint] NOT NULL,
  [VCodeID4] [smallint] NOT NULL,
  [VCodeID5] [smallint] NOT NULL,
  [CostSumCC_nt] [numeric](21, 9) NOT NULL,
  [CostTaxSum] [numeric](21, 9) NOT NULL,
  [CostSumCC_wt] [numeric](21, 9) NOT NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [GPosTSum_wt] [numeric](21, 9) NOT NULL,
  [GPosTTaxSum] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_b_SRepDV] PRIMARY KEY CLUSTERED ([ChID], [VSrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_SRepDV] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_SRepDV] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID1]
  ON [dbo].[b_SRepDV] ([VCodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID2]
  ON [dbo].[b_SRepDV] ([VCodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID3]
  ON [dbo].[b_SRepDV] ([VCodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID4]
  ON [dbo].[b_SRepDV] ([VCodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [VCodeID5]
  ON [dbo].[b_SRepDV] ([VCodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [ZTotals]
  ON [dbo].[b_SRepDV] ([CostSumCC_wt], [CostTaxSum], [CostSumCC_nt])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.VSrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.VCodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.VCodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.VCodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.VCodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.VCodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.CostSumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.CostTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.CostSumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.GPosTSum_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_SRepDV.GPosTTaxSum'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_SRepDV] ON [b_SRepDV]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 211 - Обновление итогов в главной таблице: Ремонт (Общие затраты) */
/* b_SRepDV - Основные средства: Ремонт (Общие затраты) */
/* b_SRep - Основные средства: Ремонт (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt
  FROM b_SRep r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.CostTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.CostSumCC_wt), 0) TSumCC_wt 
     FROM b_SRep WITH (NOLOCK), inserted m
     WHERE b_SRep.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_SRepDV] ON [b_SRepDV]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 211 - Обновление итогов в главной таблице: Ремонт (Общие затраты) */
/* b_SRepDV - Основные средства: Ремонт (Общие затраты) */
/* b_SRep - Основные средства: Ремонт (Заголовок) */

IF UPDATE(CostSumCC_nt) OR UPDATE(CostTaxSum) OR UPDATE(CostSumCC_wt)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt
  FROM b_SRep r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.CostTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.CostSumCC_wt), 0) TSumCC_wt 
     FROM b_SRep WITH (NOLOCK), inserted m
     WHERE b_SRep.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt
  FROM b_SRep r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.CostTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.CostSumCC_wt), 0) TSumCC_wt 
     FROM b_SRep WITH (NOLOCK), deleted m
     WHERE b_SRep.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_SRepDV] ON [b_SRepDV]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 211 - Обновление итогов в главной таблице: Ремонт (Общие затраты) */
/* b_SRepDV - Основные средства: Ремонт (Общие затраты) */
/* b_SRep - Основные средства: Ремонт (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt
  FROM b_SRep r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.CostTaxSum), 0) TTaxSum,
       ISNULL(SUM(m.CostSumCC_wt), 0) TSumCC_wt 
     FROM b_SRep WITH (NOLOCK), deleted m
     WHERE b_SRep.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_SRepDV] ON [b_SRepDV]
FOR INSERT AS
/* b_SRepDV - Основные средства: Ремонт (Общие затраты) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_SRep a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_SRep a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_SRep a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_SRep a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_SRep a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14205, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Основные средства: Ремонт'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_SRepDV ^ b_SRep - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_SRep))
    BEGIN
      EXEC z_RelationError 'b_SRep', 'b_SRepDV', 0
      RETURN
    END

/* b_SRepDV ^ r_Codes1 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_SRepDV', 0
      RETURN
    END

/* b_SRepDV ^ r_Codes2 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_SRepDV', 0
      RETURN
    END

/* b_SRepDV ^ r_Codes3 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_SRepDV', 0
      RETURN
    END

/* b_SRepDV ^ r_Codes4 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_SRepDV', 0
      RETURN
    END

/* b_SRepDV ^ r_Codes5 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_SRepDV', 0
      RETURN
    END

/* b_SRepDV ^ r_GOpers - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_SRepDV', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14205002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_SRepDV', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_SRepDV] ON [b_SRepDV]
FOR UPDATE AS
/* b_SRepDV - Основные средства: Ремонт (Общие затраты) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_SRep a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_SRep a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_SRep a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_SRep a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_SRep a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_SRep a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_SRep a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14205, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Основные средства: Ремонт'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_SRepDV ^ b_SRep - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Основные средства: Ремонт (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_SRep))
      BEGIN
        EXEC z_RelationError 'b_SRep', 'b_SRepDV', 1
        RETURN
      END

/* b_SRepDV ^ r_Codes1 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(VCodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_SRepDV', 1
        RETURN
      END

/* b_SRepDV ^ r_Codes2 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(VCodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_SRepDV', 1
        RETURN
      END

/* b_SRepDV ^ r_Codes3 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(VCodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_SRepDV', 1
        RETURN
      END

/* b_SRepDV ^ r_Codes4 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(VCodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_SRepDV', 1
        RETURN
      END

/* b_SRepDV ^ r_Codes5 - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(VCodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.VCodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_SRepDV', 1
        RETURN
      END

/* b_SRepDV ^ r_GOpers - Проверка в PARENT */
/* Основные средства: Ремонт (Общие затраты) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_SRepDV', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14205002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14205002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(VSrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14205002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.VSrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.VSrcPosID = d.VSrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14205002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.VSrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.VSrcPosID = d.VSrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14205002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14205002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14205002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14205002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(VSrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, VSrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, VSrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VSrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14205002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VSrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VSrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14205002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VSrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14205002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14205002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(VSrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14205002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(VSrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14205002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14205002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_SRepDV', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_SRepDV] ON [b_SRepDV]
FOR DELETE AS
/* b_SRepDV - Основные средства: Ремонт (Общие затраты) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_SRep a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_SRep a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_SRep a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_SRep a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Основные средства: Ремонт (Общие затраты) (b_SRepDV):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_SRep a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14205, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Основные средства: Ремонт'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14205002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VSrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14205002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.VSrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14205002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.VSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_SRepDV', N'Last', N'DELETE'
GO