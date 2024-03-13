CREATE TABLE [dbo].[r_Persons]
(
[ChID] [bigint] NOT NULL,
[PersonID] [bigint] NOT NULL,
[PersonName] [varchar] (250) NOT NULL,
[BarCode] [varchar] (50) NULL,
[Birthday] [smalldatetime] NULL,
[Phone] [varchar] (20) NULL,
[EMail] [varchar] (200) NULL,
[Address] [varchar] (200) NULL,
[Preferences] [varchar] (2000) NULL,
[ReferalPersonID] [bigint] NULL,
[State] [int] NOT NULL,
[Picture] [image] NULL,
[Sex] [tinyint] NOT NULL DEFAULT ((0)),
[PhoneHome] [varchar] (250) NULL,
[PhoneWork] [varchar] (250) NULL,
[FactRegion] [varchar] (250) NULL,
[FactDistrict] [varchar] (250) NULL,
[FactCity] [varchar] (250) NULL,
[FactStreet] [varchar] (250) NULL,
[FactHouse] [varchar] (250) NULL,
[FactBlock] [varchar] (250) NULL,
[FactAptNo] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Persons] ADD CONSTRAINT [pk_r_Persons] PRIMARY KEY CLUSTERED ([PersonID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [BarCode] ON [dbo].[r_Persons] ([BarCode]) WHERE ([BarCode] IS NOT NULL AND [BarCode]<>'') ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Persons] ([ChID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [EMail] ON [dbo].[r_Persons] ([EMail]) WHERE ([EMail] IS NOT NULL AND [EMail]<>'') ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Phone] ON [dbo].[r_Persons] ([Phone]) WHERE ([Phone] IS NOT NULL AND [Phone]<>'') ON [PRIMARY]
GO
