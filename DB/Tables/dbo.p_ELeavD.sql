CREATE TABLE [dbo].[p_ELeavD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[SubID] [smallint] NOT NULL,
[DepID] [smallint] NOT NULL,
[LeavType] [int] NOT NULL,
[AgeBDate] [smalldatetime] NOT NULL,
[AgeEDate] [smalldatetime] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[LeavDays] [smallint] NOT NULL,
[LeavAvrSalary] [numeric] (21, 9) NOT NULL,
[LeavSumCC] [numeric] (21, 9) NOT NULL,
[AChID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_ELeavD] ADD CONSTRAINT [_pk_p_ELeavD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[p_ELeavD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AgeBDate] ON [dbo].[p_ELeavD] ([AgeBDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AgeEDate] ON [dbo].[p_ELeavD] ([AgeEDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[p_ELeavD] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_ELeavD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DepID] ON [dbo].[p_ELeavD] ([DepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[p_ELeavD] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_ELeavD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SubID] ON [dbo].[p_ELeavD] ([SubID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[SubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[DepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[LeavType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[LeavDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[LeavAvrSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[LeavSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_ELeavD].[AChID]'
GO
