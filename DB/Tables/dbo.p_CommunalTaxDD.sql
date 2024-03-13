CREATE TABLE [dbo].[p_CommunalTaxDD]
(
[AChID] [bigint] NOT NULL,
[CostGAccID] [int] NOT NULL,
[GAccCommunalSumCC] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CommunalTaxDD] ADD CONSTRAINT [pk_p_CommunalTaxDD] PRIMARY KEY CLUSTERED ([AChID], [CostGAccID]) ON [PRIMARY]
GO
