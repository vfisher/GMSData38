CREATE TABLE [dbo].[p_LRecDCorCR] (
  [AChID] [bigint] NOT NULL,
  [YearID] [smallint] NOT NULL,
  [MonthID] [smallint] NOT NULL,
  [PensCCCor] [numeric](21, 9) NOT NULL,
  [UnEmployCCCor] [numeric](21, 9) NOT NULL,
  [SocInsureCCCor] [numeric](21, 9) NOT NULL,
  [IncomeTaxCCCor] [numeric](21, 9) NOT NULL,
  [TotPensCCCor] [numeric](21, 9) NOT NULL,
  [TotSocInsureCCCor] [numeric](21, 9) NOT NULL,
  [TotUnEmployCCCor] [numeric](21, 9) NOT NULL,
  [TotAccidentCCCor] [numeric](21, 9) NOT NULL,
  [UniSocChargeССCor] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocDedССCor] [numeric](21, 9) NOT NULL DEFAULT (0),
  [DetSrcPosID] [int] NOT NULL CONSTRAINT [DF__p_LRecDCo__DetSr__1BE2BFD7] DEFAULT (0),
  [Notes] [varchar](250) NULL,
  [MilitaryTaxCCCor] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [pk_p_LRecDCorCR] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_p_LRecDCorCR] ON [p_LRecDCorCR]
FOR INSERT AS
/* p_LRecDCorCR - Заработная плата: Начисление (Корректировка начислений и удержаний) - INSERT TRIGGER */
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
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* p_LRecDCorCR ^ p_LRecD - Проверка в PARENT */
/* Заработная плата: Начисление (Корректировка начислений и удержаний) ^ Заработная плата: Начисление (Данные) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_LRecD))
    BEGIN
      EXEC z_RelationError 'p_LRecD', 'p_LRecDCorCR', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 15061007, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_p_LRecDCorCR', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_p_LRecDCorCR] ON [p_LRecDCorCR]
FOR UPDATE AS
/* p_LRecDCorCR - Заработная плата: Начисление (Корректировка начислений и удержаний) - UPDATE TRIGGER */
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
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, inserted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* p_LRecDCorCR ^ p_LRecD - Проверка в PARENT */
/* Заработная плата: Начисление (Корректировка начислений и удержаний) ^ Заработная плата: Начисление (Данные) - Проверка в PARENT */
  IF UPDATE(AChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AChID NOT IN (SELECT AChID FROM p_LRecD))
      BEGIN
        EXEC z_RelationError 'p_LRecD', 'p_LRecDCorCR', 1
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 15061007 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 15061007 AND l.PKValue = 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 15061007, 0, 
          '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 15061007 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetSrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 15061007 AND PKValue IN (SELECT 
          '[' + cast(AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DetSrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 15061007, 0, 
          '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 15061007, 0, 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_p_LRecDCorCR', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_p_LRecDCorCR] ON [p_LRecDCorCR]
FOR DELETE AS
/* p_LRecDCorCR - Заработная плата: Начисление (Корректировка начислений и удержаний) - DELETE TRIGGER */
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
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  p_LRec a, p_LRecD b, deleted c , @OpenAges AS t WHERE (b.ChID = a.ChID) AND (c.AChID = b.AChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Заработная плата: Начисление (Корректировка начислений и удержаний) (p_LRecDCorCR):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
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

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 15061007 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 15061007 AND m.PKValue = 
    '[' + cast(i.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DetSrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 15061007, 0, 
    '[' + cast(d.AChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DetSrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_p_LRecDCorCR', N'Last', N'DELETE'
GO