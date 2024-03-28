CREATE TABLE [dbo].[t_SalePays]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[PayFormCode] [int] NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[POSPayID] [int] NOT NULL DEFAULT (0),
[POSPayDocID] [int] NULL,
[POSPayRRN] [varchar] (250) NULL,
[ChequeText] [varchar] (8000) NULL,
[BServID] [int] NOT NULL DEFAULT ((0)),
[PayPartsQty] [int] NULL,
[ContractNo] [varchar] (250) NULL,
[POSPayText] [varchar] (8000) NULL,
[TransactionInfo] [varchar] (8000) NULL,
[CashBack] [numeric] (21, 9) NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SalePays] ADD CONSTRAINT [pk_t_SalePays] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_PayFormCode_SumCC_wt] ON [dbo].[t_SalePays] ([ChID], [PayFormCode], [SumCC_wt]) ON [PRIMARY]
GO
