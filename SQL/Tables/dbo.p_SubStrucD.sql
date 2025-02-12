CREATE TABLE [dbo].[p_SubStrucD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [ParentSubID] [smallint] NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_p_SubStrucD] PRIMARY KEY CLUSTERED ([ChID], [SubID], [ParentSubID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[p_SubStrucD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [Notes]
  ON [dbo].[p_SubStrucD] ([Notes])
  ON [PRIMARY]
GO

CREATE INDEX [ParentSubID]
  ON [dbo].[p_SubStrucD] ([ParentSubID])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_SubStrucD] ([SubID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_SubStrucD] ON [p_SubStrucD]
FOR INSERT AS
/* p_SubStrucD - Структура предприятия (Список) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_SubStruc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_SubStruc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_SubStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_SubStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_SubStrucD ^ p_SubStruc - Проверка в PARENT */
/* Структура предприятия (Список) ^ Структура предприятия (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_SubStruc))
    BEGIN
      EXEC z_RelationError 'p_SubStruc', 'p_SubStrucD', 0
      RETURN
    END

/* p_SubStrucD ^ r_Subs - Проверка в PARENT */
/* Структура предприятия (Список) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ParentSubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_SubStrucD', 0
      RETURN
    END

/* p_SubStrucD ^ r_Subs - Проверка в PARENT */
/* Структура предприятия (Список) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_SubStrucD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_SubStrucD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_SubStrucD] ON [p_SubStrucD]
FOR UPDATE AS
/* p_SubStrucD - Структура предприятия (Список) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_SubStruc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_SubStruc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_SubStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_SubStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_SubStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_SubStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_SubStrucD ^ p_SubStruc - Проверка в PARENT */
/* Структура предприятия (Список) ^ Структура предприятия (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_SubStruc))
      BEGIN
        EXEC z_RelationError 'p_SubStruc', 'p_SubStrucD', 1
        RETURN
      END

/* p_SubStrucD ^ r_Subs - Проверка в PARENT */
/* Структура предприятия (Список) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(ParentSubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ParentSubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_SubStrucD', 1
        RETURN
      END

/* p_SubStrucD ^ r_Subs - Проверка в PARENT */
/* Структура предприятия (Список) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_SubStrucD', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_SubStrucD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_SubStrucD] ON [p_SubStrucD]
FOR DELETE AS
/* p_SubStrucD - Структура предприятия (Список) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_SubStruc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_SubStruc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_SubStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_SubStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура предприятия (Список) (p_SubStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_SubStrucD', N'Last', N'DELETE'
GO