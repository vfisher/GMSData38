CREATE TABLE [dbo].[t_SaleTempD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[ProdID] [int] NOT NULL,
[UM] [varchar] (50) NULL,
[Qty] [numeric] (21, 9) NULL,
[RealQty] [numeric] (21, 9) NULL,
[PriceCC_wt] [numeric] (21, 9) NULL,
[SumCC_wt] [numeric] (21, 9) NULL,
[PurPriceCC_wt] [numeric] (21, 9) NULL,
[PurSumCC_wt] [numeric] (21, 9) NULL,
[BarCode] [varchar] (42) NULL,
[RealBarCode] [varchar] (42) NOT NULL,
[PLID] [int] NOT NULL,
[UseToBarQty] [int] NULL,
[PosStatus] [int] NOT NULL,
[ServingTime] [smalldatetime] NULL,
[CSrcPosID] [int] NOT NULL,
[ServingID] [int] NOT NULL DEFAULT (0),
[CReasonID] [int] NOT NULL DEFAULT (0),
[PrintTime] [datetime] NULL,
[CanEditQty] [bit] NOT NULL DEFAULT (1),
[EmpID] [int] NOT NULL DEFAULT (0),
[EmpName] [varchar] (250) NULL,
[CreateTime] [datetime] NOT NULL DEFAULT (getdate()),
[ModifyTime] [datetime] NOT NULL DEFAULT (getdate()),
[TaxTypeID] [int] NOT NULL DEFAULT ((0)),
[AllowZeroPrice] [bit] NOT NULL DEFAULT ((0)),
[MarkCode] [int] NULL DEFAULT ((0)),
[LevyMark] [varchar] (20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SaleTempD] ADD CONSTRAINT [pk_t_SaleTempD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_SrcPosID_SumCC_wt] ON [dbo].[t_SaleTempD] ([ChID], [SrcPosID], [SumCC_wt]) ON [PRIMARY]
GO
