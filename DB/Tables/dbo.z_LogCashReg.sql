CREATE TABLE [dbo].[z_LogCashReg]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[CRID] [smallint] NOT NULL,
[DocTime] [smalldatetime] NULL DEFAULT (getdate()),
[CashRegAction] [int] NOT NULL,
[Status] [int] NOT NULL,
[Msg] [varchar] (2000) NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogCashReg] ADD CONSTRAINT [pk_z_LogCashReg] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [CRID_CashRegAction_LogID] ON [dbo].[z_LogCashReg] ([CRID], [CashRegAction], [LogID]) ON [PRIMARY]
GO
