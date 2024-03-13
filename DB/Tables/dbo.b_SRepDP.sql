CREATE TABLE [dbo].[b_SRepDP]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[PCodeID1] [smallint] NOT NULL,
[PCodeID2] [smallint] NOT NULL,
[PCodeID3] [smallint] NOT NULL,
[PCodeID4] [smallint] NOT NULL,
[PCodeID5] [smallint] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_SRepDP] ADD CONSTRAINT [_pk_b_SRepDP] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_SRepDP] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_SRepDP] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID1] ON [dbo].[b_SRepDP] ([PCodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID2] ON [dbo].[b_SRepDP] ([PCodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID3] ON [dbo].[b_SRepDP] ([PCodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID4] ON [dbo].[b_SRepDP] ([PCodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PCodeID5] ON [dbo].[b_SRepDP] ([PCodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[b_SRepDP] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [b_PInPb_SRepDP] ON [dbo].[b_SRepDP] ([ProdID], [PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[b_SRepDP] ([StockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PCodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PCodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PCodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PCodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PCodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PriceCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[Tax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[PriceCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SRepDP].[GTranID]'
GO
