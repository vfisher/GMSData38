CREATE TABLE [dbo].[r_EmpAct]
(
[EmpID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[PrvPlEmp] [varchar] (200) NOT NULL,
[DisReasonText] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpAct] ADD CONSTRAINT [_pk_r_EmpAct] PRIMARY KEY CLUSTERED ([EmpID], [BDate], [EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpAct] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpAct] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpAct] ([EmpID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAct].[EmpID]'
GO
