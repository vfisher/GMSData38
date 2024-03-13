CREATE TABLE [dbo].[r_ProdMP]
(
[ProdID] [int] NOT NULL,
[PLID] [int] NOT NULL,
[PriceMC] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[CurrID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_ProdMP] ADD CONSTRAINT [_pk_r_ProdMP] PRIMARY KEY CLUSTERED ([ProdID], [PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[r_ProdMP] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_ProdMP] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceMC] ON [dbo].[r_ProdMP] ([PriceMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_ProdMP] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[PriceMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_ProdMP].[CurrID]'
GO
