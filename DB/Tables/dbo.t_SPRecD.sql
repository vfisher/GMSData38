CREATE TABLE [dbo].[t_SPRecD]
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
[SubBarCode] [varchar] (42) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SPRecD] ADD CONSTRAINT [_pk_t_SPRecD] PRIMARY KEY CLUSTERED ([AChID], [SubSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_SPRecD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[t_SPRecD] ([AChID], [SubNewSumCC_nt], [SubNewTaxSum], [SubNewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_SPRecD] ([AChID], [SubQty], [SubSumCC_nt], [SubTaxSum], [SubSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubBarCode] ON [dbo].[t_SPRecD] ([SubBarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubPPID] ON [dbo].[t_SPRecD] ([SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubProdID] ON [dbo].[t_SPRecD] ([SubProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInP_Tt_SPRecD] ON [dbo].[t_SPRecD] ([SubProdID], [SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubSecID] ON [dbo].[t_SPRecD] ([SubSecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubNewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubNewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubNewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPRecD].[SubSecID]'
GO
