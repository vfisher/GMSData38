CREATE TABLE [dbo].[r_NormMH]
(
[YearID] [smallint] NOT NULL,
[MonthID] [smallint] NOT NULL,
[WWeekTypeID] [tinyint] NOT NULL,
[DaysNorm] [numeric] (21, 9) NULL,
[HoursNorm] [numeric] (21, 9) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_NormMH] ADD PRIMARY KEY CLUSTERED ([YearID], [MonthID], [WWeekTypeID]) ON [PRIMARY]
GO
