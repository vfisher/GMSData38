CREATE TABLE [dbo].[z_ReplicaOut] (
  [ReplicaEventID] [bigint] IDENTITY,
  [ReplicaSubCode] [int] NOT NULL,
  [DocTime] [smalldatetime] NOT NULL,
  [TableCode] [int] NOT NULL,
  [ReplEventType] [int] NOT NULL,
  [PKFields] [varchar](50) NULL,
  [PKValue] [varchar](250) NULL,
  [ChangeFields] [varchar](2000) NULL,
  [ChangeFieldValues] [varchar](max) NULL,
  [Status] [tinyint] NOT NULL DEFAULT (0),
  [Msg] [varchar](2000) NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO