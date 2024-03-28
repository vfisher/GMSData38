CREATE TABLE [dbo].[p_LRecDCorCR]
(
[AChID] [bigint] NOT NULL,
[YearID] [smallint] NOT NULL,
[MonthID] [smallint] NOT NULL,
[PensCCCor] [numeric] (21, 9) NOT NULL,
[UnEmployCCCor] [numeric] (21, 9) NOT NULL,
[SocInsureCCCor] [numeric] (21, 9) NOT NULL,
[IncomeTaxCCCor] [numeric] (21, 9) NOT NULL,
[TotPensCCCor] [numeric] (21, 9) NOT NULL,
[TotSocInsureCCCor] [numeric] (21, 9) NOT NULL,
[TotUnEmployCCCor] [numeric] (21, 9) NOT NULL,
[TotAccidentCCCor] [numeric] (21, 9) NOT NULL,
[UniSocChargeССCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedССCor] [numeric] (21, 9) NOT NULL DEFAULT (0),
[DetSrcPosID] [int] NOT NULL CONSTRAINT [DF__p_LRecDCo__DetSr__1BE2BFD7] DEFAULT (0),
[Notes] [varchar] (250) NULL,
[MilitaryTaxCCCor] [numeric] (21, 9) NOT NULL DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_LRecDCorCR] ADD CONSTRAINT [pk_p_LRecDCorCR] PRIMARY KEY CLUSTERED ([AChID], [DetSrcPosID]) ON [PRIMARY]
GO
