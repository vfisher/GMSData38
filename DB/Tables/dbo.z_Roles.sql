CREATE TABLE [dbo].[z_Roles]
(
[RoleCode] [int] NOT NULL,
[RoleName] [varchar] (250) NOT NULL,
[RoleDesc] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_Roles] ADD CONSTRAINT [pk_z_Roles] PRIMARY KEY CLUSTERED ([RoleCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleName] ON [dbo].[z_Roles] ([RoleName]) ON [PRIMARY]
GO
