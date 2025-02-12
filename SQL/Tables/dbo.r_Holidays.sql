CREATE TABLE [dbo].[r_Holidays] (
  [ChID] [bigint] NOT NULL,
  [HolidayDate] [smalldatetime] NOT NULL,
  [HolidayName] [varchar](200) NOT NULL,
  [DecWTime] [bit] NOT NULL,
  [Notes] [varchar](200) NULL,
  [IsHoliday] [bit] NOT NULL,
  CONSTRAINT [pk_r_Holidays] PRIMARY KEY CLUSTERED ([HolidayDate])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Holidays] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [HolidayName]
  ON [dbo].[r_Holidays] ([HolidayName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Holidays.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Holidays.DecWTime'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Holidays] ON [r_Holidays]
FOR INSERT AS
/* r_Holidays - Справочник нерабочих дней - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10722001, ChID, 
    '[' + cast(i.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Holidays', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Holidays] ON [r_Holidays]
FOR UPDATE AS
/* r_Holidays - Справочник нерабочих дней - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10722001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10722001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(HolidayDate))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10722001 AND l.PKValue = 
        '[' + cast(i.HolidayDate as varchar(200)) + ']' AND i.HolidayDate = d.HolidayDate
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10722001 AND l.PKValue = 
        '[' + cast(i.HolidayDate as varchar(200)) + ']' AND i.HolidayDate = d.HolidayDate
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10722001, ChID, 
          '[' + cast(d.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10722001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10722001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10722001, ChID, 
          '[' + cast(i.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(HolidayDate)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT HolidayDate FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT HolidayDate FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.HolidayDate as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10722001 AND l.PKValue = 
          '[' + cast(d.HolidayDate as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.HolidayDate as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10722001 AND l.PKValue = 
          '[' + cast(d.HolidayDate as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10722001, ChID, 
          '[' + cast(d.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10722001 AND PKValue IN (SELECT 
          '[' + cast(HolidayDate as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10722001 AND PKValue IN (SELECT 
          '[' + cast(HolidayDate as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10722001, ChID, 
          '[' + cast(i.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10722001, ChID, 
    '[' + cast(i.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Holidays', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Holidays] ON [r_Holidays]
FOR DELETE AS
/* r_Holidays - Справочник нерабочих дней - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10722001 AND m.PKValue = 
    '[' + cast(i.HolidayDate as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10722001 AND m.PKValue = 
    '[' + cast(i.HolidayDate as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10722001, -ChID, 
    '[' + cast(d.HolidayDate as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10722 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Holidays', N'Last', N'DELETE'
GO