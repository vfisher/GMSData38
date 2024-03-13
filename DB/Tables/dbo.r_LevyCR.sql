CREATE TABLE [dbo].[r_LevyCR]
(
[LevyID] [int] NOT NULL,
[CashType] [smallint] NOT NULL,
[TaxID] [tinyint] NOT NULL,
[CRTaxPercent] [numeric] (21, 9) NOT NULL,
[Override] [bit] NOT NULL,
[TaxTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_LevyCR] ADD CONSTRAINT [pk_r_LevyCR] PRIMARY KEY CLUSTERED ([LevyID], [CashType], [TaxTypeID]) ON [PRIMARY]
GO
