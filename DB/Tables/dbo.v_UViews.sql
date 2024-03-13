CREATE TABLE [dbo].[v_UViews]
(
[RepID] [int] NOT NULL DEFAULT (0),
[ViewID] [int] NOT NULL DEFAULT (0),
[ViewName] [varchar] (200) NOT NULL,
[UserID] [smallint] NOT NULL DEFAULT (0),
[GrandCols] [bit] NOT NULL DEFAULT (0),
[GrandRows] [bit] NOT NULL DEFAULT (0),
[FixCols] [bit] NOT NULL DEFAULT (0),
[FixRows] [bit] NOT NULL DEFAULT (1),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UViews] ADD CONSTRAINT [pk_v_UViews] PRIMARY KEY CLUSTERED ([ViewID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueName] ON [dbo].[v_UViews] ([RepID], [UserID], [ViewName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UViews] ADD CONSTRAINT [FK_v_UViews_r_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[v_UViews] ADD CONSTRAINT [FK_v_UViews_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
