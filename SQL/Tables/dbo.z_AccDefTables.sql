CREATE TABLE [dbo].[z_AccDefTables] (
  [AccDefCode] [int] NOT NULL,
  [TableCode] [int] NOT NULL,
  [AccRead] [tinyint] NOT NULL,
  [AccInsert] [tinyint] NOT NULL,
  [AccUpdate] [tinyint] NOT NULL,
  [AccDelete] [tinyint] NOT NULL,
  CONSTRAINT [pk_z_AccDefTables] PRIMARY KEY CLUSTERED ([AccDefCode], [TableCode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_AccDefTables]
  ADD CONSTRAINT [FK_z_AccDefTables_z_AccDefs] FOREIGN KEY ([AccDefCode]) REFERENCES [dbo].[z_AccDefs] ([AccDefCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[z_AccDefTables]
  ADD CONSTRAINT [FK_z_AccDefTables_z_Tables] FOREIGN KEY ([TableCode]) REFERENCES [dbo].[z_Tables] ([TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO