CREATE TABLE [dbo].[r_CRs] (
  [ChID] [bigint] NOT NULL,
  [CRID] [smallint] NOT NULL,
  [CRName] [varchar](200) NOT NULL,
  [Notes] [varchar](200) NULL,
  [FinID] [varchar](250) NULL,
  [FacID] [varchar](250) NULL,
  [CRPort] [tinyint] NOT NULL,
  [CRCode] [int] NOT NULL CONSTRAINT [df_r_CRs_CRCode] DEFAULT (0),
  [SrvID] [tinyint] NOT NULL,
  [StockID] [int] NOT NULL,
  [SecID] [int] NOT NULL,
  [CashType] [smallint] NOT NULL,
  [UseProdNotes] [bit] NOT NULL,
  [BaudRate] [smallint] NOT NULL,
  [LEDType] [tinyint] NOT NULL,
  [CanEditPrice] [bit] NOT NULL,
  [PaperWarning] [bit] NOT NULL DEFAULT (0),
  [DecQtyFromRef] [bit] NOT NULL,
  [UseStockPL] [bit] NOT NULL DEFAULT (0),
  [CashRegMode] [int] NOT NULL DEFAULT (0),
  [NetPort] [int] NOT NULL DEFAULT (0),
  [ModemID] [varchar](250) NOT NULL CONSTRAINT [DF__r_CRs__ModemID__70043D99] DEFAULT (0),
  [ModemPassword] [int] NOT NULL DEFAULT (0),
  [IP] [varchar](250) NULL,
  [GroupProds] [bit] NOT NULL DEFAULT (1),
  [AutoUpdateTaxes] [bit] NOT NULL DEFAULT (0),
  [BackupCRJournalAfterZReport] [bit] NOT NULL,
  [BackupCRJournalAfterChequeType] [tinyint] NOT NULL DEFAULT (0),
  [BackupCRJournalChequeTimeout] [int] NOT NULL DEFAULT (0),
  [BackupCRJournalInTime] [bit] NOT NULL DEFAULT (0),
  [BackupCRJournalExecTime] [smalldatetime] NOT NULL DEFAULT (0),
  [BackupCRJournalText] [bit] NULL,
  [BackupCRJournalTextChequeType] [int] NULL,
  [BackupCRJournalTextStartDate] [smalldatetime] NOT NULL DEFAULT ('1900-01-01 08:00:00'),
  [OfflineSessionMaxQtyCheques] [int] NOT NULL DEFAULT (2000),
  [PrivateKeyPath] [varchar](250) NULL,
  [PrivateKeyPassword] [varchar](250) NULL,
  [UseNTPServer] [bit] NOT NULL DEFAULT (0),
  [IsTesting] [bit] NOT NULL DEFAULT (0),
  [CRTimeOut] [int] NOT NULL DEFAULT (500),
  [BackupCRJournalTextAfterChequeType] [tinyint] NOT NULL DEFAULT (0),
  [PrintSaleCheque] [bit] NOT NULL DEFAULT (1),
  [PrintRetCheque] [bit] NOT NULL DEFAULT (1),
  [PrintReports] [bit] NOT NULL DEFAULT (1),
  [PrintRecExp] [bit] NOT NULL DEFAULT (1),
  [PrintChequeCopy] [bit] NOT NULL DEFAULT (1),
  [BackupCRJournalStartDate] [smalldatetime] NOT NULL DEFAULT ('1900-01-01 08:00:00'),
  [TimeOutExitFromOfflineSession] [int] NOT NULL DEFAULT (10),
  CONSTRAINT [pk_r_CRs] PRIMARY KEY CLUSTERED ([CRID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_CRs] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [CRCode]
  ON [dbo].[r_CRs] ([CRCode])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [CRName]
  ON [dbo].[r_CRs] ([CRName])
  ON [PRIMARY]
GO

CREATE INDEX [CRPort]
  ON [dbo].[r_CRs] ([CRPort])
  ON [PRIMARY]
GO

CREATE INDEX [FacID]
  ON [dbo].[r_CRs] ([FacID])
  ON [PRIMARY]
GO

CREATE INDEX [FinID]
  ON [dbo].[r_CRs] ([FinID])
  ON [PRIMARY]
GO

CREATE INDEX [SecID]
  ON [dbo].[r_CRs] ([SecID])
  ON [PRIMARY]
GO

CREATE INDEX [SrvID]
  ON [dbo].[r_CRs] ([SrvID])
  ON [PRIMARY]
GO

CREATE INDEX [StockID]
  ON [dbo].[r_CRs] ([StockID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.CRID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.CRPort'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.SrvID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.StockID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.SecID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.CashType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.UseProdNotes'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.BaudRate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.LEDType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_CRs.CanEditPrice'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_CRs] ON [r_CRs]
FOR DELETE AS
/* r_CRs - Справочник ЭККА - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_CRs ^ r_OperCRs - Проверка в CHILD */
/* Справочник ЭККА ^ Справочник ЭККА - Операторы ЭККА - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_OperCRs a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID)
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_OperCRs', 3
      RETURN
    END

/* r_CRs ^ r_CRMP - Проверка в CHILD */
/* Справочник ЭККА ^ Справочник ЭККА - Товары - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_CRMP a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID)
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_CRMP', 3
      RETURN
    END

/* r_CRs ^ r_WPs - Проверка в CHILD */
/* Справочник ЭККА ^ Справочник рабочих мест - Проверка в CHILD */
  IF EXISTS (SELECT * FROM r_WPs a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID)
    BEGIN
      EXEC z_RelationError 'r_CRs', 'r_WPs', 3
      RETURN
    END

/* r_CRs ^ t_SaleTemp - Удаление в CHILD */
/* Справочник ЭККА ^ Временные данные продаж: Заголовок - Удаление в CHILD */
  DELETE t_SaleTemp FROM t_SaleTemp a, deleted d WHERE a.CRID = d.CRID
  IF @@ERROR > 0 RETURN

/* r_CRs ^ t_zRep - Проверка в CHILD */
/* Справочник ЭККА ^ Z-отчеты - Проверка в CHILD */
  IF EXISTS (SELECT * FROM t_zRep a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID)
    BEGIN
      EXEC z_RelationError 'r_CRs', 't_zRep', 3
      RETURN
    END


/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10452001 AND m.PKValue = 
    '[' + cast(i.CRID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10452001 AND m.PKValue = 
    '[' + cast(i.CRID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10452001, -ChID, 
    '[' + cast(d.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10452 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_CRs', N'Last', N'DELETE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_CRs] ON [r_CRs]
FOR UPDATE AS
/* r_CRs - Справочник ЭККА - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRs ^ r_CRSrvs - Проверка в PARENT */
/* Справочник ЭККА ^ Справочник торговых серверов - Проверка в PARENT */
  IF UPDATE(SrvID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SrvID NOT IN (SELECT SrvID FROM r_CRSrvs))
      BEGIN
        EXEC z_RelationError 'r_CRSrvs', 'r_CRs', 1
        RETURN
      END

/* r_CRs ^ r_Secs - Проверка в PARENT */
/* Справочник ЭККА ^ Справочник секций - Проверка в PARENT */
  IF UPDATE(SecID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
      BEGIN
        EXEC z_RelationError 'r_Secs', 'r_CRs', 1
        RETURN
      END

/* r_CRs ^ r_Stocks - Проверка в PARENT */
/* Справочник ЭККА ^ Справочник складов - Проверка в PARENT */
  IF UPDATE(StockID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
      BEGIN
        EXEC z_RelationError 'r_Stocks', 'r_CRs', 1
        RETURN
      END

/* r_CRs ^ r_OperCRs - Обновление CHILD */
/* Справочник ЭККА ^ Справочник ЭККА - Операторы ЭККА - Обновление CHILD */
  IF UPDATE(CRID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID
          FROM r_OperCRs a, inserted i, deleted d WHERE a.CRID = d.CRID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_OperCRs a, deleted d WHERE a.CRID = d.CRID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА'' => ''Справочник ЭККА - Операторы ЭККА''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CRs ^ r_CRMP - Обновление CHILD */
/* Справочник ЭККА ^ Справочник ЭККА - Товары - Обновление CHILD */
  IF UPDATE(CRID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID
          FROM r_CRMP a, inserted i, deleted d WHERE a.CRID = d.CRID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_CRMP a, deleted d WHERE a.CRID = d.CRID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА'' => ''Справочник ЭККА - Товары''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CRs ^ r_WPs - Обновление CHILD */
/* Справочник ЭККА ^ Справочник рабочих мест - Обновление CHILD */
  IF UPDATE(CRID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID
          FROM r_WPs a, inserted i, deleted d WHERE a.CRID = d.CRID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_WPs a, deleted d WHERE a.CRID = d.CRID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА'' => ''Справочник рабочих мест''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_CRs ^ t_SaleTemp - Проверка в CHILD */
/* Справочник ЭККА ^ Временные данные продаж: Заголовок - Проверка в CHILD */
  IF UPDATE(CRID) IF EXISTS (SELECT * FROM t_SaleTemp a WITH(NOLOCK), deleted d WHERE a.CRID = d.CRID)
    BEGIN
      EXEC z_RelationError 'r_CRs', 't_SaleTemp', 2
      RETURN
    END

/* r_CRs ^ t_zRep - Обновление CHILD */
/* Справочник ЭККА ^ Z-отчеты - Обновление CHILD */
  IF UPDATE(CRID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.CRID = i.CRID
          FROM t_zRep a, inserted i, deleted d WHERE a.CRID = d.CRID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM t_zRep a, deleted d WHERE a.CRID = d.CRID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник ЭККА'' => ''Z-отчеты''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10452001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10452001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(CRID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10452001 AND l.PKValue = 
        '[' + cast(i.CRID as varchar(200)) + ']' AND i.CRID = d.CRID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10452001 AND l.PKValue = 
        '[' + cast(i.CRID as varchar(200)) + ']' AND i.CRID = d.CRID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10452001, ChID, 
          '[' + cast(d.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10452001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10452001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10452001, ChID, 
          '[' + cast(i.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(CRID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT CRID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT CRID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.CRID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10452001 AND l.PKValue = 
          '[' + cast(d.CRID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.CRID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10452001 AND l.PKValue = 
          '[' + cast(d.CRID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10452001, ChID, 
          '[' + cast(d.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10452001 AND PKValue IN (SELECT 
          '[' + cast(CRID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10452001 AND PKValue IN (SELECT 
          '[' + cast(CRID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10452001, ChID, 
          '[' + cast(i.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10452001, ChID, 
    '[' + cast(i.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_CRs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_CRs] ON [r_CRs]
FOR INSERT AS
/* r_CRs - Справочник ЭККА - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_CRs ^ r_CRSrvs - Проверка в PARENT */
/* Справочник ЭККА ^ Справочник торговых серверов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SrvID NOT IN (SELECT SrvID FROM r_CRSrvs))
    BEGIN
      EXEC z_RelationError 'r_CRSrvs', 'r_CRs', 0
      RETURN
    END

/* r_CRs ^ r_Secs - Проверка в PARENT */
/* Справочник ЭККА ^ Справочник секций - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.SecID NOT IN (SELECT SecID FROM r_Secs))
    BEGIN
      EXEC z_RelationError 'r_Secs', 'r_CRs', 0
      RETURN
    END

/* r_CRs ^ r_Stocks - Проверка в PARENT */
/* Справочник ЭККА ^ Справочник складов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.StockID NOT IN (SELECT StockID FROM r_Stocks))
    BEGIN
      EXEC z_RelationError 'r_Stocks', 'r_CRs', 0
      RETURN
    END


/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10452001, ChID, 
    '[' + cast(i.CRID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_CRs', N'Last', N'INSERT'
GO









































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO