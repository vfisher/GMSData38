CREATE TABLE [dbo].[t_CashBack]
(
[ChID] [bigint] NOT NULL,
[SaleSrcDocID] [bigint] NOT NULL,
[CRID] [smallint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[OperID] [int] NOT NULL,
[POSPayID] [int] NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[TransactionInfo] [varchar] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CashBack] ADD CONSTRAINT [pk_t_CashBack] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRID_DocTime] ON [dbo].[t_CashBack] ([CRID], [DocTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_CashBack] ([DocDate]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_CashBack] ([SaleSrcDocID], [OurID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_CashBack] ADD CONSTRAINT [FK_t_CashBack_r_CRs] FOREIGN KEY ([CRID]) REFERENCES [dbo].[r_CRs] ([CRID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CashBack] ADD CONSTRAINT [FK_t_CashBack_r_Opers] FOREIGN KEY ([OperID]) REFERENCES [dbo].[r_Opers] ([OperID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CashBack] ADD CONSTRAINT [FK_t_CashBack_r_Ours] FOREIGN KEY ([OurID]) REFERENCES [dbo].[r_Ours] ([OurID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[t_CashBack] ADD CONSTRAINT [FK_t_CashBack_r_POSPays] FOREIGN KEY ([POSPayID]) REFERENCES [dbo].[r_POSPays] ([POSPayID]) ON UPDATE CASCADE
GO
