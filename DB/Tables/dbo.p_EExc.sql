CREATE TABLE [dbo].[p_EExc]
(
[ChID] [bigint] NOT NULL,
[DocID] [bigint] NOT NULL,
[IntDocID] [varchar] (50) NULL,
[WOrderID] [int] NOT NULL,
[DocDate] [smalldatetime] NOT NULL,
[ExcDate] [smalldatetime] NOT NULL,
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
[SubJob] [varchar] (200) NULL,
[SalaryQty] [numeric] (21, 9) NULL,
[SalaryType] [tinyint] NOT NULL,
[SalaryForm] [tinyint] NOT NULL,
[SalaryMethod] [tinyint] NOT NULL,
[BSalary] [numeric] (21, 9) NOT NULL,
[BSalaryPrc] [numeric] (21, 9) NOT NULL,
[TimeNormType] [tinyint] NOT NULL,
[PensMethod] [tinyint] NOT NULL CONSTRAINT [df_p_EExc_PensMethod] DEFAULT (1),
[StateCode] [int] NOT NULL DEFAULT (0),
[IndexBaseMonth] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL DEFAULT (0),
[LeavDaysExtra] [smallint] NOT NULL DEFAULT (0),
[PensCatID] [tinyint] NOT NULL DEFAULT (1),
[Joint] [bit] NOT NULL DEFAULT (0),
[GEmpType] [tinyint] NOT NULL DEFAULT (0),
[ContractType] [tinyint] NOT NULL DEFAULT (0),
[ContractFile] [varchar] (250) NULL,
[ContrEDate] [smalldatetime] NULL,
[DecreeEmpID] [int] NOT NULL DEFAULT (0),
[StrucPostID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_EExc] ADD CONSTRAINT [_pk_p_EExc] PRIMARY KEY CLUSTERED ([DocID], [OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[p_EExc] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[p_EExc] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[p_EExc] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[p_EExc] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[p_EExc] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[p_EExc] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_EExc] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocID] ON [dbo].[p_EExc] ([DocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_EExc] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ExcDate] ON [dbo].[p_EExc] ([ExcDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntDocID] ON [dbo].[p_EExc] ([IntDocID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [KursMC] ON [dbo].[p_EExc] ([KursMC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[p_EExc] ([OurID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_PostMCp_EExc] ON [dbo].[p_EExc] ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[p_EExc] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_EExc] ([SubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WOrderID] ON [dbo].[p_EExc] ([WOrderID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[DocID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[WOrderID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[KursMC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[WorkCond]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[SalaryQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[SalaryForm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[SalaryMethod]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[BSalaryPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_EExc].[TimeNormType]'
GO
