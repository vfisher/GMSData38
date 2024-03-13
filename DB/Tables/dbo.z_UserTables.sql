CREATE TABLE [dbo].[z_UserTables]
(
[UserCode] [smallint] NOT NULL,
[TableCode] [int] NOT NULL,
[AccRead] [tinyint] NOT NULL,
[AccInsert] [tinyint] NOT NULL,
[AccUpdate] [tinyint] NOT NULL,
[AccDelete] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserTables] ADD CONSTRAINT [pk_z_UserTables] PRIMARY KEY CLUSTERED ([UserCode], [TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_UserTables] ([TableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserCode] ON [dbo].[z_UserTables] ([UserCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_UserTables] ADD CONSTRAINT [FK_z_UserTables_r_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_UserTables] ADD CONSTRAINT [FK_z_UserTables_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
