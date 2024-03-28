CREATE TABLE [dbo].[t_DeskResD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[BarCode] [varchar] (42) NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NOT NULL,
[Qty] [numeric] (21, 9) NOT NULL,
[PriceCC_nt] [numeric] (21, 9) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[Tax] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[PriceCC_wt] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[PLID] [int] NOT NULL,
[ServingID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DeskResD] ADD CONSTRAINT [pk_t_DeskResD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
