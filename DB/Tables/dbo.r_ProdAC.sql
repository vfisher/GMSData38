CREATE TABLE [dbo].[r_ProdAC]
(
[ProdID] [int] NOT NULL,
[PLID] [int] NOT NULL,
[ChPLID] [tinyint] NOT NULL,
[ExpE] [varchar] (255) NOT NULL,
[ExpR] [varchar] (255) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdAC] ON [dbo].[r_ProdAC]
FOR INSERT AS
/* r_ProdAC - Справочник товаров - Автосоздание цен - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdAC ^ r_PLs - Проверка в PARENT */
/* Справочник товаров - Автосоздание цен ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChPLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_ProdAC', 0
      RETURN
    END

/* r_ProdAC ^ r_ProdMP - Проверка в PARENT */
/* Справочник товаров - Автосоздание цен ^ Справочник товаров - Цены для прайс-листов - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_ProdMP m WITH(NOLOCK), inserted i WHERE i.PLID = m.PLID AND i.ProdID = m.ProdID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_ProdMP', 'r_ProdAC', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350009, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ChPLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_ProdAC]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdAC] ON [dbo].[r_ProdAC]
FOR UPDATE AS
/* r_ProdAC - Справочник товаров - Автосоздание цен - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdAC ^ r_PLs - Проверка в PARENT */
/* Справочник товаров - Автосоздание цен ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(ChPLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChPLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'r_ProdAC', 1
        RETURN
      END

/* r_ProdAC ^ r_ProdMP - Проверка в PARENT */
/* Справочник товаров - Автосоздание цен ^ Справочник товаров - Цены для прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID) OR UPDATE(ProdID)
    IF (SELECT COUNT(*) FROM r_ProdMP m WITH(NOLOCK), inserted i WHERE i.PLID = m.PLID AND i.ProdID = m.ProdID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_ProdMP', 'r_ProdAC', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(PLID) OR UPDATE(ChPLID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, PLID, ChPLID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, PLID, ChPLID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ChPLID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350009 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ChPLID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ChPLID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350009 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ChPLID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350009, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ChPLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350009 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ChPLID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350009 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ChPLID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350009, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ChPLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350009, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ChPLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_ProdAC]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdAC] ON [dbo].[r_ProdAC]
FOR DELETE AS
/* r_ProdAC - Справочник товаров - Автосоздание цен - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350009 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ChPLID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350009 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.PLID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ChPLID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350009, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.PLID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ChPLID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_ProdAC]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_ProdAC] ADD CONSTRAINT [_pk_r_ProdAC] PRIMARY KEY CLUSTERED ([ProdID], [PLID], [ChPLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChPLID] ON [dbo].[r_ProdAC] ([ChPLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExpE] ON [dbo].[r_ProdAC] ([ExpE]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExpR] ON [dbo].[r_ProdAC] ([ExpR]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_ProdAC] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_ProdMPr_ProdAC] ON [dbo].[r_ProdAC] ([ProdID], [PLID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[ChPLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdAC].[ChPLID]'
GO
