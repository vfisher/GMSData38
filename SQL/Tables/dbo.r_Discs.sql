CREATE TABLE [dbo].[r_Discs] (
  [ChID] [bigint] NOT NULL,
  [DiscCode] [int] NOT NULL,
  [DiscName] [varchar](200) NOT NULL,
  [ThisChargeOnly] [bit] NOT NULL,
  [ThisDocBonus] [bit] NOT NULL,
  [OtherDocsBonus] [bit] NOT NULL,
  [ChargeDCard] [bit] NOT NULL,
  [DiscOnlyWithDCard] [bit] NOT NULL,
  [ChargeAfterClose] [bit] NOT NULL,
  [Priority] [int] NOT NULL,
  [AllowDiscs] [varchar](250) NULL,
  [Shed1] [varchar](2000) NULL,
  [Shed2] [varchar](2000) NULL,
  [Shed3] [varchar](2000) NULL,
  [BDate] [smalldatetime] NOT NULL,
  [EDate] [smalldatetime] NOT NULL,
  [GenProcs] [bit] NOT NULL DEFAULT (1),
  [InUse] [bit] NOT NULL DEFAULT (1),
  [DocCode] [int] NOT NULL DEFAULT (1011),
  [SimpleDisc] [bit] NOT NULL DEFAULT (0),
  [SaveDiscToDCard] [bit] NOT NULL DEFAULT (0),
  [SaveBonusToDCard] [bit] NOT NULL DEFAULT (0),
  [DiscFromDCard] [bit] NOT NULL DEFAULT (0),
  [ReProcessPosDiscs] [bit] NOT NULL DEFAULT (0),
  [ValidOurs] [varchar](250) NULL,
  [ValidStocks] [varchar](250) NULL,
  [AutoSelDiscs] [bit] NOT NULL DEFAULT (0),
  [ShortCut] [varchar](250) NULL,
  [Notes] [varchar](250) NULL,
  [GroupDisc] [bit] NOT NULL,
  [PrintInCheque] [bit] NOT NULL DEFAULT (1),
  [AllowZeroPrice] [bit] NOT NULL DEFAULT (0),
  [AllowEditQty] [bit] NOT NULL DEFAULT (0),
  [RedistributeDiscSumInBusket] [bit] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_r_Discs] PRIMARY KEY CLUSTERED ([DiscCode])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ChID]
  ON [dbo].[r_Discs] ([ChID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [DiscName]
  ON [dbo].[r_Discs] ([DiscName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_Discs] ON [r_Discs]
FOR INSERT AS
/* r_Discs - Справочник акций - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470001, ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_Discs', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_Discs] ON [r_Discs]
FOR UPDATE AS
/* r_Discs - Справочник акций - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_Discs ^ r_DiscMessages - Обновление CHILD */
/* Справочник акций ^ Справочник акций: Сообщения - Обновление CHILD */
  IF UPDATE(DiscCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DiscCode = i.DiscCode
          FROM r_DiscMessages a, inserted i, deleted d WHERE a.DiscCode = d.DiscCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscMessages a, deleted d WHERE a.DiscCode = d.DiscCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник акций'' => ''Справочник акций: Сообщения''.'
, 18, 1)
          ROLLBACK TRAN
          RETURN
        END
    END

/* r_Discs ^ r_DiscMessagesT - Обновление CHILD */
/* Справочник акций ^ Справочник акций: Сообщения - Источники данных - Обновление CHILD */
  IF UPDATE(DiscCode)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DiscCode = i.DiscCode
          FROM r_DiscMessagesT a, inserted i, deleted d WHERE a.DiscCode = d.DiscCode
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM r_DiscMessagesT a, deleted d WHERE a.DiscCode = d.DiscCode)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Справочник акций'' => ''Справочник акций: Сообщения - Источники данных''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 10470001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 10470001 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(DiscCode))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10470001 AND l.PKValue = 
        '[' + cast(i.DiscCode as varchar(200)) + ']' AND i.DiscCode = d.DiscCode
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10470001 AND l.PKValue = 
        '[' + cast(i.DiscCode as varchar(200)) + ']' AND i.DiscCode = d.DiscCode
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10470001, ChID, 
          '[' + cast(d.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10470001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10470001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10470001, ChID, 
          '[' + cast(i.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(DiscCode)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT DiscCode FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 10470001 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.DiscCode as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 10470001 AND l.PKValue = 
          '[' + cast(d.DiscCode as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 10470001, ChID, 
          '[' + cast(d.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 10470001 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 10470001 AND PKValue IN (SELECT 
          '[' + cast(DiscCode as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 10470001, ChID, 
          '[' + cast(i.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 10470001, ChID, 
    '[' + cast(i.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_Discs', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_Discs] ON [r_Discs]
FOR DELETE AS
/* r_Discs - Справочник акций - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_Discs ^ r_DiscMessages - Удаление в CHILD */
/* Справочник акций ^ Справочник акций: Сообщения - Удаление в CHILD */
  DELETE r_DiscMessages FROM r_DiscMessages a, deleted d WHERE a.DiscCode = d.DiscCode
  IF @@ERROR > 0 RETURN

/* r_Discs ^ r_DiscMessagesT - Удаление в CHILD */
/* Справочник акций ^ Справочник акций: Сообщения - Источники данных - Удаление в CHILD */
  DELETE r_DiscMessagesT FROM r_DiscMessagesT a, deleted d WHERE a.DiscCode = d.DiscCode
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 10470001 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 10470001 AND m.PKValue = 
    '[' + cast(i.DiscCode as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 10470001, -ChID, 
    '[' + cast(d.DiscCode as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 10470 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_Discs', N'Last', N'DELETE'
GO