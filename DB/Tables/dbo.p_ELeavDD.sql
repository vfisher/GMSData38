CREATE TABLE [dbo].[p_ELeavDD]
(
[AChID] [bigint] NOT NULL,
[SrcDate] [smalldatetime] NOT NULL,
[DaysNorm] [numeric] (21, 9) NOT NULL,
[DaysFact] [numeric] (21, 9) NOT NULL,
[FactSalary] [numeric] (21, 9) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ELeavDD] ADD CONSTRAINT [_pk_p_ELeavDD] PRIMARY KEY CLUSTERED ([AChID], [SrcDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AChID] ON [dbo].[p_ELeavDD] ([AChID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavDD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavDD].[DaysNorm]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavDD].[DaysFact]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavDD].[FactSalary]'
GO
