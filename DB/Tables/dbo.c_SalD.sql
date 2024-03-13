CREATE TABLE [dbo].[c_SalD]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[CurrID] [smallint] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[KursCC] [numeric] (21, 9) NOT NULL,
[SickAC] [numeric] (21, 9) NULL,
[HolidayAC] [numeric] (21, 9) NULL,
[SurChargeAC] [numeric] (21, 9) NULL,
[MChargeCC] [numeric] (21, 9) NOT NULL,
[MChargeCC1] [numeric] (21, 9) NOT NULL,
[MChargeCC2] [numeric] (21, 9) NOT NULL,
[AdvanceAC] [numeric] (21, 9) NULL,
[CreditIn] [numeric] (21, 9) NULL,
[CreditOut] [numeric] (21, 9) NULL,
[MoreCC] [numeric] (21, 9) NOT NULL,
[MoreCC1] [numeric] (21, 9) NOT NULL,
[MoreCC2] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[SumAC] [numeric] (21, 9) NOT NULL CONSTRAINT [DF__c_SalD__SumAC__4A8F946C] DEFAULT (0),
[OutAC] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_SalD] ADD CONSTRAINT [_pk_c_SalD] PRIMARY KEY CLUSTERED ([ChID], [EmpID], [CurrID], [KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[c_SalD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CurrID] ON [dbo].[c_SalD] ([CurrID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[c_SalD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursCC] ON [dbo].[c_SalD] ([KursCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[c_SalD] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC] ON [dbo].[c_SalD] ([MChargeCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC1] ON [dbo].[c_SalD] ([MChargeCC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC2] ON [dbo].[c_SalD] ([MChargeCC2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC] ON [dbo].[c_SalD] ([MoreCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC1] ON [dbo].[c_SalD] ([MoreCC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC2] ON [dbo].[c_SalD] ([MoreCC2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumAC] ON [dbo].[c_SalD] ([SumAC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CurrID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[KursCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[SickAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[HolidayAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[SurChargeAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MChargeCC2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[AdvanceAC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CreditIn]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[CreditOut]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[c_SalD].[MoreCC2]'
GO
