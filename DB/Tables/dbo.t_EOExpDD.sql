CREATE TABLE [dbo].[t_EOExpDD]
(
[AChID] [bigint] NOT NULL,
[DetSrcPosID] [int] NOT NULL,
[DetOurID] [int] NOT NULL,
[DetStockID] [int] NOT NULL,
[DetProdID] [int] NOT NULL,
[DetUM] [varchar] (10) NULL,
[DetPriceAC] [numeric] (21, 9) NOT NULL,
[DetQty] [numeric] (21, 9) NOT NULL,
[DetExpQty] [numeric] (21, 9) NOT NULL,
[DetSumAC] [numeric] (21, 9) NOT NULL,
[DetNewQty] [numeric] (21, 9) NOT NULL,
[DetNewSumAC] [numeric] (21, 9) NOT NULL,
[DetRemQty] [numeric] (21, 9) NOT NULL,
[DetSecID] [int] NOT NULL,
[DetNRemDays] [int] NOT NULL,
[DetForeCastQty] [numeric] (21, 9) NOT NULL,
[DetPosExpDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EOExpDD] ADD CONSTRAINT [_pk_t_EOExpDD] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[t_EOExpDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetOurID] ON [dbo].[t_EOExpDD] ([DetOurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetProdID] ON [dbo].[t_EOExpDD] ([DetProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetSecID] ON [dbo].[t_EOExpDD] ([DetSecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetStockID] ON [dbo].[t_EOExpDD] ([DetStockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetSrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetOurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetPriceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetExpQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetSumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetNewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetNewSumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetRemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetSecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetNRemDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpDD].[DetForeCastQty]'
GO
