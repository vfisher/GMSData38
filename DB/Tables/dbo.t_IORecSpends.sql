CREATE TABLE [dbo].[t_IORecSpends]
(
[ChID] [bigint] NOT NULL,
[SpendCode] [int] NOT NULL,
[SpendSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_IORecSp__Spend__48F23014] DEFAULT (0),
[SpendNotes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IORecSpends] ADD CONSTRAINT [pk_t_IORecSpends] PRIMARY KEY CLUSTERED ([ChID], [SpendCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpendCode] ON [dbo].[t_IORecSpends] ([SpendCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_IORecSpends] ADD CONSTRAINT [FK_t_IORecSpends_t_IORec] FOREIGN KEY ([ChID]) REFERENCES [dbo].[t_IORec] ([ChID])
GO
