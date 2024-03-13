CREATE TABLE [dbo].[r_ProdMP]
(
[ProdID] [int] NOT NULL,
[PLID] [int] NOT NULL,
[PriceMC] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[CurrID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdMP] ON [dbo].[r_ProdMP]
FOR INSERT AS
/* r_ProdMP - Справочник товаров - Цены для прайс-листов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMP ^ r_Currs - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_ProdMP', 0
      RETURN
    END

/* r_ProdMP ^ r_Deps - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник отделов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
    BEGIN
      EXEC z_RelationError 'r_Deps', 'r_ProdMP', 0
      RETURN
    END

/* r_ProdMP ^ r_PLs - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_ProdMP', 0
      RETURN
    END

/* r_ProdMP ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMP', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350005, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdMP]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdMP] ON [dbo].[r_ProdMP]
FOR UPDATE AS
/* r_ProdMP - Справочник товаров - Цены для прайс-листов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMP ^ r_Currs - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'r_ProdMP', 1
        RETURN
      END

/* r_ProdMP ^ r_Deps - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник отделов - Проверка в PARENT */
  IF UPDATE(DepID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DepID NOT IN (SELECT DepID FROM r_Deps))
      BEGIN
        EXEC z_RelationError 'r_Deps', 'r_ProdMP', 1
        RETURN
      END

/* r_ProdMP ^ r_PLs - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'r_ProdMP', 1
        RETURN
      END

/* r_ProdMP ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Цены для прайс-листов ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMP', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldPLID int, @NewPLID int
  DECLARE @OldProdID int, @NewProdID int

/* r_ProdMP ^ r_ProdAC - Обновление CHILD */
/* Справочник товаров - Цены для прайс-листов ^ Справочник товаров - Автосоздание цен - Обновление CHILD */
  IF UPDATE(PLID) OR UPDATE(ProdID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.PLID = i.PLID, a.ProdID = i.ProdID
          FROM r_ProdAC a, inserted i, deleted d WHERE a.PLID = d.PLID AND a.ProdID = d.ProdID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT PLID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT PLID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldPLID = PLID FROM deleted
          SELECT TOP 1 @NewPLID = PLID FROM inserted
          UPDATE r_ProdAC SET r_ProdAC.PLID = @NewPLID FROM r_ProdAC, deleted d WHERE r_ProdAC.PLID = @OldPLID AND r_ProdAC.ProdID = d.ProdID
        END
      ELSE IF NOT UPDATE(PLID) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE r_ProdAC SET r_ProdAC.ProdID = @NewProdID FROM r_ProdAC, deleted d WHERE r_ProdAC.ProdID = @OldProdID AND r_ProdAC.PLID = d.PLID
        END
      ELSE IF EXISTS (SELECT * FROM r_ProdAC a, deleted d WHERE a.PLID = d.PLID AND a.ProdID = d.ProdID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Цены для прайс-листов'' => ''Справочник товаров - Автосоздание цен''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(PLID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, PLID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, PLID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PLID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350005 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PLID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PLID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350005 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PLID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350005, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350005 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PLID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350005 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PLID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350005, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350005, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdMP]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdMP] ON [dbo].[r_ProdMP]
FOR DELETE AS
/* r_ProdMP - Справочник товаров - Цены для прайс-листов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdMP ^ r_ProdAC - Проверка в CHILD */
/* Справочник товаров - Цены для прайс-листов ^ Справочник товаров - Автосоздание цен - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ProdAC a WITH(NOLOCK), deleted d WHERE a.PLID = d.PLID AND a.ProdID = d.ProdID)
    BEGIN
      EXEC z_RelationError 'r_ProdMP', 'r_ProdAC', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350005 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350005 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350005, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ProdMP]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ProdMP] ADD CONSTRAINT [_pk_r_ProdMP] PRIMARY KEY CLUSTERED ([ProdID], [PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[r_ProdMP] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_ProdMP] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceMC] ON [dbo].[r_ProdMP] ([PriceMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMP] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[CurrID]'
GO
