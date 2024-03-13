CREATE TABLE [dbo].[t_CRJournalDocTypes]
(
[DocTypeID] [int] NOT NULL,
[DocTypeName] [varchar] (100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRJournalDocTypes] ADD CONSTRAINT [pk_t_CRJournalDocTypes] PRIMARY KEY CLUSTERED ([DocTypeID]) ON [PRIMARY]
GO
