CREATE TABLE [dbo].[v_Graphs] (
  [RepID] [int] NOT NULL DEFAULT (0),
  [GraphID] [int] NOT NULL DEFAULT (0),
  [GraphName] [varchar](200) NOT NULL,
  [GraphDef] [varchar](2000) NOT NULL,
  [ObjectDef] [text] NULL,
  CONSTRAINT [pk_v_Graphs] PRIMARY KEY CLUSTERED ([GraphID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueName]
  ON [dbo].[v_Graphs] ([RepID], [GraphName])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[v_Graphs]
  ADD CONSTRAINT [FK_v_Graphs_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO