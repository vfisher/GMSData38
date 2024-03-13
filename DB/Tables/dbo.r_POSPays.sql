CREATE TABLE [dbo].[r_POSPays]
(
[ChID] [bigint] NOT NULL,
[POSPayID] [int] NOT NULL,
[POSPayName] [varchar] (250) NOT NULL,
[POSPayClass] [varchar] (250) NOT NULL,
[POSPayPort] [int] NOT NULL,
[POSPayTimeout] [int] NOT NULL,
[Notes] [varchar] (250) NULL,
[UseGrpCardForDiscs] [bit] NOT NULL DEFAULT (0),
[UseUnionCheque] [bit] NOT NULL DEFAULT ((0)),
[BankID] [int] NOT NULL DEFAULT ((0)),
[PrintTranInfoInCheque] [bit] NOT NULL DEFAULT ((0)),
[IP] [varchar] (250) NULL,
[NetPort] [int] NULL,
[UsePosCollection] [bit] NOT NULL DEFAULT ((0)),
[SettleBeforeRefund] [bit] NOT NULL DEFAULT ((1)),
[POSMerchantId] [int] NOT NULL DEFAULT ((1)),
[UsePosCompareCR] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_POSPays] ADD CONSTRAINT [pk_r_POSPays] PRIMARY KEY CLUSTERED ([POSPayID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_POSPays] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [POSPayName] ON [dbo].[r_POSPays] ([POSPayName]) ON [PRIMARY]
GO
