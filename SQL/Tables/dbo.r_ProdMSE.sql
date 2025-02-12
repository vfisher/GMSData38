CREATE TABLE [dbo].[r_ProdMSE] (
  [ProdID] [int] NOT NULL,
  [SProdID] [int] NOT NULL,
  [LExp] [varchar](255) NOT NULL,
  [EExp] [varchar](255) NOT NULL,
  [LExpSub] [varchar](255) NOT NULL,
  [EExpSub] [varchar](255) NOT NULL,
  [UseSubItems] [bit] NOT NULL,
  [UseSubDoc] [bit] NOT NULL,
  CONSTRAINT [_pk_r_ProdMSE] PRIMARY KEY CLUSTERED ([ProdID], [SProdID])
)
ON [PRIMARY]
GO

CREATE INDEX [EExp]
  ON [dbo].[r_ProdMSE] ([EExp])
  ON [PRIMARY]
GO

CREATE INDEX [EExpSub]
  ON [dbo].[r_ProdMSE] ([EExpSub])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_ProdMSE] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [RExp]
  ON [dbo].[r_ProdMSE] ([LExp])
  ON [PRIMARY]
GO

CREATE INDEX [RExpSub]
  ON [dbo].[r_ProdMSE] ([LExpSub])
  ON [PRIMARY]
GO

CREATE INDEX [SProdID]
  ON [dbo].[r_ProdMSE] ([SProdID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMSE.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMSE.SProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMSE.UseSubItems'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMSE.UseSubDoc'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdMSE] ON [r_ProdMSE]
FOR INSERT AS
/* r_ProdMSE - Справочник товаров - Комплектующие - Разукомплектация - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMSE ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Комплектующие - Разукомплектация ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMSE', 0
      RETURN
    END

/* r_ProdMSE ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Комплектующие - Разукомплектация ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMSE', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350012, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdMSE', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdMSE] ON [r_ProdMSE]
FOR UPDATE AS
/* r_ProdMSE - Справочник товаров - Комплектующие - Разукомплектация - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMSE ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Комплектующие - Разукомплектация ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMSE', 1
        RETURN
      END

/* r_ProdMSE ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Комплектующие - Разукомплектация ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(SProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMSE', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(SProdID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, SProdID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, SProdID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SProdID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350012 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SProdID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SProdID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350012 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SProdID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350012, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350012 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SProdID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350012 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SProdID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350012, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350012, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdMSE', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdMSE] ON [r_ProdMSE]
FOR DELETE AS
/* r_ProdMSE - Справочник товаров - Комплектующие - Разукомплектация - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350012 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SProdID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350012 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SProdID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350012, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SProdID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdMSE', N'Last', N'DELETE'
GO