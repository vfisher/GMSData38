CREATE TABLE [dbo].[z_DocLinkTypes]
(
[DocLinkTypeID] [int] NOT NULL,
[DocLinkTypeName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[SignType] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocLinkTypes] ADD CONSTRAINT [pk_z_DocLinkTypes] PRIMARY KEY CLUSTERED ([DocLinkTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocLinkTypeName] ON [dbo].[z_DocLinkTypes] ([DocLinkTypeName]) ON [PRIMARY]
GO
