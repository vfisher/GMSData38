CREATE TABLE [dbo].[p_CWTimeDD]
(
[AChID] [bigint] NOT NULL,
[DayPosID] [smallint] NOT NULL,
[WorkHours] [numeric] (21, 9) NULL,
[WTSignID] [tinyint] NOT NULL,
[EveningHours] [numeric] (21, 9) NOT NULL,
[NightHours] [numeric] (21, 9) NOT NULL,
[DayShiftCount] [tinyint] NOT NULL,
[DayPayFactor] [numeric] (21, 9) NOT NULL,
[OverTime] [numeric] (21, 9) NOT NULL,
[OverPayFactor] [numeric] (21, 9) NOT NULL,
[DaySaleSumCC] [numeric] (21, 9) NOT NULL,
[EvenSaleSumCC] [numeric] (21, 9) NOT NULL,
[NightSaleSumCC] [numeric] (21, 9) NOT NULL,
[OverSaleSumCC] [numeric] (21, 9) NOT NULL,
[OneHourSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_CWTimeDD] ON [dbo].[p_CWTimeDD]
FOR INSERT AS
/* p_CWTimeDD - Табель учета рабочего времени (Подробно) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_CWTime a, p_CWTimeD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_CWTime a, p_CWTimeD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_CWTime a, p_CWTimeD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_CWTime a, p_CWTimeD b, inserted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(15051, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Табель учета рабочего времени'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_CWTimeDD ^ p_CWTimeD - Проверка в PARENT */
/* Табель учета рабочего времени (Подробно) ^ Табель учета рабочего времени (Данные) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_CWTimeD))
    BEGIN
      EXEC z_RelationError 'p_CWTimeD', 'p_CWTimeDD', 0
      RETURN
    END

/* p_CWTimeDD ^ r_WTSigns - Проверка в PARENT */
/* Табель учета рабочего времени (Подробно) ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_CWTimeDD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15051003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_p_CWTimeDD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_CWTimeDD] ON [dbo].[p_CWTimeDD]
FOR UPDATE AS
/* p_CWTimeDD - Табель учета рабочего времени (Подробно) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_CWTime a, p_CWTimeD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_CWTime a, p_CWTimeD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_CWTime a, p_CWTimeD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_CWTime a, p_CWTimeD b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(15051, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Табель учета рабочего времени'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_CWTimeDD ^ p_CWTimeD - Проверка в PARENT */
/* Табель учета рабочего времени (Подробно) ^ Табель учета рабочего времени (Данные) - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_CWTimeD))
      BEGIN
        EXEC z_RelationError 'p_CWTimeD', 'p_CWTimeDD', 1
        RETURN
      END

/* p_CWTimeDD ^ r_WTSigns - Проверка в PARENT */
/* Табель учета рабочего времени (Подробно) ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF UPDATE(WTSignID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
      BEGIN
        EXEC z_RelationError 'r_WTSigns', 'p_CWTimeDD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID) OR UPDATE(DayPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, DayPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, DayPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15051003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15051003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15051003, 0, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15051003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DayPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15051003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DayPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15051003, 0, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15051003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_p_CWTimeDD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_CWTimeDD] ON [dbo].[p_CWTimeDD]
FOR DELETE AS
/* p_CWTimeDD - Табель учета рабочего времени (Подробно) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_CWTime a, p_CWTimeD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_CWTime a, p_CWTimeD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени (Подробно) (p_CWTimeDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_CWTime a, p_CWTimeD b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(15051, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Табель учета рабочего времени'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15051003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15051003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15051003, 0, 
    '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_p_CWTimeDD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[p_CWTimeDD] ADD CONSTRAINT [_pk_p_CWTimeDD] PRIMARY KEY CLUSTERED ([AChID], [DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[p_CWTimeDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DayPosID] ON [dbo].[p_CWTimeDD] ([DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WTSignID] ON [dbo].[p_CWTimeDD] ([WTSignID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[WorkHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[WTSignID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[EveningHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[NightHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayShiftCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverTime]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DaySaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[EvenSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[NightSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OneHourSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[WorkHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[WTSignID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[EveningHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[NightHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayShiftCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverTime]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DaySaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[EvenSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[NightSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OneHourSumCC]'
GO
