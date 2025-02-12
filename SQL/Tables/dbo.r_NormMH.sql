CREATE TABLE [dbo].[r_NormMH] (
  [YearID] [smallint] NOT NULL,
  [MonthID] [smallint] NOT NULL,
  [WWeekTypeID] [tinyint] NOT NULL,
  [DaysNorm] [numeric](21, 9) NULL,
  [HoursNorm] [numeric](21, 9) NULL,
  PRIMARY KEY CLUSTERED ([YearID], [MonthID], [WWeekTypeID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_NormMH] ON [r_NormMH]
FOR INSERT AS
/* r_NormMH - Справочник работ: нормы времени - Количество рабочих часов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_NormMH ^ r_Norms - Проверка в PARENT */
/* Справочник работ: нормы времени - Количество рабочих часов ^ Справочник работ: нормы времени - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.YearID NOT IN (SELECT YearID FROM r_Norms))
    BEGIN
      EXEC z_RelationError 'r_Norms', 'r_NormMH', 0
      RETURN
    END

/* r_NormMH ^ r_WWeeks - Проверка в PARENT */
/* Справочник работ: нормы времени - Количество рабочих часов ^ Справочник работ: типы недели - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WWeekTypeID NOT IN (SELECT WWeekTypeID FROM r_WWeeks))
    BEGIN
      EXEC z_RelationError 'r_WWeeks', 'r_NormMH', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10719002, m.ChID, 
    '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Norms m ON m.YearID = i.YearID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_NormMH', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_NormMH] ON [r_NormMH]
FOR UPDATE AS
/* r_NormMH - Справочник работ: нормы времени - Количество рабочих часов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_NormMH ^ r_Norms - Проверка в PARENT */
/* Справочник работ: нормы времени - Количество рабочих часов ^ Справочник работ: нормы времени - Проверка в PARENT */
  IF UPDATE(YearID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.YearID NOT IN (SELECT YearID FROM r_Norms))
      BEGIN
        EXEC z_RelationError 'r_Norms', 'r_NormMH', 1
        RETURN
      END

/* r_NormMH ^ r_WWeeks - Проверка в PARENT */
/* Справочник работ: нормы времени - Количество рабочих часов ^ Справочник работ: типы недели - Проверка в PARENT */
  IF UPDATE(WWeekTypeID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WWeekTypeID NOT IN (SELECT WWeekTypeID FROM r_WWeeks))
      BEGIN
        EXEC z_RelationError 'r_WWeeks', 'r_NormMH', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(YearID) OR UPDATE(MonthID) OR UPDATE(WWeekTypeID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT YearID, MonthID, WWeekTypeID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT YearID, MonthID, WWeekTypeID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10719002 AND l.PKValue = 
          '[' + cast(d.YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10719002 AND l.PKValue = 
          '[' + cast(d.YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10719002, m.ChID, 
          '[' + cast(d.YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Norms m ON m.YearID = d.YearID
          DELETE FROM z_LogCreate WHERE TableCode = 10719002 AND PKValue IN (SELECT 
          '[' + cast(YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WWeekTypeID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10719002 AND PKValue IN (SELECT 
          '[' + cast(YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(WWeekTypeID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10719002, m.ChID, 
          '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Norms m ON m.YearID = i.YearID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10719002, m.ChID, 
    '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Norms m ON m.YearID = i.YearID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_NormMH', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_NormMH] ON [r_NormMH]
FOR DELETE AS
/* r_NormMH - Справочник работ: нормы времени - Количество рабочих часов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10719002 AND m.PKValue = 
    '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10719002 AND m.PKValue = 
    '[' + cast(i.YearID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.MonthID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.WWeekTypeID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10719002, m.ChID, 
    '[' + cast(d.YearID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.MonthID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.WWeekTypeID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Norms m ON m.YearID = d.YearID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_NormMH', N'Last', N'DELETE'
GO