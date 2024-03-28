CREATE TABLE [dbo].[p_EGiv]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[WOrderID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[WorkAppDate] [smalldatetime] NOT NULL,
[KursMC] [numeric] (21, 9) NOT NULL,
[OurID] [int] NOT NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[EmpID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[EmpClass] [tinyint] NOT NULL,
[ShedID] [smallint] NOT NULL,
[WorkCond] [tinyint] NOT NULL,
[GEmpType] [tinyint] NOT NULL,
[ContractType] [tinyint] NOT NULL,
[ContrEDate] [smalldatetime] NULL,
[ContractFile] [varchar] (200) NULL,
[SubJob] [varchar] (200) NULL,
[TrialMonths] [numeric] (21, 9) NOT NULL,
[SalaryQty] [numeric] (21, 9) NULL,
[SalaryType] [tinyint] NOT NULL,
[SalaryForm] [tinyint] NOT NULL,
[SalaryMethod] [tinyint] NOT NULL,
[BSalary] [numeric] (21, 9) NOT NULL,
[BSalaryPrc] [numeric] (21, 9) NOT NULL,
[AdvSum] [numeric] (21, 9) NOT NULL,
[Joint] [bit] NOT NULL,
[TimeNormType] [tinyint] NOT NULL,
[PensMethod] [tinyint] NOT NULL CONSTRAINT [df_p_EGiv_PensMethod] DEFAULT (1),
[InsurSenYears] [tinyint] NOT NULL,
[InsurSenMonths] [tinyint] NOT NULL,
[InsurSenDays] [smallint] NOT NULL,
[BankID] [int] NOT NULL,
[CardAcc] [varchar] (200) NULL,
[HandCWTime] [bit] NOT NULL,
[StateCode] [int] NOT NULL DEFAULT (0),
[LeavDays] [smallint] NOT NULL DEFAULT (0),
[LeavDaysExtra] [smallint] NOT NULL DEFAULT (0),
[PensCatID] [tinyint] NOT NULL DEFAULT (1),
[DecreeEmpID] [int] NOT NULL DEFAULT (0),
[StrucPostID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EGiv] ADD CONSTRAINT [_pk_p_EGiv] PRIMARY KEY CLUSTERED ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[p_EGiv] ([BankID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[p_EGiv] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[p_EGiv] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[p_EGiv] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[p_EGiv] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[p_EGiv] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[p_EGiv] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_EGiv] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[p_EGiv] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_EGiv] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[p_EGiv] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[p_EGiv] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[p_EGiv] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_PostMCp_EGiv] ON [dbo].[p_EGiv] ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[p_EGiv] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_EGiv] ([SubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WOrderID] ON [dbo].[p_EGiv] ([WOrderID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[WOrderID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[WorkCond]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[GEmpType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[ContractType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[TrialMonths]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[SalaryQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[SalaryForm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[SalaryMethod]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[BSalaryPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[AdvSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[Joint]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[TimeNormType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[InsurSenYears]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[InsurSenMonths]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[InsurSenDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EGiv].[HandCWTime]'
GO
