CREATE TABLE [dbo].[r_ProdMPCh] (
  [ChID] [bigint] NOT NULL,
  [ChDate] [smalldatetime] NOT NULL,
  [ChTime] [smalldatetime] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PLID] [int] NOT NULL,
  [OldCurrID] [smallint] NOT NULL,
  [OldPriceMC] [numeric](21, 9) NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [PriceMC] [numeric](21, 9) NOT NULL,
  [UserID] [smallint] NOT NULL,
  [DocChID] [bigint] NOT NULL CONSTRAINT [DF__r_ProdMPC__DocCh__36B6B1A4] DEFAULT (0),
  [DocCode] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_r_ProdMPCh] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChDate]
  ON [dbo].[r_ProdMPCh] ([ChDate])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[r_ProdMPCh] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [OldCurrID]
  ON [dbo].[r_ProdMPCh] ([OldCurrID])
  ON [PRIMARY]
GO

CREATE INDEX [PLID]
  ON [dbo].[r_ProdMPCh] ([PLID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[r_ProdMPCh] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[r_ProdMPCh] ([UserID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.PLID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.OldCurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.OldPriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.PriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.r_ProdMPCh.UserID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_r_ProdMPCh] ON [r_ProdMPCh]
FOR INSERT AS
/* r_ProdMPCh - Изменение цен продажи (Таблица) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OldCurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_ProdMPCh', 0
      RETURN
    END

/* r_ProdMPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 'r_ProdMPCh', 0
      RETURN
    END

/* r_ProdMPCh ^ r_PLs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник прайс-листов - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
    BEGIN
      EXEC z_RelationError 'r_PLs', 'r_ProdMPCh', 0
      RETURN
    END

/* r_ProdMPCh ^ r_Prods - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 'r_ProdMPCh', 0
      RETURN
    END

/* r_ProdMPCh ^ r_Users - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 'r_ProdMPCh', 0
      RETURN
    END

/* r_ProdMPCh ^ z_Docs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Документы - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
    BEGIN
      EXEC z_RelationError 'z_Docs', 'r_ProdMPCh', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 8010001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_r_ProdMPCh', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_r_ProdMPCh] ON [r_ProdMPCh]
FOR UPDATE AS
/* r_ProdMPCh - Изменение цен продажи (Таблица) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* r_ProdMPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(OldCurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OldCurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'r_ProdMPCh', 1
        RETURN
      END

/* r_ProdMPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 'r_ProdMPCh', 1
        RETURN
      END

/* r_ProdMPCh ^ r_PLs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник прайс-листов - Проверка в PARENT */
  IF UPDATE(PLID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.PLID NOT IN (SELECT PLID FROM r_PLs))
      BEGIN
        EXEC z_RelationError 'r_PLs', 'r_ProdMPCh', 1
        RETURN
      END

/* r_ProdMPCh ^ r_Prods - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 'r_ProdMPCh', 1
        RETURN
      END

/* r_ProdMPCh ^ r_Users - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 'r_ProdMPCh', 1
        RETURN
      END

/* r_ProdMPCh ^ z_Docs - Проверка в PARENT */
/* Изменение цен продажи (Таблица) ^ Документы - Проверка в PARENT */
  IF UPDATE(DocCode)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode NOT IN (SELECT DocCode FROM z_Docs))
      BEGIN
        EXEC z_RelationError 'z_Docs', 'r_ProdMPCh', 1
        RETURN
      END

/* r_ProdMPCh ^ z_DocShed - Обновление CHILD */
/* Изменение цен продажи (Таблица) ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 8010, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 8010 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 8010 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Изменение цен продажи (Таблица)'' => ''Документы - Процессы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 8010001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 8010001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 8010001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 8010001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 8010001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 8010001, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 8010001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 8010001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 8010001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_r_ProdMPCh', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_r_ProdMPCh] ON [r_ProdMPCh]
FOR DELETE AS
/* r_ProdMPCh - Изменение цен продажи (Таблица) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* r_ProdMPCh ^ z_DocShed - Удаление в CHILD */
/* Изменение цен продажи (Таблица) ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 8010 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 8010001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 8010001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 8010001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 8010 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_r_ProdMPCh', N'Last', N'DELETE'
GO