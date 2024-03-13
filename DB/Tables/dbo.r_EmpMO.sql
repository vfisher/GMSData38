CREATE TABLE [dbo].[r_EmpMO]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[Official] [bit] NOT NULL,
[BankID] [int] NOT NULL,
[CardAcc] [varchar] (200) NULL,
[CSalary] [numeric] (21, 9) NOT NULL,
[BOldSalary] [numeric] (21, 9) NOT NULL,
[BOldJoint] [bit] NOT NULL,
[InsurSenYears] [tinyint] NOT NULL,
[InsurSenMonths] [tinyint] NOT NULL,
[InsurSenDays] [smallint] NOT NULL,
[BOldAcceptDate] [smalldatetime] NULL,
[BOldDismissDate] [smalldatetime] NULL,
[BOldAlimonyPrc] [numeric] (21, 9) NOT NULL,
[BOldDepID] [smallint] NOT NULL,
[BOldJobDesc] [varchar] (200) NULL,
[BOldPersCat] [tinyint] NOT NULL,
[EmpState] [tinyint] NULL,
[HandCWTime] [bit] NOT NULL,
[IntEmpID] [varchar] (50) NOT NULL CONSTRAINT [DF__r_EmpMO__IntEmpI__0EF2D90D] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpMO] ADD CONSTRAINT [_pk_r_EmpMO] PRIMARY KEY CLUSTERED ([OurID], [EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BankID] ON [dbo].[r_EmpMO] ([BankID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BOldDepID] ON [dbo].[r_EmpMO] ([BOldDepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpMO] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OurID] ON [dbo].[r_EmpMO] ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueIndex] ON [dbo].[r_EmpMO] ([OurID], [IntEmpID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[Official]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[BankID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[CSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[BOldSalary]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[BOldJoint]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[InsurSenYears]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[InsurSenMonths]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[InsurSenDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[BOldAlimonyPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[BOldDepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[BOldPersCat]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[EmpState]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpMO].[HandCWTime]'
GO
