CREATE TABLE [dbo].[b_SVenD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[AssID] [int] NOT NULL,
[SumCC_nt] [numeric] (21, 9) NOT NULL,
[TaxSum] [numeric] (21, 9) NOT NULL,
[SumCC_wt] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[NewSumCC_nt] [numeric] (21, 9) NOT NULL,
[NewTaxSum] [numeric] (21, 9) NOT NULL,
[NewSumCC_wt] [numeric] (21, 9) NOT NULL,
[TWerSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TDepSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TRepSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[WerRestSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[DepRestSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[AgeRem] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TModSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[Age] [numeric] (21, 9) NOT NULL DEFAULT (0),
[AssDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_SVenD] ADD CONSTRAINT [_pk_b_SVenD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AssID] ON [dbo].[b_SVenD] ([AssID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_SVenD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_SVenD] ([GOperID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[AssID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[SumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[TaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[SumCC_wt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[GTranID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[NewSumCC_nt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[NewTaxSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_SVenD].[NewSumCC_wt]'
GO
