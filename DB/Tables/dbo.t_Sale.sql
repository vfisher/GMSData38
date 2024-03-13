CREATE TABLE [dbo].[t_Sale]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[Discount] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[CRID] [smallint] NOT NULL,
[OperID] [int] NOT NULL,
[CreditID] [varchar] (50) NULL,
[DocTime] [datetime] NOT NULL,
[EmpID] [int] NOT NULL DEFAULT (0),
[IntDocID] [varchar] (50) NULL,
[CashSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[ChangeSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CurrID] [smallint] NOT NULL DEFAULT (0),
[TSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_Sale__TSumCC_n__397AE25A] DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_Sale__TTaxSum__3A6F0693] DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_Sale__TSumCC_w__3B632ACC] DEFAULT (0),
[StateCode] [int] NOT NULL DEFAULT (0),
[DeskCode] [int] NOT NULL DEFAULT (0),
[Visitors] [int] NULL DEFAULT (0),
[TPurSumCC_nt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TPurTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TPurSumCC_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[DocCreateTime] [datetime] NULL CONSTRAINT [DF__t_Sale__DocCreat__66AFDD89] DEFAULT (getdate()),
[TRealSum] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[TLevySum] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[WPID] [int] NOT NULL DEFAULT ((0)),
[DCardChID] [bigint] NOT NULL CONSTRAINT [DF__t_Sale__DCardChI__199B5009] DEFAULT ((0)),
[ExtraInfo] [varchar] (8000) NULL,
[GUID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
[ChequeTypeID] [int] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Sale] ADD CONSTRAINT [pk_t_Sale] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_Sale] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_Sale] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_Sale] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_Sale] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_Sale] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[t_Sale] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CRID_DocTime] ON [dbo].[t_Sale] ([CRID], [DocTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_CRMOt_Sale] ON [dbo].[t_Sale] ([CRID], [OperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_Sale] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_Sale] ([DocID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [GUID] ON [dbo].[t_Sale] ([GUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[t_Sale] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_Sale] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_Sale] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_Sale] ([StockID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_Sale] ADD CONSTRAINT [FK_t_Sale_r_DCards] FOREIGN KEY ([DCardChID]) REFERENCES [dbo].[r_DCards] ([ChID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[Discount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[CRID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_Sale].[OperID]'
GO
