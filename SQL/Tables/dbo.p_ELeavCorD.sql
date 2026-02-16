CREATE TABLE [dbo].[p_ELeavCorD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [LeavType] [int] NOT NULL,
  [LeavCorType] [int] NOT NULL,
  [LeavCorReason] [tinyint] NOT NULL,
  [AgeBDate] [smalldatetime] NOT NULL,
  [AgeEDate] [smalldatetime] NOT NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [NewBDate] [smalldatetime] NOT NULL,
  [NewEDate] [smalldatetime] NOT NULL,
  [LeavCorDays] [smallint] NOT NULL,
  [CorDays] [smallint] NOT NULL,
  [CorBasis] [varchar](200) NULL,
  CONSTRAINT [pk_p_ELeavCorD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [AgeBDate]
  ON [dbo].[p_ELeavCorD] ([AgeBDate])
  ON [PRIMARY]
GO

CREATE INDEX [AgeEDate]
  ON [dbo].[p_ELeavCorD] ([AgeEDate])
  ON [PRIMARY]
GO

CREATE INDEX [BDate]
  ON [dbo].[p_ELeavCorD] ([BDate])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[p_ELeavCorD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [EDate]
  ON [dbo].[p_ELeavCorD] ([EDate])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[p_ELeavCorD] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [LeavCorReason]
  ON [dbo].[p_ELeavCorD] ([LeavCorReason])
  ON [PRIMARY]
GO

CREATE INDEX [LeavCorType]
  ON [dbo].[p_ELeavCorD] ([LeavCorType])
  ON [PRIMARY]
GO

CREATE INDEX [LeavType]
  ON [dbo].[p_ELeavCorD] ([LeavType])
  ON [PRIMARY]
GO

CREATE INDEX [NewBDate]
  ON [dbo].[p_ELeavCorD] ([NewBDate])
  ON [PRIMARY]
GO

CREATE INDEX [NewEDate]
  ON [dbo].[p_ELeavCorD] ([NewEDate])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_ELeavCorD] ON [p_ELeavCorD]
FOR DELETE AS
/* p_ELeavCorD - Приказ: Отпуск: Корректировка (Данные) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_ELeavCor a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_ELeavCor a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeavCor a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeavCor a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_ELeavCorD', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_ELeavCorD] ON [p_ELeavCorD]
FOR UPDATE AS
/* p_ELeavCorD - Приказ: Отпуск: Корректировка (Данные) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_ELeavCor a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_ELeavCor a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeavCor a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeavCor a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeavCor a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeavCor a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Дата или одна из дат изменяемого документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_ELeavCorD ^ p_ELeavCor - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_ELeavCor))
      BEGIN
        EXEC z_RelationError 'p_ELeavCor', 'p_ELeavCorD', 1
        RETURN
      END

/* p_ELeavCorD ^ r_Emps - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'p_ELeavCorD', 1
        RETURN
      END

/* p_ELeavCorD ^ r_Uni - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(LeavCorType)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LeavCorType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10059))
      BEGIN
        EXEC z_RelationErrorUni 'p_ELeavCorD', 10059, 1
        RETURN
      END

/* p_ELeavCorD ^ r_Uni - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Справочник универсальный - Проверка в PARENT */
  IF UPDATE(LeavCorReason)
    IF EXISTS (SELECT * FROM inserted i WHERE i.LeavCorReason NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10060))
      BEGIN
        EXEC z_RelationErrorUni 'p_ELeavCorD', 10060, 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_ELeavCorD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_ELeavCorD] ON [p_ELeavCorD]
FOR INSERT AS
/* p_ELeavCorD - Приказ: Отпуск: Корректировка (Данные) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_ELeavCor a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_ELeavCor a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_ELeavCor a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа меньше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID AS varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_ELeavCor a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = FORMATMESSAGE('%s (%s):' + CHAR(13) + dbo.zf_Translate('Новая дата или одна из дат документа больше даты открытого периода %s для фирмы с кодом %s') ,dbo.zf_Translate('Приказ: Отпуск: Корректировка (Данные)'), 'p_ELeavCorD', dbo.zf_DatetoStr(@ADate), CAST(@OurID as varchar(10)))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_ELeavCorD ^ p_ELeavCor - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Приказ: Отпуск: Корректировка (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM p_ELeavCor))
    BEGIN
      EXEC z_RelationError 'p_ELeavCor', 'p_ELeavCorD', 0
      RETURN
    END

/* p_ELeavCorD ^ r_Emps - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'p_ELeavCorD', 0
      RETURN
    END

/* p_ELeavCorD ^ r_Uni - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LeavCorType NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10059))
    BEGIN
      EXEC z_RelationErrorUni 'p_ELeavCorD', 10059, 0
      RETURN
    END

/* p_ELeavCorD ^ r_Uni - Проверка в PARENT */
/* Приказ: Отпуск: Корректировка (Данные) ^ Справочник универсальный - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.LeavCorReason NOT IN (SELECT RefID FROM r_Uni  WHERE RefTypeID = 10060))
    BEGIN
      EXEC z_RelationErrorUni 'p_ELeavCorD', 10060, 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_ELeavCorD', N'Last', N'INSERT'
GO























SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO