CREATE TABLE [dbo].[c_CompCurr]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[AccountAC] [varchar] (250) NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CompAccountAC] [varchar] (250) NOT NULL,
[NewCompAccountAC] [varchar] (250) NOT NULL,
[CurrID] [smallint] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[Subject] [varchar] (200) NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[NewAccountAC] [varchar] (250) NOT NULL,
[NewCurrID] [smallint] NOT NULL,
[NewSumAC] [numeric] (21, 9) NOT NULL,
[NewKursMC] [numeric] (21, 9) NOT NULL,
[NewKursCC] [numeric] (21, 9) NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[SrcDocID] [varchar] (250) NULL,
[OldNewAccountAC] [varchar] (20) NULL,
[OldNewCompAccountAC] [varchar] (20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_CompCurr] ADD CONSTRAINT [pk_c_CompCurr] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountAC] ON [dbo].[c_CompCurr] ([AccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[c_CompCurr] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[c_CompCurr] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[c_CompCurr] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[c_CompCurr] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[c_CompCurr] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompAccountAC] ON [dbo].[c_CompCurr] ([CompAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[c_CompCurr] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[c_CompCurr] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[c_CompCurr] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[c_CompCurr] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[c_CompCurr] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[c_CompCurr] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewAccountAC] ON [dbo].[c_CompCurr] ([NewAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewCompAccountAC] ON [dbo].[c_CompCurr] ([NewCompAccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewCurrID] ON [dbo].[c_CompCurr] ([NewCurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewKursCC] ON [dbo].[c_CompCurr] ([NewKursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewKursMC] ON [dbo].[c_CompCurr] ([NewKursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewSumAC] ON [dbo].[c_CompCurr] ([NewSumAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[c_CompCurr] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[c_CompCurr] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[c_CompCurr] ([SumAC]) ON [PRIMARY]
GO
