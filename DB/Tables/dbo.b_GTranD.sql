CREATE TABLE [dbo].[b_GTranD]
(
[GTranID] [int] NOT NULL,
[AChID] [bigint] NOT NULL,
[CurrID] [smallint] NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
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
[D_Vol1] [varchar] (255) NULL,
[D_Vol2] [varchar] (255) NULL,
[D_Vol3] [varchar] (255) NULL,
[C_Vol1] [varchar] (255) NULL,
[C_Vol2] [varchar] (255) NULL,
[C_Vol3] [varchar] (255) NULL,
[D_GrndLinkID] [int] NOT NULL DEFAULT (0),
[C_GrndLinkID] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_GTranD] ADD CONSTRAINT [pk_b_GTranD] PRIMARY KEY CLUSTERED ([GTranID], [AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[b_GTranD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_AssID] ON [dbo].[b_GTranD] ([C_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID1] ON [dbo].[b_GTranD] ([C_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID2] ON [dbo].[b_GTranD] ([C_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID3] ON [dbo].[b_GTranD] ([C_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID4] ON [dbo].[b_GTranD] ([C_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CodeID5] ON [dbo].[b_GTranD] ([C_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_CompID] ON [dbo].[b_GTranD] ([C_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_EmpID] ON [dbo].[b_GTranD] ([C_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GAccID] ON [dbo].[b_GTranD] ([C_GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_GVolID] ON [dbo].[b_GTranD] ([C_GVolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_ProdID] ON [dbo].[b_GTranD] ([C_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [C_StockID] ON [dbo].[b_GTranD] ([C_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_GTranD] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_AssID] ON [dbo].[b_GTranD] ([D_AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID1] ON [dbo].[b_GTranD] ([D_CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID2] ON [dbo].[b_GTranD] ([D_CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID3] ON [dbo].[b_GTranD] ([D_CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID4] ON [dbo].[b_GTranD] ([D_CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CodeID5] ON [dbo].[b_GTranD] ([D_CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_CompID] ON [dbo].[b_GTranD] ([D_CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_EmpID] ON [dbo].[b_GTranD] ([D_EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GAccID] ON [dbo].[b_GTranD] ([D_GAccID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_GVolID] ON [dbo].[b_GTranD] ([D_GVolID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_ProdID] ON [dbo].[b_GTranD] ([D_ProdID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [D_StockID] ON [dbo].[b_GTranD] ([D_StockID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GTranID] ON [dbo].[b_GTranD] ([GTranID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_GAccID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_StockID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_ProdID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_GVolID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[D_Qty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_GTranD].[C_Qty]'
GO
