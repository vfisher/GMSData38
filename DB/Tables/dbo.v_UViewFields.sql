CREATE TABLE [dbo].[v_UViewFields]
(
[ViewID] [int] NOT NULL DEFAULT (0),
[Caption] [varchar] (200) NOT NULL,
[Location] [int] NOT NULL DEFAULT (0),
[SrcPosID] [int] NOT NULL CONSTRAINT [DF__v_UViewFi__PosID__18584F03] DEFAULT (0),
[Visible] [bit] NOT NULL DEFAULT (0),
[SubTotals] [bit] NOT NULL DEFAULT (0),
[ObjectDef] [text] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UViewFields] ADD CONSTRAINT [pk_v_UViewFields] PRIMARY KEY CLUSTERED ([ViewID], [Caption]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[v_UViewFields] ADD CONSTRAINT [FK_v_UViewFields_v_UViews] FOREIGN KEY ([ViewID]) REFERENCES [dbo].[v_UViews] ([ViewID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
