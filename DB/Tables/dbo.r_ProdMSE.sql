CREATE TABLE [dbo].[r_ProdMSE]
(
[ProdID] [int] NOT NULL,
[SProdID] [int] NOT NULL,
[LExp] [varchar] (255) NOT NULL,
[EExp] [varchar] (255) NOT NULL,
[LExpSub] [varchar] (255) NOT NULL,
[EExpSub] [varchar] (255) NOT NULL,
[UseSubItems] [bit] NOT NULL,
[UseSubDoc] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMSE] ADD CONSTRAINT [_pk_r_ProdMSE] PRIMARY KEY CLUSTERED ([ProdID], [SProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EExp] ON [dbo].[r_ProdMSE] ([EExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EExpSub] ON [dbo].[r_ProdMSE] ([EExpSub]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RExp] ON [dbo].[r_ProdMSE] ([LExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RExpSub] ON [dbo].[r_ProdMSE] ([LExpSub]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMSE] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SProdID] ON [dbo].[r_ProdMSE] ([SProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMSE].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMSE].[SProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMSE].[UseSubItems]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMSE].[UseSubDoc]'
GO
