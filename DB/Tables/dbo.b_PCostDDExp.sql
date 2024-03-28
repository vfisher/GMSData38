CREATE TABLE [dbo].[b_PCostDDExp]
(
[AChID] [bigint] NOT NULL,
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
ALTER TABLE [dbo].[b_PCostDDExp] ADD CONSTRAINT [pk_b_PCostDDExp] PRIMARY KEY CLUSTERED ([AChID], [SrcPosID]) ON [PRIMARY]
GO
