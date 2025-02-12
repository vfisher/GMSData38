CREATE TABLE [dbo].[t_SPRecM] (
  [ChID] [bigint] NOT NULL,
  [CostCodeID1] [smallint] NOT NULL,
  [CostCodeID2] [smallint] NOT NULL,
  [CostCodeID3] [smallint] NOT NULL,
  [CostCodeID4] [smallint] NOT NULL,
  [CostCodeID5] [smallint] NOT NULL,
  [CostSumCC] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_t_SPRecM] PRIMARY KEY CLUSTERED ([ChID], [CostCodeID1], [CostCodeID2], [CostCodeID3], [CostCodeID4], [CostCodeID5])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[t_SPRecM] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [CostCodeID1]
  ON [dbo].[t_SPRecM] ([CostCodeID1])
  ON [PRIMARY]
GO

CREATE INDEX [CostCodeID2]
  ON [dbo].[t_SPRecM] ([CostCodeID2])
  ON [PRIMARY]
GO

CREATE INDEX [CostCodeID3]
  ON [dbo].[t_SPRecM] ([CostCodeID3])
  ON [PRIMARY]
GO

CREATE INDEX [CostCodeID4]
  ON [dbo].[t_SPRecM] ([CostCodeID4])
  ON [PRIMARY]
GO

CREATE INDEX [CostCodeID5]
  ON [dbo].[t_SPRecM] ([CostCodeID5])
  ON [PRIMARY]
GO

CREATE INDEX [CostSumCC]
  ON [dbo].[t_SPRecM] ([CostSumCC])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.CostCodeID1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.CostCodeID2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.CostCodeID3'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.CostCodeID4'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.CostCodeID5'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_SPRecM.CostSumCC'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_SPRecM] ON [t_SPRecM]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 79 - Обновление итогов в главной таблице */
/* t_SPRecM - Планирование: Комплектация: Общие Затраты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

  UPDATE r
  SET 
    r.TCostSumCC = r.TCostSumCC + q.TCostSumCC
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC), 0) TCostSumCC 
     FROM t_SPRec WITH (NOLOCK), inserted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_SPRecM] ON [t_SPRecM]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 79 - Обновление итогов в главной таблице */
/* t_SPRecM - Планирование: Комплектация: Общие Затраты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

IF UPDATE(CostSumCC)
BEGIN
  UPDATE r
  SET 
    r.TCostSumCC = r.TCostSumCC + q.TCostSumCC
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC), 0) TCostSumCC 
     FROM t_SPRec WITH (NOLOCK), inserted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TCostSumCC = r.TCostSumCC - q.TCostSumCC
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC), 0) TCostSumCC 
     FROM t_SPRec WITH (NOLOCK), deleted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_SPRecM] ON [t_SPRecM]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 79 - Обновление итогов в главной таблице */
/* t_SPRecM - Планирование: Комплектация: Общие Затраты */
/* t_SPRec - Планирование: Комплектация: Заголовок */

  UPDATE r
  SET 
    r.TCostSumCC = r.TCostSumCC - q.TCostSumCC
  FROM t_SPRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.CostSumCC), 0) TCostSumCC 
     FROM t_SPRec WITH (NOLOCK), deleted m
     WHERE t_SPRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_SPRecM] ON [t_SPRecM]
FOR INSERT AS
/* t_SPRecM - Планирование: Комплектация: Общие Затраты - INSERT TRIGGER */
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
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* t_SPRecM ^ r_Codes1 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 1 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
    BEGIN
      EXEC z_RelationError 'r_Codes1', 't_SPRecM', 0
      RETURN
    END

/* t_SPRecM ^ r_Codes2 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 2 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
    BEGIN
      EXEC z_RelationError 'r_Codes2', 't_SPRecM', 0
      RETURN
    END

/* t_SPRecM ^ r_Codes3 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 3 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
    BEGIN
      EXEC z_RelationError 'r_Codes3', 't_SPRecM', 0
      RETURN
    END

/* t_SPRecM ^ r_Codes4 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 4 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
    BEGIN
      EXEC z_RelationError 'r_Codes4', 't_SPRecM', 0
      RETURN
    END

/* t_SPRecM ^ r_Codes5 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 5 - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
    BEGIN
      EXEC z_RelationError 'r_Codes5', 't_SPRecM', 0
      RETURN
    END

/* t_SPRecM ^ t_SPRec - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SPRec))
    BEGIN
      EXEC z_RelationError 't_SPRec', 't_SPRecM', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11311002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_SPRecM', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_SPRecM] ON [t_SPRecM]
FOR UPDATE AS
/* t_SPRecM - Планирование: Комплектация: Общие Затраты - UPDATE TRIGGER */
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
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* t_SPRecM ^ r_Codes1 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 1 - Проверка в PARENT */
  IF UPDATE(CostCodeID1)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID1 NOT IN (SELECT CodeID1 FROM r_Codes1))
      BEGIN
        EXEC z_RelationError 'r_Codes1', 't_SPRecM', 1
        RETURN
      END

