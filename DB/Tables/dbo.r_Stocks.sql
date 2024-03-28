CREATE TABLE [dbo].[r_Stocks]
(
[ChID] [bigint] NOT NULL,
[StockID] [int] NOT NULL,
[StockName] [varchar] (200) NOT NULL,
[StockGID] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL,
[PLID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[IsWholesale] [bit] NOT NULL,
[Address] [varchar] (250) NULL,
[StockTaxID] [int] NULL,
[CRStockName] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Stocks] ADD CONSTRAINT [pk_r_Stocks] PRIMARY KEY CLUSTERED ([StockID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Stocks] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_Stocks] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_Stocks] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockGID] ON [dbo].[r_Stocks] ([StockGID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [StockName] ON [dbo].[r_Stocks] ([StockName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Stocks].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Stocks].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Stocks].[StockGID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Stocks].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Stocks].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Stocks].[IsWholesale]'
GO
