CREATE TABLE [dbo].[r_StockSubs]
(
[StockID] [int] NOT NULL,
[SubStockID] [int] NOT NULL,
[DepID] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StockSubs] ADD CONSTRAINT [pk_r_StockSubs] PRIMARY KEY CLUSTERED ([StockID], [DepID]) ON [PRIMARY]
GO
