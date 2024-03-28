CREATE TABLE [dbo].[r_PayTypes]
(
[ChID] [bigint] NOT NULL,
[PayTypeID] [smallint] NOT NULL,
[PayTypeCatID] [smallint] NOT NULL,
[PayTypeName] [varchar] (200) NOT NULL,
[Notes] [varchar] (200) NULL,
[UseTotPensFund] [bit] NOT NULL,
[UseTotUnEmploy] [bit] NOT NULL,
[UseTotSocInsure] [bit] NOT NULL,
[UseTotAccident] [bit] NOT NULL,
[UseIncomeTax] [bit] NOT NULL,
[UsePensFund] [bit] NOT NULL,
[UseUnEmploy] [bit] NOT NULL,
[UseSocInsure] [bit] NOT NULL,
[GrossOutlay] [bit] NOT NULL,
[UseToIndexing] [bit] NOT NULL,
[UsePrivIncomeTax] [bit] NOT NULL,
[FundType] [tinyint] NOT NULL,
[UseInSick] [bit] NOT NULL,
[UseInLeav] [bit] NOT NULL,
[UseInTrn] [bit] NOT NULL,
[SrcDocTypeR] [varchar] (255) NULL,
[SrcDocTypeE] [varchar] (255) NULL,
[DocDateFieldR] [varchar] (255) NULL,
[DocDateFieldE] [varchar] (255) NULL,
[SrcDocFilterR] [varchar] (255) NULL,
[SrcDocFilterE] [varchar] (255) NULL,
[SrcDocExpR] [varchar] (255) NULL,
[SrcDocExpE] [varchar] (255) NULL,
[IsDeduction] [bit] NOT NULL,
[UseInDisPay] [bit] NOT NULL DEFAULT (0),
[UseInMainSalaryType] [bit] NOT NULL DEFAULT (0),
[UseInAdvanceSalaryType] [bit] NOT NULL DEFAULT (0),
[UseInLeavSalaryType] [bit] NOT NULL DEFAULT (0),
[UseInPregSick] [bit] NOT NULL DEFAULT (0),
[UniSocChargeRateExpR] [varchar] (250) NOT NULL DEFAULT ('0'),
[UniSocChargeRateExpE] [varchar] (250) NOT NULL DEFAULT ('0'),
[UniSocDedRateExpR] [varchar] (250) NOT NULL DEFAULT ('0'),
[UniSocDedRateExpE] [varchar] (250) NOT NULL DEFAULT ('0'),
[UniSocPriority] [int] NOT NULL DEFAULT (0),
[BIncomeTaxExpE] [varchar] (250) NOT NULL DEFAULT (''),
[BIncomeTaxExpR] [varchar] (250) NOT NULL DEFAULT (''),
[UseMilitaryTax] [bit] NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[r_PayTypes] ADD CONSTRAINT [pk_r_PayTypes] PRIMARY KEY CLUSTERED ([PayTypeID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ChID] ON [dbo].[r_PayTypes] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PayTypeCatID] ON [dbo].[r_PayTypes] ([PayTypeCatID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PayTypeName] ON [dbo].[r_PayTypes] ([PayTypeName]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[PayTypeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[PayTypeCatID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseTotPensFund]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseTotUnEmploy]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseTotSocInsure]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseTotAccident]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseIncomeTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UsePensFund]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseUnEmploy]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseSocInsure]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[GrossOutlay]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseToIndexing]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UsePrivIncomeTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[FundType]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseInSick]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseInLeav]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[UseInTrn]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[r_PayTypes].[IsDeduction]'
GO
