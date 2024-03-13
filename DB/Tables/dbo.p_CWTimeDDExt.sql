CREATE TABLE [dbo].[p_CWTimeDDExt]
(
[AChID] [bigint] NOT NULL,
[ShedID] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[p_CWTimeDDExt] ADD CONSTRAINT [pk_p_CWTimeDDExt] PRIMARY KEY CLUSTERED ([AChID], [ShedID], [DayPosID]) ON [PRIMARY]
GO
