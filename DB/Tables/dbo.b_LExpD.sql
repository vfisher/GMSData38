CREATE TABLE [dbo].[b_LExpD]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[SumCC] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_LExpD] ADD CONSTRAINT [_pk_b_LExpD] PRIMARY KEY CLUSTERED ([ChID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_LExpD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_LExpD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_LExpD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SumCC] ON [dbo].[b_LExpD] ([SumCC]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LExpD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LExpD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LExpD].[SumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LExpD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LExpD].[GTranID]'
GO
