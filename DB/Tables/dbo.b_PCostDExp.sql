CREATE TABLE [dbo].[b_PCostDExp]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[DetSumCC_nt] [numeric] (21, 9) NOT NULL,
[DetTaxSum] [numeric] (21, 9) NOT NULL,
[DetSumCC_wt] [numeric] (21, 9) NOT NULL,
[DetNote] [varchar] (200) NOT NULL,
[DetCompID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_PCostDExp] ADD CONSTRAINT [pk_b_PCostDExp] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
