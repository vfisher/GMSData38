CREATE TABLE [dbo].[r_ProdA]
(
[ChID] [bigint] NOT NULL,
[PGrAID] [smallint] NOT NULL,
[PGrAName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdA] ADD CONSTRAINT [pk_r_ProdA] PRIMARY KEY CLUSTERED ([PGrAID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdA] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrAName] ON [dbo].[r_ProdA] ([PGrAName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdA].[PGrAID]'
GO
