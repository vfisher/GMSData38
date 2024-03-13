CREATE TABLE [dbo].[t_CRJournalText]
(
[ChID] [bigint] NOT NULL,
[CRID] [smallint] NULL,
[SerialID] [varchar] (250) NULL,
[FiscalID] [varchar] (250) NULL,
[TextData] [varchar] (8000) NULL,
[DocTypeID] [int] NULL,
[DocSubtypeID] [int] NULL,
[CRDocID] [varchar] (50) NOT NULL CONSTRAINT [df_t_CRJournalText_CRDocID] DEFAULT ((0)),
[DocCode] [int] NULL,
[DocChID] [bigint] NULL,
[DocTime] [datetime] NULL,
[IsFinished] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_t_CRJournalText] ON [dbo].[t_CRJournalText]
FOR DELETE AS
/* t_CRJournalText - ЭКЛЗ - резервные копии документов в виде текста - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Удаление регистрации печати */
  DELETE z_LogPrint FROM z_LogPrint m, deleted i
  WHERE m.DocCode = 1011 AND m.ChID = i.ChID

END
GO
EXEC sp_settriggerorder N'[dbo].[TRel3_Del_t_CRJournalText]', 'last', 'delete', null
GO
ALTER TABLE [dbo].[t_CRJournalText] ADD CONSTRAINT [pk_t_CRJournalText] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRID_SerialID_CRDocID] ON [dbo].[t_CRJournalText] ([CRID], [SerialID], [CRDocID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRJournalText] ADD CONSTRAINT [FK_t_CRJournalText_t_CRJournalDocSubtypes] FOREIGN KEY ([DocSubtypeID]) REFERENCES [dbo].[t_CRJournalDocSubtypes] ([DocSubtypeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CRJournalText] ADD CONSTRAINT [FK_t_CRJournalText_t_CRJournalDocTypes] FOREIGN KEY ([DocTypeID]) REFERENCES [dbo].[t_CRJournalDocTypes] ([DocTypeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CRJournalText] ADD CONSTRAINT [FK_t_CRJournalText_z_Docs] FOREIGN KEY ([DocCode]) REFERENCES [dbo].[z_Docs] ([DocCode]) ON UPDATE CASCADE
GO
