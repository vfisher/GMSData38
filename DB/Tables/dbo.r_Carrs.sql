CREATE TABLE [dbo].[r_Carrs]
(
[ChID] [bigint] NOT NULL,
[CarrID] [smallint] NOT NULL,
[CarrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[AssID] [int] NOT NULL,
[StateRegNo] [varchar] (42) NOT NULL,
[GarageNo] [varchar] (42) NULL,
[CarMark] [varchar] (42) NOT NULL,
[CarModel] [varchar] (42) NOT NULL,
[ProdID] [int] NOT NULL,
[ExpNorm] [numeric] (21, 9) NOT NULL,
[CarrCID] [smallint] NOT NULL,
[MotorNo] [varchar] (42) NULL,
[BodyNo] [varchar] (42) NOT NULL,
[TechnNo] [varchar] (42) NOT NULL,
[TechnMass] [numeric] (21, 9) NOT NULL,
[Tonnage] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Carrs] ON [dbo].[r_Carrs]
FOR INSERT AS
/* r_Carrs - Справочник транспорта - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Carrs ^ r_Assets - Проверка в PARENT */
/* Справочник транспорта ^ Справочник основных средств - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.AssID NOT IN (SELECT AssID FROM r_Assets))
    BEGIN
      EXEC z_RelationError 'r_Assets', 'r_Carrs', 0
      RETURN
    END

/* r_Carrs ^ r_CarrsC - Проверка в PARENT */
/* Справочник транспорта ^ Справочник транспорта: категории - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CarrCID NOT IN (SELECT CarrCID FROM r_CarrsC))
    BEGIN
      EXEC z_RelationError 'r_CarrsC', 'r_Carrs', 0
      RETURN
    END

/* r_Carrs ^ r_Prods - Проверка в PARENT */
/* Справочник транспорта ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_Carrs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10715001, ChID, 
    '[' + cast(i.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Carrs]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Carrs] ON [dbo].[r_Carrs]
FOR UPDATE AS
/* r_Carrs - Справочник транспорта - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Carrs ^ r_Assets - Проверка в PARENT */
/* Справочник транспорта ^ Справочник основных средств - Проверка в PARENT */
  IF UPDATE(AssID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.AssID NOT IN (SELECT AssID FROM r_Assets))
      BEGIN
        EXEC z_RelationError 'r_Assets', 'r_Carrs', 1
        RETURN
      END

/* r_Carrs ^ r_CarrsC - Проверка в PARENT */
/* Справочник транспорта ^ Справочник транспорта: категории - Проверка в PARENT */
  IF UPDATE(CarrCID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CarrCID NOT IN (SELECT CarrCID FROM r_CarrsC))
      BEGIN
        EXEC z_RelationError 'r_CarrsC', 'r_Carrs', 1
        RETURN
      END

/* r_Carrs ^ r_Prods - Проверка в PARENT */
/* Справочник транспорта ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_Carrs', 1
        RETURN
      END

/* r_Carrs ^ b_WBill - Обновление CHILD */
/* Справочник транспорта ^ Путевой лист - Обновление CHILD */
  IF UPDATE(CarrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CarrID = i.CarrID
          FROM b_WBill a, inserted i, deleted d WHERE a.CarrID = d.CarrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.CarrID = d.CarrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник транспорта'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Carrs ^ b_WBill - Обновление CHILD */
/* Справочник транспорта ^ Путевой лист - Обновление CHILD */
  IF UPDATE(CarrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TrailerID1 = i.CarrID
          FROM b_WBill a, inserted i, deleted d WHERE a.TrailerID1 = d.CarrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.TrailerID1 = d.CarrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник транспорта'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Carrs ^ b_WBill - Обновление CHILD */
/* Справочник транспорта ^ Путевой лист - Обновление CHILD */
  IF UPDATE(CarrID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.TrailerID2 = i.CarrID
          FROM b_WBill a, inserted i, deleted d WHERE a.TrailerID2 = d.CarrID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_WBill a, deleted d WHERE a.TrailerID2 = d.CarrID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник транспорта'' => ''Путевой лист''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10715001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10715001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CarrID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10715001 AND l.PKValue = 
        '[' + cast(i.CarrID as varchar(200)) + ']' AND i.CarrID = d.CarrID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10715001 AND l.PKValue = 
        '[' + cast(i.CarrID as varchar(200)) + ']' AND i.CarrID = d.CarrID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10715001, ChID, 
          '[' + cast(d.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10715001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10715001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10715001, ChID, 
          '[' + cast(i.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CarrID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CarrID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CarrID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CarrID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10715001 AND l.PKValue = 
          '[' + cast(d.CarrID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CarrID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10715001 AND l.PKValue = 
          '[' + cast(d.CarrID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10715001, ChID, 
          '[' + cast(d.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10715001 AND PKValue IN (SELECT 
          '[' + cast(CarrID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10715001 AND PKValue IN (SELECT 
          '[' + cast(CarrID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10715001, ChID, 
          '[' + cast(i.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10715001, ChID, 
    '[' + cast(i.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Carrs]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Carrs] ON [dbo].[r_Carrs]
FOR DELETE AS
/* r_Carrs - Справочник транспорта - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Carrs ^ b_WBill - Проверка в CHILD */
/* Справочник транспорта ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.CarrID = d.CarrID)
    BEGIN
      EXEC z_RelationError 'r_Carrs', 'b_WBill', 3
      RETURN
    END

/* r_Carrs ^ b_WBill - Проверка в CHILD */
/* Справочник транспорта ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.TrailerID1 = d.CarrID)
    BEGIN
      EXEC z_RelationError 'r_Carrs', 'b_WBill', 3
      RETURN
    END

/* r_Carrs ^ b_WBill - Проверка в CHILD */
/* Справочник транспорта ^ Путевой лист - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_WBill a WITH(NOLOCK), deleted d WHERE a.TrailerID2 = d.CarrID)
    BEGIN
      EXEC z_RelationError 'r_Carrs', 'b_WBill', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10715001 AND m.PKValue = 
    '[' + cast(i.CarrID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10715001 AND m.PKValue = 
    '[' + cast(i.CarrID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10715001, -ChID, 
    '[' + cast(d.CarrID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10715 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Carrs]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Carrs] ADD CONSTRAINT [pk_r_Carrs] PRIMARY KEY CLUSTERED ([CarrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AssID] ON [dbo].[r_Carrs] ([AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CarrCID] ON [dbo].[r_Carrs] ([CarrCID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CarrName] ON [dbo].[r_Carrs] ([CarrName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Carrs] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_Carrs] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[CarrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ExpNorm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[CarrCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[TechnMass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[Tonnage]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[CarrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[ExpNorm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[CarrCID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[TechnMass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Carrs].[Tonnage]'
GO
