CREATE TABLE [dbo].[p_LRecDD]
(
[AChID] [bigint] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[PayTypeID] [smallint] NOT NULL,
[SumCC] [numeric] (21, 9) NOT NULL,
[IsDeduction] [bit] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[UniSocChargeRate] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedRate] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocChargeСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[BIncomeTaxCC] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_LRecDD] ON [dbo].[p_LRecDD]
FOR INSERT AS
/* p_LRecDD - Заработная плата: Начисление (Подробно) - INSERT TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_LRec a, p_LRecD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_LRec a, p_LRecD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LRec a, p_LRecD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_LRec a, p_LRecD b, inserted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(15061, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Заработная плата: Начисление'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_LRecDD ^ p_LRecD - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Заработная плата: Начисление (Данные) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_LRecD))
    BEGIN
      EXEC z_RelationError 'p_LRecD', 'p_LRecDD', 0
      RETURN
    END

/* p_LRecDD ^ r_Deps - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'p_LRecDD', 0
      RETURN
    END

/* p_LRecDD ^ r_GOpers - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'p_LRecDD', 0
      RETURN
    END

/* p_LRecDD ^ r_PayTypes - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeID NOT IN (SELECT PayTypeID FROM r_PayTypes))
    BEGIN
      EXEC z_RelationError 'r_PayTypes', 'p_LRecDD', 0
      RETURN
    END

/* p_LRecDD ^ r_Subs - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
    BEGIN
      EXEC z_RelationError 'r_Subs', 'p_LRecDD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15061003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_p_LRecDD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_LRecDD] ON [dbo].[p_LRecDD]
FOR UPDATE AS
/* p_LRecDD - Заработная плата: Начисление (Подробно) - UPDATE TRIGGER */
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
  SELECT DISTINCT OurID, 1 FROM  p_LRec a, p_LRecD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_LRec a, p_LRecD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LRec a, p_LRecD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_LRec a, p_LRecD b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(15061, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Заработная плата: Начисление'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* p_LRecDD ^ p_LRecD - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Заработная плата: Начисление (Данные) - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_LRecD))
      BEGIN
        EXEC z_RelationError 'p_LRecD', 'p_LRecDD', 1
        RETURN
      END

/* p_LRecDD ^ r_Deps - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'p_LRecDD', 1
        RETURN
      END

/* p_LRecDD ^ r_GOpers - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'p_LRecDD', 1
        RETURN
      END

/* p_LRecDD ^ r_PayTypes - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник выплат/удержаний - Проверка в PARENT */
  IF UPDATE(PayTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PayTypeID NOT IN (SELECT PayTypeID FROM r_PayTypes))
      BEGIN
        EXEC z_RelationError 'r_PayTypes', 'p_LRecDD', 1
        RETURN
      END

/* p_LRecDD ^ r_Subs - Проверка в PARENT */
/* Заработная плата: Начисление (Подробно) ^ Справочник работ: подразделения - Проверка в PARENT */
  IF UPDATE(SubID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SubID NOT IN (SELECT SubID FROM r_Subs))
      BEGIN
        EXEC z_RelationError 'r_Subs', 'p_LRecDD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(AChID) OR UPDATE(DetSrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, DetSrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT AChID, DetSrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15061003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15061003 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15061003, 0, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15061003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetSrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15061003 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetSrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15061003, 0, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15061003, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_p_LRecDD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_LRecDD] ON [dbo].[p_LRecDD]
FOR DELETE AS
/* p_LRecDD - Заработная плата: Начисление (Подробно) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  p_LRec a, p_LRecD b, inserted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  p_LRec a, p_LRecD b, deleted c  WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Подробно) (p_LRecDD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM p_LRec a, p_LRecD b, deleted c WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND dbo.zf_CanChangeDoc(15061, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Заработная плата: Начисление'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15061003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15061003 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15061003, 0, 
    '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_p_LRecDD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[p_LRecDD] ADD CONSTRAINT [_pk_p_LRecDD] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[p_LRecDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LRecDD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[p_LRecDD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayTypeID] ON [dbo].[p_LRecDD] ([PayTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_LRecDD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[PayTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[IsDeduction]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[PayTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[IsDeduction]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecDD].[GTranID]'
GO
