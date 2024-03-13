CREATE TABLE [dbo].[b_CRepADV]
(
[ChID] [bigint] NOT NULL,
[VCodeID1] [smallint] NOT NULL,
[VCodeID2] [smallint] NOT NULL,
[VCodeID3] [smallint] NOT NULL,
[VCodeID4] [smallint] NOT NULL,
[VCodeID5] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[b_CRepADV] ADD CONSTRAINT [_pk_b_CRepADV] PRIMARY KEY CLUSTERED ([ChID], [DocDesc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_CRepADV] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_CRepADV] ([ChID], [SumCC_nt], [TaxSum], [SumCC_wt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_CRepADV] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GVTAccID] ON [dbo].[b_CRepADV] ([GVTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID1] ON [dbo].[b_CRepADV] ([VCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID2] ON [dbo].[b_CRepADV] ([VCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID3] ON [dbo].[b_CRepADV] ([VCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID4] ON [dbo].[b_CRepADV] ([VCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID5] ON [dbo].[b_CRepADV] ([VCodeID5]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[VCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[VCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[VCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[VCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[VCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[GVTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[GVTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADV].[GVTAccID]'
GO
