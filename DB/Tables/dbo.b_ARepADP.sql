CREATE TABLE [dbo].[b_ARepADP]
(
[ChID] [bigint] NOT NULL,
[PCodeID1] [smallint] NOT NULL,
[PCodeID2] [smallint] NOT NULL,
[PCodeID3] [smallint] NOT NULL,
[PCodeID4] [smallint] NOT NULL,
[PCodeID5] [smallint] NOT NULL,
[StockID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PKursMC] [numeric] (21, 9) NOT NULL,
[PKursCC] [numeric] (21, 9) NOT NULL,
[PCurrID] [smallint] NOT NULL,
[PriceAC_In] [numeric] (21, 9) NOT NULL,
[SumAC_In] [numeric] (21, 9) NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[DocDesc] [varchar] (200) NULL,
[BuyDate] [smalldatetime] NULL,
[GTranID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[GTSum_wt] [numeric] (21, 9) NOT NULL,
[GTTaxSum] [numeric] (21, 9) NOT NULL,
[GTAccID] [int] NOT NULL,
[GTCorrSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_ARepADP] ADD CONSTRAINT [_pk_b_ARepADP] PRIMARY KEY CLUSTERED ([ChID], [ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_ARepADP] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_b_ARepADP_ZTotals] ON [dbo].[b_ARepADP] ([ChID], [Qty], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_ARepADP] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTAccID] ON [dbo].[b_ARepADP] ([GTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID1] ON [dbo].[b_ARepADP] ([PCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID2] ON [dbo].[b_ARepADP] ([PCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID3] ON [dbo].[b_ARepADP] ([PCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID4] ON [dbo].[b_ARepADP] ([PCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID5] ON [dbo].[b_ARepADP] ([PCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCurrID] ON [dbo].[b_ARepADP] ([PCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PKursCC] ON [dbo].[b_ARepADP] ([PKursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PKursMC] ON [dbo].[b_ARepADP] ([PKursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_ARepADP] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_ARepADP] ON [dbo].[b_ARepADP] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[b_ARepADP] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PKursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PKursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PCurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PriceAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[SumAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[GTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[GTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADP].[GTAccID]'
GO
