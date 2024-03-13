CREATE TABLE [dbo].[z_DocRoles]
(
[DocCode] [int] NOT NULL,
[RoleCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocRoles] ADD CONSTRAINT [pk_z_DocRoles] PRIMARY KEY CLUSTERED ([DocCode], [RoleCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocRoles] ADD CONSTRAINT [FK_z_DocRoles_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_DocRoles] ADD CONSTRAINT [FK_z_DocRoles_z_Roles] FOREIGN KEY ([RoleCode]) REFERENCES [dbo].[z_Roles] ([RoleCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
