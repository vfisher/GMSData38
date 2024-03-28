CREATE TABLE [dbo].[r_TaxRates]
(
[TaxTypeID] [int] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[TaxPercent] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_TaxRates] ADD CONSTRAINT [pk_r_TaxRates] PRIMARY KEY CLUSTERED ([TaxTypeID], [ChDate]) ON [PRIMARY]
GO
