CREATE TABLE [dbo].[t_SExp]
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
[TCostSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TCostSum__0C7331B9] DEFAULT (0),
[TSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSumCC_n__0D6755F2] DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TTaxSum__0E5B7A2B] DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSumCC_w__0F4F9E64] DEFAULT (0),
[TNewSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TNewSumC__1043C29D] DEFAULT (0),
[TNewTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TNewTaxS__1137E6D6] DEFAULT (0),
[TNewSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TNewSumC__122C0B0F] DEFAULT (0),
[TSubSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSubSumC__13202F48] DEFAULT (0),
[TSubTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSubTaxS__14145381] DEFAULT (0),
[TSubSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSubSumC__150877BA] DEFAULT (0),
[TSubNewSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSubNewS__15FC9BF3] DEFAULT (0),
[TSubNewTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSubNewT__16F0C02C] DEFAULT (0),
[TSubNewSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSubNewS__17E4E465] DEFAULT (0),
[TSetSumCC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__t_SExp__TSetSumC__18D9089E] DEFAULT (0),
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_SExp] ADD CONSTRAINT [pk_t_SExp] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[t_SExp] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[t_SExp] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[t_SExp] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[t_SExp] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[t_SExp] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[t_SExp] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[t_SExp] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[t_SExp] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[t_SExp] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[t_SExp] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[t_SExp] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[t_SExp] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[t_SExp] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubDocDate] ON [dbo].[t_SExp] ([SubDocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubStockID] ON [dbo].[t_SExp] ([SubStockID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[SubStockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[t_SExp].[Value3]'
GO
