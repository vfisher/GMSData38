CREATE TABLE [dbo].[r_ProdMQ] (
  [ProdID] [int] NOT NULL,
  [UM] [varchar](50) NOT NULL,
  [Qty] [numeric](21, 9) NOT NULL,
  [Weight] [numeric](21, 9) NULL,
  [Notes] [varchar](200) NULL,
  [BarCode] [varchar](42) NOT NULL,
  [ProdBarCode] [varchar](42) NULL,
  [PLID] [int] NOT NULL,
  [TareWeight] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_r_ProdMQ] PRIMARY KEY CLUSTERED ([ProdID], [UM])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [BarCode]
  ON [dbo].[r_ProdMQ] ([BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [FindBarCode]
  ON [dbo].[r_ProdMQ] ([BarCode], [ProdID], [Qty])
  ON [PRIMARY]
GO

CREATE INDEX [PLID]
  ON [dbo].[r_ProdMQ] ([PLID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdBarCode]
  ON [dbo].[r_ProdMQ] ([ProdBarCode])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_ProdMQ] ([ProdID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ProdIDBarCode]
  ON [dbo].[r_ProdMQ] ([ProdID], [BarCode])
  ON [PRIMARY]
GO

CREATE INDEX [Qty]
  ON [dbo].[r_ProdMQ] ([Qty])
  ON [PRIMARY]
GO

CREATE INDEX [UM]
  ON [dbo].[r_ProdMQ] ([UM])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMQ.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMQ.Qty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMQ.Weight'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMQ.PLID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdMQ] ON [r_ProdMQ]
FOR INSERT AS
/* r_ProdMQ - Справочник товаров - Виды упаковок - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMQ ^ r_PLs - Проверка в PARENT */
/* Справочник товаров - Виды упаковок ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_ProdMQ', 0
      RETURN
    END

/* r_ProdMQ ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Виды упаковок ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMQ', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350004, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.UM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdMQ', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdMQ] ON [r_ProdMQ]
FOR UPDATE AS
/* r_ProdMQ - Справочник товаров - Виды упаковок - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMQ ^ r_PLs - Проверка в PARENT */
/* Справочник товаров - Виды упаковок ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'r_ProdMQ', 1
        RETURN
      END

/* r_ProdMQ ^ r_Prods - Проверка в PARENT */
/* Справочник товаров - Виды упаковок ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMQ', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldProdID int, @NewProdID int
  DECLARE @OldUM varchar(250), @NewUM varchar(250)

/* r_ProdMQ ^ t_VenD_UM - Обновление CHILD */
/* Справочник товаров - Виды упаковок ^ Инвентаризация товара: Виды упаковок - Обновление CHILD */
  IF UPDATE(ProdID) OR UPDATE(UM)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DetProdID = i.ProdID, a.DetUM = i.UM
          FROM t_VenD_UM a, inserted i, deleted d WHERE a.DetProdID = d.ProdID AND a.DetUM = d.UM
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(UM) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_VenD_UM SET t_VenD_UM.DetProdID = @NewProdID FROM t_VenD_UM, deleted d WHERE t_VenD_UM.DetProdID = @OldProdID AND t_VenD_UM.DetUM = d.UM
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT UM) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT UM) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldUM = UM FROM deleted
          SELECT TOP 1 @NewUM = UM FROM inserted
          UPDATE t_VenD_UM SET t_VenD_UM.DetUM = @NewUM FROM t_VenD_UM, deleted d WHERE t_VenD_UM.DetUM = @OldUM AND t_VenD_UM.DetProdID = d.ProdID
        END
      ELSE IF EXISTS (SELECT * FROM t_VenD_UM a, deleted d WHERE a.DetProdID = d.ProdID AND a.DetUM = d.UM)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Виды упаковок'' => ''Инвентаризация товара: Виды упаковок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_ProdMQ ^ t_VenI - Обновление CHILD */
/* Справочник товаров - Виды упаковок ^ Инвентаризация товара: Первичные данные - Обновление CHILD */
  IF UPDATE(ProdID) OR UPDATE(UM)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ProdID = i.ProdID, a.UM = i.UM
          FROM t_VenI a, inserted i, deleted d WHERE a.ProdID = d.ProdID AND a.UM = d.UM
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(UM) AND (SELECT COUNT(DISTINCT ProdID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ProdID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldProdID = ProdID FROM deleted
          SELECT TOP 1 @NewProdID = ProdID FROM inserted
          UPDATE t_VenI SET t_VenI.ProdID = @NewProdID FROM t_VenI, deleted d WHERE t_VenI.ProdID = @OldProdID AND t_VenI.UM = d.UM
        END
      ELSE IF NOT UPDATE(ProdID) AND (SELECT COUNT(DISTINCT UM) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT UM) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldUM = UM FROM deleted
          SELECT TOP 1 @NewUM = UM FROM inserted
          UPDATE t_VenI SET t_VenI.UM = @NewUM FROM t_VenI, deleted d WHERE t_VenI.UM = @OldUM AND t_VenI.ProdID = d.ProdID
        END
      ELSE IF EXISTS (SELECT * FROM t_VenI a, deleted d WHERE a.ProdID = d.ProdID AND a.UM = d.UM)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров - Виды упаковок'' => ''Инвентаризация товара: Первичные данные''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ProdID) OR UPDATE(UM)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, UM FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ProdID, UM FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.UM as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10350004 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.UM as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.UM as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10350004 AND l.PKValue = 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.UM as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10350004, m.ChID, 
          '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.UM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID
          DELETE FROM z_LogCreate WHERE TableCode = 10350004 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(UM as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10350004 AND PKValue IN (SELECT 
          '[' + cast(ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(UM as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10350004, m.ChID, 
          '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.UM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10350004, m.ChID, 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.UM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Prods m ON m.ProdID = i.ProdID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdMQ', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdMQ] ON [r_ProdMQ]
FOR DELETE AS
/* r_ProdMQ - Справочник товаров - Виды упаковок - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdMQ ^ t_VenD_UM - Проверка в CHILD */
/* Справочник товаров - Виды упаковок ^ Инвентаризация товара: Виды упаковок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenD_UM a WITH(NOLOCK), deleted d WHERE a.DetProdID = d.ProdID AND a.DetUM = d.UM)
    BEGIN
      EXEC z_RelationError 'r_ProdMQ', 't_VenD_UM', 3
      RETURN
    END

/* r_ProdMQ ^ t_VenI - Проверка в CHILD */
/* Справочник товаров - Виды упаковок ^ Инвентаризация товара: Первичные данные - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_VenI a WITH(NOLOCK), deleted d WHERE a.ProdID = d.ProdID AND a.UM = d.UM)
    BEGIN
      EXEC z_RelationError 'r_ProdMQ', 't_VenI', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10350004 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.UM as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10350004 AND m.PKValue = 
    '[' + cast(i.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.UM as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10350004, m.ChID, 
    '[' + cast(d.ProdID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.UM as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Prods m ON m.ProdID = d.ProdID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdMQ', N'Last', N'DELETE'
GO