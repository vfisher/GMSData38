CREATE TABLE [dbo].[v_UNotify]
(
[RepID] [int] NOT NULL,
[UserID] [smallint] NOT NULL,
[NotifyName] [varchar] (200) NOT NULL,
[NotifyText] [varchar] (200) NULL,
[NotifyType] [int] NOT NULL DEFAULT (0),
[Address] [varchar] (200) NULL,
[AttachReport] [bit] NOT NULL DEFAULT (0),
[SendToDevs] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UNotify] ADD CONSTRAINT [pk_v_UNotify] PRIMARY KEY CLUSTERED ([RepID], [UserID], [NotifyName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UNotify] ADD CONSTRAINT [FK_v_UNotify_r_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[v_UNotify] ADD CONSTRAINT [FK_v_UNotify_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
