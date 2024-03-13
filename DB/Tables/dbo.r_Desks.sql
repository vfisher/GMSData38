CREATE TABLE [dbo].[r_Desks]
(
[ChID] [bigint] NOT NULL,
[DeskCode] [int] NOT NULL,
[DeskName] [varchar] (200) NOT NULL,
[DeskLeft] [int] NOT NULL DEFAULT (0),
[DeskTop] [int] NOT NULL DEFAULT (0),
[DeskWidth] [int] NOT NULL DEFAULT (90),
[DeskHeight] [int] NOT NULL DEFAULT (50),
[DeskRound] [bit] NOT NULL DEFAULT (0),
[DeskGCode] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Desks] ON [dbo].[r_Desks]
FOR INSERT AS
/* r_Desks - Справочник ресторана: столики - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Desks ^ r_DeskG - Проверка в PARENT */
/* Справочник ресторана: столики ^ Справочник ресторана: столики: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DeskGCode NOT IN (SELECT DeskGCode FROM r_DeskG))
    BEGIN
      EXEC z_RelationError 'r_DeskG', 'r_Desks', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10601001, ChID, 
    '[' + cast(i.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_Desks]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Desks] ON [dbo].[r_Desks]
FOR UPDATE AS
/* r_Desks - Справочник ресторана: столики - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Desks ^ r_DeskG - Проверка в PARENT */
/* Справочник ресторана: столики ^ Справочник ресторана: столики: группы - Проверка в PARENT */
  IF UPDATE(DeskGCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DeskGCode NOT IN (SELECT DeskGCode FROM r_DeskG))
      BEGIN
        EXEC z_RelationError 'r_DeskG', 'r_Desks', 1
        RETURN
      END

/* r_Desks ^ t_DeskRes - Обновление CHILD */
/* Справочник ресторана: столики ^ Ресторан: Резервирование столиков - Обновление CHILD */
  IF UPDATE(DeskCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DeskCode = i.DeskCode
          FROM t_DeskRes a, inserted i, deleted d WHERE a.DeskCode = d.DeskCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_DeskRes a, deleted d WHERE a.DeskCode = d.DeskCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресторана: столики'' => ''Ресторан: Резервирование столиков''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Desks ^ t_Sale - Обновление CHILD */
/* Справочник ресторана: столики ^ Продажа товара оператором: Заголовок - Обновление CHILD */
  IF UPDATE(DeskCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DeskCode = i.DeskCode
          FROM t_Sale a, inserted i, deleted d WHERE a.DeskCode = d.DeskCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_Sale a, deleted d WHERE a.DeskCode = d.DeskCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресторана: столики'' => ''Продажа товара оператором: Заголовок''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Desks ^ t_SaleTemp - Обновление CHILD */
/* Справочник ресторана: столики ^ Временные данные продаж: Заголовок - Обновление CHILD */
  IF UPDATE(DeskCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DeskCode = i.DeskCode
          FROM t_SaleTemp a, inserted i, deleted d WHERE a.DeskCode = d.DeskCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_SaleTemp a, deleted d WHERE a.DeskCode = d.DeskCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ресторана: столики'' => ''Временные данные продаж: Заголовок''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10601001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10601001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DeskCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10601001 AND l.PKValue = 
        '[' + cast(i.DeskCode as varchar(200)) + ']' AND i.DeskCode = d.DeskCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10601001 AND l.PKValue = 
        '[' + cast(i.DeskCode as varchar(200)) + ']' AND i.DeskCode = d.DeskCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10601001, ChID, 
          '[' + cast(d.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10601001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10601001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10601001, ChID, 
          '[' + cast(i.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DeskCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DeskCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DeskCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DeskCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10601001 AND l.PKValue = 
          '[' + cast(d.DeskCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DeskCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10601001 AND l.PKValue = 
          '[' + cast(d.DeskCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10601001, ChID, 
          '[' + cast(d.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10601001 AND PKValue IN (SELECT 
          '[' + cast(DeskCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10601001 AND PKValue IN (SELECT 
          '[' + cast(DeskCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10601001, ChID, 
          '[' + cast(i.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10601001, ChID, 
    '[' + cast(i.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_Desks]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Desks] ON [dbo].[r_Desks]
FOR DELETE AS
/* r_Desks - Справочник ресторана: столики - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Desks ^ t_DeskRes - Проверка в CHILD */
/* Справочник ресторана: столики ^ Ресторан: Резервирование столиков - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_DeskRes a WITH(NOLOCK), deleted d WHERE a.DeskCode = d.DeskCode)
    BEGIN
      EXEC z_RelationError 'r_Desks', 't_DeskRes', 3
      RETURN
    END

/* r_Desks ^ t_Sale - Проверка в CHILD */
/* Справочник ресторана: столики ^ Продажа товара оператором: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_Sale a WITH(NOLOCK), deleted d WHERE a.DeskCode = d.DeskCode)
    BEGIN
      EXEC z_RelationError 'r_Desks', 't_Sale', 3
      RETURN
    END

/* r_Desks ^ t_SaleTemp - Проверка в CHILD */
/* Справочник ресторана: столики ^ Временные данные продаж: Заголовок - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_SaleTemp a WITH(NOLOCK), deleted d WHERE a.DeskCode = d.DeskCode)
    BEGIN
      EXEC z_RelationError 'r_Desks', 't_SaleTemp', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10601001 AND m.PKValue = 
    '[' + cast(i.DeskCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10601001 AND m.PKValue = 
    '[' + cast(i.DeskCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10601001, -ChID, 
    '[' + cast(d.DeskCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10601 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_Desks]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_Desks] ADD CONSTRAINT [pk_r_Desks] PRIMARY KEY CLUSTERED ([DeskCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Desks] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DeskName] ON [dbo].[r_Desks] ([DeskName]) ON [PRIMARY]
GO
