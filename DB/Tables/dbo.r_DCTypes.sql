CREATE TABLE [dbo].[r_DCTypes]
(
[ChID] [bigint] NOT NULL,
[DCTypeCode] [int] NOT NULL,
[DCTypeName] [varchar] (200) NOT NULL,
[Value1] [numeric] (21, 9) NOT NULL,
[Value2] [numeric] (21, 9) NOT NULL,
[Value3] [numeric] (21, 9) NOT NULL,
[InitSum] [numeric] (21, 9) NOT NULL,
[ProdID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[MaxQty] [int] NOT NULL DEFAULT (1),
[DCTypeGCode] [int] NOT NULL,
[DeactivateAfterUse] [bit] NOT NULL,
[NoManualDCardEnter] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_DCTypes] ON [dbo].[r_DCTypes]
FOR INSERT AS
/* r_DCTypes - Справочник дисконтных карт: типы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCTypes ^ r_DCTypeG - Проверка в PARENT */
/* Справочник дисконтных карт: типы ^ Справочник дисконтных карт: группы типов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeGCode NOT IN (SELECT DCTypeGCode FROM r_DCTypeG))
    BEGIN
      EXEC z_RelationError 'r_DCTypeG', 'r_DCTypes', 0
      RETURN
    END

/* r_DCTypes ^ r_Prods - Проверка в PARENT */
/* Справочник дисконтных карт: типы ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_DCTypes', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10392001, ChID, 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_DCTypes]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_DCTypes] ON [dbo].[r_DCTypes]
FOR UPDATE AS
/* r_DCTypes - Справочник дисконтных карт: типы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_DCTypes ^ r_DCTypeG - Проверка в PARENT */
/* Справочник дисконтных карт: типы ^ Справочник дисконтных карт: группы типов - Проверка в PARENT */
  IF UPDATE(DCTypeGCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DCTypeGCode NOT IN (SELECT DCTypeGCode FROM r_DCTypeG))
      BEGIN
        EXEC z_RelationError 'r_DCTypeG', 'r_DCTypes', 1
        RETURN
      END

/* r_DCTypes ^ r_Prods - Проверка в PARENT */
/* Справочник дисконтных карт: типы ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_DCTypes', 1
        RETURN
      END

/* r_DCTypes ^ r_DCTypeP - Обновление CHILD */
/* Справочник дисконтных карт: типы ^ Справочник дисконтных карт: Типы: Товары - Обновление CHILD */
  IF UPDATE(DCTypeCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DCTypeCode = i.DCTypeCode
          FROM r_DCTypeP a, inserted i, deleted d WHERE a.DCTypeCode = d.DCTypeCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCTypeP a, deleted d WHERE a.DCTypeCode = d.DCTypeCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник дисконтных карт: типы'' => ''Справочник дисконтных карт: Типы: Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_DCTypes ^ r_DCards - Обновление CHILD */
/* Справочник дисконтных карт: типы ^ Справочник дисконтных карт - Обновление CHILD */
  IF UPDATE(DCTypeCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DCTypeCode = i.DCTypeCode
          FROM r_DCards a, inserted i, deleted d WHERE a.DCTypeCode = d.DCTypeCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DCards a, deleted d WHERE a.DCTypeCode = d.DCTypeCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник дисконтных карт: типы'' => ''Справочник дисконтных карт''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10392001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10392001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DCTypeCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10392001 AND l.PKValue = 
        '[' + cast(i.DCTypeCode as varchar(200)) + ']' AND i.DCTypeCode = d.DCTypeCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10392001 AND l.PKValue = 
        '[' + cast(i.DCTypeCode as varchar(200)) + ']' AND i.DCTypeCode = d.DCTypeCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10392001, ChID, 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10392001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10392001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10392001, ChID, 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DCTypeCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DCTypeCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DCTypeCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10392001 AND l.PKValue = 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10392001 AND l.PKValue = 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10392001, ChID, 
          '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10392001 AND PKValue IN (SELECT 
          '[' + cast(DCTypeCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10392001 AND PKValue IN (SELECT 
          '[' + cast(DCTypeCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10392001, ChID, 
          '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10392001, ChID, 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_DCTypes]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_DCTypes] ON [dbo].[r_DCTypes]
FOR DELETE AS
/* r_DCTypes - Справочник дисконтных карт: типы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_DCTypes ^ r_DCTypeP - Удаление в CHILD */
/* Справочник дисконтных карт: типы ^ Справочник дисконтных карт: Типы: Товары - Удаление в CHILD */
  DELETE r_DCTypeP FROM r_DCTypeP a, deleted d WHERE a.DCTypeCode = d.DCTypeCode
  IF @@ERROR > 0 RETURN

/* r_DCTypes ^ r_DCards - Проверка в CHILD */
/* Справочник дисконтных карт: типы ^ Справочник дисконтных карт - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_DCards a WITH(NOLOCK), deleted d WHERE a.DCTypeCode = d.DCTypeCode)
    BEGIN
      EXEC z_RelationError 'r_DCTypes', 'r_DCards', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10392001 AND m.PKValue = 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10392001 AND m.PKValue = 
    '[' + cast(i.DCTypeCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10392001, -ChID, 
    '[' + cast(d.DCTypeCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10392 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_DCTypes]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_DCTypes] ADD CONSTRAINT [pk_r_DCTypes] PRIMARY KEY CLUSTERED ([DCTypeCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_DCTypes] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DCTypeName] ON [dbo].[r_DCTypes] ([DCTypeName]) ON [PRIMARY]
GO
