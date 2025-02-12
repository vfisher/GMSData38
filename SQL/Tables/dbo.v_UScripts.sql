CREATE TABLE [dbo].[v_UScripts] (
  [RepID] [int] NOT NULL,
  [UserID] [smallint] NOT NULL,
  [ScBeforeRun] [text] NULL,
  [ScBeforeSource] [text] NULL,
  [ScAfterSource] [text] NULL,
  [ScAfterPrepare] [text] NULL,
  [ScBeforeLoad] [text] NULL,
  CONSTRAINT [pk_v_UScripts] PRIMARY KEY CLUSTERED ([RepID], [UserID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[v_UScripts]
  ADD CONSTRAINT [FK_v_UScripts_r_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[r_Users] ([UserID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[v_UScripts]
  ADD CONSTRAINT [FK_v_UScripts_v_Reps] FOREIGN KEY ([RepID]) REFERENCES [dbo].[v_Reps] ([RepID]) ON DELETE CASCADE ON UPDATE CASCADE
GO