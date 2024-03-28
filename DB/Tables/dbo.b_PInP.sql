CREATE TABLE [dbo].[b_PInP]
(
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[PPDesc] [varchar] (200) NULL,
[PriceCC_In] [numeric] (21, 9) NOT NULL,
[PriceMC] [numeric] (21, 9) NOT NULL,
[Priority] [int] NOT NULL,
[ProdDate] [smalldatetime] NULL,
[CompID] [int] NOT NULL,
[Article] [varchar] (200) NULL,
[CostAC] [numeric] (21, 9) NOT NULL,
[CostCC] [numeric] (21, 9) NOT NULL,
[PPWeight] [numeric] (21, 9) NOT NULL,
[File1] [varchar] (200) NULL,
[File2] [varchar] (200) NULL,
[File3] [varchar] (200) NULL,
[PPDelay] [smallint] NOT NULL,
[ProdPPDate] [smalldatetime] NULL,
[IsCommission] [bit] NOT NULL DEFAULT (0),
[CstProdCode] [varchar] (250) NULL,
[CstDocCode] [varchar] (250) NULL,
[ParentDocCode] [int] NOT NULL DEFAULT (0),
[ParentChID] [bigint] NOT NULL CONSTRAINT [DF__b_pInP__ParentCh__03C11D83] DEFAULT ((0)),
[ProdPPProducer] [varchar] (250) NULL,
[CounID] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_PInP] ADD CONSTRAINT [_pk_b_PInP] PRIMARY KEY CLUSTERED ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[b_PInP] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostAC] ON [dbo].[b_PInP] ([CostAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CostCC] ON [dbo].[b_PInP] ([CostCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CounID] ON [dbo].[b_PInP] ([CounID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceMC] ON [dbo].[b_PInP] ([PriceMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Priority] ON [dbo].[b_PInP] ([Priority]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdDate] ON [dbo].[b_PInP] ([ProdDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_PInP] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdPPProducer] ON [dbo].[b_PInP] ([ProdPPProducer]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[PriceCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[CostAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[CostCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[PPWeight]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PInP].[PPDelay]'
GO
