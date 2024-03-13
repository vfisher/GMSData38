CREATE TABLE [dbo].[b_TranE]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[DocDate] [smalldatetime] NULL,
[EmpID] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumAC_nt] [numeric] (21, 9) NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[SumAC1] [numeric] (21, 9) NOT NULL,
[TaxSum1] [numeric] (21, 9) NOT NULL,
[SumAC1_nt] [numeric] (21, 9) NOT NULL,
[InDocID] [bigint] NULL,
[Notes] [varchar] (200) NULL,
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_TranE] ADD CONSTRAINT [pk_b_TranE] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_TranE] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_TranE] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_TranE] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_TranE] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_TranE] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_TranE] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_TranE] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_TranE] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_TranE] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcDocID] ON [dbo].[b_TranE] ([InDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[b_TranE] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_TranE] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_TranE] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[b_TranE] ([SumAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC_nt] ON [dbo].[b_TranE] ([SumAC_nt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC1] ON [dbo].[b_TranE] ([SumAC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC1_nt] ON [dbo].[b_TranE] ([SumAC1_nt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxSum] ON [dbo].[b_TranE] ([TaxSum]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxSum1] ON [dbo].[b_TranE] ([TaxSum1]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[SumAC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[SumAC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[TaxSum1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[SumAC1_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_TranE].[InDocID]'
GO
