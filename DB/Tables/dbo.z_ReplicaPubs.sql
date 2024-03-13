CREATE TABLE [dbo].[z_ReplicaPubs]
(
[ReplicaPubCode] [int] NOT NULL,
[ReplicaPubName] [varchar] (200) NOT NULL,
[GenTriggers] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[GenProcs] [bit] NOT NULL DEFAULT (0),
[SyncDiscs] [bit] NOT NULL DEFAULT (0),
[SyncUsers] [bit] NOT NULL DEFAULT (0),
[DestPCCode] [int] NOT NULL DEFAULT ((0)),
[MainReplicaPubCode] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaPubs] ADD CONSTRAINT [pk_z_ReplicaPubs] PRIMARY KEY CLUSTERED ([ReplicaPubCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[z_ReplicaPubs] ([ReplicaPubName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaPubs] ADD CONSTRAINT [FK_z_ReplicaPubs_r_PCs] FOREIGN KEY ([DestPCCode]) REFERENCES [dbo].[r_PCs] ([PCCode])
GO
