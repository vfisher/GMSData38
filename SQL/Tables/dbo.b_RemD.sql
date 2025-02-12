CREATE TABLE [dbo].[b_RemD] (
  [OurID] [int] NOT NULL,
  [StockID] [int] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  CONSTRAINT [_pk_b_RemD] PRIMARY KEY CLUSTERED ([OurID], [StockID], [ProdID], [PPID])
)
ON [PRIMARY]
GO

CREATE INDEX [b_PInPb_RemD]
  ON [dbo].[b_RemD] ([ProdID], [PPID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[b_RemD] ([OurID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[b_RemD] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [Qty]
  ON [dbo].[b_RemD] ([Qty])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[b_RemD] ([StockID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RemD.OurID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RemD.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RemD.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RemD.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_RemD.Qty'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_RemD] ON [b_RemD]
FOR INSERT AS
/* b_RemD - ТМЦ: Остатки на дату (Данные) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_RemD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Остатки на дату (Данные) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'b_PInP', 'b_RemD', 0
      RETURN
    END

/* b_RemD ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Остатки на дату (Данные) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'b_RemD', 0
      RETURN
    END

/* b_RemD ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Остатки на дату (Данные) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'b_RemD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14915001, 0, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_RemD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_RemD] ON [b_RemD]
FOR UPDATE AS
/* b_RemD - ТМЦ: Остатки на дату (Данные) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* b_RemD ^ b_PInP - Проверка в PARENT */
/* ТМЦ: Остатки на дату (Данные) ^ Справочник товаров - Цены прихода Бухгалтерии - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM b_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'b_PInP', 'b_RemD', 1
        RETURN
      END

/* b_RemD ^ r_Ours - Проверка в PARENT */
/* ТМЦ: Остатки на дату (Данные) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'b_RemD', 1
        RETURN
      END

/* b_RemD ^ r_Stocks - Проверка в PARENT */
/* ТМЦ: Остатки на дату (Данные) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'b_RemD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(ProdID) OR UPDATE(PPID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, StockID, ProdID, PPID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, StockID, ProdID, PPID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14915001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14915001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14915001, 0, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14915001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14915001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14915001, 0, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14915001, 0, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_RemD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_RemD] ON [b_RemD]FOR DELETE AS/* b_RemD - ТМЦ: Остатки на дату (Данные) - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 14915001 AND m.PKValue =     '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.PPID as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 14915001 AND m.PKValue =     '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.PPID as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 14915001, 0,     '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.PPID as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_RemD', N'Last', N'DELETE'
GO