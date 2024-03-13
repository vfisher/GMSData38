CREATE TABLE [dbo].[t_CRetSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_CRetSpe__Spend__50C85C06] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRetSpends] ADD CONSTRAINT [pk_t_CRetSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_CRetSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CRetSpends] ADD CONSTRAINT [FK_t_CRetSpends_t_CRet] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_CRet] ([ChID])
GO
