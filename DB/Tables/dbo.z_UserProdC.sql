CREATE TABLE [dbo].[z_UserProdC]
(
[UserID] [smallint] NOT NULL,
[PCatID] [int] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserProdC] ADD CONSTRAINT [pk_z_UserProdC] PRIMARY KEY CLUSTERED ([UserID], [PCatID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserProdC] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserProdC] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserProdC] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserProdC] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCatID] ON [dbo].[z_UserProdC] ([PCatID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserProdC] ([UserID]) ON [PRIMARY]
GO
