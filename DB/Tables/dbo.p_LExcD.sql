CREATE TABLE [dbo].[p_LExcD]
(
[ChID] [bigint] NOT NULL,
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
[PensMethod] [tinyint] NOT NULL CONSTRAINT [df_p_LExcD_PensMethod] DEFAULT (1),
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
ALTER TABLE [dbo].[p_LExcD] ADD CONSTRAINT [_pk_p_LExcD] PRIMARY KEY CLUSTERED ([ChID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_LExcD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LExcD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_LExcD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [r_PostMCp_LExcD] ON [dbo].[p_LExcD] ([PostID], [EmpClass]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ShedID] ON [dbo].[p_LExcD] ([ShedID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_LExcD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[PostID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[EmpClass]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[ShedID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[WorkCond]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[SalaryQty]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[SalaryType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[SalaryForm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[SalaryMethod]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[BSalaryPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExcD].[TimeNormType]'
GO
