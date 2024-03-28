CREATE TABLE [dbo].[t_SExpD]
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
[SubExtra] [numeric] (21, 9) NULL,
[SubPriceCC] [numeric] (21, 9) NULL,
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
ALTER TABLE [dbo].[t_SExpD] ADD CONSTRAINT [_pk_t_SExpD] PRIMARY KEY CLUSTERED ([AChID], [SubSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_SExpD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[t_SExpD] ([AChID], [SubNewSumCC_nt], [SubNewTaxSum], [SubNewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_SExpD] ([AChID], [SubQty], [SubSumCC_nt], [SubTaxSum], [SubSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubBarCode] ON [dbo].[t_SExpD] ([SubBarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubPPID] ON [dbo].[t_SExpD] ([SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubProdID] ON [dbo].[t_SExpD] ([SubProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInPt_SExpD] ON [dbo].[t_SExpD] ([SubProdID], [SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubSecID] ON [dbo].[t_SExpD] ([SubSecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubExtra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubNewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubNewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubNewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExpD].[SubSecID]'
GO
