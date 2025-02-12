CREATE TABLE [dbo].[r_WPs] (
  [ChID] [bigint] NOT NULL,
  [WPID] [int] NOT NULL,
  [WPName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [WPRoleID] [int] NOT NULL,
  [CRID] [smallint] NOT NULL,
  [ScaleID] [int] NOT NULL DEFAULT (0),
  [CollectMetrics] [bit] NOT NULL DEFAULT (0),
  [MetricMaxDays] [int] NOT NULL DEFAULT (14),
  [UserName] [varchar](250) NULL,
  [UserPassword] [varchar](250) NULL,
  [AllowChequeClose] [bit] NOT NULL DEFAULT (1),
  [ShowClientMonitor] [bit] NOT NULL DEFAULT (0),
  [ExtraInfo] [varchar](250) NULL,
  [AllowCashBack] [bit] NOT NULL DEFAULT (1),
  [ExtraSettings] [varchar](250) NULL,
  [Telemetry] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_WPs] PRIMARY KEY CLUSTERED ([WPID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_WPs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CRID]
  ON [dbo].[r_WPs] ([CRID])
  ON [PRIMARY]
GO

CREATE INDEX [ScaleID]
  ON [dbo].[r_WPs] ([ScaleID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [WPName]
  ON [dbo].[r_WPs] ([WPName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_WPs] ON [r_WPs]
FOR INSERT AS
/* r_WPs - Справочник рабочих мест - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WPs ^ r_CRs - Проверка в PARENT */
/* Справочник рабочих мест ^ Справочник ЭККА - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_WPs', 0
      RETURN
    END

/* r_WPs ^ r_Scales - Проверка в PARENT */
/* Справочник рабочих мест ^ Справочник весов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleID NOT IN (SELECT ScaleID FROM r_Scales))
    BEGIN
      EXEC z_RelationError 'r_Scales', 'r_WPs', 0
      RETURN
    END

/* r_WPs ^ r_WPRoles - Проверка в PARENT */
/* Справочник рабочих мест ^ Справочник рабочих мест: роли - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.WPRoleID NOT IN (SELECT WPRoleID FROM r_WPRoles))
    BEGIN
      EXEC z_RelationError 'r_WPRoles', 'r_WPs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10550001, ChID, 
    '[' + cast(i.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_WPs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_WPs] ON [r_WPs]
FOR UPDATE AS
/* r_WPs - Справочник рабочих мест - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_WPs ^ r_CRs - Проверка в PARENT */
/* Справочник рабочих мест ^ Справочник ЭККА - Проверка в PARENT */
  IF UPDATE(CRID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CRID NOT IN (SELECT CRID FROM r_CRs))
      BEGIN
        EXEC z_RelationError 'r_CRs', 'r_WPs', 1
        RETURN
      END

/* r_WPs ^ r_Scales - Проверка в PARENT */
/* Справочник рабочих мест ^ Справочник весов - Проверка в PARENT */
  IF UPDATE(ScaleID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ScaleID NOT IN (SELECT ScaleID FROM r_Scales))
      BEGIN
        EXEC z_RelationError 'r_Scales', 'r_WPs', 1
        RETURN
      END

/* r_WPs ^ r_WPRoles - Проверка в PARENT */
/* Справочник рабочих мест ^ Справочник рабочих мест: роли - Проверка в PARENT */
  IF UPDATE(WPRoleID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.WPRoleID NOT IN (SELECT WPRoleID FROM r_WPRoles))
      BEGIN
        EXEC z_RelationError 'r_WPRoles', 'r_WPs', 1
        RETURN
      END

/* r_WPs ^ r_CRDeskG - Обновление CHILD */
/* Справочник рабочих мест ^ Справочник ЭККА - Столики: группы - Обновление CHILD */
  IF UPDATE(WPID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WPID = i.WPID
          FROM r_CRDeskG a, inserted i, deleted d WHERE a.WPID = d.WPID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRDeskG a, deleted d WHERE a.WPID = d.WPID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник рабочих мест'' => ''Справочник ЭККА - Столики: группы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_WPs ^ r_CRPOSPays - Обновление CHILD */
/* Справочник рабочих мест ^ Справочник ЭККА: Платежные терминалы - Обновление CHILD */
  IF UPDATE(WPID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WPID = i.WPID
          FROM r_CRPOSPays a, inserted i, deleted d WHERE a.WPID = d.WPID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRPOSPays a, deleted d WHERE a.WPID = d.WPID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник рабочих мест'' => ''Справочник ЭККА: Платежные терминалы''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_WPs ^ r_Displays - Обновление CHILD */
/* Справочник рабочих мест ^ Рабочие места: внешние дисплеи - Обновление CHILD */
  IF UPDATE(WPID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.WPID = i.WPID
          FROM r_Displays a, inserted i, deleted d WHERE a.WPID = d.WPID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Displays a, deleted d WHERE a.WPID = d.WPID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник рабочих мест'' => ''Рабочие места: внешние дисплеи''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10550001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10550001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(WPID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10550001 AND l.PKValue = 
        '[' + cast(i.WPID as varchar(200)) + ']' AND i.WPID = d.WPID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10550001 AND l.PKValue = 
        '[' + cast(i.WPID as varchar(200)) + ']' AND i.WPID = d.WPID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10550001, ChID, 
          '[' + cast(d.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10550001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10550001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10550001, ChID, 
          '[' + cast(i.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(WPID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT WPID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT WPID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.WPID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10550001 AND l.PKValue = 
          '[' + cast(d.WPID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.WPID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10550001 AND l.PKValue = 
          '[' + cast(d.WPID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10550001, ChID, 
          '[' + cast(d.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10550001 AND PKValue IN (SELECT 
          '[' + cast(WPID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10550001 AND PKValue IN (SELECT 
          '[' + cast(WPID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10550001, ChID, 
          '[' + cast(i.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10550001, ChID, 
    '[' + cast(i.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_WPs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_WPs] ON [r_WPs]
FOR DELETE AS
/* r_WPs - Справочник рабочих мест - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_WPs ^ r_CRDeskG - Проверка в CHILD */
/* Справочник рабочих мест ^ Справочник ЭККА - Столики: группы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRDeskG a WITH(NOLOCK), deleted d WHERE a.WPID = d.WPID)
    BEGIN
      EXEC z_RelationError 'r_WPs', 'r_CRDeskG', 3
      RETURN
    END

/* r_WPs ^ r_CRPOSPays - Проверка в CHILD */
/* Справочник рабочих мест ^ Справочник ЭККА: Платежные терминалы - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRPOSPays a WITH(NOLOCK), deleted d WHERE a.WPID = d.WPID)
    BEGIN
      EXEC z_RelationError 'r_WPs', 'r_CRPOSPays', 3
      RETURN
    END

/* r_WPs ^ r_Displays - Удаление в CHILD */
/* Справочник рабочих мест ^ Рабочие места: внешние дисплеи - Удаление в CHILD */
  DELETE r_Displays FROM r_Displays a, deleted d WHERE a.WPID = d.WPID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10550001 AND m.PKValue = 
    '[' + cast(i.WPID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10550001 AND m.PKValue = 
    '[' + cast(i.WPID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10550001, -ChID, 
    '[' + cast(d.WPID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10550 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_WPs', N'Last', N'DELETE'
GO