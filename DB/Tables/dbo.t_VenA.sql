CREATE TABLE [dbo].[t_VenA]
(
[ChID] [bigint] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[TQty] [numeric] (21, 9) NOT NULL,
[TNewQty] [numeric] (21, 9) NOT NULL,
[TSumCC_nt] [numeric] (21, 9) NOT NULL,
[TTaxSum] [numeric] (21, 9) NOT NULL,
[TSumCC_wt] [numeric] (21, 9) NOT NULL,
[TNewSumCC_nt] [numeric] (21, 9) NOT NULL,
[TNewTaxSum] [numeric] (21, 9) NOT NULL,
[TNewSumCC_wt] [numeric] (21, 9) NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[Norma1] [numeric] (21, 9) NOT NULL,
[TSrcPosID] [int] NOT NULL,
[HandCorrected] [bit] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_VenA] ADD CONSTRAINT [_pk_t_VenA] PRIMARY KEY CLUSTERED ([ChID], [ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_VenA] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_VenA] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicate] ON [dbo].[t_VenA] ([ChID], [TSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_VenA] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZNewTotals] ON [dbo].[t_VenA] ([TNewSumCC_wt], [TTaxSum], [TSumCC_nt], [TNewQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TSrcPosID] ON [dbo].[t_VenA] ([TSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ZTotals] ON [dbo].[t_VenA] ([TSumCC_wt], [TTaxSum], [TSumCC_nt], [TQty]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TNewSumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[Norma1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_VenA].[TSrcPosID]'
GO
