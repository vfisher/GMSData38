CREATE TABLE [dbo].[p_LExpD]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[LArrSumCC] [numeric] (21, 9) NOT NULL,
[LRecSumCC] [numeric] (21, 9) NOT NULL,
[LExpSumCC] [numeric] (21, 9) NOT NULL,
[LDepSumCC] [numeric] (21, 9) NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LExpD] ADD CONSTRAINT [_pk_p_LExpD] PRIMARY KEY CLUSTERED ([ChID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_LExpD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_LExpD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_LExpD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[p_LExpD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LExpSumCC] ON [dbo].[p_LExpD] ([LExpSumCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LRecSumCC] ON [dbo].[p_LExpD] ([LRecSumCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_LExpD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[LArrSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[LRecSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[LExpSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[LDepSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LExpD].[GTranID]'
GO
