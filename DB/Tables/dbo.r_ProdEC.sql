CREATE TABLE [dbo].[r_ProdEC]
(
[ProdID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[ExtProdID] [varchar] (200) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdEC] ADD CONSTRAINT [_pk_r_ProdEC] PRIMARY KEY CLUSTERED ([ProdID], [CompID], [ExtProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[r_ProdEC] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExtProdID] ON [dbo].[r_ProdEC] ([ExtProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdEC] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdEC].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdEC].[CompID]'
GO
