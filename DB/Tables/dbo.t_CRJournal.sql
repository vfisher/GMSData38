CREATE TABLE [dbo].[t_CRJournal]
(
[ChID] [bigint] NOT NULL,
[CRID] [smallint] NULL,
[SerialID] [varchar] (250) NULL,
[FiscalID] [varchar] (250) NULL,
[Data] [image] NULL,
[DocTypeID] [int] NULL,
[DocSubtypeID] [int] NULL,
[XMLDocID] [bigint] NOT NULL,
[DocCode] [int] NULL,
[DocChID] [bigint] NULL,
[DocTime] [datetime] NULL,
[IsFinished] [bit] NOT NULL DEFAULT ((0)),
[InetChequeNum] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRJournal] ADD CONSTRAINT [pk_t_CRJournal] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [XMLDocID_CRID] ON [dbo].[t_CRJournal] ([XMLDocID], [CRID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRJournal] ADD CONSTRAINT [FK_t_CRJournal_t_CRJournalDocSubtypes] FOREIGN KEY ([DocSubtypeID]) REFERENCES [dbo].[t_CRJournalDocSubtypes] ([DocSubtypeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CRJournal] ADD CONSTRAINT [FK_t_CRJournal_t_CRJournalDocTypes] FOREIGN KEY ([DocTypeID]) REFERENCES [dbo].[t_CRJournalDocTypes] ([DocTypeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CRJournal] ADD CONSTRAINT [FK_t_CRJournal_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON UPDATE CASCADE
GO
