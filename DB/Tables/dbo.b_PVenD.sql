CREATE TABLE [dbo].[b_PVenD]
(
[ChID] [bigint] NOT NULL,
[DetProdID] [int] NOT NULL,
[SrcPosID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[DetUM] [varchar] (10) NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[NewQty] [numeric] (21, 9) NOT NULL,
[NewSumCC_nt] [numeric] (21, 9) NOT NULL,
[NewTaxSum] [numeric] (21, 9) NOT NULL,
[NewSumCC_wt] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_PVenD] ADD CONSTRAINT [_pk_b_PVenD] PRIMARY KEY CLUSTERED ([ChID], [DetProdID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PVenAb_PVenD] ON [dbo].[b_PVenD] ([ChID], [DetProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[b_PVenD] ([ChID], [NewQty], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_PVenD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetProdID] ON [dbo].[b_PVenD] ([DetProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_PVenD] ON [dbo].[b_PVenD] ([DetProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[b_PVenD] ([PPID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[DetProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[NewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[NewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[NewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenD].[NewSumCC_wt]'
GO
