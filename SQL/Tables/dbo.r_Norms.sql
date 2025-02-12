CREATE TABLE [dbo].[r_Norms] (
  [ChID] [bigint] NOT NULL,
  [YearID] [smallint] NOT NULL,
  [YearName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  CONSTRAINT [pk_r_Norms] PRIMARY KEY CLUSTERED ([YearID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Norms] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [YearName]
  ON [dbo].[r_Norms] ([YearName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Norms.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_Norms.YearID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Norms] ON [r_Norms]
FOR INSERT AS
/* r_Norms - Справочник работ: нормы времени - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10719001, ChID, 
    '[' + cast(i.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Norms', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Norms] ON [r_Norms]
FOR UPDATE AS
/* r_Norms - Справочник работ: нормы времени - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Norms ^ r_NormMH - Обновление CHILD */
/* Справочник работ: нормы времени ^ Справочник работ: нормы времени - Количество рабочих часов - Обновление CHILD */
  IF UPDATE(YearID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.YearID = i.YearID
          FROM r_NormMH a, inserted i, deleted d WHERE a.YearID = d.YearID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_NormMH a, deleted d WHERE a.YearID = d.YearID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: нормы времени'' => ''Справочник работ: нормы времени - Количество рабочих часов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10719001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10719001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(YearID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10719001 AND l.PKValue = 
        '[' + cast(i.YearID as varchar(200)) + ']' AND i.YearID = d.YearID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10719001 AND l.PKValue = 
        '[' + cast(i.YearID as varchar(200)) + ']' AND i.YearID = d.YearID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10719001, ChID, 
          '[' + cast(d.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10719001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10719001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10719001, ChID, 
          '[' + cast(i.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(YearID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT YearID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT YearID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.YearID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10719001 AND l.PKValue = 
          '[' + cast(d.YearID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.YearID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10719001 AND l.PKValue = 
          '[' + cast(d.YearID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10719001, ChID, 
          '[' + cast(d.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10719001 AND PKValue IN (SELECT 
          '[' + cast(YearID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10719001 AND PKValue IN (SELECT 
          '[' + cast(YearID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10719001, ChID, 
          '[' + cast(i.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10719001, ChID, 
    '[' + cast(i.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Norms', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Norms] ON [r_Norms]
FOR DELETE AS
/* r_Norms - Справочник работ: нормы времени - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Norms ^ r_NormMH - Удаление в CHILD */
/* Справочник работ: нормы времени ^ Справочник работ: нормы времени - Количество рабочих часов - Удаление в CHILD */
  DELETE r_NormMH FROM r_NormMH a, deleted d WHERE a.YearID = d.YearID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10719001 AND m.PKValue = 
    '[' + cast(i.YearID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10719001 AND m.PKValue = 
    '[' + cast(i.YearID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10719001, -ChID, 
    '[' + cast(d.YearID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10719 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Norms', N'Last', N'DELETE'
GO