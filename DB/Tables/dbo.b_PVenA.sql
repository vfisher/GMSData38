CREATE TABLE [dbo].[b_PVenA]
(
[ChID] [bigint] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[TQty] [numeric] (21, 9) NOT NULL,
[TNewQty] [numeric] (21, 9) NOT NULL,
[TSumCC_nt] [numeric] (21, 9) NOT NULL,
[TTaxSum] [numeric] (21, 9) NOT NULL,
[TSumCC_wt] [numeric] (21, 9) NOT NULL,
[TNewSumCC_nt] [numeric] (21, 9) NOT NULL,
[TNewTaxSum] [numeric] (21, 9) NOT NULL,
[TNewSumCC_wt] [numeric] (21, 9) NOT NULL,
[Norma1] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[TSrcPosID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_PVenA] ADD CONSTRAINT [_pk_b_PVenA] PRIMARY KEY CLUSTERED ([ChID], [ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_PVenA] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[b_PVenA] ([ChID], [TSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_PVenA] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[b_PVenA] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZNewTotals] ON [dbo].[b_PVenA] ([TNewSumCC_wt], [TNewTaxSum], [TNewSumCC_nt], [TNewQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TSrcPosID] ON [dbo].[b_PVenA] ([TSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[b_PVenA] ([TSumCC_wt], [TTaxSum], [TSumCC_nt], [TQty]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[Norma1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_PVenA].[TSrcPosID]'
GO
