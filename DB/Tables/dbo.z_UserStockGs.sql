CREATE TABLE [dbo].[z_UserStockGs]
(
[UserID] [smallint] NOT NULL,
[StockGID] [smallint] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserStockGs] ADD CONSTRAINT [pk_z_UserStockGs] PRIMARY KEY CLUSTERED ([UserID], [StockGID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserStockGs] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserStockGs] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserStockGs] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserStockGs] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockGID] ON [dbo].[z_UserStockGs] ([StockGID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserStockGs] ([UserID]) ON [PRIMARY]
GO
