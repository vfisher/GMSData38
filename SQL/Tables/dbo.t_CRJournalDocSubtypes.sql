CREATE TABLE [dbo].[t_CRJournalDocSubtypes] (
  [DocSubtypeID] [int] NOT NULL,
  [DocSubtypeName] [varchar](100) NULL,
  CONSTRAINT [pk_t_CRJournalDocSubtypes] PRIMARY KEY CLUSTERED ([DocSubtypeID])
)
ON [PRIMARY]
GO