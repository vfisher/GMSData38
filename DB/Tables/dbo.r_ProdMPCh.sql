CREATE TABLE [dbo].[r_ProdMPCh]
(
[ChID] [bigint] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[ChTime] [smalldatetime] NOT NULL,
[ProdID] [int] NOT NULL,
[PLID] [int] NOT NULL,
[OldCurrID] [smallint] NOT NULL,
[OldPriceMC] [numeric] (21, 9) NOT NULL,
[CurrID] [smallint] NOT NULL,
[PriceMC] [numeric] (21, 9) NOT NULL,
[UserID] [smallint] NOT NULL,
[DocChID] [bigint] NOT NULL CONSTRAINT [DF__r_ProdMPC__DocCh__36B6B1A4] DEFAULT ((0)),
[DocCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMPCh] ADD CONSTRAINT [_pk_r_ProdMPCh] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChDate] ON [dbo].[r_ProdMPCh] ([ChDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[r_ProdMPCh] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OldCurrID] ON [dbo].[r_ProdMPCh] ([OldCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_ProdMPCh] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMPCh] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[r_ProdMPCh] ([UserID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[OldCurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[OldPriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMPCh].[UserID]'
GO
