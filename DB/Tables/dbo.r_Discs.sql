CREATE TABLE [dbo].[r_Discs]
(
[ChID] [bigint] NOT NULL,
[DiscCode] [int] NOT NULL,
[DiscName] [varchar] (200) NOT NULL,
[ThisChargeOnly] [bit] NOT NULL,
[ThisDocBonus] [bit] NOT NULL,
[OtherDocsBonus] [bit] NOT NULL,
[ChargeDCard] [bit] NOT NULL,
[DiscOnlyWithDCard] [bit] NOT NULL,
[ChargeAfterClose] [bit] NOT NULL,
[Priority] [int] NOT NULL,
[AllowDiscs] [varchar] (250) NULL,
[Shed1] [varchar] (2000) NULL,
[Shed2] [varchar] (2000) NULL,
[Shed3] [varchar] (2000) NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[GenProcs] [bit] NOT NULL DEFAULT (1),
[InUse] [bit] NOT NULL DEFAULT (1),
[DocCode] [int] NOT NULL DEFAULT (1011),
[SimpleDisc] [bit] NOT NULL DEFAULT (0),
[SaveDiscToDCard] [bit] NOT NULL DEFAULT (0),
[SaveBonusToDCard] [bit] NOT NULL DEFAULT (0),
[DiscFromDCard] [bit] NOT NULL DEFAULT (0),
[ReProcessPosDiscs] [bit] NOT NULL DEFAULT (0),
[ValidOurs] [varchar] (250) NULL,
[ValidStocks] [varchar] (250) NULL,
[AutoSelDiscs] [bit] NOT NULL DEFAULT (0),
[ShortCut] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL,
[GroupDisc] [bit] NOT NULL,
[PrintInCheque] [bit] NOT NULL DEFAULT ((1)),
[AllowZeroPrice] [bit] NOT NULL DEFAULT ((0)),
[AllowEditQty] [bit] NOT NULL DEFAULT ((0)),
[RedistributeDiscSumInBusket] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Discs] ADD CONSTRAINT [pk_r_Discs] PRIMARY KEY CLUSTERED ([DiscCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Discs] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DiscName] ON [dbo].[r_Discs] ([DiscName]) ON [PRIMARY]
GO
