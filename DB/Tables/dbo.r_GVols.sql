CREATE TABLE [dbo].[r_GVols]
(
[ChID] [bigint] NOT NULL,
[GVolID] [int] NOT NULL,
[GVolName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_GVols] ON [dbo].[r_GVols]
FOR INSERT AS
/* r_GVols - Справочник проводок: виды аналитики - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10706001, ChID, 
    '[' + cast(i.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_GVols]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_GVols] ON [dbo].[r_GVols]
FOR UPDATE AS
/* r_GVols - Справочник проводок: виды аналитики - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_GVols ^ r_GOperD - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_VolID = i.GVolID
          FROM r_GOperD a, inserted i, deleted d WHERE a.C_VolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.C_VolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ r_GOperD - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Справочник проводок - Проводки - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_VolID = i.GVolID
          FROM r_GOperD a, inserted i, deleted d WHERE a.D_VolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GOperD a, deleted d WHERE a.D_VolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Справочник проводок - Проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ r_GAccs - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ План счетов - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.A_VolID = i.GVolID
          FROM r_GAccs a, inserted i, deleted d WHERE a.A_VolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_GAccs a, deleted d WHERE a.A_VolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''План счетов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ b_GTranD - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GVolID = i.GVolID
          FROM b_GTranD a, inserted i, deleted d WHERE a.C_GVolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.C_GVolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ b_GTranD - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Таблица проводок (Проводки) - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GVolID = i.GVolID
          FROM b_GTranD a, inserted i, deleted d WHERE a.D_GVolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_GTranD a, deleted d WHERE a.D_GVolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Таблица проводок (Проводки)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ b_TranH - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GVolID = i.GVolID
          FROM b_TranH a, inserted i, deleted d WHERE a.C_GVolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.C_GVolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ b_TranH - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Ручные проводки - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GVolID = i.GVolID
          FROM b_TranH a, inserted i, deleted d WHERE a.D_GVolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_TranH a, deleted d WHERE a.D_GVolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Ручные проводки''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ b_zInH - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.C_GVolID = i.GVolID
          FROM b_zInH a, inserted i, deleted d WHERE a.C_GVolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.C_GVolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Ручные входящие''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_GVols ^ b_zInH - Обновление CHILD */
/* Справочник проводок: виды аналитики ^ Ручные входящие - Обновление CHILD */
  IF UPDATE(GVolID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.D_GVolID = i.GVolID
          FROM b_zInH a, inserted i, deleted d WHERE a.D_GVolID = d.GVolID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM b_zInH a, deleted d WHERE a.D_GVolID = d.GVolID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник проводок: виды аналитики'' => ''Ручные входящие''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10706001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10706001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(GVolID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10706001 AND l.PKValue = 
        '[' + cast(i.GVolID as varchar(200)) + ']' AND i.GVolID = d.GVolID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10706001 AND l.PKValue = 
        '[' + cast(i.GVolID as varchar(200)) + ']' AND i.GVolID = d.GVolID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10706001, ChID, 
          '[' + cast(d.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10706001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10706001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10706001, ChID, 
          '[' + cast(i.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(GVolID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT GVolID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT GVolID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.GVolID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10706001 AND l.PKValue = 
          '[' + cast(d.GVolID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.GVolID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10706001 AND l.PKValue = 
          '[' + cast(d.GVolID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10706001, ChID, 
          '[' + cast(d.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10706001 AND PKValue IN (SELECT 
          '[' + cast(GVolID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10706001 AND PKValue IN (SELECT 
          '[' + cast(GVolID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10706001, ChID, 
          '[' + cast(i.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10706001, ChID, 
    '[' + cast(i.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_GVols]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_GVols] ON [dbo].[r_GVols]
FOR DELETE AS
/* r_GVols - Справочник проводок: виды аналитики - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_GVols ^ r_GOperD - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.C_VolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'r_GOperD', 3
      RETURN
    END

/* r_GVols ^ r_GOperD - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Справочник проводок - Проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GOperD a WITH(NOLOCK), deleted d WHERE a.D_VolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'r_GOperD', 3
      RETURN
    END

/* r_GVols ^ r_GAccs - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ План счетов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_GAccs a WITH(NOLOCK), deleted d WHERE a.A_VolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'r_GAccs', 3
      RETURN
    END

/* r_GVols ^ b_GTranD - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.C_GVolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_GTranD', 3
      RETURN
    END

/* r_GVols ^ b_GTranD - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Таблица проводок (Проводки) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_GTranD a WITH(NOLOCK), deleted d WHERE a.D_GVolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_GTranD', 3
      RETURN
    END

/* r_GVols ^ b_TranH - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.C_GVolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_TranH', 3
      RETURN
    END

/* r_GVols ^ b_TranH - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Ручные проводки - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_TranH a WITH(NOLOCK), deleted d WHERE a.D_GVolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_TranH', 3
      RETURN
    END

/* r_GVols ^ b_zInH - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.C_GVolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_zInH', 3
      RETURN
    END

/* r_GVols ^ b_zInH - Проверка в CHILD */
/* Справочник проводок: виды аналитики ^ Ручные входящие - Проверка в CHILD */
  IF EXISTS (SELECT * FROM b_zInH a WITH(NOLOCK), deleted d WHERE a.D_GVolID = d.GVolID)
    BEGIN
      EXEC z_RelationError 'r_GVols', 'b_zInH', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10706001 AND m.PKValue = 
    '[' + cast(i.GVolID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10706001 AND m.PKValue = 
    '[' + cast(i.GVolID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10706001, -ChID, 
    '[' + cast(d.GVolID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10706 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_GVols]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_GVols] ADD CONSTRAINT [pk_r_GVols] PRIMARY KEY CLUSTERED ([GVolID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_GVols] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GVolName] ON [dbo].[r_GVols] ([GVolName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GVols].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GVols].[GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GVols].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_GVols].[GVolID]'
GO
