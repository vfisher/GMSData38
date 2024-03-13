CREATE TABLE [dbo].[t_CashRegInetChequesRepair]
(
[DocCode] [int] NOT NULL,
[ChID] [bigint] NOT NULL,
[InetChequeNum] [varchar] (50) NOT NULL,
[InetChequeURL] [varchar] (250) NULL,
[Status] [int] NOT NULL,
[IsOffline] [bit] NOT NULL,
[OfflineSeed] [varchar] (128) NOT NULL,
[OfflineSessionId] [varchar] (128) NOT NULL,
[XMLTextCheque] [varbinary] (max) NULL,
[DocTime] [datetime] NOT NULL,
[FinID] [varchar] (250) NOT NULL,
[NextLocalNum] [int] NOT NULL,
[OfflineNextLocalNum] [int] NOT NULL,
[DocHash] [varchar] (250) NULL,
[CRID] [smallint] NOT NULL,
[IsTesting] [bit] NOT NULL,
[ExtraInfo] [varchar] (8000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CashRegInetChequesRepair] ADD CONSTRAINT [pk_t_CashRegInetChequesRepair] PRIMARY KEY CLUSTERED ([ChID], [DocCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CashRegInetChequesRepair] ADD CONSTRAINT [FK_t_CashRegInetChequesRepair_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
