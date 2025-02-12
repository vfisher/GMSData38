CREATE TABLE [dbo].[r_WPrefs] (
  [ChID] [bigint] NOT NULL,
  [WPref] [varchar](10) NOT NULL,
  [Notes] [varchar](200) NULL,
  [ProdIDOffset] [smallint] NOT NULL,
  [BarQtyCount] [int] NOT NULL DEFAULT (5),
  [BarDecCount] [int] NOT NULL DEFAULT (3),
  CONSTRAINT [pk_r_WPrefs] PRIMARY KEY CLUSTERED ([WPref])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_WPrefs] ([ChID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_WPrefs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_WPrefs.ProdIDOffset'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_WPrefs] ON [r_WPrefs]
FOR INSERT AS
/* r_WPrefs - Справочник товаров: весовые префиксы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10347001, ChID, 
    '[' + cast(i.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_WPrefs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_WPrefs] ON [r_WPrefs]
FOR UPDATE AS
/* r_WPrefs - Справочник товаров: весовые префиксы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WPrefs ^ r_ScaleGrMW - Обновление CHILD */
/* Справочник товаров: весовые префиксы ^ Справочник весов: группы - префиксы - Обновление CHILD */
  IF UPDATE(WPref)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WPref = i.WPref
          FROM r_ScaleGrMW a, inserted i, deleted d WHERE a.WPref = d.WPref
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_ScaleGrMW a, deleted d WHERE a.WPref = d.WPref)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник товаров: весовые префиксы'' => ''Справочник весов: группы - префиксы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10347001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10347001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(Wpref))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10347001 AND l.PKValue = 
        '[' + cast(i.Wpref as varchar(200)) + ']' AND i.Wpref = d.Wpref
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10347001 AND l.PKValue = 
        '[' + cast(i.Wpref as varchar(200)) + ']' AND i.Wpref = d.Wpref
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10347001, ChID, 
          '[' + cast(d.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10347001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10347001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10347001, ChID, 
          '[' + cast(i.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(Wpref)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT Wpref FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT Wpref FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.Wpref as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10347001 AND l.PKValue = 
          '[' + cast(d.Wpref as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.Wpref as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10347001 AND l.PKValue = 
          '[' + cast(d.Wpref as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10347001, ChID, 
          '[' + cast(d.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10347001 AND PKValue IN (SELECT 
          '[' + cast(Wpref as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10347001 AND PKValue IN (SELECT 
          '[' + cast(Wpref as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10347001, ChID, 
          '[' + cast(i.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10347001, ChID, 
    '[' + cast(i.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_WPrefs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_WPrefs] ON [r_WPrefs]
FOR DELETE AS
/* r_WPrefs - Справочник товаров: весовые префиксы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_WPrefs ^ r_ScaleGrMW - Проверка в CHILD */
/* Справочник товаров: весовые префиксы ^ Справочник весов: группы - префиксы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_ScaleGrMW a WITH(NOLOCK), deleted d WHERE a.WPref = d.WPref)
    BEGIN
      EXEC z_RelationError 'r_WPrefs', 'r_ScaleGrMW', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10347001 AND m.PKValue = 
    '[' + cast(i.Wpref as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10347001 AND m.PKValue = 
    '[' + cast(i.Wpref as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10347001, -ChID, 
    '[' + cast(d.Wpref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10347 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_WPrefs', N'Last', N'DELETE'
GO