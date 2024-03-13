CREATE TABLE [dbo].[c_SalD]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[SickAC] [numeric] (21, 9) NULL,
[HolidayAC] [numeric] (21, 9) NULL,
[SurChargeAC] [numeric] (21, 9) NULL,
[MChargeCC] [numeric] (21, 9) NOT NULL,
[MChargeCC1] [numeric] (21, 9) NOT NULL,
[MChargeCC2] [numeric] (21, 9) NOT NULL,
[AdvanceAC] [numeric] (21, 9) NULL,
[CreditIn] [numeric] (21, 9) NULL,
[CreditOut] [numeric] (21, 9) NULL,
[MoreCC] [numeric] (21, 9) NOT NULL,
[MoreCC1] [numeric] (21, 9) NOT NULL,
[MoreCC2] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[SumAC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__c_SalD__SumAC__4A8F946C] DEFAULT (0),
[OutAC] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_c_SalD] ON [dbo].[c_SalD]
FOR INSERT AS
/* c_SalD - Начисление денег служащим (Данные) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  c_Sal a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  c_Sal a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  c_Sal a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  c_Sal a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM c_Sal a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(12016, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Начисление денег служащим'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* c_SalD ^ c_Sal - Проверка в PARENT */
/* Начисление денег служащим (Данные) ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM c_Sal))
    BEGIN
      EXEC z_RelationError 'c_Sal', 'c_SalD', 0
      RETURN
    END

/* c_SalD ^ r_Currs - Проверка в PARENT */
/* Начисление денег служащим (Данные) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'c_SalD', 0
      RETURN
    END

/* c_SalD ^ r_Emps - Проверка в PARENT */
/* Начисление денег служащим (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'c_SalD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 12016002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_c_SalD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_c_SalD] ON [dbo].[c_SalD]
FOR UPDATE AS
/* c_SalD - Начисление денег служащим (Данные) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  c_Sal a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  c_Sal a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  c_Sal a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  c_Sal a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  c_Sal a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  c_Sal a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM c_Sal a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(12016, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Начисление денег служащим'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* c_SalD ^ c_Sal - Проверка в PARENT */
/* Начисление денег служащим (Данные) ^ Начисление денег служащим (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM c_Sal))
      BEGIN
        EXEC z_RelationError 'c_Sal', 'c_SalD', 1
        RETURN
      END

/* c_SalD ^ r_Currs - Проверка в PARENT */
/* Начисление денег служащим (Данные) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'c_SalD', 1
        RETURN
      END

/* c_SalD ^ r_Emps - Проверка в PARENT */
/* Начисление денег служащим (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'c_SalD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 12016002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 12016002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(EmpID) OR UPDATE(CurrID) OR UPDATE(KursMC))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 12016002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.KursMC as varchar(200)) + ']' AND i.ChID = d.ChID AND i.EmpID = d.EmpID AND i.CurrID = d.CurrID AND i.KursMC = d.KursMC
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 12016002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.KursMC as varchar(200)) + ']' AND i.ChID = d.ChID AND i.EmpID = d.EmpID AND i.CurrID = d.CurrID AND i.KursMC = d.KursMC
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 12016002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 12016002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 12016002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 12016002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(EmpID) OR UPDATE(CurrID) OR UPDATE(KursMC)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, EmpID, CurrID, KursMC FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, EmpID, CurrID, KursMC FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.KursMC as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 12016002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.KursMC as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.KursMC as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 12016002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.KursMC as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 12016002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 12016002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(KursMC as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 12016002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(KursMC as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 12016002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 12016002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_c_SalD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_c_SalD] ON [dbo].[c_SalD]
FOR DELETE AS
/* c_SalD - Начисление денег служащим (Данные) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  c_Sal a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  c_Sal a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  c_Sal a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  c_Sal a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Начисление денег служащим (Данные) (c_SalD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM c_Sal a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(12016, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Начисление денег служащим'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 12016002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.KursMC as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 12016002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.KursMC as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 12016002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.EmpID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.CurrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.KursMC as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_c_SalD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[c_SalD] ADD CONSTRAINT [_pk_c_SalD] PRIMARY KEY CLUSTERED ([ChID], [EmpID], [CurrID], [KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[c_SalD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[c_SalD] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[c_SalD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[c_SalD] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[c_SalD] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC] ON [dbo].[c_SalD] ([MChargeCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC1] ON [dbo].[c_SalD] ([MChargeCC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC2] ON [dbo].[c_SalD] ([MChargeCC2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC] ON [dbo].[c_SalD] ([MoreCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC1] ON [dbo].[c_SalD] ([MoreCC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC2] ON [dbo].[c_SalD] ([MoreCC2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[c_SalD] ([SumAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[SickAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[HolidayAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[SurChargeAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[AdvanceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CreditIn]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CreditOut]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[SickAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[HolidayAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[SurChargeAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[AdvanceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CreditIn]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CreditOut]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC2]'
GO
