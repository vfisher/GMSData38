CREATE TABLE [dbo].[p_CommunalTaxD]
(
[ChID] [bigint] NOT NULL,
[AChID] [bigint] NOT NULL,
[TaxRegionID] [int] NOT NULL,
[AvgEmpsQty] [numeric] (21, 9) NOT NULL,
[CommunalSumCC] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CommunalTaxD] ADD CONSTRAINT [pk_p_CommunalTaxD] PRIMARY KEY CLUSTERED ([ChID], [TaxRegionID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[p_CommunalTaxD] ([AChID]) ON [PRIMARY]
GO
