CREATE TABLE [dbo].[b_BankPayAC]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[AccountAC] [varchar] (250) NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[DocDate] [smalldatetime] NOT NULL,
[CompID] [int] NOT NULL,
[CompAccountAC] [varchar] (250) NOT NULL,
[CompBank] [varchar] (255) NULL,
[CompBankSWIFT] [varchar] (50) NULL,
[CorrBank] [varchar] (255) NULL,
[CorrBankSWIFT] [varchar] (50) NULL,
[CurrID] [smallint] NOT NULL,
[SumAC] [numeric] (21, 9) NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[Subject] [varchar] (255) NULL,
[PayType] [tinyint] NOT NULL,
[OurBankPays] [bit] NOT NULL,
[OtherBankPays] [bit] NOT NULL,
[CompBankBLZ] [varchar] (50) NULL,
[CompBankFW] [varchar] (200) NULL,
[CorrBankBLZ] [varchar] (50) NULL,
[CorrBankFW] [varchar] (200) NULL,
[BankOperID] [smallint] NULL,
[CounID] [smallint] NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_BankPayAC] ADD CONSTRAINT [pk_b_BankPayAC] PRIMARY KEY CLUSTERED ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[b_BankPayAC] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[b_BankPayAC] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[b_BankPayAC] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[b_BankPayAC] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[b_BankPayAC] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompID] ON [dbo].[b_BankPayAC] ([CompID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CounID] ON [dbo].[b_BankPayAC] ([CounID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[b_BankPayAC] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocDate] ON [dbo].[b_BankPayAC] ([DocDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[b_BankPayAC] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[b_BankPayAC] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[b_BankPayAC] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[b_BankPayAC] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_OursACb_BAPay] ON [dbo].[b_BankPayAC] ([OurID], [AccountAC]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[b_BankPayAC] ([OurID], [DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayType] ON [dbo].[b_BankPayAC] ([PayType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[b_BankPayAC] ([SumAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[SumAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[PayType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[OurBankPays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[OtherBankPays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[BankOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CounID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_BankPayAC].[CodeID5]'
GO
