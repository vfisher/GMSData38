CREATE TABLE [dbo].[r_EmpMPst]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[PostID] [int] NOT NULL,
[EmpClass] [tinyint] NOT NULL,
[WorkCond] [tinyint] NOT NULL,
[ShedID] [smallint] NOT NULL,
[SalaryType] [tinyint] NOT NULL,
[SalaryForm] [tinyint] NOT NULL,
[SalaryMethod] [tinyint] NOT NULL,
[BSalary] [numeric] (21, 9) NOT NULL,
[BSalaryPrc] [numeric] (21, 9) NOT NULL,
[AdvSum] [numeric] (21, 9) NOT NULL,
[PensMethod] [tinyint] NOT NULL CONSTRAINT [df_r_EmpMPSt_PensMethod] DEFAULT (1),
[SalaryQty] [numeric] (21, 9) NULL,
[Joint] [bit] NOT NULL,
[Notes] [varchar] (200) NULL,
[IsDisDoc] [bit] NOT NULL,
[IsGivDoc] [bit] NOT NULL,
[TimeNormType] [tinyint] NOT NULL,
[IndexBaseMonth] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL DEFAULT (0),
[LeavDaysExtra] [smallint] NOT NULL DEFAULT (0),
[PensCatID] [tinyint] NOT NULL DEFAULT (1),
[IndexExtSumCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[GEmpType] [tinyint] NOT NULL DEFAULT ((0)),
[StrucPostID] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpMPst] ADD CONSTRAINT [_pk_r_EmpMPst] PRIMARY KEY CLUSTERED ([OurID], [EmpID], [BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpMPst] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[r_EmpMPst] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpMPst] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_EmpMOr_EmpMPst] ON [dbo].[r_EmpMPst] ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_PostMCr_EmpMPst] ON [dbo].[r_EmpMPst] ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[r_EmpMPst] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[r_EmpMPst] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[WorkCond]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryForm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryMethod]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[BSalaryPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[AdvSum]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[SalaryQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[Joint]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[IsDisDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[IsGivDoc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMPst].[TimeNormType]'
GO
