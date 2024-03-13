CREATE TABLE [dbo].[p_CWTimeDD]
(
[AChID] [bigint] NOT NULL,
[DayPosID] [smallint] NOT NULL,
[WorkHours] [numeric] (21, 9) NULL,
[WTSignID] [tinyint] NOT NULL,
[EveningHours] [numeric] (21, 9) NOT NULL,
[NightHours] [numeric] (21, 9) NOT NULL,
[DayShiftCount] [tinyint] NOT NULL,
[DayPayFactor] [numeric] (21, 9) NOT NULL,
[OverTime] [numeric] (21, 9) NOT NULL,
[OverPayFactor] [numeric] (21, 9) NOT NULL,
[DaySaleSumCC] [numeric] (21, 9) NOT NULL,
[EvenSaleSumCC] [numeric] (21, 9) NOT NULL,
[NightSaleSumCC] [numeric] (21, 9) NOT NULL,
[OverSaleSumCC] [numeric] (21, 9) NOT NULL,
[OneHourSumCC] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_CWTimeDD] ADD CONSTRAINT [_pk_p_CWTimeDD] PRIMARY KEY CLUSTERED ([AChID], [DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[p_CWTimeDD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DayPosID] ON [dbo].[p_CWTimeDD] ([DayPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WTSignID] ON [dbo].[p_CWTimeDD] ([WTSignID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[WorkHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[WTSignID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[EveningHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[NightHours]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayShiftCount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DayPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverTime]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[DaySaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[EvenSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[NightSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OverSaleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_CWTimeDD].[OneHourSumCC]'
GO
