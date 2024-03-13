CREATE TABLE [dbo].[z_RoleDocs]
(
[RoleCode] [int] NOT NULL,
[DocCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_RoleDocs] ADD CONSTRAINT [pk_z_RoleDocs] PRIMARY KEY CLUSTERED ([RoleCode], [DocCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_RoleDocs] ADD CONSTRAINT [FK_z_RoleDocs_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_RoleDocs] ADD CONSTRAINT [FK_z_RoleDocs_z_Roles] FOREIGN KEY ([RoleCode]) REFERENCES [dbo].[z_Roles] ([RoleCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
