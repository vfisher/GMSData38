CREATE TABLE [dbo].[r_Mods] (
  [ChID] [bigint] NOT NULL,
  [ModCode] [int] NOT NULL,
  [ModName] [varchar](200) NOT NULL,
  [MinValue] [numeric](21, 9) NOT NULL,
  [MaxValue] [numeric](21, 9) NOT NULL,
  [PProdFilter] [varchar](4000) NOT NULL,
  [PCatFilter] [varchar](4000) NOT NULL,
  [PGrFilter] [varchar](4000) NOT NULL,
  [Notes] [varchar](200) NULL,
  [Required] [bit] NOT NULL DEFAULT (0),
  [IsProd] [bit] NOT NULL DEFAULT (0),
  [ProdID] [int] NOT NULL DEFAULT (0),
  [Color] [int] NOT NULL DEFAULT (0),
  [Picture] [image] NULL,
  [PGr1Filter] [varchar](4000) NULL,
  [PGr2Filter] [varchar](4000) NULL,
  [PGr3Filter] [varchar](4000) NULL,
  CONSTRAINT [pk_r_Mods] PRIMARY KEY CLUSTERED ([ModCode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Mods] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ModName]
  ON [dbo].[r_Mods] ([ModName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Mods] ON [r_Mods]
FOR INSERT AS
/* r_Mods - Справочник ресторана: модификаторы блюд - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10605001, ChID, 
    '[' + cast(i.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Mods', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Mods] ON [r_Mods]
FOR UPDATE AS
/* r_Mods - Справочник ресторана: модификаторы блюд - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Mods ^ t_SaleM - Обновление CHILD */
/* Справочник ресторана: модификаторы блюд ^ Продажа товара оператором: Модификаторы - Обновление CHILD */
  IF UPDATE(ModCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ModCode = i.ModCode
          FROM t_SaleM a, inserted i, deleted d WHERE a.ModCode = d.ModCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleM a, deleted d WHERE a.ModCode = d.ModCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресторана: модификаторы блюд'' => ''Продажа товара оператором: Модификаторы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Mods ^ t_SaleTempM - Обновление CHILD */
/* Справочник ресторана: модификаторы блюд ^ Временные данные продаж: Модификаторы - Обновление CHILD */
  IF UPDATE(ModCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.ModCode = i.ModCode
          FROM t_SaleTempM a, inserted i, deleted d WHERE a.ModCode = d.ModCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTempM a, deleted d WHERE a.ModCode = d.ModCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресторана: модификаторы блюд'' => ''Временные данные продаж: Модификаторы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10605001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10605001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ModCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10605001 AND l.PKValue = 
        '[' + cast(i.ModCode as varchar(200)) + ']' AND i.ModCode = d.ModCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10605001 AND l.PKValue = 
        '[' + cast(i.ModCode as varchar(200)) + ']' AND i.ModCode = d.ModCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10605001, ChID, 
          '[' + cast(d.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10605001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10605001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10605001, ChID, 
          '[' + cast(i.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ModCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ModCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ModCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ModCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10605001 AND l.PKValue = 
          '[' + cast(d.ModCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ModCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10605001 AND l.PKValue = 
          '[' + cast(d.ModCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10605001, ChID, 
          '[' + cast(d.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10605001 AND PKValue IN (SELECT 
          '[' + cast(ModCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10605001 AND PKValue IN (SELECT 
          '[' + cast(ModCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10605001, ChID, 
          '[' + cast(i.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10605001, ChID, 
    '[' + cast(i.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Mods', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Mods] ON [r_Mods]
FOR DELETE AS
/* r_Mods - Справочник ресторана: модификаторы блюд - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Mods ^ t_SaleM - Проверка в CHILD */
/* Справочник ресторана: модификаторы блюд ^ Продажа товара оператором: Модификаторы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleM a WITH(NOLOCK), deleted d WHERE a.ModCode = d.ModCode)
    BEGIN
      EXEC z_RelationError 'r_Mods', 't_SaleM', 3
      RETURN
    END

/* r_Mods ^ t_SaleTempM - Проверка в CHILD */
/* Справочник ресторана: модификаторы блюд ^ Временные данные продаж: Модификаторы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTempM a WITH(NOLOCK), deleted d WHERE a.ModCode = d.ModCode)
    BEGIN
      EXEC z_RelationError 'r_Mods', 't_SaleTempM', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10605001 AND m.PKValue = 
    '[' + cast(i.ModCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10605001 AND m.PKValue = 
    '[' + cast(i.ModCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10605001, -ChID, 
    '[' + cast(d.ModCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10605 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Mods', N'Last', N'DELETE'
GO