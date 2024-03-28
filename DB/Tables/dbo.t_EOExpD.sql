CREATE TABLE [dbo].[t_EOExpD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[PriceAC] [numeric] (21, 9) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[ExpQty] [numeric] (21, 9) NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[NewQty] [numeric] (21, 9) NOT NULL,
[NewSumAC] [numeric] (21, 9) NOT NULL,
[RemQty] [numeric] (21, 9) NOT NULL,
[Extra] [numeric] (21, 9) NOT NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[SecID] [int] NOT NULL,
[ForeCastQty] [numeric] (21, 9) NOT NULL,
[PosExpDate] [smalldatetime] NULL,
[NRemDays] [int] NOT NULL,
[AChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EOExpD] ADD CONSTRAINT [pk_t_EOExpD] PRIMARY KEY CLUSTERED ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_EOExpD] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_EOExpD] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_EOExpD] ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewQty] ON [dbo].[t_EOExpD] ([NewQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewSumAC] ON [dbo].[t_EOExpD] ([NewSumAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_EOExpD] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Qty] ON [dbo].[t_EOExpD] ([Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RemQty] ON [dbo].[t_EOExpD] ([RemQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[t_EOExpD] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[t_EOExpD] ([SumAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[PriceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[ExpQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[NewQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[NewSumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[RemQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[Extra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[ForeCastQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[NRemDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_EOExpD].[AChID]'
GO
