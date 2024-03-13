CREATE TABLE [dbo].[t_RemD]
(
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[SecID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[AccQty] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_RemD__AccQty__7015537F] DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_RemD] ON [dbo].[t_RemD]
FOR INSERT AS
/* t_RemD - Остатки товара на дату (Таблица) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_RemD ^ r_Ours - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 't_RemD', 0
      RETURN
    END

/* t_RemD ^ r_Secs - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 't_RemD', 0
      RETURN
    END

/* t_RemD ^ r_Stocks - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 't_RemD', 0
      RETURN
    END

/* t_RemD ^ t_PInP - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 't_PInP', 't_RemD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11904001, 0, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_t_RemD]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_RemD] ON [dbo].[t_RemD]
FOR UPDATE AS
/* t_RemD - Остатки товара на дату (Таблица) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_RemD ^ r_Ours - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 't_RemD', 1
        RETURN
      END

/* t_RemD ^ r_Secs - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 't_RemD', 1
        RETURN
      END

/* t_RemD ^ r_Stocks - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 't_RemD', 1
        RETURN
      END

/* t_RemD ^ t_PInP - Проверка в PARENT */
/* Остатки товара на дату (Таблица) ^ Справочник товаров - Цены прихода Торговли - Проверка в PARENT */
  IF UPDATE(PPID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM t_PInP m WITH(NOLOCK), inserted i WHERE i.PPID = m.PPID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 't_PInP', 't_RemD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(OurID) OR UPDATE(StockID) OR UPDATE(SecID) OR UPDATE(ProdID) OR UPDATE(PPID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, StockID, SecID, ProdID, PPID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT OurID, StockID, SecID, ProdID, PPID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11904001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11904001 AND l.PKValue = 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11904001, 0, 
          '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11904001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11904001 AND PKValue IN (SELECT 
          '[' + cast(OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PPID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11904001, 0, 
          '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11904001, 0, 
    '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_t_RemD]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_RemD] ON [dbo].[t_RemD]FOR DELETE AS/* t_RemD - Остатки товара на дату (Таблица) - DELETE TRIGGER */BEGIN  SET NOCOUNT ON/* Удаление регистрации создания записи */  DELETE z_LogCreate FROM z_LogCreate m, deleted i  WHERE m.TableCode = 11904001 AND m.PKValue =     '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.PPID as varchar(200)) + ']'/* Удаление регистрации изменения записи */  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i  WHERE m.TableCode = 11904001 AND m.PKValue =     '[' + cast(i.OurID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.StockID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.SecID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' +     '[' + cast(i.PPID as varchar(200)) + ']'/* Регистрация удаления записи */  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)  SELECT 11904001, 0,     '[' + cast(d.OurID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.StockID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.SecID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' +     '[' + cast(d.PPID as varchar(200)) + ']'          , dbo.zf_GetUserCode() FROM deleted dEND
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_RemD]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_RemD] ADD CONSTRAINT [_pk_t_RemD] PRIMARY KEY CLUSTERED ([OurID], [StockID], [SecID], [ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_RemD] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_RemD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_RemD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInP_Tt_RemD] ON [dbo].[t_RemD] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Qty] ON [dbo].[t_RemD] ([Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_RemD] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_RemD] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_RemD].[Qty]'
GO
