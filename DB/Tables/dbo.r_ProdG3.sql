CREATE TABLE [dbo].[r_ProdG3]
(
[ChID] [bigint] NOT NULL,
[PGrID3] [int] NOT NULL,
[PGrName3] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdG3] ADD CONSTRAINT [pk_r_ProdG3] PRIMARY KEY CLUSTERED ([PGrID3]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdG3] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrName3] ON [dbo].[r_ProdG3] ([PGrName3]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG3].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG3].[PGrID3]'
GO
