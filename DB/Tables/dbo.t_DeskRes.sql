CREATE TABLE [dbo].[t_DeskRes]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocTime] [datetime] NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[DeskCode] [int] NOT NULL,
[ResTime] [smalldatetime] NOT NULL,
[Visitors] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[ResTimeEnd] [smalldatetime] NULL,
[SumPrePay] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CodeID1] [smallint] NOT NULL DEFAULT (0),
[CodeID2] [smallint] NOT NULL DEFAULT (0),
[CodeID3] [smallint] NOT NULL DEFAULT (0),
[CodeID4] [smallint] NOT NULL DEFAULT (0),
[CodeID5] [smallint] NOT NULL DEFAULT (0),
[CompID] [int] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[CurrID] [smallint] NOT NULL,
[TSumCC_nt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[PersonID] [bigint] NOT NULL CONSTRAINT [DF__t_DeskRes__Perso__18DC35FA] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_DeskRes] ADD CONSTRAINT [pk_t_DeskRes] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_DeskRes] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_DeskRes] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_DeskRes] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[t_DeskRes] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_DeskRes] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_DeskRes] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_DeskRes] ([StockID]) ON [PRIMARY]
GO
