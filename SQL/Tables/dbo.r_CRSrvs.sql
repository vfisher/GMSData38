CREATE TABLE [dbo].[r_CRSrvs] (
  [ChID] [bigint] NOT NULL,
  [SrvID] [tinyint] NOT NULL,
  [SrvName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [OurID] [int] NOT NULL,
  [Host] [varchar](250) NULL,
  [NetPort] [int] NULL,
  CONSTRAINT [pk_r_CRSrvs] PRIMARY KEY CLUSTERED ([SrvID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_CRSrvs] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [OurID]
  ON [dbo].[r_CRSrvs] ([OurID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [SrvName]
  ON [dbo].[r_CRSrvs] ([SrvName])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRSrvs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRSrvs.SrvID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRSrvs.OurID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRSrvs] ON [r_CRSrvs]
FOR INSERT AS
/* r_CRSrvs - Справочник торговых серверов - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRSrvs ^ r_Ours - Проверка в PARENT */
/* Справочник торговых серверов ^ Справочник внутренних фирм - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
    BEGIN
      EXEC z_RelationError 'r_Ours', 'r_CRSrvs', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10451001, ChID, 
    '[' + cast(i.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CRSrvs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRSrvs] ON [r_CRSrvs]
FOR UPDATE AS
/* r_CRSrvs - Справочник торговых серверов - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRSrvs ^ r_Ours - Проверка в PARENT */
/* Справочник торговых серверов ^ Справочник внутренних фирм - Проверка в PARENT */
  IF UPDATE(OurID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OurID NOT IN (SELECT OurID FROM r_Ours))
      BEGIN
        EXEC z_RelationError 'r_Ours', 'r_CRSrvs', 1
        RETURN
      END

/* r_CRSrvs ^ r_CRs - Обновление CHILD */
/* Справочник торговых серверов ^ Справочник ЭККА - Обновление CHILD */
  IF UPDATE(SrvID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvID = i.SrvID
          FROM r_CRs a, inserted i, deleted d WHERE a.SrvID = d.SrvID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRs a, deleted d WHERE a.SrvID = d.SrvID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник торговых серверов'' => ''Справочник ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CRSrvs ^ r_Scales - Обновление CHILD */
/* Справочник торговых серверов ^ Справочник весов - Обновление CHILD */
  IF UPDATE(SrvID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.SrvID = i.SrvID
          FROM r_Scales a, inserted i, deleted d WHERE a.SrvID = d.SrvID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_Scales a, deleted d WHERE a.SrvID = d.SrvID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник торговых серверов'' => ''Справочник весов''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10451001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10451001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(SrvID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10451001 AND l.PKValue = 
        '[' + cast(i.SrvID as varchar(200)) + ']' AND i.SrvID = d.SrvID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10451001 AND l.PKValue = 
        '[' + cast(i.SrvID as varchar(200)) + ']' AND i.SrvID = d.SrvID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10451001, ChID, 
          '[' + cast(d.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10451001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10451001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10451001, ChID, 
          '[' + cast(i.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(SrvID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT SrvID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10451001 AND l.PKValue = 
          '[' + cast(d.SrvID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.SrvID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10451001 AND l.PKValue = 
          '[' + cast(d.SrvID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10451001, ChID, 
          '[' + cast(d.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10451001 AND PKValue IN (SELECT 
          '[' + cast(SrvID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10451001 AND PKValue IN (SELECT 
          '[' + cast(SrvID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10451001, ChID, 
          '[' + cast(i.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10451001, ChID, 
    '[' + cast(i.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CRSrvs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CRSrvs] ON [r_CRSrvs]
FOR DELETE AS
/* r_CRSrvs - Справочник торговых серверов - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CRSrvs ^ r_CRs - Проверка в CHILD */
/* Справочник торговых серверов ^ Справочник ЭККА - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRs a WITH(NOLOCK), deleted d WHERE a.SrvID = d.SrvID)
    BEGIN
      EXEC z_RelationError 'r_CRSrvs', 'r_CRs', 3
      RETURN
    END

/* r_CRSrvs ^ r_Scales - Проверка в CHILD */
/* Справочник торговых серверов ^ Справочник весов - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_Scales a WITH(NOLOCK), deleted d WHERE a.SrvID = d.SrvID)
    BEGIN
      EXEC z_RelationError 'r_CRSrvs', 'r_Scales', 3
      RETURN
    END

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10451001 AND m.PKValue = 
    '[' + cast(i.SrvID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10451001 AND m.PKValue = 
    '[' + cast(i.SrvID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10451001, -ChID, 
    '[' + cast(d.SrvID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10451 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CRSrvs', N'Last', N'DELETE'
GO