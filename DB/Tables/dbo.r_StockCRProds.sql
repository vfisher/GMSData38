CREATE TABLE [dbo].[r_StockCRProds]
(
[StockID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[CRProdID] [smallint] NOT NULL,
[CRProdGroup] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_StockCRProds] ADD CONSTRAINT [pk_r_StockCRProds] PRIMARY KEY CLUSTERED ([StockID], [ProdID], [CRProdGroup]) ON [PRIMARY]
GO
