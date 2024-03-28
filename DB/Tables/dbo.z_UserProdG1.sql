CREATE TABLE [dbo].[z_UserProdG1]
(
[UserID] [smallint] NOT NULL,
[PGrID1] [int] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserProdG1] ADD CONSTRAINT [pk_z_UserProdG1] PRIMARY KEY CLUSTERED ([UserID], [PGrID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserProdG1] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserProdG1] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserProdG1] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserProdG1] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PGrID1] ON [dbo].[z_UserProdG1] ([PGrID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserProdG1] ([UserID]) ON [PRIMARY]
GO
