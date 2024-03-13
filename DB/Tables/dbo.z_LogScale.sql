CREATE TABLE [dbo].[z_LogScale]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[ScaleID] [int] NOT NULL,
[DocTime] [smalldatetime] NULL DEFAULT (getdate()),
[ScaleAction] [int] NOT NULL,
[Status] [int] NOT NULL,
[Msg] [varchar] (2000) NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_LogScale] ADD CONSTRAINT [pk_z_LogScale] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ScaleID_ScaleAction_LogID] ON [dbo].[z_LogScale] ([ScaleID], [ScaleAction], [LogID]) ON [PRIMARY]
GO