/* t_SPRecM ^ r_Codes2 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 2 - Проверка в PARENT */
  IF UPDATE(CostCodeID2)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID2 NOT IN (SELECT CodeID2 FROM r_Codes2))
      BEGIN
        EXEC z_RelationError 'r_Codes2', 't_SPRecM', 1
        RETURN
      END

/* t_SPRecM ^ r_Codes3 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 3 - Проверка в PARENT */
  IF UPDATE(CostCodeID3)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID3 NOT IN (SELECT CodeID3 FROM r_Codes3))
      BEGIN
        EXEC z_RelationError 'r_Codes3', 't_SPRecM', 1
        RETURN
      END

/* t_SPRecM ^ r_Codes4 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 4 - Проверка в PARENT */
  IF UPDATE(CostCodeID4)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID4 NOT IN (SELECT CodeID4 FROM r_Codes4))
      BEGIN
        EXEC z_RelationError 'r_Codes4', 't_SPRecM', 1
        RETURN
      END

/* t_SPRecM ^ r_Codes5 - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Справочник признаков 5 - Проверка в PARENT */
  IF UPDATE(CostCodeID5)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CostCodeID5 NOT IN (SELECT CodeID5 FROM r_Codes5))
      BEGIN
        EXEC z_RelationError 'r_Codes5', 't_SPRecM', 1
        RETURN
      END

/* t_SPRecM ^ t_SPRec - Проверка в PARENT */
/* Планирование: Комплектация: Общие Затраты ^ Планирование: Комплектация: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_SPRec))
      BEGIN
        EXEC z_RelationError 't_SPRec', 't_SPRecM', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11311002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11311002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(CostCodeID1) OR UPDATE(CostCodeID2) OR UPDATE(CostCodeID3) OR UPDATE(CostCodeID4) OR UPDATE(CostCodeID5))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11311002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID5 as varchar(200)) + ']' AND i.ChID = d.ChID AND i.CostCodeID1 = d.CostCodeID1 AND i.CostCodeID2 = d.CostCodeID2 AND i.CostCodeID3 = d.CostCodeID3 AND i.CostCodeID4 = d.CostCodeID4 AND i.CostCodeID5 = d.CostCodeID5
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11311002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CostCodeID5 as varchar(200)) + ']' AND i.ChID = d.ChID AND i.CostCodeID1 = d.CostCodeID1 AND i.CostCodeID2 = d.CostCodeID2 AND i.CostCodeID3 = d.CostCodeID3 AND i.CostCodeID4 = d.CostCodeID4 AND i.CostCodeID5 = d.CostCodeID5
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11311002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11311002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11311002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11311002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(CostCodeID1) OR UPDATE(CostCodeID2) OR UPDATE(CostCodeID3) OR UPDATE(CostCodeID4) OR UPDATE(CostCodeID5)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, CostCodeID1, CostCodeID2, CostCodeID3, CostCodeID4, CostCodeID5 FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, CostCodeID1, CostCodeID2, CostCodeID3, CostCodeID4, CostCodeID5 FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID5 as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11311002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID5 as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID5 as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11311002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID5 as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11311002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11311002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID5 as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11311002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CostCodeID5 as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11311002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11311002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_SPRecM', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_SPRecM] ON [t_SPRecM]
FOR DELETE AS
/* t_SPRecM - Планирование: Комплектация: Общие Затраты - DELETE TRIGGER */
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
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_SPRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Планирование: Комплектация: Общие Затраты (t_SPRecM):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11311002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID5 as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11311002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CostCodeID5 as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11311002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CostCodeID1 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CostCodeID2 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CostCodeID3 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CostCodeID4 as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CostCodeID5 as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_SPRecM', N'Last', N'DELETE'
GO