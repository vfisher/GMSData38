CREATE TABLE [dbo].[t_CashRegInetCheques] (
  [DocCode] [int] NOT NULL,
  [ChID] [bigint] NOT NULL,
  [InetChequeNum] [varchar](50) NOT NULL,
  [InetChequeURL] [varchar](250) NULL,
  [Status] [int] NOT NULL,
  [IsOffline] [bit] NOT NULL,
  [OfflineSeed] [varchar](128) NOT NULL,
  [OfflineSessionId] [varchar](128) NOT NULL,
  [XMLTextCheque] [varbinary](max) NULL,
  [DocTime] [datetime] NOT NULL,
  [FinID] [varchar](250) NOT NULL,
  [NextLocalNum] [int] NOT NULL,
  [OfflineNextLocalNum] [int] NOT NULL,
  [DocHash] [varchar](250) NULL,
  [CRID] [smallint] NOT NULL,
  [IsTesting] [bit] NOT NULL DEFAULT (0),
  [ExtraInfo] [varchar](8000) NULL,
  CONSTRAINT [pk_t_CashRegInetCheques] PRIMARY KEY CLUSTERED ([ChID], [DocCode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_t_CashRegInetCheques] ON [t_CashRegInetCheques]
FOR INSERT AS
/* t_CashRegInetCheques - Чеки электронного РРО - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_CashRegInetCheques ^ t_CRRet - Проверка в PARENT */
/* Чеки электронного РРО ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
    BEGIN
      EXEC z_RelationError 't_CRRet', 't_CashRegInetCheques', 0
      RETURN
    END

/* t_CashRegInetCheques ^ t_MonIntExp - Проверка в PARENT */
/* Чеки электронного РРО ^ Служебный расход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11052 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntExp))
    BEGIN
      EXEC z_RelationError 't_MonIntExp', 't_CashRegInetCheques', 0
      RETURN
    END

/* t_CashRegInetCheques ^ t_MonIntRec - Проверка в PARENT */
/* Чеки электронного РРО ^ Служебный приход денег - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11051 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntRec))
    BEGIN
      EXEC z_RelationError 't_MonIntRec', 't_CashRegInetCheques', 0
      RETURN
    END

/* t_CashRegInetCheques ^ t_Sale - Проверка в PARENT */
/* Чеки электронного РРО ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
    BEGIN
      EXEC z_RelationError 't_Sale', 't_CashRegInetCheques', 0
      RETURN
    END

/* t_CashRegInetCheques ^ t_zRep - Проверка в PARENT */
/* Чеки электронного РРО ^ Z-отчеты - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11951 AND i.ChID NOT IN (SELECT ChID FROM t_zRep))
    BEGIN
      EXEC z_RelationError 't_zRep', 't_CashRegInetCheques', 0
      RETURN
    END

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_t_CashRegInetCheques', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_t_CashRegInetCheques] ON [t_CashRegInetCheques]
FOR UPDATE AS
/* t_CashRegInetCheques - Чеки электронного РРО - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* t_CashRegInetCheques ^ t_CRRet - Проверка в PARENT */
/* Чеки электронного РРО ^ Возврат товара по чеку: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11004 AND i.ChID NOT IN (SELECT ChID FROM t_CRRet))
      BEGIN
        EXEC z_RelationError 't_CRRet', 't_CashRegInetCheques', 1
        RETURN
      END

/* t_CashRegInetCheques ^ t_MonIntExp - Проверка в PARENT */
/* Чеки электронного РРО ^ Служебный расход денег - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11052 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntExp))
      BEGIN
        EXEC z_RelationError 't_MonIntExp', 't_CashRegInetCheques', 1
        RETURN
      END

/* t_CashRegInetCheques ^ t_MonIntRec - Проверка в PARENT */
/* Чеки электронного РРО ^ Служебный приход денег - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11051 AND i.ChID NOT IN (SELECT ChID FROM t_MonIntRec))
      BEGIN
        EXEC z_RelationError 't_MonIntRec', 't_CashRegInetCheques', 1
        RETURN
      END

/* t_CashRegInetCheques ^ t_Sale - Проверка в PARENT */
/* Чеки электронного РРО ^ Продажа товара оператором: Заголовок - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11035 AND i.ChID NOT IN (SELECT ChID FROM t_Sale))
      BEGIN
        EXEC z_RelationError 't_Sale', 't_CashRegInetCheques', 1
        RETURN
      END

/* t_CashRegInetCheques ^ t_zRep - Проверка в PARENT */
/* Чеки электронного РРО ^ Z-отчеты - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.DocCode = 11951 AND i.ChID NOT IN (SELECT ChID FROM t_zRep))
      BEGIN
        EXEC z_RelationError 't_zRep', 't_CashRegInetCheques', 1
        RETURN
      END

END
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_t_CashRegInetCheques', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_CashRegInetCheques] ON [t_CashRegInetCheques]
FOR DELETE AS
/* t_CashRegInetCheques - Чеки электронного РРО - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_CashRegInetCheques', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[t_CashRegInetCheques]
  ADD CONSTRAINT [FK_t_CashRegInetCheques_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO