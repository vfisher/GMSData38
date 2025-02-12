CREATE TABLE [dbo].[r_WTSigns] (
  [ChID] [bigint] NOT NULL,
  [WTSignID] [tinyint] NOT NULL,
  [WTSignName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [IsHandSign] [bit] NOT NULL,
  [IsWorkTime] [bit] NOT NULL DEFAULT (0),
  [PayFactor] [numeric](21, 9) NOT NULL DEFAULT (0),
  [IsBasisLeavTime] [bit] NOT NULL DEFAULT (0),
  [IsPregTime] [bit] NOT NULL DEFAULT (0),
  [IsSickTime] [bit] NOT NULL DEFAULT (0),
  [IsTruancyTime] [bit] NOT NULL DEFAULT (0),
  [IsNoAppTime] [bit] NOT NULL DEFAULT (0),
  [IsHolidayTime] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_WTSigns] PRIMARY KEY CLUSTERED ([WTSignID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_WTSigns] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [WTSignName]
  ON [dbo].[r_WTSigns] ([WTSignName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_WTSigns.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_WTSigns.WTSignID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_WTSigns.IsHandSign'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_WTSigns] ON [r_WTSigns]
FOR INSERT AS
/* r_WTSigns - Справочник работ: обозначения времени - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10717001, ChID, 
    '[' + cast(i.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_WTSigns', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_WTSigns] ON [r_WTSigns]
FOR UPDATE AS
/* r_WTSigns - Справочник работ: обозначения времени - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WTSigns ^ p_CWTimeCor - Обновление CHILD */
/* Справочник работ: обозначения времени ^ Табель учета рабочего времени: Корректировка: Список - Обновление CHILD */
  IF UPDATE(WTSignID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WTSignID = i.WTSignID
          FROM p_CWTimeCor a, inserted i, deleted d WHERE a.WTSignID = d.WTSignID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeCor a, deleted d WHERE a.WTSignID = d.WTSignID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: обозначения времени'' => ''Табель учета рабочего времени: Корректировка: Список''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_WTSigns ^ p_CWTimeDD - Обновление CHILD */
/* Справочник работ: обозначения времени ^ Табель учета рабочего времени (Подробно) - Обновление CHILD */
  IF UPDATE(WTSignID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WTSignID = i.WTSignID
          FROM p_CWTimeDD a, inserted i, deleted d WHERE a.WTSignID = d.WTSignID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeDD a, deleted d WHERE a.WTSignID = d.WTSignID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: обозначения времени'' => ''Табель учета рабочего времени (Подробно)''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_WTSigns ^ p_CWTimeDDExt - Обновление CHILD */
/* Справочник работ: обозначения времени ^ Табель учета рабочего времени: Подробно: Графики - Обновление CHILD */
  IF UPDATE(WTSignID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WTSignID = i.WTSignID
          FROM p_CWTimeDDExt a, inserted i, deleted d WHERE a.WTSignID = d.WTSignID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_CWTimeDDExt a, deleted d WHERE a.WTSignID = d.WTSignID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: обозначения времени'' => ''Табель учета рабочего времени: Подробно: Графики''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_WTSigns ^ p_DTran - Обновление CHILD */
/* Справочник работ: обозначения времени ^ Перенос рабочих дней - Обновление CHILD */
  IF UPDATE(WTSignID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WTSignID = i.WTSignID
          FROM p_DTran a, inserted i, deleted d WHERE a.WTSignID = d.WTSignID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM p_DTran a, deleted d WHERE a.WTSignID = d.WTSignID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник работ: обозначения времени'' => ''Перенос рабочих дней''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10717001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10717001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(WTSignID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10717001 AND l.PKValue = 
        '[' + cast(i.WTSignID as varchar(200)) + ']' AND i.WTSignID = d.WTSignID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10717001 AND l.PKValue = 
        '[' + cast(i.WTSignID as varchar(200)) + ']' AND i.WTSignID = d.WTSignID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10717001, ChID, 
          '[' + cast(d.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10717001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10717001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10717001, ChID, 
          '[' + cast(i.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(WTSignID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WTSignID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WTSignID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WTSignID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10717001 AND l.PKValue = 
          '[' + cast(d.WTSignID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WTSignID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10717001 AND l.PKValue = 
          '[' + cast(d.WTSignID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10717001, ChID, 
          '[' + cast(d.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10717001 AND PKValue IN (SELECT 
          '[' + cast(WTSignID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10717001 AND PKValue IN (SELECT 
          '[' + cast(WTSignID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10717001, ChID, 
          '[' + cast(i.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10717001, ChID, 
    '[' + cast(i.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_WTSigns', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_WTSigns] ON [r_WTSigns]
FOR DELETE AS
/* r_WTSigns - Справочник работ: обозначения времени - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_WTSigns ^ p_CWTimeCor - Проверка в CHILD */
/* Справочник работ: обозначения времени ^ Табель учета рабочего времени: Корректировка: Список - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeCor a WITH(NOLOCK), deleted d WHERE a.WTSignID = d.WTSignID)
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_CWTimeCor', 3
      RETURN
    END

/* r_WTSigns ^ p_CWTimeDD - Проверка в CHILD */
/* Справочник работ: обозначения времени ^ Табель учета рабочего времени (Подробно) - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeDD a WITH(NOLOCK), deleted d WHERE a.WTSignID = d.WTSignID)
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_CWTimeDD', 3
      RETURN
    END

/* r_WTSigns ^ p_CWTimeDDExt - Проверка в CHILD */
/* Справочник работ: обозначения времени ^ Табель учета рабочего времени: Подробно: Графики - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_CWTimeDDExt a WITH(NOLOCK), deleted d WHERE a.WTSignID = d.WTSignID)
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_CWTimeDDExt', 3
      RETURN
    END

/* r_WTSigns ^ p_DTran - Проверка в CHILD */
/* Справочник работ: обозначения времени ^ Перенос рабочих дней - Проверка в CHILD */
  IF EXISTS (SELECT * FROM p_DTran a WITH(NOLOCK), deleted d WHERE a.WTSignID = d.WTSignID)
    BEGIN
      EXEC z_RelationError 'r_WTSigns', 'p_DTran', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10717001 AND m.PKValue = 
    '[' + cast(i.WTSignID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10717001 AND m.PKValue = 
    '[' + cast(i.WTSignID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10717001, -ChID, 
    '[' + cast(d.WTSignID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10717 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_WTSigns', N'Last', N'DELETE'
GO