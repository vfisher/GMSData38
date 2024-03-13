CREATE TABLE [dbo].[t_SRec]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[SubDocDate] [smalldatetime] NOT NULL,
[SubStockID] [int] NOT NULL,
[Value1] [numeric] (21, 9) NULL,
[Value2] [numeric] (21, 9) NULL,
[Value3] [numeric] (21, 9) NULL,
[CurrID] [smallint] NOT NULL DEFAULT (0),
[TCostSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TCostSum__7E251262] DEFAULT (0),
[TSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSumCC_n__7F19369B] DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TTaxSum__000D5AD4] DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSumCC_w__01017F0D] DEFAULT (0),
[TNewSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TNewSumC__01F5A346] DEFAULT (0),
[TNewTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TNewTaxS__02E9C77F] DEFAULT (0),
[TNewSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TNewSumC__03DDEBB8] DEFAULT (0),
[TSubSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubSumC__04D20FF1] DEFAULT (0),
[TSubTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubTaxS__05C6342A] DEFAULT (0),
[TSubSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubSumC__06BA5863] DEFAULT (0),
[TSubNewSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubNewS__07AE7C9C] DEFAULT (0),
[TSubNewTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubNewT__08A2A0D5] DEFAULT (0),
[TSubNewSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSubNewS__0996C50E] DEFAULT (0),
[TSetSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SRec__TSetSumC__0A8AE947] DEFAULT (0),
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SRec] ADD CONSTRAINT [pk_t_SRec] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_SRec] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_SRec] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_SRec] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_SRec] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_SRec] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_SRec] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_SRec] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_SRec] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[t_SRec] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[t_SRec] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_SRec] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_SRec] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_SRec] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubDocDate] ON [dbo].[t_SRec] ([SubDocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubStockID] ON [dbo].[t_SRec] ([SubStockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[SubStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SRec].[Value3]'
GO
