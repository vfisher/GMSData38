CREATE TABLE [dbo].[r_Comps]
(
[ChID] [bigint] NOT NULL,
[CompID] [int] NOT NULL,
[CompName] [varchar] (200) NOT NULL,
[CompShort] [varchar] (200) NULL,
[Address] [varchar] (200) NULL,
[PostIndex] [varchar] (10) NULL,
[City] [varchar] (200) NOT NULL,
[Region] [varchar] (200) NULL,
[Code] [varchar] (20) NOT NULL,
[TaxRegNo] [varchar] (50) NOT NULL,
[TaxCode] [varchar] (20) NOT NULL,
[TaxPayer] [bit] NOT NULL,
[CompDesc] [varchar] (200) NULL,
[Contact] [varchar] (200) NULL,
[Phone1] [varchar] (50) NULL,
[Phone2] [varchar] (50) NULL,
[Phone3] [varchar] (50) NULL,
[Fax] [varchar] (20) NULL,
[EMail] [varchar] (200) NULL,
[HTTP] [varchar] (200) NULL,
[Notes] [varchar] (200) NULL,
[CodeID1] [smallint] NOT NULL,
[CodeID2] [smallint] NOT NULL,
[CodeID3] [smallint] NOT NULL,
[CodeID4] [smallint] NOT NULL,
[CodeID5] [smallint] NOT NULL,
[UseCodes] [bit] NULL,
[PLID] [int] NOT NULL,
[UsePL] [bit] NULL,
[Discount] [numeric] (21, 9) NOT NULL,
[UseDiscount] [bit] NULL,
[PayDelay] [smallint] NOT NULL,
[UsePayDelay] [bit] NULL,
[MaxCredit] [numeric] (21, 9) NULL,
[CalcMaxCredit] [bit] NULL,
[EmpID] [int] NOT NULL,
[Contract1] [varchar] (200) NULL,
[Contract2] [varchar] (200) NULL,
[Contract3] [varchar] (200) NULL,
[License1] [varchar] (200) NULL,
[License2] [varchar] (200) NULL,
[License3] [varchar] (200) NULL,
[Job1] [varchar] (200) NULL,
[Job2] [varchar] (200) NULL,
[Job3] [varchar] (200) NULL,
[TranPrc] [numeric] (21, 9) NOT NULL,
[MorePrc] [numeric] (21, 9) NOT NULL,
[FirstEventMode] [tinyint] NOT NULL,
[CompType] [smallint] NOT NULL,
[SysTaxType] [smallint] NOT NULL,
[FixTaxPercent] [numeric] (21, 9) NOT NULL,
[InStopList] [bit] NOT NULL,
[Value1] [numeric] (21, 9) NULL,
[Value2] [numeric] (21, 9) NULL,
[Value3] [numeric] (21, 9) NULL,
[PassNo] [varchar] (50) NULL,
[PassSer] [varchar] (50) NULL,
[PassDate] [smalldatetime] NULL,
[PassDept] [varchar] (200) NULL,
[CompGrID1] [int] NOT NULL DEFAULT (0),
[CompGrID2] [int] NOT NULL DEFAULT (0),
[CompGrID3] [int] NOT NULL DEFAULT (0),
[CompGrID4] [int] NOT NULL DEFAULT (0),
[CompGrID5] [int] NOT NULL DEFAULT (0),
[CompNameFull] [varchar] (250) NOT NULL,
[IsResident] [bit] NULL DEFAULT ((1)),
[ReasonRegCode] [varchar] (12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_Comps] ADD CONSTRAINT [pk_r_Comps] PRIMARY KEY CLUSTERED ([CompID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_Comps] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Code] ON [dbo].[r_Comps] ([Code]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID1] ON [dbo].[r_Comps] ([CodeID1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID2] ON [dbo].[r_Comps] ([CodeID2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID3] ON [dbo].[r_Comps] ([CodeID3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID4] ON [dbo].[r_Comps] ([CodeID4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CodeID5] ON [dbo].[r_Comps] ([CodeID5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReportPerf] ON [dbo].[r_Comps] ([CompID], [CompName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompName] ON [dbo].[r_Comps] ([CompName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NoDuplicates] ON [dbo].[r_Comps] ([CompName], [Code]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[r_Comps] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PLID] ON [dbo].[r_Comps] ([PLID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxCode] ON [dbo].[r_Comps] ([TaxCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TaxRegNo] ON [dbo].[r_Comps] ([TaxRegNo]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CompID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CodeID1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CodeID2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CodeID3]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CodeID4]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CodeID5]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[UseCodes]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[PLID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[UsePL]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[Discount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[UseDiscount]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[PayDelay]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[UsePayDelay]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[MaxCredit]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CalcMaxCredit]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[TranPrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[MorePrc]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[FirstEventMode]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[CompType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[SysTaxType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[FixTaxPercent]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[InStopList]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[Value1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[Value2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_Comps].[Value3]'
GO
