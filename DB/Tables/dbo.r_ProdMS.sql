CREATE TABLE [dbo].[r_ProdMS]
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
ALTER TABLE [dbo].[r_ProdMS] ADD CONSTRAINT [_pk_r_ProdMS] PRIMARY KEY CLUSTERED ([ProdID], [SProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EExp] ON [dbo].[r_ProdMS] ([EExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EExpSub] ON [dbo].[r_ProdMS] ([EExpSub]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RExp] ON [dbo].[r_ProdMS] ([LExp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RExpSub] ON [dbo].[r_ProdMS] ([LExpSub]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMS] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SProdID] ON [dbo].[r_ProdMS] ([SProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMS].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMS].[SProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMS].[UseSubItems]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMS].[UseSubDoc]'
GO
