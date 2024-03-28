CREATE TABLE [dbo].[t_SRecD]
(
[AChID] [bigint] NOT NULL,
[SubSrcPosID] [int] NOT NULL,
[SubProdID] [int] NOT NULL,
[SubPPID] [int] NOT NULL,
[SubUM] [varchar] (10) NULL,
[SubQty] [numeric] (21, 9) NOT NULL,
[SubPriceCC_nt] [numeric] (21, 9) NOT NULL,
[SubSumCC_nt] [numeric] (21, 9) NOT NULL,
[SubTax] [numeric] (21, 9) NOT NULL,
[SubTaxSum] [numeric] (21, 9) NOT NULL,
[SubPriceCC_wt] [numeric] (21, 9) NOT NULL,
[SubSumCC_wt] [numeric] (21, 9) NOT NULL,
[SubNewPriceCC_nt] [numeric] (21, 9) NOT NULL,
[SubNewSumCC_nt] [numeric] (21, 9) NOT NULL,
[SubNewTax] [numeric] (21, 9) NOT NULL,
[SubNewTaxSum] [numeric] (21, 9) NOT NULL,
[SubNewPriceCC_wt] [numeric] (21, 9) NOT NULL,
[SubNewSumCC_wt] [numeric] (21, 9) NOT NULL,
[SubSecID] [int] NOT NULL,
[SubBarCode] [varchar] (42) NOT NULL,
[SubPriceAC_nt] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SubTaxAC] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SubPriceAC_wt] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SRecD] ADD CONSTRAINT [_pk_t_SRecD] PRIMARY KEY CLUSTERED ([AChID], [SubSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_SRecD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[t_SRecD] ([AChID], [SubNewSumCC_nt], [SubNewTaxSum], [SubNewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_SRecD] ([AChID], [SubQty], [SubSumCC_nt], [SubTaxSum], [SubSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubBarCode] ON [dbo].[t_SRecD] ([SubBarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubPPID] ON [dbo].[t_SRecD] ([SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubProdID] ON [dbo].[t_SRecD] ([SubProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInPt_SRecD] ON [dbo].[t_SRecD] ([SubProdID], [SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubSecID] ON [dbo].[t_SRecD] ([SubSecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubNewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubNewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubNewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRecD].[SubSecID]'
GO
