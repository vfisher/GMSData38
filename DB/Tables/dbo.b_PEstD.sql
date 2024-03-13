CREATE TABLE [dbo].[b_PEstD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PPID] [int] NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[NewPPID] [int] NOT NULL,
[NewPriceCC_nt] [numeric] (21, 9) NOT NULL,
[NewSumCC_nt] [numeric] (21, 9) NOT NULL,
[NewTax] [numeric] (21, 9) NOT NULL,
[NewTaxSum] [numeric] (21, 9) NOT NULL,
[NewPriceCC_wt] [numeric] (21, 9) NOT NULL,
[NewSumCC_wt] [numeric] (21, 9) NOT NULL,
[Extra] [numeric] (21, 9) NULL,
[PriceCC] [numeric] (21, 9) NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_PEstD] ADD CONSTRAINT [_pk_b_PEstD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_PEstD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotalsNew] ON [dbo].[b_PEstD] ([ChID], [NewSumCC_nt], [NewTaxSum], [NewSumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_PEstD] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_PEstD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewPPID] ON [dbo].[b_PEstD] ([NewPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[b_PEstD] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_PEstD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_PEstD1] ON [dbo].[b_PEstD] ([ProdID], [NewPPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_PEstD] ON [dbo].[b_PEstD] ([ProdID], [PPID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewPPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewPriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewPriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[NewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[Extra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PEstD].[GTranID]'
GO
