CREATE TABLE [dbo].[z_ReplicaConfigSent] (
  [ReplicaConfigID] [int] NOT NULL,
  [DocTime] [smalldatetime] NULL DEFAULT (getdate()),
  [Status] [int] NOT NULL,
  [Msg] [varchar](2000) NULL,
  [Hash] [varchar](250) NULL,
  CONSTRAINT [pk_z_ReplicaConfigSent] PRIMARY KEY CLUSTERED ([ReplicaConfigID])
)
ON [PRIMARY]
GO