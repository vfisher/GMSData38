CREATE TABLE [dbo].[t_AccSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_AccSpen__Spend__28BA6AAC] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_AccSpends] ADD CONSTRAINT [pk_t_AccSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_AccSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_AccSpends] ADD CONSTRAINT [FK_t_AccSpends_t_Acc] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_Acc] ([ChID])
GO
