CREATE TABLE [dbo].[v_UGraphs] (
  [RepID] [int] NOT NULL DEFAULT (0),
  [GraphID] [int] NOT NULL DEFAULT (0),
  [GraphName] [varchar](200) NOT NULL,
  [GraphDef] [varchar](2000) NOT NULL,
  [UserID] [smallint] NOT NULL DEFAULT (0),
  [ObjectDef] [text] NULL,
  CONSTRAINT [pk_v_UGraphs] PRIMARY KEY CLUSTERED ([GraphID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueName]
  ON [dbo].[v_UGraphs] ([RepID], [UserID], [GraphName])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[v_UGraphs]
  ADD CONSTRAINT [FK_v_UGraphs_r_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[v_UGraphs]
  ADD CONSTRAINT [FK_v_UGraphs_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO