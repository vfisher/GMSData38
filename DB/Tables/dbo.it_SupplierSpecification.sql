CREATE TABLE [dbo].[it_SupplierSpecification]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[OurID] [int] NOT NULL,
[CompID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[it_SupplierSpecification] ADD CONSTRAINT [pk_it_SupplierSpecification] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[it_SupplierSpecification] ([DocID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[it_SupplierSpecification] ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[it_SupplierSpecification] ([OurID]) ON [PRIMARY]
GO
