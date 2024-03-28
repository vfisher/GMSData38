CREATE TABLE [dbo].[t_PInP]
(
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[PPDesc] [varchar] (200) NULL,
[PriceMC_In] [numeric] (21, 9) NOT NULL,
[PriceMC] [numeric] (21, 9) NOT NULL,
[Priority] [int] NOT NULL,
[ProdDate] [smalldatetime] NULL,
[CurrID] [smallint] NOT NULL,
[CompID] [int] NOT NULL,
[Article] [varchar] (200) NULL,
[CostAC] [numeric] (21, 9) NOT NULL,
[PPWeight] [numeric] (21, 9) NOT NULL,
[File1] [varchar] (200) NULL,
[File2] [varchar] (200) NULL,
[File3] [varchar] (200) NULL,
[PriceCC_In] [numeric] (21, 9) NOT NULL,
[CostCC] [numeric] (21, 9) NOT NULL,
[PPDelay] [smallint] NOT NULL,
[ProdPPDate] [smalldatetime] NULL,
[IsCommission] [bit] NOT NULL DEFAULT (0),
[CstProdCode] [varchar] (250) NULL,
[CstDocCode] [varchar] (250) NULL,
[ParentDocCode] [int] NOT NULL DEFAULT (0),
[ParentChID] [bigint] NOT NULL CONSTRAINT [DF__t_pInP__ParentCh__01D8D511] DEFAULT ((0)),
[PriceAC_In] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[CostMC] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_PInP] ADD CONSTRAINT [_pk_t_PInP] PRIMARY KEY CLUSTERED ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[t_PInP] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[t_PInP] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_PInP] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceCC_In] ON [dbo].[t_PInP] ([PriceCC_In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceMC] ON [dbo].[t_PInP] ([PriceMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceMC_In] ON [dbo].[t_PInP] ([PriceMC_In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Priority] ON [dbo].[t_PInP] ([Priority]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_PInP] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[PriceMC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[CostAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[PPWeight]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[PriceCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[CostCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInP].[PPDelay]'
GO
