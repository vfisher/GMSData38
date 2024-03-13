CREATE TABLE [dbo].[r_Resources]
(
[ChID] [bigint] NOT NULL,
[ResourceID] [int] NOT NULL,
[ResourceName] [varchar] (200) NOT NULL,
[ResourceTypeID] [int] NOT NULL,
[MaxClients] [int] NOT NULL DEFAULT ((1)),
[StockID] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Resources] ADD CONSTRAINT [pk_r_Resources] PRIMARY KEY CLUSTERED ([ResourceID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Resources] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceName] ON [dbo].[r_Resources] ([ResourceName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceTypeID] ON [dbo].[r_Resources] ([ResourceTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[r_Resources] ([StockID]) ON [PRIMARY]
GO
