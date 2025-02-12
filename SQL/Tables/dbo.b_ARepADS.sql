CREATE TABLE [dbo].[b_ARepADS] (
  [ChID] [bigint] NOT NULL,
  [AssID] [int] NOT NULL,
  [ACodeID1] [smallint] NOT NULL,
  [ACodeID2] [smallint] NOT NULL,
  [ACodeID3] [smallint] NOT NULL,
  [ACodeID4] [smallint] NOT NULL,
  [ACodeID5] [smallint] NOT NULL,
  [UM] [varchar](50) NULL,
  [AKursMC] [numeric](21, 9) NOT NULL,
  [AKursCC] [numeric](21, 9) NOT NULL,
  [ACurrID] [smallint] NOT NULL,
  [ASumAC] [numeric](21, 9) NOT NULL,
  [SumCC_nt] [numeric](21, 9) NOT NULL,
  [TaxSum] [numeric](21, 9) NOT NULL,
  [SumCC_wt] [numeric](21, 9) NOT NULL,
  [DocDesc] [varchar](200) NULL,
  [BuyDate] [smalldatetime] NULL,
  [GTranID] [int] NOT NULL,
  [GOperID] [int] NOT NULL,
  [GSTSum_wt] [numeric](21, 9) NOT NULL,
  [GSTTaxSum] [numeric](21, 9) NOT NULL,
  [GSTAccID] [int] NOT NULL,
  CONSTRAINT [_pk_b_ARepADS] PRIMARY KEY CLUSTERED ([ChID], [AssID])
)
ON [PRIMARY]
GO

CREATE INDEX [ACodeID1]
  ON [dbo].[b_ARepADS] ([ACodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [ACodeID2]
  ON [dbo].[b_ARepADS] ([ACodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [ACodeID3]
  ON [dbo].[b_ARepADS] ([ACodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [ACodeID4]
  ON [dbo].[b_ARepADS] ([ACodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [ACodeID5]
  ON [dbo].[b_ARepADS] ([ACodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [ACurrID]
  ON [dbo].[b_ARepADS] ([ACurrID])
  ON [PRIMARY]
GO

CREATE INDEX [AKursCC]
  ON [dbo].[b_ARepADS] ([AKursCC])
  ON [PRIMARY]
GO

CREATE INDEX [AKursMC]
  ON [dbo].[b_ARepADS] ([AKursMC])
  ON [PRIMARY]
GO

CREATE INDEX [AssID]
  ON [dbo].[b_ARepADS] ([AssID])
  ON [PRIMARY]
GO

CREATE INDEX [ASumAC]
  ON [dbo].[b_ARepADS] ([ASumAC])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_ARepADS] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_ARepADS] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [GSTAccID]
  ON [dbo].[b_ARepADS] ([GSTAccID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.AssID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ACodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ACodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ACodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ACodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ACodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.AKursMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.AKursCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ACurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.ASumAC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.SumCC_nt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.TaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.SumCC_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.GTranID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.GSTSum_wt'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.GSTTaxSum'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_ARepADS.GSTAccID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_ARepADS] ON [b_ARepADS]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 106 - Обновление итогов в главной таблице */
/* b_ARepADS - Авансовый отчет валютный (Основные средства) */
/* b_ARepA - Авансовый отчет валютный (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumMC = r.TSumMC + q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.ASumAC / m.AKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), inserted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_ARepADS] ON [b_ARepADS]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 106 - Обновление итогов в главной таблице */
/* b_ARepADS - Авансовый отчет валютный (Основные средства) */
/* b_ARepA - Авансовый отчет валютный (Заголовок) */

IF UPDATE(SumCC_nt) OR UPDATE(TaxSum) OR UPDATE(SumCC_wt) OR UPDATE(ASumAC) OR UPDATE(AKursMC)
BEGIN
  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt + q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum + q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt + q.TSumCC_wt, 
    r.TSumMC = r.TSumMC + q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.ASumAC / m.AKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), inserted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumMC = r.TSumMC - q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.ASumAC / m.AKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), deleted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_ARepADS] ON [b_ARepADS]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 106 - Обновление итогов в главной таблице */
/* b_ARepADS - Авансовый отчет валютный (Основные средства) */
/* b_ARepA - Авансовый отчет валютный (Заголовок) */

  UPDATE r
  SET 
    r.TSumCC_nt = r.TSumCC_nt - q.TSumCC_nt, 
    r.TTaxSum = r.TTaxSum - q.TTaxSum, 
    r.TSumCC_wt = r.TSumCC_wt - q.TSumCC_wt, 
    r.TSumMC = r.TSumMC - q.TSumMC
  FROM b_ARepA r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt,
       ISNULL(SUM(m.ASumAC / m.AKursMC), 0) TSumMC 
     FROM b_ARepA WITH (NOLOCK), deleted m
     WHERE b_ARepA.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_ARepADS] ON [b_ARepADS]
FOR INSERT AS
/* b_ARepADS - Авансовый отчет валютный (Основные средства) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_ARepA a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14312, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Авансовый отчет валютный'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_ARepADS ^ b_ARepA - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_ARepA))
    BEGIN
      EXEC z_RelationError 'b_ARepA', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Assets - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Codes1 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Codes2 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Codes3 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Codes4 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Codes5 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_Currs - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ACurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_GAccs - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ План счетов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GSTAccID NOT IN (SELECT GAccID FROM r_GAccs))
    BEGIN
      EXEC z_RelationError 'r_GAccs', 'b_ARepADS', 0
      RETURN
    END

/* b_ARepADS ^ r_GOpers - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_ARepADS', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14312004, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_ARepADS', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_ARepADS] ON [b_ARepADS]
FOR UPDATE AS
/* b_ARepADS - Авансовый отчет валютный (Основные средства) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_ARepA a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14312, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Авансовый отчет валютный'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_ARepADS ^ b_ARepA - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Авансовый отчет валютный (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_ARepA))
      BEGIN
        EXEC z_RelationError 'b_ARepA', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Assets - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Codes1 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(ACodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Codes2 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(ACodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Codes3 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(ACodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Codes4 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(ACodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Codes5 - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(ACodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_Currs - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(ACurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ACurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_GAccs - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ План счетов - Проверка в PARENT */
  IF UPDATE(GSTAccID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GSTAccID NOT IN (SELECT GAccID FROM r_GAccs))
      BEGIN
        EXEC z_RelationError 'r_GAccs', 'b_ARepADS', 1
        RETURN
      END

/* b_ARepADS ^ r_GOpers - Проверка в PARENT */
/* Авансовый отчет валютный (Основные средства) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_ARepADS', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14312004 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14312004 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(AssID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14312004 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.AssID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.AssID = d.AssID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14312004 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.AssID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.AssID = d.AssID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14312004, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14312004 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14312004 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14312004, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(AssID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, AssID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, AssID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AssID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14312004 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AssID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AssID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14312004 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AssID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14312004, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14312004 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AssID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14312004 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(AssID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14312004, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14312004, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_ARepADS', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_ARepADS] ON [b_ARepADS]
FOR DELETE AS
/* b_ARepADS - Авансовый отчет валютный (Основные средства) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_ARepA a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_ARepA a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Авансовый отчет валютный (Основные средства) (b_ARepADS):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_ARepA a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14312, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Авансовый отчет валютный'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14312004 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AssID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14312004 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.AssID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14312004, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.AssID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_ARepADS', N'Last', N'DELETE'
GO