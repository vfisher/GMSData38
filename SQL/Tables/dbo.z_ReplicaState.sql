CREATE TABLE [dbo].[z_ReplicaState] (
  [ReplicaSubCode] [int] NOT NULL,
  [PCCode] [int] NOT NULL,
  [IsPublisher] [bit] NOT NULL,
  [DocTime] [datetime] NOT NULL DEFAULT (getdate()),
  [LastFullSync] [datetime] NULL,
  [MaxExchangedEventID] [bigint] NULL,
  [LastProcessedEventID] [bigint] NULL,
  [LastEventCount] [bigint] NULL,
  [LastSessionBytesExchanged] [bigint] NULL,
  [LastResult] [int] NULL,
  [LastErrorMsg] [varchar](max) NULL,
  CONSTRAINT [pk_z_ReplicaState] PRIMARY KEY CLUSTERED ([ReplicaSubCode], [PCCode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO