CREATE TABLE [dbo].[p_PostStrucD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [SubID] [smallint] NOT NULL,
  [PostID] [int] NOT NULL,
  [StrucPostID] [int] NOT NULL,
  [VacTotal] [numeric](21, 9) NOT NULL,
  [VacOcc] [numeric](21, 9) NOT NULL,
  [VacFree] [numeric](21, 9) NOT NULL,
  [EDate] [smalldatetime] NULL,
  [StrucParentPostID] [int] NOT NULL,
  CONSTRAINT [pk_p_PostStrucD] PRIMARY KEY CLUSTERED ([ChID], [StrucPostID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[p_PostStrucD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [PostID]
  ON [dbo].[p_PostStrucD] ([PostID])
  ON [PRIMARY]
GO

CREATE INDEX [StrucParentPostID]
  ON [dbo].[p_PostStrucD] ([StrucParentPostID])
  ON [PRIMARY]
GO

CREATE INDEX [StrucPostID]
  ON [dbo].[p_PostStrucD] ([StrucPostID])
  ON [PRIMARY]
GO

CREATE INDEX [SubID]
  ON [dbo].[p_PostStrucD] ([SubID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_PostStrucD] ON [p_PostStrucD]
FOR INSERT AS
/* p_PostStrucD - Структура должностей (Список) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_PostStruc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_PostStruc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_PostStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_PostStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_PostStrucD ^ p_PostStruc - Проверка в PARENT */
/* Структура должностей (Список) ^ Структура должностей (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_PostStruc))
    BEGIN
      EXEC z_RelationError 'p_PostStruc', 'p_PostStrucD', 0
      RETURN
    END

/* p_PostStrucD ^ r_Posts - Проверка в PARENT */
/* Структура должностей (Список) ^ Справочник должностей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PostID NOT IN (SELECT PostID FROM r_Posts))
    BEGIN
      EXEC z_RelationError 'r_Posts', 'p_PostStrucD', 0
      RETURN
    END

/* p_PostStrucD ^ r_Subs - Проверка в PARENT */
/* Структура должностей (Список) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_PostStrucD', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_PostStrucD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_PostStrucD] ON [p_PostStrucD]
FOR UPDATE AS
/* p_PostStrucD - Структура должностей (Список) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_PostStruc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_PostStruc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_PostStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_PostStruc a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_PostStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_PostStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_PostStrucD ^ p_PostStruc - Проверка в PARENT */
/* Структура должностей (Список) ^ Структура должностей (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_PostStruc))
      BEGIN
        EXEC z_RelationError 'p_PostStruc', 'p_PostStrucD', 1
        RETURN
      END

/* p_PostStrucD ^ r_Posts - Проверка в PARENT */
/* Структура должностей (Список) ^ Справочник должностей - Проверка в PARENT */
  IF UPDATE(PostID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PostID NOT IN (SELECT PostID FROM r_Posts))
      BEGIN
        EXEC z_RelationError 'r_Posts', 'p_PostStrucD', 1
        RETURN
      END

/* p_PostStrucD ^ r_Subs - Проверка в PARENT */
/* Структура должностей (Список) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_PostStrucD', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_PostStrucD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_PostStrucD] ON [p_PostStrucD]
FOR DELETE AS
/* p_PostStrucD - Структура должностей (Список) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_PostStruc a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_PostStruc a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_PostStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_PostStruc a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Структура должностей (Список) (p_PostStrucD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_PostStrucD', N'Last', N'DELETE'
GO