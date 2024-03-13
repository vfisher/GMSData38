CREATE TABLE [dbo].[b_Cst]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[KursAC] [numeric] (21, 9) NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[StockID] [int] NOT NULL,
[CompID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[PayDelay] [smallint] NULL,
[Notes] [varchar] (200) NULL,
[CurrID] [smallint] NOT NULL,
[DelID] [tinyint] NOT NULL,
[TSumAC_In] [numeric] (21, 9) NOT NULL,
[TTrtAC] [numeric] (21, 9) NOT NULL,
[TMoreCC] [numeric] (21, 9) NOT NULL,
[Note1] [varchar] (200) NULL,
[GTSum_wt] [numeric] (21, 9) NOT NULL,
[GTTaxSum] [numeric] (21, 9) NOT NULL,
[GTAccID] [int] NOT NULL,
[CompAdd] [varchar] (200) NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[TTaxSum] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_Cst__TTaxSum__27F1FA53] DEFAULT (0),
[TSumCC_In] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__b_Cst__TSumCC_In__28E61E8C] DEFAULT (0),
[GPosID] [int] NOT NULL DEFAULT (0),
[GTCorrSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstCompID] [int] NOT NULL DEFAULT (0),
[TCstSumCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TTrtCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[KursAC_In] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTAdvAccID] [int] NOT NULL DEFAULT (0),
[GTAdvSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrAdvSum_wt] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTAdvTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GTCorrAdvTaxSum] [numeric] (21, 9) NOT NULL DEFAULT (0),
[CstDocCode] [varchar] (250) NOT NULL DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_Cst] ADD CONSTRAINT [pk_b_Cst] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_Cst] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_Cst] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_Cst] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_Cst] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_Cst] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[b_Cst] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_Cst] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DelID] ON [dbo].[b_Cst] ([DelID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_Cst] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_Cst] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_Cst] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTAccID] ON [dbo].[b_Cst] ([GTAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_Cst] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursAC] ON [dbo].[b_Cst] ([KursAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_Cst] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[b_Cst] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayDelay] ON [dbo].[b_Cst] ([PayDelay]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [StockID] ON [dbo].[b_Cst] ([StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TMoreCC] ON [dbo].[b_Cst] ([TMoreCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TSumAC_In] ON [dbo].[b_Cst] ([TSumAC_In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TTrtAC] ON [dbo].[b_Cst] ([TTrtAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[KursAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[PayDelay]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[DelID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[TSumAC_In]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[TTrtAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[TMoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[GTSum_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[GTTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_Cst].[GTAccID]'
GO
