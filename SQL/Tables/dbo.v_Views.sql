CREATE TABLE [dbo].[v_Views] (
  [RepID] [int] NOT NULL DEFAULT (0),
  [ViewID] [int] NOT NULL DEFAULT (0),
  [ViewName] [varchar](200) NOT NULL,
  [GrandCols] [bit] NOT NULL DEFAULT (0),
  [GrandRows] [bit] NOT NULL DEFAULT (0),
  [FixCols] [bit] NOT NULL DEFAULT (0),
  [FixRows] [bit] NOT NULL DEFAULT (1),
  [ObjectDef] [text] NULL,
  CONSTRAINT [pk_v_Views] PRIMARY KEY CLUSTERED ([ViewID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UniqueIndex]
  ON [dbo].[v_Views] ([RepID], [ViewName])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[v_Views]
  ADD CONSTRAINT [FK_v_Views_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO