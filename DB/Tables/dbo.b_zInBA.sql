CREATE TABLE [dbo].[b_zInBA]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[AccountAC] [varchar] (250) NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[Notes] [varchar] (200) NULL,
[DocID] [bigint] NOT NULL,
[StockID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_zInBA] ADD CONSTRAINT [_pk_b_zInBA] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountAC] ON [dbo].[b_zInBA] ([AccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_zInBA] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_zInBA] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_zInBA] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_zInBA] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_zInBA] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_zInBA] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_zInBA] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[b_zInBA] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_zInBA] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_OursACb_zInBA] ON [dbo].[b_zInBA] ([OurID], [AccountAC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[b_zInBA] ([SumAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_zInBA].[GTranID]'
GO
