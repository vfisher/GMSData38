CREATE TABLE [dbo].[b_LRecD]
(
[ChID] [bigint] NOT NULL,
[SrcPosID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[ChargeCC] [numeric] (21, 9) NOT NULL,
[SickCC] [numeric] (21, 9) NOT NULL,
[InsureCC] [numeric] (21, 9) NOT NULL,
[LeaveCC] [numeric] (21, 9) NOT NULL,
[NLeaveCC] [numeric] (21, 9) NOT NULL,
[MHelpCC] [numeric] (21, 9) NOT NULL,
[PregCC] [numeric] (21, 9) NOT NULL,
[MChargeCC] [numeric] (21, 9) NULL,
[MChargeCC1] [numeric] (21, 9) NULL,
[MChargeCC2] [numeric] (21, 9) NULL,
[AdvanceCC] [numeric] (21, 9) NOT NULL,
[AlimonyCC] [numeric] (21, 9) NOT NULL,
[PensionTaxCC] [numeric] (21, 9) NOT NULL,
[IncomeTaxCC] [numeric] (21, 9) NOT NULL,
[InsureTaxCC] [numeric] (21, 9) NOT NULL,
[UnionCC] [numeric] (21, 9) NOT NULL,
[CRateCC] [numeric] (21, 9) NOT NULL,
[LoanCC] [numeric] (21, 9) NOT NULL,
[EmpTaxCC] [numeric] (21, 9) NOT NULL,
[WorkDays] [tinyint] NOT NULL,
[SickDays] [tinyint] NOT NULL,
[MoreCC] [numeric] (21, 9) NULL,
[MoreCC1] [numeric] (21, 9) NULL,
[MoreCC2] [numeric] (21, 9) NULL,
[GOperID] [int] NOT NULL,
[GTranID] [int] NOT NULL,
[TUniSocDedСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[TUniSocChargeСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocChargeСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedContractsCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocChargeContractsСС] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocDedSickCC] [numeric] (21, 9) NOT NULL DEFAULT (0),
[UniSocChargeSickСС] [numeric] (21, 9) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[b_LRecD] ADD CONSTRAINT [_pk_b_LRecD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AdvanceCC] ON [dbo].[b_LRecD] ([AdvanceCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AlimonyCC] ON [dbo].[b_LRecD] ([AlimonyCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChargeCC] ON [dbo].[b_LRecD] ([ChargeCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ChID] ON [dbo].[b_LRecD] ([ChID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [EmpID] ON [dbo].[b_LRecD] ([EmpID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GOperID] ON [dbo].[b_LRecD] ([GOperID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IncomeTaxCC] ON [dbo].[b_LRecD] ([IncomeTaxCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [InsureCC] ON [dbo].[b_LRecD] ([InsureCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [InsureTaxCC] ON [dbo].[b_LRecD] ([InsureTaxCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LeaveCC] ON [dbo].[b_LRecD] ([LeaveCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC] ON [dbo].[b_LRecD] ([MChargeCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC1] ON [dbo].[b_LRecD] ([MChargeCC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MChargeCC2] ON [dbo].[b_LRecD] ([MChargeCC2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MHelpCC] ON [dbo].[b_LRecD] ([MHelpCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC] ON [dbo].[b_LRecD] ([MoreCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC1] ON [dbo].[b_LRecD] ([MoreCC1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MoreCC2] ON [dbo].[b_LRecD] ([MoreCC2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NLeaveCC] ON [dbo].[b_LRecD] ([NLeaveCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PensionTaxCC] ON [dbo].[b_LRecD] ([PensionTaxCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SickCC] ON [dbo].[b_LRecD] ([SickCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SickDays] ON [dbo].[b_LRecD] ([SickDays]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SrcPosID] ON [dbo].[b_LRecD] ([SrcPosID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WorkDays] ON [dbo].[b_LRecD] ([WorkDays]) ON [PRIMARY]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[ChID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[SrcPosID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[EmpID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[ChargeCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[SickCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[InsureCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[LeaveCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[NLeaveCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MHelpCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[PregCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MChargeCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MChargeCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MChargeCC2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[AdvanceCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[AlimonyCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[PensionTaxCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[IncomeTaxCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[InsureTaxCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[UnionCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[CRateCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[LoanCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[EmpTaxCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[WorkDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[SickDays]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MoreCC]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MoreCC1]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[MoreCC2]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[GOperID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[b_LRecD].[GTranID]'
GO
