CREATE TABLE [dbo].[t_zRep]
(
[ChID] [bigint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[CRID] [smallint] NOT NULL,
[OperID] [int] NOT NULL,
[OurID] [int] NOT NULL,
[DocID] [bigint] NOT NULL,
[FacID] [varchar] (250) NOT NULL,
[FinID] [varchar] (250) NOT NULL,
[ZRepNum] [int] NOT NULL DEFAULT (0),
[SumCC_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[Sum_A] [numeric] (21, 9) NOT NULL DEFAULT (0),
[Sum_B] [numeric] (21, 9) NOT NULL DEFAULT (0),
[Sum_C] [numeric] (21, 9) NOT NULL DEFAULT (0),
[Sum_D] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSum_A] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSum_B] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSum_C] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSum_D] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCash] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCard] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCredit] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumCheque] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumOther] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSumCash] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSumCard] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSumCredit] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSumCheque] [numeric] (21, 9) NOT NULL DEFAULT (0),
[RetSumOther] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumMonRec] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumMonExp] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SumRem] [numeric] (21, 9) NULL DEFAULT (0),
[Notes] [varchar] (250) NULL,
[Sum_E] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[Sum_F] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[RetSum_E] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[RetSum_F] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[Tax_A] [numeric] (21, 9) NULL DEFAULT ((0)),
[Tax_B] [numeric] (21, 9) NULL DEFAULT ((0)),
[Tax_C] [numeric] (21, 9) NULL DEFAULT ((0)),
[Tax_D] [numeric] (21, 9) NULL DEFAULT ((0)),
[Tax_E] [numeric] (21, 9) NULL DEFAULT ((0)),
[Tax_F] [numeric] (21, 9) NULL DEFAULT ((0)),
[RetTax_A] [numeric] (21, 9) NULL DEFAULT ((0)),
[RetTax_B] [numeric] (21, 9) NULL DEFAULT ((0)),
[RetTax_C] [numeric] (21, 9) NULL DEFAULT ((0)),
[RetTax_D] [numeric] (21, 9) NULL DEFAULT ((0)),
[RetTax_E] [numeric] (21, 9) NULL DEFAULT ((0)),
[RetTax_F] [numeric] (21, 9) NULL DEFAULT ((0)),
[SaleSumCustom1] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SaleSumCustom2] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SaleSumCustom3] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SumRetCustom1] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SumRetCustom2] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SumRetCustom3] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[ChequesCountSale] [int] NOT NULL DEFAULT ((0)),
[ChequesCountRet] [int] NOT NULL DEFAULT ((0)),
[ChequesCountCashBack] [int] NOT NULL DEFAULT ((0)),
[SumCashBack] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[SaleSumCCardCashBack] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_zRep] ADD CONSTRAINT [pk_t_zRep] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_zRep] ([CRID], [DocTime] DESC) ON [PRIMARY]
GO