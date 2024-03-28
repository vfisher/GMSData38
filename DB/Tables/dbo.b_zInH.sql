CREATE TABLE [dbo].[b_zInH]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[GTranID] [int] NOT NULL,
[D_GAccID] [int] NOT NULL,
[C_GAccID] [int] NOT NULL,
[D_CompID] [int] NOT NULL,
[C_CompID] [int] NOT NULL,
[D_EmpID] [int] NOT NULL,
[C_EmpID] [int] NOT NULL,
[D_CodeID1] [smallint] NOT NULL,
[C_CodeID1] [smallint] NOT NULL,
[D_CodeID2] [smallint] NOT NULL,
[C_CodeID2] [smallint] NOT NULL,
[D_CodeID3] [smallint] NOT NULL,
[C_CodeID3] [smallint] NOT NULL,
[D_CodeID4] [smallint] NOT NULL,
[C_CodeID4] [smallint] NOT NULL,
[D_CodeID5] [smallint] NOT NULL,
[C_CodeID5] [smallint] NOT NULL,
[D_StockID] [int] NOT NULL,
[C_StockID] [int] NOT NULL,
[D_ProdID] [int] NOT NULL,
[C_ProdID] [int] NOT NULL,
[D_AssID] [int] NOT NULL,
[C_AssID] [int] NOT NULL,
[D_GVolID] [int] NOT NULL,
[C_GVolID] [int] NOT NULL,
[D_Qty] [numeric] (21, 9) NOT NULL,
[C_Qty] [numeric] (21, 9) NOT NULL,
[DocID] [bigint] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[DocDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_zInH] ADD CONSTRAINT [pk_b_zInH] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_AssID] ON [dbo].[b_zInH] ([C_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID1] ON [dbo].[b_zInH] ([C_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID2] ON [dbo].[b_zInH] ([C_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID3] ON [dbo].[b_zInH] ([C_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID4] ON [dbo].[b_zInH] ([C_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID5] ON [dbo].[b_zInH] ([C_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CompID] ON [dbo].[b_zInH] ([C_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_EmpID] ON [dbo].[b_zInH] ([C_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccID] ON [dbo].[b_zInH] ([C_GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GVolID] ON [dbo].[b_zInH] ([C_GVolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_ProdID] ON [dbo].[b_zInH] ([C_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_StockID] ON [dbo].[b_zInH] ([C_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_zInH] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_AssID] ON [dbo].[b_zInH] ([D_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID1] ON [dbo].[b_zInH] ([D_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID2] ON [dbo].[b_zInH] ([D_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID3] ON [dbo].[b_zInH] ([D_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID4] ON [dbo].[b_zInH] ([D_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID5] ON [dbo].[b_zInH] ([D_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CompID] ON [dbo].[b_zInH] ([D_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_EmpID] ON [dbo].[b_zInH] ([D_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccID] ON [dbo].[b_zInH] ([D_GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GVolID] ON [dbo].[b_zInH] ([D_GVolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_ProdID] ON [dbo].[b_zInH] ([D_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_StockID] ON [dbo].[b_zInH] ([D_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[b_zInH] ([OurID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[D_Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInH].[C_Qty]'
GO
