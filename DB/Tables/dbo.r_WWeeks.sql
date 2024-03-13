CREATE TABLE [dbo].[r_WWeeks]
(
[ChID] [bigint] NOT NULL,
[WWeekTypeID] [tinyint] NOT NULL,
[WWeekName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[IsInt] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_WWeeks] ON [dbo].[r_WWeeks]
FOR INSERT AS
/* r_WWeeks - Справочник работ: типы недели - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10094001, ChID, 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel1_Ins_r_WWeeks]', 'last', 'insert', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_WWeeks] ON [dbo].[r_WWeeks]
FOR UPDATE AS
/* r_WWeeks - Справочник работ: типы недели - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WWeeks ^ r_NormMH - Обновление CHILD */
/* Справочник работ: типы недели ^ Справочник работ: нормы времени - Количество рабочих часов - Обновление CHILD */
  IF UPDATE(WWeekTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WWeekTypeID = i.WWeekTypeID
          FROM r_NormMH a, inserted i, deleted d WHERE a.WWeekTypeID = d.WWeekTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_NormMH a, deleted d WHERE a.WWeekTypeID = d.WWeekTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: типы недели'' => ''Справочник работ: нормы времени - Количество рабочих часов''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_WWeeks ^ r_Sheds - Обновление CHILD */
/* Справочник работ: типы недели ^ Справочник работ: графики - Обновление CHILD */
  IF UPDATE(WWeekTypeID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WWeekTypeID = i.WWeekTypeID
          FROM r_Sheds a, inserted i, deleted d WHERE a.WWeekTypeID = d.WWeekTypeID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Sheds a, deleted d WHERE a.WWeekTypeID = d.WWeekTypeID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: типы недели'' => ''Справочник работ: графики''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10094001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10094001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(WWeekTypeID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10094001 AND l.PKValue = 
        '[' + cast(i.WWeekTypeID as varchar(200)) + ']' AND i.WWeekTypeID = d.WWeekTypeID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10094001 AND l.PKValue = 
        '[' + cast(i.WWeekTypeID as varchar(200)) + ']' AND i.WWeekTypeID = d.WWeekTypeID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10094001, ChID, 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10094001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10094001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10094001, ChID, 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(WWeekTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WWeekTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WWeekTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10094001 AND l.PKValue = 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10094001 AND l.PKValue = 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10094001, ChID, 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10094001 AND PKValue IN (SELECT 
          '[' + cast(WWeekTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10094001 AND PKValue IN (SELECT 
          '[' + cast(WWeekTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10094001, ChID, 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10094001, ChID, 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO
EXEC sp_settriggerorder N'[dbo].[TRel2_Upd_r_WWeeks]', 'last', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_WWeeks] ON [dbo].[r_WWeeks]
FOR DELETE AS
/* r_WWeeks - Справочник работ: типы недели - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_WWeeks ^ r_NormMH - Проверка в CHILD */
/* Справочник работ: типы недели ^ Справочник работ: нормы времени - Количество рабочих часов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_NormMH a WITH(NOLOCK), deleted d WHERE a.WWeekTypeID = d.WWeekTypeID)
    BEGIN
      EXEC z_RelationError 'r_WWeeks', 'r_NormMH', 3
      RETURN
    END

/* r_WWeeks ^ r_Sheds - Проверка в CHILD */
/* Справочник работ: типы недели ^ Справочник работ: графики - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Sheds a WITH(NOLOCK), deleted d WHERE a.WWeekTypeID = d.WWeekTypeID)
    BEGIN
      EXEC z_RelationError 'r_WWeeks', 'r_Sheds', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10094001 AND m.PKValue = 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10094001 AND m.PKValue = 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10094001, -ChID, 
    '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10094 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_r_WWeeks]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[r_WWeeks] ADD CONSTRAINT [pk_r_WWeeks] PRIMARY KEY CLUSTERED ([WWeekTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_WWeeks] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [WWeekName] ON [dbo].[r_WWeeks] ([WWeekName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[WWeekTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[IsInt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[WWeekTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_WWeeks].[IsInt]'
GO
