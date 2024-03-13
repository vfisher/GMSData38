CREATE TABLE [dbo].[r_TaxRegions]
(
[ChID] [bigint] NOT NULL,
[TaxRegionID] [int] NOT NULL,
[TaxRegionName] [varchar] (250) NOT NULL,
[RegionID] [int] NOT NULL,
[DistrictID] [int] NOT NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_TaxRegions] ADD CONSTRAINT [pk_r_TaxRegions] PRIMARY KEY CLUSTERED ([TaxRegionID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_TaxRegions] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [TaxRegionName] ON [dbo].[r_TaxRegions] ([TaxRegionName]) ON [PRIMARY]
GO
