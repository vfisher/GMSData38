CREATE TABLE [dbo].[t_IOExpSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_IOExpSp__Spend__564C2B32] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IOExpSpends] ADD CONSTRAINT [pk_t_IOExpSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_IOExpSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IOExpSpends] ADD CONSTRAINT [FK_t_IOExpSpends_t_IOExp] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_IOExp] ([ChID])
GO
