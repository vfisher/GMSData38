CREATE TABLE [dbo].[z_AppRoles] (
  [AppCode] [int] NOT NULL,
  [RoleCode] [int] NOT NULL,
  CONSTRAINT [pk_z_AppRoles] PRIMARY KEY CLUSTERED ([AppCode], [RoleCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_AppRoles]
  ADD CONSTRAINT [FK_z_AppRoles_z_Apps] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[z_Apps] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_AppRoles]
  ADD CONSTRAINT [FK_z_AppRoles_z_Roles] FOREIGN KEY ([RoleCode]) REFERENCES [dbo].[z_Roles] ([RoleCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO