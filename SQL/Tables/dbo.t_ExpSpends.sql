﻿CREATE TABLE [dbo].[t_ExpSpends] (
  [ChID] [bigint] NOT NULL,
  [SpendCode] [int] NOT NULL,
  [SpendSumCC] [numeric](21, 9) NOT NULL CONSTRAINT [DF__t_ExpSpen__Spend__6B7C5242] DEFAULT (0),
  [SpendNotes] [varchar](200) NULL,
  CONSTRAINT [pk_t_ExpSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode])
)
ON [PRIMARY]
GO

CREATE INDEX [SpendCode]
  ON [dbo].[t_ExpSpends] ([SpendCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_t_ExpSpends] ON [t_ExpSpends]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 32 - Обновление итогов в главной таблице: Затраты */
/* t_ExpSpends - Расходный документ: Затраты */
/* t_Exp - Расходный документ: Заголовок */

  UPDATE r
  SET 
    r.TSpendSumCC = r.TSpendSumCC + q.TSpendSumCC
  FROM t_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SpendSumCC), 0) TSpendSumCC 
     FROM t_Exp WITH (NOLOCK), inserted m
     WHERE t_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_t_ExpSpends] ON [t_ExpSpends]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 32 - Обновление итогов в главной таблице: Затраты */
/* t_ExpSpends - Расходный документ: Затраты */
/* t_Exp - Расходный документ: Заголовок */

IF UPDATE(SpendSumCC)
BEGIN
  UPDATE r
  SET 
    r.TSpendSumCC = r.TSpendSumCC + q.TSpendSumCC
  FROM t_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SpendSumCC), 0) TSpendSumCC 
     FROM t_Exp WITH (NOLOCK), inserted m
     WHERE t_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TSpendSumCC = r.TSpendSumCC - q.TSpendSumCC
  FROM t_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SpendSumCC), 0) TSpendSumCC 
     FROM t_Exp WITH (NOLOCK), deleted m
     WHERE t_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_t_ExpSpends] ON [t_ExpSpends]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 32 - Обновление итогов в главной таблице: Затраты */
/* t_ExpSpends - Расходный документ: Затраты */
/* t_Exp - Расходный документ: Заголовок */

  UPDATE r
  SET 
    r.TSpendSumCC = r.TSpendSumCC - q.TSpendSumCC
  FROM t_Exp r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SpendSumCC), 0) TSpendSumCC 
     FROM t_Exp WITH (NOLOCK), deleted m
     WHERE t_Exp.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_ExpSpends] ON [t_ExpSpends]
FOR INSERT AS
/* t_ExpSpends - Расходный документ: Затраты - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Exp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Exp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Exp a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11015, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Расходный документ'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_ExpSpends ^ r_Spends - Проверка в PARENT */
/* Расходный документ: Затраты ^ Справочник затрат - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SpendCode NOT IN (SELECT SpendCode FROM r_Spends))
    BEGIN
      EXEC z_RelationError 'r_Spends', 't_ExpSpends', 0
      RETURN
    END

/* t_ExpSpends ^ t_Exp - Проверка в PARENT */
/* Расходный документ: Затраты ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Exp))
    BEGIN
      EXEC z_RelationError 't_Exp', 't_ExpSpends', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11015003, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_ExpSpends', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_ExpSpends] ON [t_ExpSpends]
FOR UPDATE AS
/* t_ExpSpends - Расходный документ: Затраты - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  t_Exp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Exp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exp a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Exp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11015, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Расходный документ'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* t_ExpSpends ^ r_Spends - Проверка в PARENT */
/* Расходный документ: Затраты ^ Справочник затрат - Проверка в PARENT */
  IF UPDATE(SpendCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SpendCode NOT IN (SELECT SpendCode FROM r_Spends))
      BEGIN
        EXEC z_RelationError 'r_Spends', 't_ExpSpends', 1
        RETURN
      END

/* t_ExpSpends ^ t_Exp - Проверка в PARENT */
/* Расходный документ: Затраты ^ Расходный документ: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM t_Exp))
      BEGIN
        EXEC z_RelationError 't_Exp', 't_ExpSpends', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11015003 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11015003 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SpendCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11015003 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SpendCode as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SpendCode = d.SpendCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11015003 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SpendCode as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SpendCode = d.SpendCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11015003, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11015003 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11015003 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11015003, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(SpendCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SpendCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SpendCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11015003 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11015003 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11015003, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11015003 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SpendCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11015003 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SpendCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11015003, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11015003, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_ExpSpends', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_ExpSpends] ON [t_ExpSpends]
FOR DELETE AS
/* t_ExpSpends - Расходный документ: Затраты - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  t_Exp a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  t_Exp a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  t_Exp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  t_Exp a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Расходный документ: Затраты (t_ExpSpends):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM t_Exp a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(11015, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Расходный документ'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11015003 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SpendCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11015003 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SpendCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11015003, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SpendCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_ExpSpends', N'Last', N'DELETE'
GO