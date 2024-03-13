CREATE TABLE [dbo].[p_ESicD]
(
[ChID] [bigint] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[DaysNorm] [numeric] (21, 9) NOT NULL,
[DaysFact] [numeric] (21, 9) NOT NULL,
[HoursFact] [numeric] (21, 9) NOT NULL,
[FactSalary] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ESicD] ADD CONSTRAINT [_pk_p_ESicD] PRIMARY KEY CLUSTERED ([ChID], [SrcDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_ESicD] ([ChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicD].[DaysNorm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicD].[DaysFact]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicD].[HoursFact]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ESicD].[FactSalary]'
GO
