CREATE TABLE [dbo].[z_DocLinks_Tax]
(
[LinkID] [int] NOT NULL,
[SumCC_nt_20] [numeric] (21, 9) NOT NULL,
[TaxSum_20] [numeric] (21, 9) NOT NULL,
[SumCC_nt_0] [numeric] (21, 9) NOT NULL,
[TaxSum_0] [numeric] (21, 9) NOT NULL,
[SumCC_nt_Free] [numeric] (21, 9) NOT NULL,
[TaxSum_Free] [numeric] (21, 9) NOT NULL,
[SumCC_nt_No] [numeric] (21, 9) NOT NULL,
[TaxSum_No] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[z_DocLinks_Tax] ADD CONSTRAINT [pk_z_DocLinks_Tax] PRIMARY KEY CLUSTERED ([LinkID]) ON [PRIMARY]
GO
