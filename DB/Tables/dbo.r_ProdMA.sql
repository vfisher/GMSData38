CREATE TABLE [dbo].[r_ProdMA]
(
[ProdID] [int] NOT NULL,
[AProdID] [int] NOT NULL,
[ValidSets] [varchar] (200) NULL,
[Priority] [int] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMA] ADD CONSTRAINT [_pk_r_ProdMA] PRIMARY KEY CLUSTERED ([ProdID], [AProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AProdID] ON [dbo].[r_ProdMA] ([AProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMA] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Priority] ON [dbo].[r_ProdMA] ([ProdID], [Priority]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMA].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMA].[AProdID]'
GO
