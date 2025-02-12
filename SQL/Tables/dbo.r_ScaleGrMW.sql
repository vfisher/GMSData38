CREATE TABLE [dbo].[r_ScaleGrMW] (
  [ScaleGrID] [int] NOT NULL,
  [WPref] [varchar](10) NOT NULL,
  CONSTRAINT [pk_r_ScaleGrMW] PRIMARY KEY CLUSTERED ([ScaleGrID], [WPref])
)
ON [PRIMARY]
GO

CREATE INDEX [ScaleGrID]
  ON [dbo].[r_ScaleGrMW] ([ScaleGrID])
  ON [PRIMARY]
GO

CREATE INDEX [WPref]
  ON [dbo].[r_ScaleGrMW] ([WPref])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ScaleGrMW] ON [r_ScaleGrMW]
FOR INSERT AS
/* r_ScaleGrMW - Справочник весов: группы - префиксы - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ScaleGrMW ^ r_ScaleGrs - Проверка в PARENT */
/* Справочник весов: группы - префиксы ^ Справочник весов: группы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleGrID NOT IN (SELECT ScaleGrID FROM r_ScaleGrs))
    BEGIN
      EXEC z_RelationError 'r_ScaleGrs', 'r_ScaleGrMW', 0
      RETURN
    END

/* r_ScaleGrMW ^ r_WPrefs - Проверка в PARENT */
/* Справочник весов: группы - префиксы ^ Справочник товаров: весовые префиксы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WPref NOT IN (SELECT WPref FROM r_WPrefs))
    BEGIN
      EXEC z_RelationError 'r_WPrefs', 'r_ScaleGrMW', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10420002, m.ChID, 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WPref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_ScaleGrs m ON m.ScaleGrID = i.ScaleGrID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ScaleGrMW', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ScaleGrMW] ON [r_ScaleGrMW]
FOR UPDATE AS
/* r_ScaleGrMW - Справочник весов: группы - префиксы - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ScaleGrMW ^ r_ScaleGrs - Проверка в PARENT */
/* Справочник весов: группы - префиксы ^ Справочник весов: группы - Проверка в PARENT */
  IF UPDATE(ScaleGrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleGrID NOT IN (SELECT ScaleGrID FROM r_ScaleGrs))
      BEGIN
        EXEC z_RelationError 'r_ScaleGrs', 'r_ScaleGrMW', 1
        RETURN
      END

/* r_ScaleGrMW ^ r_WPrefs - Проверка в PARENT */
/* Справочник весов: группы - префиксы ^ Справочник товаров: весовые префиксы - Проверка в PARENT */
  IF UPDATE(WPref)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WPref NOT IN (SELECT WPref FROM r_WPrefs))
      BEGIN
        EXEC z_RelationError 'r_WPrefs', 'r_ScaleGrMW', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ScaleGrID) OR UPDATE(WPref)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleGrID, WPref FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ScaleGrID, WPref FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WPref as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10420002 AND l.PKValue = 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WPref as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WPref as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10420002 AND l.PKValue = 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WPref as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10420002, m.ChID, 
          '[' + cast(d.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WPref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_ScaleGrs m ON m.ScaleGrID = d.ScaleGrID
          DELETE FROM z_LogCreate WHERE TableCode = 10420002 AND PKValue IN (SELECT 
          '[' + cast(ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WPref as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10420002 AND PKValue IN (SELECT 
          '[' + cast(ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WPref as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10420002, m.ChID, 
          '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WPref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_ScaleGrs m ON m.ScaleGrID = i.ScaleGrID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10420002, m.ChID, 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WPref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_ScaleGrs m ON m.ScaleGrID = i.ScaleGrID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ScaleGrMW', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ScaleGrMW] ON [r_ScaleGrMW]
FOR DELETE AS
/* r_ScaleGrMW - Справочник весов: группы - префиксы - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10420002 AND m.PKValue = 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WPref as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10420002 AND m.PKValue = 
    '[' + cast(i.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WPref as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10420002, m.ChID, 
    '[' + cast(d.ScaleGrID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.WPref as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_ScaleGrs m ON m.ScaleGrID = d.ScaleGrID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ScaleGrMW', N'Last', N'DELETE'
GO