CREATE TABLE [dbo].[r_Ours]
(
[ChID] [bigint] NOT NULL,
[OurID] [int] NOT NULL,
[OurName] [varchar] (200) NOT NULL,
[Address] [varchar] (200) NOT NULL,
[PostIndex] [varchar] (10) NOT NULL,
[City] [varchar] (200) NOT NULL,
[Region] [varchar] (200) NOT NULL,
[Code] [varchar] (20) NOT NULL,
[TaxRegNo] [varchar] (50) NOT NULL,
[TaxCode] [varchar] (20) NOT NULL,
[OurDesc] [varchar] (200) NULL,
[Phone] [varchar] (20) NULL,
[Fax] [varchar] (20) NULL,
[OurShort] [varchar] (200) NOT NULL,
[Note1] [varchar] (200) NULL,
[Note2] [varchar] (200) NULL,
[Note3] [varchar] (200) NULL,
[Job1] [varchar] (200) NULL,
[Job2] [varchar] (200) NULL,
[Job3] [varchar] (200) NULL,
[DayBTime] [smalldatetime] NULL,
[DayETime] [smalldatetime] NULL,
[EvenBTime] [smalldatetime] NULL,
[EvenETime] [smalldatetime] NULL,
[EvenPayFac] [numeric] (21, 9) NOT NULL,
[NightBTime] [smalldatetime] NULL,
[NightETime] [smalldatetime] NULL,
[NightPayFac] [numeric] (21, 9) NOT NULL,
[OverPayFactor] [numeric] (21, 9) NOT NULL,
[ActType] [varchar] (200) NULL,
[FinForm] [varchar] (200) NULL,
[PropForm] [varchar] (200) NULL,
[EcActType] [varchar] (200) NULL,
[PensFundID] [varchar] (200) NULL,
[SocInsFundID] [varchar] (200) NULL,
[SocUnEFundID] [varchar] (200) NULL,
[SocAddFundID] [varchar] (200) NULL,
[MinExcPowerID] [varchar] (200) NULL,
[TaxNotes] [varchar] (200) NULL,
[TaxOKPO] [varchar] (20) NULL,
[ActTypeCVED] [varchar] (200) NULL,
[TerritoryID] [varchar] (200) NULL,
[ExcComRegNum] [varchar] (200) NULL,
[SysTaxType] [smallint] NOT NULL,
[FixTaxPercent] [numeric] (21, 9) NOT NULL,
[TaxPayer] [bit] NOT NULL,
[OurNameFull] [varchar] (250) NOT NULL,
[IsResident] [bit] NULL DEFAULT ((1)),
[CROurName] [varchar] (250) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Ours] ADD CONSTRAINT [pk_r_Ours] PRIMARY KEY CLUSTERED ([OurID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Ours] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Code] ON [dbo].[r_Ours] ([Code]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [OurName] ON [dbo].[r_Ours] ([OurName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxCode] ON [dbo].[r_Ours] ([TaxCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxOKPO] ON [dbo].[r_Ours] ([TaxOKPO]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxRegNo] ON [dbo].[r_Ours] ([TaxRegNo]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[OurID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[EvenPayFac]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[NightPayFac]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[OverPayFactor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[SysTaxType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Ours].[FixTaxPercent]'
GO
