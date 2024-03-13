CREATE TABLE [dbo].[p_CWTimeDDExt]
(
[AChID] [bigint] NOT NULL,
[ShedID] [smallint] NOT NULL,
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
CREATE TRIGGER [dbo].[TRel1_Ins_p_CWTimeDDExt] ON [dbo].[p_CWTimeDDExt]
FOR INSERT AS
/* p_CWTimeDDExt - Табель учета рабочего времени: Подробно: Графики - INSERT TRIGGER */
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
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* p_CWTimeDDExt ^ p_CWTimeD - Проверка в PARENT */
/* Табель учета рабочего времени: Подробно: Графики ^ Табель учета рабочего времени (Данные) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_CWTimeD))
    BEGIN
      EXEC z_RelationError 'p_CWTimeD', 'p_CWTimeDDExt', 0
      RETURN
    END

/* p_CWTimeDDExt ^ r_Sheds - Проверка в PARENT */
/* Табель учета рабочего времени: Подробно: Графики ^ Справочник работ: графики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'p_CWTimeDDExt', 0
      RETURN
    END

/* p_CWTimeDDExt ^ r_WTSigns - Проверка в PARENT */
/* Табель учета рабочего времени: Подробно: Графики ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_CWTimeDDExt', 0
      RETURN
    END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_p_CWTimeDDExt]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_CWTimeDDExt] ON [dbo].[p_CWTimeDDExt]
FOR UPDATE AS
/* p_CWTimeDDExt - Табель учета рабочего времени: Подробно: Графики - UPDATE TRIGGER */
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
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* p_CWTimeDDExt ^ p_CWTimeD - Проверка в PARENT */
/* Табель учета рабочего времени: Подробно: Графики ^ Табель учета рабочего времени (Данные) - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_CWTimeD))
      BEGIN
        EXEC z_RelationError 'p_CWTimeD', 'p_CWTimeDDExt', 1
        RETURN
      END

/* p_CWTimeDDExt ^ r_Sheds - Проверка в PARENT */
/* Табель учета рабочего времени: Подробно: Графики ^ Справочник работ: графики - Проверка в PARENT */
  IF UPDATE(ShedID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
      BEGIN
        EXEC z_RelationError 'r_Sheds', 'p_CWTimeDDExt', 1
        RETURN
      END

/* p_CWTimeDDExt ^ r_WTSigns - Проверка в PARENT */
/* Табель учета рабочего времени: Подробно: Графики ^ Справочник работ: обозначения времени - Проверка в PARENT */
  IF UPDATE(WTSignID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WTSignID NOT IN (SELECT WTSignID FROM r_WTSigns))
      BEGIN
        EXEC z_RelationError 'r_WTSigns', 'p_CWTimeDDExt', 1
        RETURN
      END

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_p_CWTimeDDExt]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_CWTimeDDExt] ON [dbo].[p_CWTimeDDExt]
FOR DELETE AS
/* p_CWTimeDDExt - Табель учета рабочего времени: Подробно: Графики - DELETE TRIGGER */
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
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_CWTime a, p_CWTimeD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Табель учета рабочего времени: Подробно: Графики (p_CWTimeDDExt):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_p_CWTimeDDExt]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[p_CWTimeDDExt] ADD CONSTRAINT [pk_p_CWTimeDDExt] PRIMARY KEY CLUSTERED ([AChID], [ShedID], [DayPosID]) ON [PRIMARY]
GO
