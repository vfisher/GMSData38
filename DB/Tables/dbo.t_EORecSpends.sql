CREATE TABLE [dbo].[t_EORecSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_EORecSp__Spend__3B9834F6] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EORecSpends] ADD CONSTRAINT [pk_t_EORecSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_EORecSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EORecSpends] ADD CONSTRAINT [FK_t_EORecSpends_t_EORec] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_EORec] ([ChID])
GO
