CREATE TABLE [dbo].[t_SPExpD]
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
[SubBarCode] [varchar] (42) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SPExpD] ADD CONSTRAINT [_pk_t_SPExpD] PRIMARY KEY CLUSTERED ([AChID], [SubSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_SPExpD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[t_SPExpD] ([AChID], [SubNewSumCC_nt], [SubNewTaxSum], [SubNewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_SPExpD] ([AChID], [SubQty], [SubSumCC_nt], [SubTaxSum], [SubSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubBarCode] ON [dbo].[t_SPExpD] ([SubBarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubPPID] ON [dbo].[t_SPExpD] ([SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubProdID] ON [dbo].[t_SPExpD] ([SubProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [t_PInP_Tt_SPExpD] ON [dbo].[t_SPExpD] ([SubProdID], [SubPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubSecID] ON [dbo].[t_SPExpD] ([SubSecID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubExtra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubPriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubNewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubNewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubNewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SPExpD].[SubSecID]'
GO
