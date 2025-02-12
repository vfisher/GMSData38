CREATE TABLE [dbo].[r_ShedMS] (
  [ShedID] [smallint] NOT NULL,
  [DayPosID] [smallint] NOT NULL,
  [ShiftID] [tinyint] NOT NULL,
  [BTime] [smalldatetime] NOT NULL,
  [ETime] [smalldatetime] NOT NULL,
  [ShiftLength] [smalldatetime] NOT NULL,
  [ShiftDesc] [varchar](200) NULL,
  [BIntTime] [smalldatetime] NOT NULL,
  [EIntTime] [smalldatetime] NOT NULL,
  [IntLength] [smalldatetime] NOT NULL,
  CONSTRAINT [_pk_r_ShedMS] PRIMARY KEY CLUSTERED ([ShedID], [DayPosID], [ShiftID])
)
ON [PRIMARY]
GO

CREATE INDEX [DayPosID]
  ON [dbo].[r_ShedMS] ([DayPosID])
  ON [PRIMARY]
GO

CREATE INDEX [r_ShedMDr_ShedMS]
  ON [dbo].[r_ShedMS] ([ShedID], [DayPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ShedID]
  ON [dbo].[r_ShedMS] ([ShedID])
  ON [PRIMARY]
GO

CREATE INDEX [ShiftID]
  ON [dbo].[r_ShedMS] ([ShiftID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMS.ShedID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMS.DayPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMS.ShiftID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ShedMS] ON [r_ShedMS]
FOR INSERT AS
/* r_ShedMS - Справочник работ: графики - Смены графика - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ShedMS ^ r_ShedMD - Проверка в PARENT */
/* Справочник работ: графики - Смены графика ^ Справочник работ: графики - Дни графика - Проверка в PARENT */
  IF (SELECT COUNT(*) FROM r_ShedMD m WITH(NOLOCK), inserted i WHERE i.DayPosID = m.DayPosID AND i.ShedID = m.ShedID) <> @RCount
    BEGIN
      EXEC z_RelationError 'r_ShedMD', 'r_ShedMS', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10095003, m.ChID, 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ShiftID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Sheds m ON m.ShedID = i.ShedID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ShedMS', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ShedMS] ON [r_ShedMS]
FOR UPDATE AS
/* r_ShedMS - Справочник работ: графики - Смены графика - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ShedMS ^ r_ShedMD - Проверка в PARENT */
/* Справочник работ: графики - Смены графика ^ Справочник работ: графики - Дни графика - Проверка в PARENT */
  IF UPDATE(DayPosID) OR UPDATE(ShedID)
    IF (SELECT COUNT(*) FROM r_ShedMD m WITH(NOLOCK), inserted i WHERE i.DayPosID = m.DayPosID AND i.ShedID = m.ShedID) <> @RCount
      BEGIN
        EXEC z_RelationError 'r_ShedMD', 'r_ShedMS', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ShedID) OR UPDATE(DayPosID) OR UPDATE(ShiftID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ShedID, DayPosID, ShiftID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ShedID, DayPosID, ShiftID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ShiftID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10095003 AND l.PKValue = 
          '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ShiftID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ShiftID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10095003 AND l.PKValue = 
          '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ShiftID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10095003, m.ChID, 
          '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.ShiftID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Sheds m ON m.ShedID = d.ShedID
          DELETE FROM z_LogCreate WHERE TableCode = 10095003 AND PKValue IN (SELECT 
          '[' + cast(ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ShiftID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10095003 AND PKValue IN (SELECT 
          '[' + cast(ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(ShiftID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10095003, m.ChID, 
          '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.ShiftID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Sheds m ON m.ShedID = i.ShedID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10095003, m.ChID, 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ShiftID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Sheds m ON m.ShedID = i.ShedID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ShedMS', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ShedMS] ON [r_ShedMS]
FOR DELETE AS
/* r_ShedMS - Справочник работ: графики - Смены графика - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10095003 AND m.PKValue = 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ShiftID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10095003 AND m.PKValue = 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.ShiftID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10095003, m.ChID, 
    '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DayPosID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.ShiftID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Sheds m ON m.ShedID = d.ShedID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ShedMS', N'Last', N'DELETE'
GO