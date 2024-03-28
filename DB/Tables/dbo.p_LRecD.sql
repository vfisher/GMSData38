CREATE TABLE [dbo].[p_LRecD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[DetSubID] [smallint] NOT NULL,
[DetDepID] [smallint] NOT NULL,
[AChID] [bigint] NOT NULL,
[MainSumCC] [numeric] (21, 9) NOT NULL,
[ExtraSumCC] [numeric] (21, 9) NOT NULL,
[MoreSumCC] [numeric] (21, 9) NOT NULL,
[NeglibleSumCC] [numeric] (21, 9) NOT NULL,
[DeductionSumCC] [numeric] (21, 9) NOT NULL,
[BTotPensCC] [numeric] (21, 9) NOT NULL,
[BTotUnEmployCC] [numeric] (21, 9) NOT NULL,
[BTotSocInsureCC] [numeric] (21, 9) NOT NULL,
[BTotAccidentCC] [numeric] (21, 9) NOT NULL,
[BIncomeTaxCC] [numeric] (21, 9) NOT NULL,
[BPensCC] [numeric] (21, 9) NOT NULL,
[BUnEmployCC] [numeric] (21, 9) NOT NULL,
[BSocInsureCC] [numeric] (21, 9) NOT NULL,
[BIndexing] [numeric] (21, 9) NOT NULL,
[BPrivIncomeTax] [int] NOT NULL,
[TotPensCC] [numeric] (21, 9) NOT NULL,
[TotUnEmployCC] [numeric] (21, 9) NOT NULL,
[TotSocInsureCC] [numeric] (21, 9) NOT NULL,
[TotAccidentCC] [numeric] (21, 9) NOT NULL,
[IncomeTaxCC] [numeric] (21, 9) NOT NULL,
[PensCC] [numeric] (21, 9) NOT NULL,
[UnEmployCC] [numeric] (21, 9) NOT NULL,
[SocInsureCC] [numeric] (21, 9) NOT NULL,
[ChargeSumCC] [numeric] (21, 9) NOT NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[CRateCC] [numeric] (21, 9) NOT NULL,
[TPensCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TUnEmployCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TSocInsureCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TIncomeTaxCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TTotPensCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TTotSocInsureCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TTotUnEmployCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TTotAccidentCCCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocChargeСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TUniSocChargeССCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TUniSocDedССCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[BUniSocChargeСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[BUniSocDedСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[MilitaryTaxCC] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[TMilitaryTaxCCCor] [numeric] (21, 9) NOT NULL DEFAULT ((0)),
[BMilitaryTaxCC] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LRecD] ADD CONSTRAINT [_pk_p_LRecD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AChID] ON [dbo].[p_LRecD] ([AChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[p_LRecD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetDepID] ON [dbo].[p_LRecD] ([DetDepID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DetSubID] ON [dbo].[p_LRecD] ([DetSubID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[p_LRecD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[p_LRecD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[p_LRecD] ([SrcPosID]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[DetSubID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[DetDepID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[AChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[MainSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[ExtraSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[MoreSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[NeglibleSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[DeductionSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BTotPensCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BTotUnEmployCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BTotSocInsureCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BTotAccidentCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BIncomeTaxCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BPensCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BUnEmployCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BSocInsureCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BIndexing]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[BPrivIncomeTax]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[TotPensCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[TotUnEmployCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[TotSocInsureCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[TotAccidentCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[IncomeTaxCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[PensCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[UnEmployCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[SocInsureCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[ChargeSumCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[p_LRecD].[GTranID]'
GO
