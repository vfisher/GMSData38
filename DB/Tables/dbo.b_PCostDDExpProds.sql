CREATE TABLE [dbo].[b_PCostDDExpProds]
(
[AChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DetProdID] [int] NOT NULL,
[DetPPID] [int] NOT NULL,
[DetUM] [varchar] (10) NULL,
[DetQty] [numeric] (21, 9) NOT NULL,
[DetPriceCC_nt] [numeric] (21, 9) NOT NULL,
[DetSumCC_nt] [numeric] (21, 9) NOT NULL,
[DetTax] [numeric] (21, 9) NOT NULL,
[DetTaxSum] [numeric] (21, 9) NOT NULL,
[DetPriceCC_wt] [numeric] (21, 9) NOT NULL,
[DetSumCC_wt] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_PCostDDExpProds] ADD CONSTRAINT [pk_b_PCostDDExpProds] PRIMARY KEY CLUSTERED ([AChID], [SrcPosID]) ON [PRIMARY]
GO
