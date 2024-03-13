CREATE TABLE [dbo].[b_WBill]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[EmpID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[CarrID] [smallint] NOT NULL,
[TrailerID1] [smallint] NOT NULL,
[TrailerID2] [smallint] NOT NULL,
[StartSpInf] [numeric] (21, 9) NOT NULL,
[EndSpInf] [numeric] (21, 9) NOT NULL,
[StartTime] [smalldatetime] NULL,
[EndTime] [smalldatetime] NULL,
[GiveFuell] [numeric] (21, 9) NOT NULL,
[InRemFuell] [numeric] (21, 9) NOT NULL,
[RemFuell] [numeric] (21, 9) NOT NULL,
[NExpFuell] [numeric] (21, 9) NOT NULL,
[RaceLength] [numeric] (21, 9) NOT NULL,
[RaceTime] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[CurrID] [smallint] NOT NULL DEFAULT (0),
[TSumCC_nt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_WBill__TSumCC___58602784] DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_WBill__TTaxSum__59544BBD] DEFAULT (0),
[TSumCC_wt] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_WBill__TSumCC___5A486FF6] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_WBill] ADD CONSTRAINT [pk_b_WBill] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CarrID] ON [dbo].[b_WBill] ([CarrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_WBill] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_WBill] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_WBill] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_WBill] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_WBill] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_WBill] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_WBill] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_WBill] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_WBill] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_WBill] ([KursMC]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[b_WBill] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TrailerID1] ON [dbo].[b_WBill] ([TrailerID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TrailerID2] ON [dbo].[b_WBill] ([TrailerID2]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[CarrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[TrailerID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[TrailerID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[StartSpInf]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[EndSpInf]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[GiveFuell]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[InRemFuell]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[RemFuell]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[NExpFuell]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[RaceLength]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_WBill].[RaceTime]'
GO
