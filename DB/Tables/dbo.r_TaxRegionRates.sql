CREATE TABLE [dbo].[r_TaxRegionRates]
(
[TaxRegionID] [int] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[CommunalTaxRate] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_TaxRegionRates] ADD CONSTRAINT [pk_r_TaxRegionRates] PRIMARY KEY CLUSTERED ([TaxRegionID], [SrcDate]) ON [PRIMARY]
GO
