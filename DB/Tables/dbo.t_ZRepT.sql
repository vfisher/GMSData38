CREATE TABLE [dbo].[t_ZRepT]
(
[ChID] [bigint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[OperID] [int] NOT NULL,
[POSPayID] [int] NOT NULL,
[ChequesCount] [int] NOT NULL DEFAULT ((0)),
[ChequesCountSale] [int] NOT NULL DEFAULT ((0)),
[SumCard] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[ChequesCountRet] [int] NOT NULL DEFAULT ((0)),
[RetSumCard] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[CRID] [smallint] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_ZRepT] ADD CONSTRAINT [pk_t_ZRepT] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_ZRepT] ([POSPayID], [DocTime]) ON [PRIMARY]
GO
