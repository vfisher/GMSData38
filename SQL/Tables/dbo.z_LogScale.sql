CREATE TABLE [dbo].[z_LogScale] (
  [LogID] [int] IDENTITY,
  [ScaleID] [int] NOT NULL,
  [DocTime] [smalldatetime] NULL DEFAULT (getdate()),
  [ScaleAction] [int] NOT NULL,
  [Status] [int] NOT NULL,
  [Msg] [varchar](2000) NULL,
  [Notes] [varchar](250) NULL,
  CONSTRAINT [pk_z_LogScale] PRIMARY KEY CLUSTERED ([LogID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ScaleID_ScaleAction_LogID]
  ON [dbo].[z_LogScale] ([ScaleID], [ScaleAction], [LogID])
  ON [PRIMARY]
GO