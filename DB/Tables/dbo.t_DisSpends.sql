CREATE TABLE [dbo].[t_DisSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_DisSpen__Spend__63A62650] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DisSpends] ADD CONSTRAINT [pk_t_DisSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_DisSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DisSpends] ADD CONSTRAINT [FK_t_DisSpends_t_Dis] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_Dis] ([ChID])
GO
