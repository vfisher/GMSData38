CREATE TABLE [dbo].[t_CashRegInetChequesRepair] (
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
  [IsTesting] [bit] NOT NULL,
  [ExtraInfo] [varchar](8000) NULL,
  [SrcPosID] [int] NOT NULL DEFAULT (0),
  CONSTRAINT [pk_t_CashRegInetChequesRepair] PRIMARY KEY CLUSTERED ([DocCode], [ChID], [SrcPosID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_CashRegInetChequesRepair] ON [t_CashRegInetChequesRepair]
FOR DELETE AS
/* t_CashRegInetChequesRepair - Чеки электронного РРО - перерегистрация - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_t_CashRegInetChequesRepair', N'Last', N'DELETE'
GO

ALTER TABLE [dbo].[t_CashRegInetChequesRepair]
  ADD CONSTRAINT [FK_t_CashRegInetChequesRepair_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO