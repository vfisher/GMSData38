CREATE TABLE [dbo].[r_ShedMD] (
  [ShedID] [smallint] NOT NULL,
  [DayPosID] [smallint] NOT NULL,
  [ShifsQty] [tinyint] NOT NULL,
  [HoursInDay] [numeric](21, 9) NOT NULL,
  [DayDesc] [varchar](200) NULL,
  CONSTRAINT [_pk_r_ShedMD] PRIMARY KEY CLUSTERED ([ShedID], [DayPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [DayPosID]
  ON [dbo].[r_ShedMD] ([DayPosID])
  ON [PRIMARY]
GO

CREATE INDEX [ShedID]
  ON [dbo].[r_ShedMD] ([ShedID])
  ON [PRIMARY]
GO

CREATE INDEX [ShifsQty]
  ON [dbo].[r_ShedMD] ([ShifsQty])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMD.ShedID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMD.DayPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMD.ShifsQty'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ShedMD.HoursInDay'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ShedMD] ON [r_ShedMD]
FOR INSERT AS
/* r_ShedMD - Справочник работ: графики - Дни графика - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ShedMD ^ r_Sheds - Проверка в PARENT */
/* Справочник работ: графики - Дни графика ^ Справочник работ: графики - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
    BEGIN
      EXEC z_RelationError 'r_Sheds', 'r_ShedMD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10095002, m.ChID, 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Sheds m ON m.ShedID = i.ShedID

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ShedMD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ShedMD] ON [r_ShedMD]
FOR UPDATE AS
/* r_ShedMD - Справочник работ: графики - Дни графика - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ShedMD ^ r_Sheds - Проверка в PARENT */
/* Справочник работ: графики - Дни графика ^ Справочник работ: графики - Проверка в PARENT */
  IF UPDATE(ShedID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ShedID NOT IN (SELECT ShedID FROM r_Sheds))
      BEGIN
        EXEC z_RelationError 'r_Sheds', 'r_ShedMD', 1
        RETURN
      END

/* Переменные для пакетного каскадного обновления */
  DECLARE @OldDayPosID smallint, @NewDayPosID smallint
  DECLARE @OldShedID smallint, @NewShedID smallint

/* r_ShedMD ^ r_ShedMS - Обновление CHILD */
/* Справочник работ: графики - Дни графика ^ Справочник работ: графики - Смены графика - Обновление CHILD */
  IF UPDATE(DayPosID) OR UPDATE(ShedID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DayPosID = i.DayPosID, a.ShedID = i.ShedID
          FROM r_ShedMS a, inserted i, deleted d WHERE a.DayPosID = d.DayPosID AND a.ShedID = d.ShedID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF NOT UPDATE(ShedID) AND (SELECT COUNT(DISTINCT DayPosID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT DayPosID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldDayPosID = DayPosID FROM deleted
          SELECT TOP 1 @NewDayPosID = DayPosID FROM inserted
          UPDATE r_ShedMS SET r_ShedMS.DayPosID = @NewDayPosID FROM r_ShedMS, deleted d WHERE r_ShedMS.DayPosID = @OldDayPosID AND r_ShedMS.ShedID = d.ShedID
        END
      ELSE IF NOT UPDATE(DayPosID) AND (SELECT COUNT(DISTINCT ShedID) FROM deleted) = 1 AND (SELECT COUNT(DISTINCT ShedID) FROM inserted) = 1
        BEGIN
          SELECT TOP 1 @OldShedID = ShedID FROM deleted
          SELECT TOP 1 @NewShedID = ShedID FROM inserted
          UPDATE r_ShedMS SET r_ShedMS.ShedID = @NewShedID FROM r_ShedMS, deleted d WHERE r_ShedMS.ShedID = @OldShedID AND r_ShedMS.DayPosID = d.DayPosID
        END
      ELSE IF EXISTS (SELECT * FROM r_ShedMS a, deleted d WHERE a.DayPosID = d.DayPosID AND a.ShedID = d.ShedID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: графики - Дни графика'' => ''Справочник работ: графики - Смены графика''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* Регистрация изменения записи */


/* Регистрация изменения первичного ключа */
  IF UPDATE(ShedID) OR UPDATE(DayPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ShedID, DayPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ShedID, DayPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10095002 AND l.PKValue = 
          '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10095002 AND l.PKValue = 
          '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10095002, m.ChID, 
          '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Sheds m ON m.ShedID = d.ShedID
          DELETE FROM z_LogCreate WHERE TableCode = 10095002 AND PKValue IN (SELECT 
          '[' + cast(ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DayPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10095002 AND PKValue IN (SELECT 
          '[' + cast(ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(DayPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10095002, m.ChID, 
          '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Sheds m ON m.ShedID = i.ShedID

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10095002, m.ChID, 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i JOIN r_Sheds m ON m.ShedID = i.ShedID


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ShedMD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ShedMD] ON [r_ShedMD]
FOR DELETE AS
/* r_ShedMD - Справочник работ: графики - Дни графика - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ShedMD ^ r_ShedMS - Удаление в CHILD */
/* Справочник работ: графики - Дни графика ^ Справочник работ: графики - Смены графика - Удаление в CHILD */
  DELETE r_ShedMS FROM r_ShedMS a, deleted d WHERE a.DayPosID = d.DayPosID AND a.ShedID = d.ShedID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10095002 AND m.PKValue = 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10095002 AND m.PKValue = 
    '[' + cast(i.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.DayPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10095002, m.ChID, 
    '[' + cast(d.ShedID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.DayPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d JOIN r_Sheds m ON m.ShedID = d.ShedID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ShedMD', N'Last', N'DELETE'
GO