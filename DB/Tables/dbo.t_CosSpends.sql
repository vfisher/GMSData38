CREATE TABLE [dbo].[t_CosSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_CosSpen__Spend__7100216E] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CosSpends] ADD CONSTRAINT [pk_t_CosSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_CosSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CosSpends] ADD CONSTRAINT [FK_t_CosSpends_t_Cos] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_Cos] ([ChID])
GO
