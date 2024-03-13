CREATE TABLE [dbo].[z_UserProdG]
(
[UserID] [smallint] NOT NULL,
[PGrID] [int] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserProdG] ADD CONSTRAINT [pk_z_UserProdG] PRIMARY KEY CLUSTERED ([UserID], [PGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserProdG] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserProdG] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserProdG] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserProdG] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrID] ON [dbo].[z_UserProdG] ([PGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserProdG] ([UserID]) ON [PRIMARY]
GO
