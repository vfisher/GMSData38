CREATE TABLE [dbo].[z_RoleObjects]
(
[RoleCode] [int] NOT NULL,
[ObjCode] [int] NOT NULL,
[AccRun] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_RoleObjects] ADD CONSTRAINT [pk_z_RoleObjects] PRIMARY KEY CLUSTERED ([RoleCode], [ObjCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_RoleObjects] ADD CONSTRAINT [FK_z_RoleObjects_z_Objects] FOREIGN KEY ([ObjCode]) REFERENCES [dbo].[z_Objects] ([ObjCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_RoleObjects] ADD CONSTRAINT [FK_z_RoleObjects_z_Roles] FOREIGN KEY ([RoleCode]) REFERENCES [dbo].[z_Roles] ([RoleCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
