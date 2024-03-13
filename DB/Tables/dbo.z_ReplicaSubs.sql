CREATE TABLE [dbo].[z_ReplicaSubs]
(
[ReplicaSubCode] [int] NOT NULL,
[ReplicaSubName] [varchar] (200) NOT NULL,
[ReplicaPubCode] [int] NOT NULL,
[PublisherCode] [int] NOT NULL,
[Shed] [varchar] (50) NULL,
[Notes] [varchar] (200) NULL,
[ServiceName] [varchar] (250) NULL,
[UseSched] [bit] NOT NULL DEFAULT (1),
[PCCode] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaSubs] ADD CONSTRAINT [pk_z_ReplicaSubs] PRIMARY KEY CLUSTERED ([ReplicaSubCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PublisherCode] ON [dbo].[z_ReplicaSubs] ([PublisherCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReplicaPubCode] ON [dbo].[z_ReplicaSubs] ([ReplicaPubCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[z_ReplicaSubs] ([ReplicaSubName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaSubs] ADD CONSTRAINT [FK_z_ReplicaSubs_r_PCs] FOREIGN KEY ([PCCode]) REFERENCES [dbo].[r_PCs] ([PCCode]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[z_ReplicaSubs] ADD CONSTRAINT [FK_z_ReplicaSubs_z_ReplicaPubs] FOREIGN KEY ([ReplicaPubCode]) REFERENCES [dbo].[z_ReplicaPubs] ([ReplicaPubCode]) ON UPDATE CASCADE
GO
