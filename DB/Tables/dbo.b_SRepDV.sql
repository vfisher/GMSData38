CREATE TABLE [dbo].[b_SRepDV]
(
[ChID] [bigint] NOT NULL,
[VSrcPosID] [int] NOT NULL,
[DocDesc] [varchar] (200) NOT NULL,
[VCodeID1] [smallint] NOT NULL,
[VCodeID2] [smallint] NOT NULL,
[VCodeID3] [smallint] NOT NULL,
[VCodeID4] [smallint] NOT NULL,
[VCodeID5] [smallint] NOT NULL,
[CostSumCC_nt] [numeric] (21, 9) NOT NULL,
[CostTaxSum] [numeric] (21, 9) NOT NULL,
[CostSumCC_wt] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[GPosTSum_wt] [numeric] (21, 9) NOT NULL,
[GPosTTaxSum] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_SRepDV] ADD CONSTRAINT [_pk_b_SRepDV] PRIMARY KEY CLUSTERED ([ChID], [VSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_SRepDV] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_SRepDV] ([CostSumCC_wt], [CostTaxSum], [CostSumCC_nt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_SRepDV] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID1] ON [dbo].[b_SRepDV] ([VCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID2] ON [dbo].[b_SRepDV] ([VCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID3] ON [dbo].[b_SRepDV] ([VCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID4] ON [dbo].[b_SRepDV] ([VCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [VCodeID5] ON [dbo].[b_SRepDV] ([VCodeID5]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[VSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[VCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[VCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[VCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[VCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[VCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[CostSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[CostTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[CostSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[GPosTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDV].[GPosTTaxSum]'
GO
