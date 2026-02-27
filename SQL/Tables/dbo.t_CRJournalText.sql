CREATE TABLE [dbo].[t_CRJournalText] (
  [ChID] [bigint] NOT NULL,
  [CRID] [smallint] NULL,
  [SerialID] [varchar](250) NULL,
  [FiscalID] [varchar](250) NULL,
  [TextData] [varchar](8000) NULL,
  [DocTypeID] [int] NULL,
  [DocSubtypeID] [int] NULL,
  [CRDocID] [varchar](50) NOT NULL CONSTRAINT [df_t_CRJournalText_CRDocID] DEFAULT (0),
  [DocCode] [int] NULL,
  [DocChID] [bigint] NULL,
  [DocTime] [datetime] NULL,
  [IsFinished] [bit] NOT NULL,
  CONSTRAINT [pk_t_CRJournalText] PRIMARY KEY CLUSTERED ([ChID])
)
ON [PRIMARY]
GO

CREATE INDEX [CRID_SerialID_CRDocID]
  ON [dbo].[t_CRJournalText] ([CRID], [SerialID], [CRDocID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_CRJournalText]
  ADD CONSTRAINT [FK_t_CRJournalText_t_CRJournalDocSubtypes] FOREIGN KEY ([DocSubtypeID]) REFERENCES [dbo].[t_CRJournalDocSubtypes] ([DocSubtypeID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[t_CRJournalText]
  ADD CONSTRAINT [FK_t_CRJournalText_t_CRJournalDocTypes] FOREIGN KEY ([DocTypeID]) REFERENCES [dbo].[t_CRJournalDocTypes] ([DocTypeID]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[t_CRJournalText]
  ADD CONSTRAINT [FK_t_CRJournalText_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON UPDATE CASCADE
GO