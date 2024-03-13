CREATE TABLE [dbo].[v_ViewFields]
(
[ViewID] [int] NOT NULL DEFAULT (0),
[Caption] [varchar] (200) NOT NULL,
[Location] [int] NOT NULL DEFAULT (0),
[SrcPosID] [int] NOT NULL CONSTRAINT [DF__v_ViewFie__SrcPo__469813B2] DEFAULT (0),
[Visible] [bit] NOT NULL DEFAULT (0),
[SubTotals] [bit] NOT NULL DEFAULT (0),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_ViewFields] ADD CONSTRAINT [pk_v_ViewFields] PRIMARY KEY CLUSTERED ([ViewID], [Caption]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_ViewFields] ADD CONSTRAINT [FK_v_ViewFields_v_Views] FOREIGN KEY ([ViewID]) REFERENCES [dbo].[v_Views] ([ViewID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
