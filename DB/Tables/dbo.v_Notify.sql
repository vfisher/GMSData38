CREATE TABLE [dbo].[v_Notify]
(
[RepID] [int] NOT NULL,
[NotifyName] [varchar] (200) NOT NULL,
[NotifyText] [varchar] (200) NULL,
[NotifyType] [int] NOT NULL DEFAULT (0),
[Address] [varchar] (200) NULL,
[AttachReport] [bit] NOT NULL DEFAULT (0),
[SendToDevs] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Notify] ADD CONSTRAINT [pk_v_Notify] PRIMARY KEY CLUSTERED ([RepID], [NotifyName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_Notify] ADD CONSTRAINT [FK_v_Notify_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
