CREATE TABLE [dbo].[z_RoleTables] (
  [RoleCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [AccRead] [tinyint] NOT NULL,
  [AccInsert] [tinyint] NOT NULL,
  [AccUpdate] [tinyint] NOT NULL,
  [AccDelete] [tinyint] NOT NULL,
  CONSTRAINT [pk_z_RoleTables] PRIMARY KEY CLUSTERED ([RoleCode], [TableCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_RoleTables]
  ADD CONSTRAINT [FK_z_RoleTables_z_Roles] FOREIGN KEY ([RoleCode]) REFERENCES [dbo].[z_Roles] ([RoleCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_RoleTables]
  ADD CONSTRAINT [FK_z_RoleTables_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO