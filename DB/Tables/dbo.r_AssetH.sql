CREATE TABLE [dbo].[r_AssetH]
(
[AssID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[AGrID] [int] NOT NULL,
[ACatID] [int] NOT NULL,
[Age] [numeric] (21, 9) NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SupPriceCC_nt] [numeric] (21, 9) NOT NULL,
[WerSumCC_nt] [numeric] (21, 9) NOT NULL,
[DepSumCC_nt] [numeric] (21, 9) NOT NULL,
[RepSumCC_nt] [numeric] (21, 9) NOT NULL,
[ChargeType] [tinyint] NOT NULL,
[ChargeTypeDep] [tinyint] NOT NULL,
[LiqPriceCC_nt] [numeric] (21, 9) NOT NULL,
[GenQty] [numeric] (21, 9) NOT NULL,
[EmpID] [int] NOT NULL,
[GAccID] [int] NOT NULL,
[IsProdAss] [bit] NOT NULL,
[DepID] [smallint] NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_AssetH] ADD CONSTRAINT [pk_r_AssetH] PRIMARY KEY CLUSTERED ([AssID], [BDate]) ON [PRIMARY]
GO
