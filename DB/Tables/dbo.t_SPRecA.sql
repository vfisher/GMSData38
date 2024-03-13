CREATE TABLE [dbo].[t_SPRecA]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[SetCostCC] [numeric] (21, 9) NOT NULL,
[SetValue1] [numeric] (21, 9) NULL,
[SetValue2] [numeric] (21, 9) NULL,
[SetValue3] [numeric] (21, 9) NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[Extra] [numeric] (21, 9) NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[NewPriceCC_nt] [numeric] (21, 9) NOT NULL,
[NewSumCC_nt] [numeric] (21, 9) NOT NULL,
[NewTax] [numeric] (21, 9) NOT NULL,
[NewTaxSum] [numeric] (21, 9) NOT NULL,
[NewPriceCC_wt] [numeric] (21, 9) NOT NULL,
[NewSumCC_wt] [numeric] (21, 9) NOT NULL,
[AChID] [bigint] NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[SecID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SPRecA] ADD CONSTRAINT [pk_t_SPRecA] PRIMARY KEY CLUSTERED ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_SPRecA] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_SPRecA] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[t_SPRecA] ([ChID], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_SPRecA] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_SPRecA] ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_SPRecA] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_SPRecA] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInP_Tt_SPRecA] ON [dbo].[t_SPRecA] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_SPRecA] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SetCostCC] ON [dbo].[t_SPRecA] ([SetCostCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SetCostCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SetValue1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SetValue2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SetValue3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[Extra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[NewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[NewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[NewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[NewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[NewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[NewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecA].[SecID]'
GO
