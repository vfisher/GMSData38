CREATE TABLE [dbo].[b_BankRecCC]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[AccountCC] [varchar] (250) NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[DocID] [bigint] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CompAccountCC] [varchar] (250) NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[Subject] [varchar] (255) NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[GOperID] [int] NOT NULL,
[GTAccID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[GTSum_wt] [numeric] (21, 9) NOT NULL,
[GTTaxSum] [numeric] (21, 9) NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[GPosID] [int] NOT NULL DEFAULT (0),
[GTCorrSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[SrcDocID] [varchar] (250) NULL,
[GTAdvAccID] [int] NOT NULL DEFAULT (0),
[GTAdvSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrAdvSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTAdvTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrAdvTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_BankRecCC] ADD CONSTRAINT [pk_b_BankRecCC] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountCC] ON [dbo].[b_BankRecCC] ([AccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_BankRecCC] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_BankRecCC] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_BankRecCC] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_BankRecCC] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_BankRecCC] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompAccountCC] ON [dbo].[b_BankRecCC] ([CompAccountCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[b_BankRecCC] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_BankRecCC] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_BankRecCC] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_BankRecCC] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_BankRecCC] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_BankRecCC] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[b_BankRecCC] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC_nt] ON [dbo].[b_BankRecCC] ([SumCC_nt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC_wt] ON [dbo].[b_BankRecCC] ([SumCC_wt]) ON [PRIMARY]
GO
