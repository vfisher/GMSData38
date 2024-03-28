CREATE TABLE [dbo].[r_EmpAdd]
(
[EmpID] [int] NOT NULL,
[BDate] [smalldatetime] NOT NULL,
[EDate] [smalldatetime] NOT NULL,
[RegRegion] [varchar] (200) NULL,
[RegDistrict] [varchar] (200) NULL,
[RegCity] [varchar] (200) NULL,
[RegStreet] [varchar] (200) NULL,
[RegHouse] [varchar] (200) NULL,
[RegBlock] [varchar] (200) NULL,
[RegAptNo] [varchar] (200) NULL,
[RegPostIndex] [varchar] (50) NULL,
[FactRegion] [varchar] (200) NULL,
[FactDistrict] [varchar] (200) NULL,
[FactCity] [varchar] (200) NULL,
[FactStreet] [varchar] (200) NULL,
[FactHouse] [varchar] (200) NULL,
[FactBlock] [varchar] (200) NULL,
[FactAptNo] [varchar] (200) NULL,
[FactPostIndex] [varchar] (50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_EmpAdd] ADD CONSTRAINT [_pk_r_EmpAdd] PRIMARY KEY CLUSTERED ([EmpID], [BDate], [EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BDate] ON [dbo].[r_EmpAdd] ([BDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EDate] ON [dbo].[r_EmpAdd] ([EDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_EmpAdd] ([EmpID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_EmpAdd].[EmpID]'
GO
