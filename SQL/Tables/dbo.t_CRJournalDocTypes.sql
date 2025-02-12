CREATE TABLE [dbo].[t_CRJournalDocTypes] (
  [DocTypeID] [int] NOT NULL,
  [DocTypeName] [varchar](100) NULL,
  CONSTRAINT [pk_t_CRJournalDocTypes] PRIMARY KEY CLUSTERED ([DocTypeID])
)
ON [PRIMARY]
GO