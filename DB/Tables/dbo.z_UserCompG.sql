CREATE TABLE [dbo].[z_UserCompG]
(
[UserID] [smallint] NOT NULL,
[CGrID] [smallint] NOT NULL,
[AccRead] [tinyint] NOT NULL DEFAULT (0),
[AccInsert] [tinyint] NOT NULL DEFAULT (0),
[AccUpdate] [tinyint] NOT NULL DEFAULT (0),
[AccDelete] [tinyint] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserCompG] ADD CONSTRAINT [pk_z_UserCompG] PRIMARY KEY CLUSTERED ([UserID], [CGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccDelete] ON [dbo].[z_UserCompG] ([AccDelete]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccInsert] ON [dbo].[z_UserCompG] ([AccInsert]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccRead] ON [dbo].[z_UserCompG] ([AccRead]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccUpdate] ON [dbo].[z_UserCompG] ([AccUpdate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CGrID] ON [dbo].[z_UserCompG] ([CGrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[z_UserCompG] ([UserID]) ON [PRIMARY]
GO
