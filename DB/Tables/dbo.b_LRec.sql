CREATE TABLE [dbo].[b_LRec]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[OurID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[WorkDays] [tinyint] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[CurrID] [smallint] NOT NULL DEFAULT (0),
[TAdvanceCC] [numeric] (21, 9) NOT NULL,
[TAlimonyCC] [numeric] (21, 9) NOT NULL,
[TChargeCC] [numeric] (21, 9) NOT NULL,
[TCRateCC] [numeric] (21, 9) NOT NULL,
[TEmpTaxCC] [numeric] (21, 9) NOT NULL,
[TIncomeTaxCC] [numeric] (21, 9) NOT NULL,
[TInsureCC] [numeric] (21, 9) NOT NULL,
[TInsureTaxCC] [numeric] (21, 9) NOT NULL,
[TLeaveCC] [numeric] (21, 9) NOT NULL,
[TLoanCC] [numeric] (21, 9) NOT NULL,
[TMChargeCC] [numeric] (21, 9) NOT NULL,
[TMChargeCC1] [numeric] (21, 9) NOT NULL,
[TMChargeCC2] [numeric] (21, 9) NOT NULL,
[TMHelpCC] [numeric] (21, 9) NOT NULL,
[TMoreCC] [numeric] (21, 9) NOT NULL,
[TMoreCC1] [numeric] (21, 9) NOT NULL,
[TMoreCC2] [numeric] (21, 9) NOT NULL,
[TNLeaveCC] [numeric] (21, 9) NOT NULL,
[TPensionTaxCC] [numeric] (21, 9) NOT NULL,
[TPregCC] [numeric] (21, 9) NOT NULL,
[TSickCC] [numeric] (21, 9) NOT NULL,
[TUnionCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_LRec] ADD CONSTRAINT [pk_b_LRec] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_LRec] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_LRec] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_LRec] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_LRec] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_LRec] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_LRec] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_LRec] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_LRec] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_LRec] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_LRec] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[b_LRec] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WorkDays] ON [dbo].[b_LRec] ([WorkDays]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRec].[WorkDays]'
GO
