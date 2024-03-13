CREATE TABLE [dbo].[r_ProdG]
(
[ChID] [bigint] NOT NULL,
[PGrID] [int] NOT NULL,
[PGrName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdG] ADD CONSTRAINT [pk_r_ProdG] PRIMARY KEY CLUSTERED ([PGrID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdG] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrName] ON [dbo].[r_ProdG] ([PGrName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG].[PGrID]'
GO
