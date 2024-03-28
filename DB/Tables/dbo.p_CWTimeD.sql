CREATE TABLE [dbo].[p_CWTimeD]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[AChID] [bigint] NOT NULL,
[BSalary] [numeric] (21, 9) NOT NULL,
[BLeaveDaysCount] [numeric] (21, 9) NOT NULL,
[PLeaveDaysCount] [numeric] (21, 9) NOT NULL,
[SickDaysCount] [numeric] (21, 9) NOT NULL,
[TruanDaysCount] [numeric] (21, 9) NOT NULL,
[NonAppDaysCount] [numeric] (21, 9) NOT NULL,
[HolDaysCount] [numeric] (21, 9) NOT NULL,
[TWorkHours] [numeric] (21, 9) NOT NULL,
[TWorkDays] [numeric] (21, 9) NOT NULL,
[ChargeCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CWTimeD] ADD CONSTRAINT [_pk_p_CWTimeD] PRIMARY KEY CLUSTERED ([ChID], [EmpID], [SubID], [DepID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[p_CWTimeD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_CWTimeD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_CWTimeD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_CWTimeD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_CWTimeD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[BSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[BLeaveDaysCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[PLeaveDaysCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[SickDaysCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[TruanDaysCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[NonAppDaysCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[HolDaysCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[TWorkHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[TWorkDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeD].[ChargeCC]'
GO
