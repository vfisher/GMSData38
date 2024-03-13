CREATE TABLE [dbo].[r_Emps]
(
[ChID] [bigint] NOT NULL,
[EmpID] [int] NOT NULL,
[EmpName] [varchar] (200) NOT NULL,
[UAEmpName] [varchar] (200) NOT NULL,
[EmpLastName] [varchar] (200) NULL,
[EmpFirstName] [varchar] (200) NULL,
[EmpParName] [varchar] (200) NULL,
[UAEmpLastName] [varchar] (200) NULL,
[UAEmpFirstName] [varchar] (200) NULL,
[UAEmpParName] [varchar] (200) NULL,
[EmpInitials] [varchar] (200) NULL,
[UAEmpInitials] [varchar] (200) NULL,
[TaxCode] [varchar] (50) NULL,
[EmpSex] [tinyint] NOT NULL,
[BirthDay] [smalldatetime] NULL,
[File1] [varchar] (200) NULL,
[File2] [varchar] (200) NULL,
[File3] [varchar] (200) NULL,
[Education] [smallint] NULL,
[FamilyStatus] [smallint] NULL,
[BirthPlace] [varchar] (200) NULL,
[Phone] [varchar] (20) NULL,
[InPhone] [varchar] (20) NULL,
[Mobile] [varchar] (200) NULL,
[EMail] [varchar] (200) NULL,
[Percent1] [numeric] (21, 9) NOT NULL,
[Percent2] [numeric] (21, 9) NOT NULL,
[Percent3] [numeric] (21, 9) NOT NULL,
[Notes] [varchar] (200) NULL,
[MilStatus] [smallint] NULL,
[MilFitness] [smallint] NULL,
[MilRank] [varchar] (200) NULL,
[MilSpecialCalc] [varchar] (200) NULL,
[MilProfes] [varchar] (200) NULL,
[MilCalcGrp] [varchar] (200) NULL,
[MilCalcCat] [varchar] (200) NULL,
[MilStaff] [varchar] (200) NULL,
[MilRegOffice] [varchar] (200) NULL,
[MilNum] [varchar] (20) NULL,
[PassNo] [varchar] (50) NULL,
[PassSer] [varchar] (50) NULL,
[PassDate] [smalldatetime] NULL,
[PassDept] [varchar] (200) NULL,
[DisNum] [varchar] (20) NULL,
[PensNum] [varchar] (20) NULL,
[WorkBookNo] [varchar] (50) NULL,
[WorkBookSer] [varchar] (50) NULL,
[PerFileNo] [varchar] (50) NULL,
[InStopList] [bit] NOT NULL,
[BarCode] [varchar] (250) NULL,
[ShiftPostID] [int] NOT NULL DEFAULT (0),
[IsCitizen] [bit] NOT NULL DEFAULT (1),
[CertInsurSer] [varchar] (250) NULL,
[CertInsurNum] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Emps] ADD CONSTRAINT [pk_r_Emps] PRIMARY KEY CLUSTERED ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CertInsurNum] ON [dbo].[r_Emps] ([CertInsurNum]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CertInsurSer] ON [dbo].[r_Emps] ([CertInsurSer]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Emps] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [EmpName] ON [dbo].[r_Emps] ([EmpName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[EmpSex]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Education]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[FamilyStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[Percent3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[MilStatus]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[MilFitness]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Emps].[InStopList]'
GO
