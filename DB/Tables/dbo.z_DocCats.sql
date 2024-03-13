CREATE TABLE [dbo].[z_DocCats]
(
[DocCatCode] [int] NOT NULL,
[DocCatName] [varchar] (250) NOT NULL,
[DocCatInfo] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocCats] ADD CONSTRAINT [pk_z_DocCats] PRIMARY KEY CLUSTERED ([DocCatCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DocCatName] ON [dbo].[z_DocCats] ([DocCatName]) ON [PRIMARY]
GO
