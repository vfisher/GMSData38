CREATE TABLE [dbo].[b_ARepADS]
(
[ChID] [bigint] NOT NULL,
[AssID] [int] NOT NULL,
[ACodeID1] [smallint] NOT NULL,
[ACodeID2] [smallint] NOT NULL,
[ACodeID3] [smallint] NOT NULL,
[ACodeID4] [smallint] NOT NULL,
[ACodeID5] [smallint] NOT NULL,
[UM] [varchar] (50) NULL,
[AKursMC] [numeric] (21, 9) NOT NULL,
[AKursCC] [numeric] (21, 9) NOT NULL,
[ACurrID] [smallint] NOT NULL,
[ASumAC] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[DocDesc] [varchar] (200) NULL,
[BuyDate] [smalldatetime] NULL,
[GTranID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[GSTSum_wt] [numeric] (21, 9) NOT NULL,
[GSTTaxSum] [numeric] (21, 9) NOT NULL,
[GSTAccID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_ARepADS] ADD CONSTRAINT [_pk_b_ARepADS] PRIMARY KEY CLUSTERED ([ChID], [AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID1] ON [dbo].[b_ARepADS] ([ACodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID2] ON [dbo].[b_ARepADS] ([ACodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID3] ON [dbo].[b_ARepADS] ([ACodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID4] ON [dbo].[b_ARepADS] ([ACodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID5] ON [dbo].[b_ARepADS] ([ACodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACurrID] ON [dbo].[b_ARepADS] ([ACurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AKursCC] ON [dbo].[b_ARepADS] ([AKursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AKursMC] ON [dbo].[b_ARepADS] ([AKursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AssID] ON [dbo].[b_ARepADS] ([AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ASumAC] ON [dbo].[b_ARepADS] ([ASumAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_ARepADS] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_ARepADS] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GSTAccID] ON [dbo].[b_ARepADS] ([GSTAccID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ACodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ACodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ACodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ACodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ACodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[AKursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[AKursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ACurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[ASumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[GSTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[GSTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_ARepADS].[GSTAccID]'
GO
