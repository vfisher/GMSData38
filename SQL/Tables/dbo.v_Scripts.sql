CREATE TABLE [dbo].[v_Scripts] (
  [RepID] [int] NOT NULL,
  [ScBeforeRun] [text] NULL,
  [ScBeforeSource] [text] NULL,
  [ScAfterSource] [text] NULL,
  [ScAfterPrepare] [text] NULL,
  [ScBeforeLoad] [text] NULL,
  CONSTRAINT [pk_v_Scripts] PRIMARY KEY CLUSTERED ([RepID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[v_Scripts]
  ADD CONSTRAINT [FK_v_Scripts_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO