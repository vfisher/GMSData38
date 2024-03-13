CREATE TABLE [dbo].[z_ReplicaExchangeLog]
(
[ChID] [bigint] NOT NULL IDENTITY(1, 1),
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
[Msg] [varchar] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaExchangeLog] ADD CONSTRAINT [pk_z_ReplicaExchangeLog] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocTime] ON [dbo].[z_ReplicaExchangeLog] ([DocTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReplicaSubCode_PCCode] ON [dbo].[z_ReplicaExchangeLog] ([ReplicaSubCode], [PCCode]) ON [PRIMARY]
GO
