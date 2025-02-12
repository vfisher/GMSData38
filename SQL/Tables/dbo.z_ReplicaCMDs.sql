CREATE TABLE [dbo].[z_ReplicaCMDs] (
  [LogId] [int] IDENTITY,
  [DocTime] [datetime] NULL DEFAULT (getdate()),
  [ReplicaCMD] [int] NOT NULL,
  [ReplicaSubCode] [int] NOT NULL,
  CONSTRAINT [pk_z_ReplicaCMDs] PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
GO