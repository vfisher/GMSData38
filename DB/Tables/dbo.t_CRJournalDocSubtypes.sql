CREATE TABLE [dbo].[t_CRJournalDocSubtypes]
(
[DocSubtypeID] [int] NOT NULL,
[DocSubtypeName] [varchar] (100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRJournalDocSubtypes] ADD CONSTRAINT [pk_t_CRJournalDocSubtypes] PRIMARY KEY CLUSTERED ([DocSubtypeID]) ON [PRIMARY]
GO
