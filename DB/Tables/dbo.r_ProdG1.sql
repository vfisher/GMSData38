CREATE TABLE [dbo].[r_ProdG1]
(
[ChID] [bigint] NOT NULL,
[PGrID1] [int] NOT NULL,
[PGrName1] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdG1] ADD CONSTRAINT [pk_r_ProdG1] PRIMARY KEY CLUSTERED ([PGrID1]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdG1] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrName1] ON [dbo].[r_ProdG1] ([PGrName1]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG1].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG1].[PGrID1]'
GO
