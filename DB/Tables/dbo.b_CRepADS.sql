CREATE TABLE [dbo].[b_CRepADS]
(
[ChID] [bigint] NOT NULL,
[AssID] [int] NOT NULL,
[ACodeID1] [smallint] NOT NULL,
[ACodeID2] [smallint] NOT NULL,
[ACodeID3] [smallint] NOT NULL,
[ACodeID4] [smallint] NOT NULL,
[ACodeID5] [smallint] NOT NULL,
[UM] [varchar] (50) NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[DocDesc] [varchar] (200) NULL,
[BuyDate] [smalldatetime] NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[GSTSum_wt] [numeric] (21, 9) NOT NULL,
[GSTTaxSum] [numeric] (21, 9) NOT NULL,
[GSTAccID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_CRepADS] ADD CONSTRAINT [_pk_b_CRepADS] PRIMARY KEY CLUSTERED ([ChID], [AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID1] ON [dbo].[b_CRepADS] ([ACodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID2] ON [dbo].[b_CRepADS] ([ACodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID3] ON [dbo].[b_CRepADS] ([ACodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID4] ON [dbo].[b_CRepADS] ([ACodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ACodeID5] ON [dbo].[b_CRepADS] ([ACodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AssID] ON [dbo].[b_CRepADS] ([AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_CRepADS] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_CRepADS] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GSTAccID] ON [dbo].[b_CRepADS] ([GSTAccID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[ACodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[ACodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[ACodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[ACodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[ACodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[GSTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[GSTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_CRepADS].[GSTAccID]'
GO
