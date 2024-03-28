CREATE TABLE [dbo].[r_CRMP]
(
[CRID] [smallint] NOT NULL,
[ProdID] [int] NOT NULL,
[CRProdName] [varchar] (200) NOT NULL,
[CRProdID] [int] NOT NULL,
[TaxID] [tinyint] NOT NULL,
[SecID] [int] NOT NULL,
[FixedPrice] [bit] NOT NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[DecimalQty] [bit] NOT NULL,
[BarCode] [varchar] (250) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_CRMP] ADD CONSTRAINT [_pk_r_CRMP] PRIMARY KEY CLUSTERED ([CRID], [CRProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRID] ON [dbo].[r_CRMP] ([CRID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRProdID] ON [dbo].[r_CRMP] ([CRProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRProdName] ON [dbo].[r_CRMP] ([CRProdName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PriceCC] ON [dbo].[r_CRMP] ([PriceCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[r_CRMP] ([ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SecID] ON [dbo].[r_CRMP] ([SecID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxID] ON [dbo].[r_CRMP] ([TaxID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[CRID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[CRProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[TaxID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[SecID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[FixedPrice]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[PriceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_CRMP].[DecimalQty]'
GO
