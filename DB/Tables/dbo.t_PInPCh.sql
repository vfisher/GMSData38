CREATE TABLE [dbo].[t_PInPCh]
(
[ChID] [bigint] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[ChTime] [smalldatetime] NOT NULL,
[ProdID] [int] NOT NULL,
[PPID] [int] NOT NULL,
[OldCurrID] [smallint] NOT NULL,
[OldPriceMC_In] [numeric] (21, 9) NOT NULL,
[OldPriceMC] [numeric] (21, 9) NOT NULL,
[CurrID] [smallint] NOT NULL,
[PriceMC_In] [numeric] (21, 9) NOT NULL,
[PriceMC] [numeric] (21, 9) NOT NULL,
[UserID] [smallint] NOT NULL,
[OldPriceCC_In] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[PriceCC_In] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[OldPriceAC_In] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[PriceAC_In] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_PInPCh] ADD CONSTRAINT [_pk_t_PInPCh] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChDate] ON [dbo].[t_PInPCh] ([ChDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[t_PInPCh] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OldCurrID] ON [dbo].[t_PInPCh] ([OldCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PPID] ON [dbo].[t_PInPCh] ([PPID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_PInPCh] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[t_PInPCh] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[PPID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[OldCurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[OldPriceMC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[OldPriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[PriceMC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_PInPCh].[UserID]'
GO
