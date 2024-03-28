CREATE TABLE [dbo].[z_ReplicaFilters]
(
[ReplicaPubCode] [int] NOT NULL,
[TableCode] [int] NOT NULL,
[PTableCode] [int] NOT NULL,
[PFieldNames] [varchar] (250) NOT NULL,
[PFieldDescs] [varchar] (250) NULL,
[CTableCode] [int] NOT NULL,
[CFieldNames] [varchar] (250) NULL,
[CFieldDescs] [varchar] (250) NULL,
[Alias] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaFilters] ADD CONSTRAINT [pk_z_ReplicaFilters] PRIMARY KEY NONCLUSTERED ([ReplicaPubCode], [TableCode], [PFieldNames], [CTableCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReplicaPubCode] ON [dbo].[z_ReplicaFilters] ([ReplicaPubCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TableCode] ON [dbo].[z_ReplicaFilters] ([TableCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaFilters] ADD CONSTRAINT [FK_z_ReplicaFilters_z_ReplicaTables] FOREIGN KEY ([ReplicaPubCode], [TableCode]) REFERENCES [dbo].[z_ReplicaTables] ([ReplicaPubCode], [TableCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
