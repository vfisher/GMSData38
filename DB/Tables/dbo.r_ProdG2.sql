CREATE TABLE [dbo].[r_ProdG2]
(
[ChID] [bigint] NOT NULL,
[PGrID2] [int] NOT NULL,
[PGrName2] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdG2] ADD CONSTRAINT [pk_r_ProdG2] PRIMARY KEY CLUSTERED ([PGrID2]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_ProdG2] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PGrName2] ON [dbo].[r_ProdG2] ([PGrName2]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG2].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdG2].[PGrID2]'
GO
