CREATE TABLE [dbo].[t_PInPCh] (
  [ChID] [bigint] NOT NULL,
  [ChDate] [smalldatetime] NOT NULL,
  [ChTime] [smalldatetime] NOT NULL,
  [ProdID] [int] NOT NULL,
  [PPID] [int] NOT NULL,
  [OldCurrID] [smallint] NOT NULL,
  [OldPriceMC_In] [numeric](21, 9) NOT NULL,
  [OldPriceMC] [numeric](21, 9) NOT NULL,
  [CurrID] [smallint] NOT NULL,
  [PriceMC_In] [numeric](21, 9) NOT NULL,
  [PriceMC] [numeric](21, 9) NOT NULL,
  [UserID] [smallint] NOT NULL,
  [OldPriceCC_In] [numeric](21, 9) NOT NULL DEFAULT (0),
  [PriceCC_In] [numeric](21, 9) NOT NULL DEFAULT (0),
  [OldPriceAC_In] [numeric](21, 9) NOT NULL DEFAULT (0),
  [PriceAC_In] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_t_PInPCh] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [ChDate]
  ON [dbo].[t_PInPCh] ([ChDate])
  ON [PRIMARY]
GO

CREATE INDEX [CurrID]
  ON [dbo].[t_PInPCh] ([CurrID])
  ON [PRIMARY]
GO

CREATE INDEX [OldCurrID]
  ON [dbo].[t_PInPCh] ([OldCurrID])
  ON [PRIMARY]
GO

CREATE INDEX [PPID]
  ON [dbo].[t_PInPCh] ([PPID])
  ON [PRIMARY]
GO

CREATE INDEX [ProdID]
  ON [dbo].[t_PInPCh] ([ProdID])
  ON [PRIMARY]
GO

CREATE INDEX [UserID]
  ON [dbo].[t_PInPCh] ([UserID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.ProdID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.PPID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.OldCurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.OldPriceMC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.OldPriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.CurrID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.PriceMC_In'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.PriceMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.t_PInPCh.UserID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_PInPCh] ON [t_PInPCh]
FOR INSERT AS
/* t_PInPCh - Изменение цен прихода: Бизнес - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_PInPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_PInPCh', 0
      RETURN
    END

/* t_PInPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник валют - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.OldCurrID NOT IN (SELECT CurrID FROM r_Currs))
    BEGIN
      EXEC z_RelationError 'r_Currs', 't_PInPCh', 0
      RETURN
    END

/* t_PInPCh ^ r_Prods - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник товаров - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
    BEGIN
      EXEC z_RelationError 'r_Prods', 't_PInPCh', 0
      RETURN
    END

/* t_PInPCh ^ r_Users - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник пользователей - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
    BEGIN
      EXEC z_RelationError 'r_Users', 't_PInPCh', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 11905001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_PInPCh', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_PInPCh] ON [t_PInPCh]
FOR UPDATE AS
/* t_PInPCh - Изменение цен прихода: Бизнес - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_PInPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(CurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.CurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_PInPCh', 1
        RETURN
      END

/* t_PInPCh ^ r_Currs - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник валют - Проверка в PARENT */
  IF UPDATE(OldCurrID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.OldCurrID NOT IN (SELECT CurrID FROM r_Currs))
      BEGIN
        EXEC z_RelationError 'r_Currs', 't_PInPCh', 1
        RETURN
      END

/* t_PInPCh ^ r_Prods - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник товаров - Проверка в PARENT */
  IF UPDATE(ProdID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ProdID NOT IN (SELECT ProdID FROM r_Prods))
      BEGIN
        EXEC z_RelationError 'r_Prods', 't_PInPCh', 1
        RETURN
      END

/* t_PInPCh ^ r_Users - Проверка в PARENT */
/* Изменение цен прихода: Бизнес ^ Справочник пользователей - Проверка в PARENT */
  IF UPDATE(UserID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.UserID NOT IN (SELECT UserID FROM r_Users))
      BEGIN
        EXEC z_RelationError 'r_Users', 't_PInPCh', 1
        RETURN
      END

/* t_PInPCh ^ z_DocShed - Обновление CHILD */
/* Изменение цен прихода: Бизнес ^ Документы - Процессы - Обновление CHILD */
  IF UPDATE(ChID)
    BEGIN
      IF @RCount = 1
        BEGIN
          UPDATE a SET a.DocCode = 11905, a.ChID = i.ChID
          FROM z_DocShed a, inserted i, deleted d WHERE a.DocCode = 11905 AND a.ChID = d.ChID
          IF @@ERROR > 0 RETURN
        END
      ELSE IF EXISTS (SELECT * FROM z_DocShed a, deleted d WHERE a.DocCode = 11905 AND a.ChID = d.ChID)
        BEGIN
          RAISERROR ('Каскадная операция невозможна ''Изменение цен прихода: Бизнес'' => ''Документы - Процессы''.'
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
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 11905001 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 11905001 AND l.ChID = d.ChID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 11905001, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 11905001 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 11905001 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 11905001, ChID, 
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
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 11905001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 11905001 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']'
        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 11905001, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_PInPCh', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_PInPCh] ON [t_PInPCh]
FOR DELETE AS
/* t_PInPCh - Изменение цен прихода: Бизнес - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* t_PInPCh ^ z_DocShed - Удаление в CHILD */
/* Изменение цен прихода: Бизнес ^ Документы - Процессы - Удаление в CHILD */
  DELETE z_DocShed FROM z_DocShed a, deleted d WHERE a.DocCode = 11905 AND a.ChID = d.ChID
  IF @@ERROR > 0 RETURN

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 11905001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 11905001 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 11905001, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 11905 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_PInPCh', N'Last', N'DELETE'
GO