CREATE TABLE [dbo].[z_LogSale]
(
[LogIDex] [bigint] NOT NULL IDENTITY(1, 1),
[CRID] [smallint] NOT NULL,
[DocTime] [datetime] NOT NULL,
[DocCode] [int] NULL,
[ChID] [bigint] NULL,
[EventId] [int] NOT NULL,
[ExtraInfo] [varchar] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogSale] ADD CONSTRAINT [pk_z_LogSale] PRIMARY KEY CLUSTERED ([LogIDex]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRID_DocTime] ON [dbo].[z_LogSale] ([CRID], [DocTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocCode_ChID] ON [dbo].[z_LogSale] ([DocCode], [ChID]) ON [PRIMARY]
GO
