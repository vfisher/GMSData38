CREATE TABLE [dbo].[z_ReplicaConfigOut] (
  [ReplicaEventID] [bigint] IDENTITY,
  [TableCode] [int] NOT NULL,
  [DocTime] [smalldatetime] NULL DEFAULT (getdate()),
  [IDFields] [varchar](250) NULL,
  [IDValue] [varchar](250) NULL,
  [ReplEventType] [int] NOT NULL DEFAULT (0),
  [ReplicaSubCode] [int] NOT NULL,
  [ReplicaConfigID] [int] NULL,
  CONSTRAINT [pk_z_ReplicaConfigEvents] PRIMARY KEY CLUSTERED ([ReplicaEventID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[z_ReplicaConfigOut]
  ADD CONSTRAINT [FK_z_ReplicaConfigOut_z_ReplicaSubs] FOREIGN KEY ([ReplicaSubCode]) REFERENCES [dbo].[z_ReplicaSubs] ([ReplicaSubCode]) ON UPDATE CASCADE
GO