CREATE TABLE [dbo].[it_SupplierSpecificationD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (250) NOT NULL,
[PriceCC] [numeric] (21, 9) NOT NULL,
[Extra] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[it_SupplierSpecificationD] ADD CONSTRAINT [pk_it_SupplierSpecificationD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[it_SupplierSpecificationD] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex1] ON [dbo].[it_SupplierSpecificationD] ([ChID], [ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProdID] ON [dbo].[it_SupplierSpecificationD] ([ProdID]) ON [PRIMARY]
GO
