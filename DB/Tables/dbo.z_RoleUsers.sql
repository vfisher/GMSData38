CREATE TABLE [dbo].[z_RoleUsers]
(
[RoleCode] [int] NOT NULL,
[UserCode] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_RoleUsers] ADD CONSTRAINT [pk_z_RoleUsers] PRIMARY KEY CLUSTERED ([RoleCode], [UserCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_RoleUsers] ([UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_RoleUsers] ADD CONSTRAINT [FK_z_RoleUsers_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_RoleUsers] ADD CONSTRAINT [FK_z_RoleUsers_z_Roles] FOREIGN KEY ([RoleCode]) REFERENCES [dbo].[z_Roles] ([RoleCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
