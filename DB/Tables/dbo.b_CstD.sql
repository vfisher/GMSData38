CREATE TABLE [dbo].[b_CstD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceAC_In] [numeric] (21, 9) NOT NULL,
[SumAC_In] [numeric] (21, 9) NOT NULL,
[TrtAC] [numeric] (21, 9) NOT NULL,
[CstSumAC] [numeric] (21, 9) NOT NULL,
[CstPriceCC] [numeric] (21, 9) NOT NULL,
[DtyCC] [numeric] (21, 9) NOT NULL,
[PrcCC] [numeric] (21, 9) NOT NULL,
[ExcCC] [numeric] (21, 9) NOT NULL,
[ImpCC] [numeric] (21, 9) NOT NULL,
[MoreCC] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_In] [numeric] (21, 9) NOT NULL,
[SumCC_In] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[GPosTSum_wt] [numeric] (21, 9) NOT NULL,
[GPosTTaxSum] [numeric] (21, 9) NOT NULL,
[CstSumCC_In] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TrtCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstDty] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstPrc] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstExc] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstSumCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GroupID] [int] NOT NULL DEFAULT (0),
[ExcCostCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstPriceAC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstDty2] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[Dty2CC] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_CstD] ADD CONSTRAINT [_pk_b_CstD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_CstD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_CstD] ([ChID], [Qty], [SumCC_In], [TaxSum], [SumAC_In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CstDty2] ON [dbo].[b_CstD] ([CstDty2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Dty2CC] ON [dbo].[b_CstD] ([Dty2CC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_CstD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[b_CstD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_CstD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_CstD] ON [dbo].[b_CstD] ([ProdID], [PPID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[PriceAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[SumAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[TrtAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[CstSumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[CstPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[DtyCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[PrcCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[ExcCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[ImpCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[PriceCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[SumCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[GPosTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CstD].[GPosTTaxSum]'
GO
