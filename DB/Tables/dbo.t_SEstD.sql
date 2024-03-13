CREATE TABLE [dbo].[t_SEstD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceAC] [numeric] (21, 9) NOT NULL,
[NewPriceAC] [numeric] (21, 9) NOT NULL,
[Extra] [numeric] (21, 9) NOT NULL,
[CurrID] [smallint] NOT NULL,
[NewCurrID] [smallint] NOT NULL,
[PLID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[BarCode] [varchar] (42) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SEstD] ADD CONSTRAINT [_pk_t_SEstD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BarCode] ON [dbo].[t_SEstD] ([BarCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[t_SEstD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[t_SEstD] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_SEstD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewCurrID] ON [dbo].[t_SEstD] ([NewCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[t_SEstD] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[t_SEstD] ([ProdID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[PriceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[NewPriceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[Extra]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[NewCurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SEstD].[EmpID]'
GO
