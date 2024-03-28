CREATE TABLE [dbo].[b_ARepADV]
(
[ChID] [bigint] NOT NULL,
[VCodeID1] [smallint] NOT NULL,
[VCodeID2] [smallint] NOT NULL,
[VCodeID3] [smallint] NOT NULL,
[VCodeID4] [smallint] NOT NULL,
[VCodeID5] [smallint] NOT NULL,
[VKursMC] [numeric] (21, 9) NOT NULL,
[VKursCC] [numeric] (21, 9) NOT NULL,
[VCurrID] [smallint] NOT NULL,
[VSumAC] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[DocDesc] [varchar] (200) NOT NULL,
[BuyDate] [smalldatetime] NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[GVTSum_wt] [numeric] (21, 9) NOT NULL,
[GVTTaxSum] [numeric] (21, 9) NOT NULL,
[GVTAccID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_ARepADV] ADD CONSTRAINT [_pk_b_ARepADV] PRIMARY KEY CLUSTERED ([ChID], [DocDesc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_ARepADV] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_b_ARepADV_ZTotals] ON [dbo].[b_ARepADV] ([ChID], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_ARepADV] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GVTAccID] ON [dbo].[b_ARepADV] ([GVTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID1] ON [dbo].[b_ARepADV] ([VCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID2] ON [dbo].[b_ARepADV] ([VCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID3] ON [dbo].[b_ARepADV] ([VCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID4] ON [dbo].[b_ARepADV] ([VCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID5] ON [dbo].[b_ARepADV] ([VCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCurrID] ON [dbo].[b_ARepADV] ([VCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VKursCC] ON [dbo].[b_ARepADV] ([VKursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VKursMC] ON [dbo].[b_ARepADV] ([VKursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VSumAC] ON [dbo].[b_ARepADV] ([VSumAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VKursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VKursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VCurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[VSumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[GVTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[GVTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADV].[GVTAccID]'
GO
