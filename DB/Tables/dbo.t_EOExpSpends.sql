CREATE TABLE [dbo].[t_EOExpSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_EOExpSp__Spend__2E3E39D8] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EOExpSpends] ADD CONSTRAINT [pk_t_EOExpSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_EOExpSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_EOExpSpends] ADD CONSTRAINT [FK_t_EOExpSpends_t_EOExp] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_EOExp] ([ChID])
GO
