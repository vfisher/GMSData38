CREATE TABLE [dbo].[t_CRRetPays]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[PayFormCode] [int] NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[POSPayID] [int] NOT NULL DEFAULT (0),
[SrcPayPosID] [int] NULL,
[POSPayDocID] [int] NULL,
[POSPayRRN] [varchar] (250) NULL,
[PrintState] [smallint] NULL,
[ChequeText] [varchar] (8000) NULL,
[BServID] [int] NOT NULL DEFAULT ((0)),
[POSPayText] [varchar] (8000) NULL,
[TransactionInfo] [varchar] (8000) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRRetPays] ADD CONSTRAINT [pk_t_CRRetPays] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID_PayFormCode_SumCC_wt] ON [dbo].[t_CRRetPays] ([ChID], [PayFormCode], [SumCC_wt]) ON [PRIMARY]
GO
