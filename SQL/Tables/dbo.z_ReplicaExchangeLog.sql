CREATE TABLE [dbo].[z_ReplicaExchangeLog] (
  [ChID] [bigint] IDENTITY,
  [ReplicaSubCode] [int] NULL,
  [PCCode] [int] NULL,
  [Mode] [int] NULL,
  [ExchangeStartTime] [datetime] NULL,
  [DocTime] [datetime] NULL,
  [MaxExchangedEventID] [bigint] NULL,
  [LastProcessedEventID] [bigint] NULL,
  [LastEventCount] [bigint] NULL,
  [LastSessionBytesExchanged] [bigint] NULL,
  [Result] [int] NULL,
  [Msg] [varchar](max) NULL,
  CONSTRAINT [pk_z_ReplicaExchangeLog] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [DocTime]
  ON [dbo].[z_ReplicaExchangeLog] ([DocTime])
  ON [PRIMARY]
GO

CREATE INDEX [ReplicaSubCode_PCCode]
  ON [dbo].[z_ReplicaExchangeLog] ([ReplicaSubCode], [PCCode])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_z_ReplicaExchangeLog] ON [z_ReplicaExchangeLog]
FOR DELETE AS
/* z_ReplicaExchangeLog - Синхронизация: Журнал Обмена - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1005 AND m.ChID = i.ChID

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_z_ReplicaExchangeLog', N'Last', N'DELETE'
GO