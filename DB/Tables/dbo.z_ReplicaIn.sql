CREATE TABLE [dbo].[z_ReplicaIn]
(
[ReplicaEventID] [bigint] NOT NULL,
[ReplicaSubCode] [int] NOT NULL,
[ExecStr] [varchar] (max) NOT NULL,
[Status] [int] NOT NULL,
[Msg] [varchar] (2000) NULL,
[DocTime] [smalldatetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaIn] ADD CONSTRAINT [pk_z_ReplicaIn] PRIMARY KEY CLUSTERED ([ReplicaSubCode], [ReplicaEventID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaIn] ADD CONSTRAINT [FK_z_ReplicaIn_z_ReplicaSubs] FOREIGN KEY ([ReplicaSubCode]) REFERENCES [dbo].[z_ReplicaSubs] ([ReplicaSubCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
