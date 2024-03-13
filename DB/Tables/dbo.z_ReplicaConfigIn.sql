CREATE TABLE [dbo].[z_ReplicaConfigIn]
(
[ReplicaConfigID] [int] NOT NULL,
[ReplicaSubCode] [int] NOT NULL,
[Status] [int] NOT NULL,
[Msg] [varchar] (2000) NULL,
[DocTime] [smalldatetime] NULL DEFAULT (getdate()),
[Hash] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_ReplicaConfigIn] ADD CONSTRAINT [pk_z_ReplicaConfigIn] PRIMARY KEY CLUSTERED ([ReplicaConfigID], [ReplicaSubCode]) ON [PRIMARY]
GO
