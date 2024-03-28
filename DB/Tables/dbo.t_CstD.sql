CREATE TABLE [dbo].[t_CstD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
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
[BarCode] [varchar] (42) NOT NULL,
[SecID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CstD] ADD CONSTRAINT [_pk_t_CstD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_CstD] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_CstD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_CstD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceCC_In] ON [dbo].[t_CstD] ([PriceCC_In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_CstD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInPt_CstD] ON [dbo].[t_CstD] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Qty] ON [dbo].[t_CstD] ([Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_CstD] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC_In] ON [dbo].[t_CstD] ([SumCC_In]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[PriceAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[SumAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[TrtAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[CstSumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[CstPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[DtyCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[PrcCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[ExcCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[ImpCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[PriceCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[SumCC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_CstD].[SecID]'
GO
