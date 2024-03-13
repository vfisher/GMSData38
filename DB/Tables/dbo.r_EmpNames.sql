CREATE TABLE [dbo].[r_EmpNames]
(
[OurID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[ChDate] [smalldatetime] NOT NULL,
[EmpName] [varchar] (200) NOT NULL,
[EmpInitials] [varchar] (200) NOT NULL,
[EmpLastName] [varchar] (200) NOT NULL,
[EmpFirstName] [varchar] (200) NOT NULL,
[EmpParName] [varchar] (200) NOT NULL,
[UAEmpName] [varchar] (200) NOT NULL,
[UAEmpLastName] [varchar] (200) NOT NULL,
[UAEmpFirstName] [varchar] (200) NOT NULL,
[UAEmpParName] [varchar] (200) NOT NULL,
[UAEmpInitials] [varchar] (200) NOT NULL,
[PassSer] [varchar] (250) NULL,
[PassNo] [varchar] (250) NULL,
[PassDate] [smalldatetime] NULL,
[PassDept] [varchar] (250) NULL,
[TaxCode] [varchar] (250) NULL,
[Notes] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpNames] ADD CONSTRAINT [pk_r_EmpNames] PRIMARY KEY CLUSTERED ([EmpID], [OurID], [ChDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Notes] ON [dbo].[r_EmpNames] ([Notes]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxCode] ON [dbo].[r_EmpNames] ([TaxCode]) ON [PRIMARY]
GO
