CREATE TABLE [dbo].[b_LRecD] (
  [ChID] [bigint] NOT NULL,
  [SrcPosID] [int] NOT NULL,
  [EmpID] [int] NOT NULL,
  [ChargeCC] [numeric](21, 9) NOT NULL,
  [SickCC] [numeric](21, 9) NOT NULL,
  [InsureCC] [numeric](21, 9) NOT NULL,
  [LeaveCC] [numeric](21, 9) NOT NULL,
  [NLeaveCC] [numeric](21, 9) NOT NULL,
  [MHelpCC] [numeric](21, 9) NOT NULL,
  [PregCC] [numeric](21, 9) NOT NULL,
  [MChargeCC] [numeric](21, 9) NULL,
  [MChargeCC1] [numeric](21, 9) NULL,
  [MChargeCC2] [numeric](21, 9) NULL,
  [AdvanceCC] [numeric](21, 9) NOT NULL,
  [AlimonyCC] [numeric](21, 9) NOT NULL,
  [PensionTaxCC] [numeric](21, 9) NOT NULL,
  [IncomeTaxCC] [numeric](21, 9) NOT NULL,
  [InsureTaxCC] [numeric](21, 9) NOT NULL,
  [UnionCC] [numeric](21, 9) NOT NULL,
  [CRateCC] [numeric](21, 9) NOT NULL,
  [LoanCC] [numeric](21, 9) NOT NULL,
  [EmpTaxCC] [numeric](21, 9) NOT NULL,
  [WorkDays] [tinyint] NOT NULL,
  [SickDays] [tinyint] NOT NULL,
  [MoreCC] [numeric](21, 9) NULL,
  [MoreCC1] [numeric](21, 9) NULL,
  [MoreCC2] [numeric](21, 9) NULL,
  [GOperID] [int] NOT NULL,
  [GTranID] [int] NOT NULL,
  [TUniSocDedСС] [numeric](21, 9) NOT NULL DEFAULT (0),
  [TUniSocChargeСС] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocDedСС] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocChargeСС] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocDedContractsCC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocChargeContractsСС] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocDedSickCC] [numeric](21, 9) NOT NULL DEFAULT (0),
  [UniSocChargeSickСС] [numeric](21, 9) NOT NULL DEFAULT (0),
  CONSTRAINT [_pk_b_LRecD] PRIMARY KEY CLUSTERED ([ChID], [SrcPosID])
)
ON [PRIMARY]
GO

CREATE INDEX [AdvanceCC]
  ON [dbo].[b_LRecD] ([AdvanceCC])
  ON [PRIMARY]
GO

CREATE INDEX [AlimonyCC]
  ON [dbo].[b_LRecD] ([AlimonyCC])
  ON [PRIMARY]
GO

CREATE INDEX [ChargeCC]
  ON [dbo].[b_LRecD] ([ChargeCC])
  ON [PRIMARY]
GO

CREATE INDEX [ChID]
  ON [dbo].[b_LRecD] ([ChID])
  ON [PRIMARY]
GO

CREATE INDEX [EmpID]
  ON [dbo].[b_LRecD] ([EmpID])
  ON [PRIMARY]
GO

CREATE INDEX [GOperID]
  ON [dbo].[b_LRecD] ([GOperID])
  ON [PRIMARY]
GO

CREATE INDEX [IncomeTaxCC]
  ON [dbo].[b_LRecD] ([IncomeTaxCC])
  ON [PRIMARY]
GO

CREATE INDEX [InsureCC]
  ON [dbo].[b_LRecD] ([InsureCC])
  ON [PRIMARY]
GO

CREATE INDEX [InsureTaxCC]
  ON [dbo].[b_LRecD] ([InsureTaxCC])
  ON [PRIMARY]
GO

CREATE INDEX [LeaveCC]
  ON [dbo].[b_LRecD] ([LeaveCC])
  ON [PRIMARY]
GO

CREATE INDEX [MChargeCC]
  ON [dbo].[b_LRecD] ([MChargeCC])
  ON [PRIMARY]
GO

CREATE INDEX [MChargeCC1]
  ON [dbo].[b_LRecD] ([MChargeCC1])
  ON [PRIMARY]
GO

CREATE INDEX [MChargeCC2]
  ON [dbo].[b_LRecD] ([MChargeCC2])
  ON [PRIMARY]
GO

CREATE INDEX [MHelpCC]
  ON [dbo].[b_LRecD] ([MHelpCC])
  ON [PRIMARY]
GO

CREATE INDEX [MoreCC]
  ON [dbo].[b_LRecD] ([MoreCC])
  ON [PRIMARY]
GO

CREATE INDEX [MoreCC1]
  ON [dbo].[b_LRecD] ([MoreCC1])
  ON [PRIMARY]
GO

CREATE INDEX [MoreCC2]
  ON [dbo].[b_LRecD] ([MoreCC2])
  ON [PRIMARY]
GO

CREATE INDEX [NLeaveCC]
  ON [dbo].[b_LRecD] ([NLeaveCC])
  ON [PRIMARY]
GO

CREATE INDEX [PensionTaxCC]
  ON [dbo].[b_LRecD] ([PensionTaxCC])
  ON [PRIMARY]
GO

CREATE INDEX [SickCC]
  ON [dbo].[b_LRecD] ([SickCC])
  ON [PRIMARY]
GO

CREATE INDEX [SickDays]
  ON [dbo].[b_LRecD] ([SickDays])
  ON [PRIMARY]
GO

CREATE INDEX [SrcPosID]
  ON [dbo].[b_LRecD] ([SrcPosID])
  ON [PRIMARY]
GO

CREATE INDEX [WorkDays]
  ON [dbo].[b_LRecD] ([WorkDays])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.ChID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.SrcPosID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.EmpID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.ChargeCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.SickCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.InsureCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.LeaveCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.NLeaveCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MHelpCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.PregCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MChargeCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MChargeCC1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MChargeCC2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.AdvanceCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.AlimonyCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.PensionTaxCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.IncomeTaxCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.InsureTaxCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.UnionCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.CRateCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.LoanCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.EmpTaxCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.WorkDays'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.SickDays'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MoreCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MoreCC1'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.MoreCC2'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.GOperID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_Zero', @objname = N'dbo.b_LRecD.GTranID'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU1_INS_b_LRecD] ON [b_LRecD]
FOR INSERT
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 172 - Обновление итогов в главной таблице */
/* b_LRecD - Зарплата: Начисление (Данные) */
/* b_LRec - Зарплата: Начисление (Заголовок) */

  UPDATE r
  SET 
    r.TAdvanceCC = r.TAdvanceCC + q.TAdvanceCC, 
    r.TAlimonyCC = r.TAlimonyCC + q.TAlimonyCC, 
    r.TChargeCC = r.TChargeCC + q.TChargeCC, 
    r.TCRateCC = r.TCRateCC + q.TCRateCC, 
    r.TEmpTaxCC = r.TEmpTaxCC + q.TEmpTaxCC, 
    r.TIncomeTaxCC = r.TIncomeTaxCC + q.TIncomeTaxCC, 
    r.TInsureCC = r.TInsureCC + q.TInsureCC, 
    r.TInsureTaxCC = r.TInsureTaxCC + q.TInsureTaxCC, 
    r.TLeaveCC = r.TLeaveCC + q.TLeaveCC, 
    r.TLoanCC = r.TLoanCC + q.TLoanCC, 
    r.TMChargeCC = r.TMChargeCC + q.TMChargeCC, 
    r.TMChargeCC1 = r.TMChargeCC1 + q.TMChargeCC1, 
    r.TMChargeCC2 = r.TMChargeCC2 + q.TMChargeCC2, 
    r.TMHelpCC = r.TMHelpCC + q.TMHelpCC, 
    r.TMoreCC = r.TMoreCC + q.TMoreCC, 
    r.TMoreCC1 = r.TMoreCC1 + q.TMoreCC1, 
    r.TMoreCC2 = r.TMoreCC2 + q.TMoreCC2, 
    r.TNLeaveCC = r.TNLeaveCC + q.TNLeaveCC, 
    r.TPensionTaxCC = r.TPensionTaxCC + q.TPensionTaxCC, 
    r.TPregCC = r.TPregCC + q.TPregCC, 
    r.TSickCC = r.TSickCC + q.TSickCC, 
    r.TUnionCC = r.TUnionCC + q.TUnionCC
  FROM b_LRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.AdvanceCC), 0) TAdvanceCC,
       ISNULL(SUM(m.AlimonyCC), 0) TAlimonyCC,
       ISNULL(SUM(m.ChargeCC), 0) TChargeCC,
       ISNULL(SUM(m.CRateCC), 0) TCRateCC,
       ISNULL(SUM(m.EmpTaxCC), 0) TEmpTaxCC,
       ISNULL(SUM(m.IncomeTaxCC), 0) TIncomeTaxCC,
       ISNULL(SUM(m.InsureCC), 0) TInsureCC,
       ISNULL(SUM(m.InsureTaxCC), 0) TInsureTaxCC,
       ISNULL(SUM(m.LeaveCC), 0) TLeaveCC,
       ISNULL(SUM(m.LoanCC), 0) TLoanCC,
       ISNULL(SUM(m.MChargeCC), 0) TMChargeCC,
       ISNULL(SUM(m.MChargeCC1), 0) TMChargeCC1,
       ISNULL(SUM(m.MChargeCC2), 0) TMChargeCC2,
       ISNULL(SUM(m.MHelpCC), 0) TMHelpCC,
       ISNULL(SUM(m.MoreCC), 0) TMoreCC,
       ISNULL(SUM(m.MoreCC1), 0) TMoreCC1,
       ISNULL(SUM(m.MoreCC2), 0) TMoreCC2,
       ISNULL(SUM(m.NLeaveCC), 0) TNLeaveCC,
       ISNULL(SUM(m.PensionTaxCC), 0) TPensionTaxCC,
       ISNULL(SUM(m.PregCC), 0) TPregCC,
       ISNULL(SUM(m.SickCC), 0) TSickCC,
       ISNULL(SUM(m.UnionCC), 0) TUnionCC 
     FROM b_LRec WITH (NOLOCK), inserted m
     WHERE b_LRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU2_UPD_b_LRecD] ON [b_LRecD]
FOR UPDATE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 172 - Обновление итогов в главной таблице */
/* b_LRecD - Зарплата: Начисление (Данные) */
/* b_LRec - Зарплата: Начисление (Заголовок) */

IF UPDATE(AdvanceCC) OR UPDATE(AlimonyCC) OR UPDATE(ChargeCC) OR UPDATE(CRateCC) OR UPDATE(EmpTaxCC) OR UPDATE(IncomeTaxCC) OR UPDATE(InsureCC) OR UPDATE(InsureTaxCC) OR UPDATE(LeaveCC) OR UPDATE(LoanCC) OR UPDATE(MChargeCC) OR UPDATE(MChargeCC1) OR UPDATE(MChargeCC2) OR UPDATE(MHelpCC) OR UPDATE(MoreCC) OR UPDATE(MoreCC1) OR UPDATE(MoreCC2) OR UPDATE(NLeaveCC) OR UPDATE(PensionTaxCC) OR UPDATE(PregCC) OR UPDATE(SickCC) OR UPDATE(UnionCC)
BEGIN
  UPDATE r
  SET 
    r.TAdvanceCC = r.TAdvanceCC + q.TAdvanceCC, 
    r.TAlimonyCC = r.TAlimonyCC + q.TAlimonyCC, 
    r.TChargeCC = r.TChargeCC + q.TChargeCC, 
    r.TCRateCC = r.TCRateCC + q.TCRateCC, 
    r.TEmpTaxCC = r.TEmpTaxCC + q.TEmpTaxCC, 
    r.TIncomeTaxCC = r.TIncomeTaxCC + q.TIncomeTaxCC, 
    r.TInsureCC = r.TInsureCC + q.TInsureCC, 
    r.TInsureTaxCC = r.TInsureTaxCC + q.TInsureTaxCC, 
    r.TLeaveCC = r.TLeaveCC + q.TLeaveCC, 
    r.TLoanCC = r.TLoanCC + q.TLoanCC, 
    r.TMChargeCC = r.TMChargeCC + q.TMChargeCC, 
    r.TMChargeCC1 = r.TMChargeCC1 + q.TMChargeCC1, 
    r.TMChargeCC2 = r.TMChargeCC2 + q.TMChargeCC2, 
    r.TMHelpCC = r.TMHelpCC + q.TMHelpCC, 
    r.TMoreCC = r.TMoreCC + q.TMoreCC, 
    r.TMoreCC1 = r.TMoreCC1 + q.TMoreCC1, 
    r.TMoreCC2 = r.TMoreCC2 + q.TMoreCC2, 
    r.TNLeaveCC = r.TNLeaveCC + q.TNLeaveCC, 
    r.TPensionTaxCC = r.TPensionTaxCC + q.TPensionTaxCC, 
    r.TPregCC = r.TPregCC + q.TPregCC, 
    r.TSickCC = r.TSickCC + q.TSickCC, 
    r.TUnionCC = r.TUnionCC + q.TUnionCC
  FROM b_LRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.AdvanceCC), 0) TAdvanceCC,
       ISNULL(SUM(m.AlimonyCC), 0) TAlimonyCC,
       ISNULL(SUM(m.ChargeCC), 0) TChargeCC,
       ISNULL(SUM(m.CRateCC), 0) TCRateCC,
       ISNULL(SUM(m.EmpTaxCC), 0) TEmpTaxCC,
       ISNULL(SUM(m.IncomeTaxCC), 0) TIncomeTaxCC,
       ISNULL(SUM(m.InsureCC), 0) TInsureCC,
       ISNULL(SUM(m.InsureTaxCC), 0) TInsureTaxCC,
       ISNULL(SUM(m.LeaveCC), 0) TLeaveCC,
       ISNULL(SUM(m.LoanCC), 0) TLoanCC,
       ISNULL(SUM(m.MChargeCC), 0) TMChargeCC,
       ISNULL(SUM(m.MChargeCC1), 0) TMChargeCC1,
       ISNULL(SUM(m.MChargeCC2), 0) TMChargeCC2,
       ISNULL(SUM(m.MHelpCC), 0) TMHelpCC,
       ISNULL(SUM(m.MoreCC), 0) TMoreCC,
       ISNULL(SUM(m.MoreCC1), 0) TMoreCC1,
       ISNULL(SUM(m.MoreCC2), 0) TMoreCC2,
       ISNULL(SUM(m.NLeaveCC), 0) TNLeaveCC,
       ISNULL(SUM(m.PensionTaxCC), 0) TPensionTaxCC,
       ISNULL(SUM(m.PregCC), 0) TPregCC,
       ISNULL(SUM(m.SickCC), 0) TSickCC,
       ISNULL(SUM(m.UnionCC), 0) TUnionCC 
     FROM b_LRec WITH (NOLOCK), inserted m
     WHERE b_LRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return

  UPDATE r
  SET 
    r.TAdvanceCC = r.TAdvanceCC - q.TAdvanceCC, 
    r.TAlimonyCC = r.TAlimonyCC - q.TAlimonyCC, 
    r.TChargeCC = r.TChargeCC - q.TChargeCC, 
    r.TCRateCC = r.TCRateCC - q.TCRateCC, 
    r.TEmpTaxCC = r.TEmpTaxCC - q.TEmpTaxCC, 
    r.TIncomeTaxCC = r.TIncomeTaxCC - q.TIncomeTaxCC, 
    r.TInsureCC = r.TInsureCC - q.TInsureCC, 
    r.TInsureTaxCC = r.TInsureTaxCC - q.TInsureTaxCC, 
    r.TLeaveCC = r.TLeaveCC - q.TLeaveCC, 
    r.TLoanCC = r.TLoanCC - q.TLoanCC, 
    r.TMChargeCC = r.TMChargeCC - q.TMChargeCC, 
    r.TMChargeCC1 = r.TMChargeCC1 - q.TMChargeCC1, 
    r.TMChargeCC2 = r.TMChargeCC2 - q.TMChargeCC2, 
    r.TMHelpCC = r.TMHelpCC - q.TMHelpCC, 
    r.TMoreCC = r.TMoreCC - q.TMoreCC, 
    r.TMoreCC1 = r.TMoreCC1 - q.TMoreCC1, 
    r.TMoreCC2 = r.TMoreCC2 - q.TMoreCC2, 
    r.TNLeaveCC = r.TNLeaveCC - q.TNLeaveCC, 
    r.TPensionTaxCC = r.TPensionTaxCC - q.TPensionTaxCC, 
    r.TPregCC = r.TPregCC - q.TPregCC, 
    r.TSickCC = r.TSickCC - q.TSickCC, 
    r.TUnionCC = r.TUnionCC - q.TUnionCC
  FROM b_LRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.AdvanceCC), 0) TAdvanceCC,
       ISNULL(SUM(m.AlimonyCC), 0) TAlimonyCC,
       ISNULL(SUM(m.ChargeCC), 0) TChargeCC,
       ISNULL(SUM(m.CRateCC), 0) TCRateCC,
       ISNULL(SUM(m.EmpTaxCC), 0) TEmpTaxCC,
       ISNULL(SUM(m.IncomeTaxCC), 0) TIncomeTaxCC,
       ISNULL(SUM(m.InsureCC), 0) TInsureCC,
       ISNULL(SUM(m.InsureTaxCC), 0) TInsureTaxCC,
       ISNULL(SUM(m.LeaveCC), 0) TLeaveCC,
       ISNULL(SUM(m.LoanCC), 0) TLoanCC,
       ISNULL(SUM(m.MChargeCC), 0) TMChargeCC,
       ISNULL(SUM(m.MChargeCC1), 0) TMChargeCC1,
       ISNULL(SUM(m.MChargeCC2), 0) TMChargeCC2,
       ISNULL(SUM(m.MHelpCC), 0) TMHelpCC,
       ISNULL(SUM(m.MoreCC), 0) TMoreCC,
       ISNULL(SUM(m.MoreCC1), 0) TMoreCC1,
       ISNULL(SUM(m.MoreCC2), 0) TMoreCC2,
       ISNULL(SUM(m.NLeaveCC), 0) TNLeaveCC,
       ISNULL(SUM(m.PensionTaxCC), 0) TPensionTaxCC,
       ISNULL(SUM(m.PregCC), 0) TPregCC,
       ISNULL(SUM(m.SickCC), 0) TSickCC,
       ISNULL(SUM(m.UnionCC), 0) TUnionCC 
     FROM b_LRec WITH (NOLOCK), deleted m
     WHERE b_LRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
END
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TAU3_DEL_b_LRecD] ON [b_LRecD]
FOR DELETE
AS
BEGIN
  IF @@RowCount = 0 RETURN
  SET NOCOUNT ON
/* -------------------------------------------------------------------------- */

/* 172 - Обновление итогов в главной таблице */
/* b_LRecD - Зарплата: Начисление (Данные) */
/* b_LRec - Зарплата: Начисление (Заголовок) */

  UPDATE r
  SET 
    r.TAdvanceCC = r.TAdvanceCC - q.TAdvanceCC, 
    r.TAlimonyCC = r.TAlimonyCC - q.TAlimonyCC, 
    r.TChargeCC = r.TChargeCC - q.TChargeCC, 
    r.TCRateCC = r.TCRateCC - q.TCRateCC, 
    r.TEmpTaxCC = r.TEmpTaxCC - q.TEmpTaxCC, 
    r.TIncomeTaxCC = r.TIncomeTaxCC - q.TIncomeTaxCC, 
    r.TInsureCC = r.TInsureCC - q.TInsureCC, 
    r.TInsureTaxCC = r.TInsureTaxCC - q.TInsureTaxCC, 
    r.TLeaveCC = r.TLeaveCC - q.TLeaveCC, 
    r.TLoanCC = r.TLoanCC - q.TLoanCC, 
    r.TMChargeCC = r.TMChargeCC - q.TMChargeCC, 
    r.TMChargeCC1 = r.TMChargeCC1 - q.TMChargeCC1, 
    r.TMChargeCC2 = r.TMChargeCC2 - q.TMChargeCC2, 
    r.TMHelpCC = r.TMHelpCC - q.TMHelpCC, 
    r.TMoreCC = r.TMoreCC - q.TMoreCC, 
    r.TMoreCC1 = r.TMoreCC1 - q.TMoreCC1, 
    r.TMoreCC2 = r.TMoreCC2 - q.TMoreCC2, 
    r.TNLeaveCC = r.TNLeaveCC - q.TNLeaveCC, 
    r.TPensionTaxCC = r.TPensionTaxCC - q.TPensionTaxCC, 
    r.TPregCC = r.TPregCC - q.TPregCC, 
    r.TSickCC = r.TSickCC - q.TSickCC, 
    r.TUnionCC = r.TUnionCC - q.TUnionCC
  FROM b_LRec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.AdvanceCC), 0) TAdvanceCC,
       ISNULL(SUM(m.AlimonyCC), 0) TAlimonyCC,
       ISNULL(SUM(m.ChargeCC), 0) TChargeCC,
       ISNULL(SUM(m.CRateCC), 0) TCRateCC,
       ISNULL(SUM(m.EmpTaxCC), 0) TEmpTaxCC,
       ISNULL(SUM(m.IncomeTaxCC), 0) TIncomeTaxCC,
       ISNULL(SUM(m.InsureCC), 0) TInsureCC,
       ISNULL(SUM(m.InsureTaxCC), 0) TInsureTaxCC,
       ISNULL(SUM(m.LeaveCC), 0) TLeaveCC,
       ISNULL(SUM(m.LoanCC), 0) TLoanCC,
       ISNULL(SUM(m.MChargeCC), 0) TMChargeCC,
       ISNULL(SUM(m.MChargeCC1), 0) TMChargeCC1,
       ISNULL(SUM(m.MChargeCC2), 0) TMChargeCC2,
       ISNULL(SUM(m.MHelpCC), 0) TMHelpCC,
       ISNULL(SUM(m.MoreCC), 0) TMoreCC,
       ISNULL(SUM(m.MoreCC1), 0) TMoreCC1,
       ISNULL(SUM(m.MoreCC2), 0) TMoreCC2,
       ISNULL(SUM(m.NLeaveCC), 0) TNLeaveCC,
       ISNULL(SUM(m.PensionTaxCC), 0) TPensionTaxCC,
       ISNULL(SUM(m.PregCC), 0) TPregCC,
       ISNULL(SUM(m.SickCC), 0) TSickCC,
       ISNULL(SUM(m.UnionCC), 0) TUnionCC 
     FROM b_LRec WITH (NOLOCK), deleted m
     WHERE b_LRec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID
  IF @@error > 0 Return
/* -------------------------------------------------------------------------- */

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel1_Ins_b_LRecD] ON [b_LRecD]
FOR INSERT AS
/* b_LRecD - Зарплата: Начисление (Данные) - INSERT TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_LRec a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_LRec a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_LRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))

  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID AS varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_LRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF @ADate IS NOT NULL
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_LRec a, inserted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14325, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Зарплата: Начисление'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_LRecD ^ b_LRec - Проверка в PARENT */
/* Зарплата: Начисление (Данные) ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_LRec))
    BEGIN
      EXEC z_RelationError 'b_LRec', 'b_LRecD', 0
      RETURN
    END

/* b_LRecD ^ r_Emps - Проверка в PARENT */
/* Зарплата: Начисление (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
    BEGIN
      EXEC z_RelationError 'r_Emps', 'b_LRecD', 0
      RETURN
    END

/* b_LRecD ^ r_GOpers - Проверка в PARENT */
/* Зарплата: Начисление (Данные) ^ Справочник проводок - Проверка в PARENT */
  IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
    BEGIN
      EXEC z_RelationError 'r_GOpers', 'b_LRecD', 0
      RETURN
    END

/* Регистрация создания записи */
  INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
  SELECT 14325002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

END
GO

EXEC sp_settriggerorder N'dbo.TRel1_Ins_b_LRecD', N'Last', N'INSERT'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel2_Upd_b_LRecD] ON [b_LRecD]
FOR UPDATE AS
/* b_LRecD - Зарплата: Начисление (Данные) - UPDATE TRIGGER */
BEGIN
  DECLARE @RCount Int
  SELECT @RCount = @@RowCount
  IF @RCount = 0 RETURN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_LRec a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_LRec a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_LRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Новая дата или одна из дат документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_LRec a, inserted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isIns = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Новая дата или одна из дат документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_LRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_LRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_LRec a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14325, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Зарплата: Начисление'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* b_LRecD ^ b_LRec - Проверка в PARENT */
/* Зарплата: Начисление (Данные) ^ Зарплата: Начисление (Заголовок) - Проверка в PARENT */
  IF UPDATE(ChID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.ChID NOT IN (SELECT ChID FROM b_LRec))
      BEGIN
        EXEC z_RelationError 'b_LRec', 'b_LRecD', 1
        RETURN
      END

/* b_LRecD ^ r_Emps - Проверка в PARENT */
/* Зарплата: Начисление (Данные) ^ Справочник служащих - Проверка в PARENT */
  IF UPDATE(EmpID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.EmpID NOT IN (SELECT EmpID FROM r_Emps))
      BEGIN
        EXEC z_RelationError 'r_Emps', 'b_LRecD', 1
        RETURN
      END

/* b_LRecD ^ r_GOpers - Проверка в PARENT */
/* Зарплата: Начисление (Данные) ^ Справочник проводок - Проверка в PARENT */
  IF UPDATE(GOperID)
    IF EXISTS (SELECT * FROM inserted i WHERE i.GOperID NOT IN (SELECT GOperID FROM r_GOpers))
      BEGIN
        EXEC z_RelationError 'r_GOpers', 'b_LRecD', 1
        RETURN
      END

/* Регистрация изменения записи */


/* Регистрация изменения кода регистрации */
  IF UPDATE(ChID)
    IF ((SELECT COUNT(ChID) FROM deleted GROUP BY ChID) = 1) AND ((SELECT COUNT(ChID) FROM inserted GROUP BY ChID) = 1)
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, inserted i, deleted d WHERE l.TableCode = 14325002 AND l.ChID = d.ChID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, inserted i, deleted d WHERE l.TableCode = 14325002 AND l.ChID = d.ChID
      END
    ELSE IF NOT(UPDATE(ChID) OR UPDATE(SrcPosID))
      BEGIN
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14325002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
        UPDATE l SET l.ChID = i.ChID
        FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14325002 AND l.PKValue = 
        '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
        '[' + cast(i.SrcPosID as varchar(200)) + ']' AND i.ChID = d.ChID AND i.SrcPosID = d.SrcPosID
      END
    ELSE
      BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14325002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14325002 AND ChID IN (SELECT ChID FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14325002 AND ChID IN (SELECT ChID FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14325002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i
      END

/* Регистрация изменения первичного ключа */
  IF UPDATE(ChID) OR UPDATE(SrcPosID)
    BEGIN
      IF ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM deleted) q) = 1) AND ((SELECT COUNT(1) FROM (SELECT DISTINCT ChID, SrcPosID FROM inserted) q) = 1)
        BEGIN
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogUpdate l, deleted d, inserted i WHERE l.TableCode = 14325002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          UPDATE l SET PKValue = 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          FROM z_LogCreate l, deleted d, inserted i WHERE l.TableCode = 14325002 AND l.PKValue = 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
        END
      ELSE
        BEGIN
          INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
          SELECT 14325002, ChID, 
          '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d
          DELETE FROM z_LogCreate WHERE TableCode = 14325002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          DELETE FROM z_LogUpdate WHERE TableCode = 14325002 AND PKValue IN (SELECT 
          '[' + cast(ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(SrcPosID as varchar(200)) + ']' FROM deleted)
          INSERT INTO z_LogCreate (TableCode, ChID, PKValue, UserCode)
          SELECT 14325002, ChID, 
          '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
          '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i

        END
      END

  INSERT INTO z_LogUpdate (TableCode, ChID, PKValue, UserCode)
  SELECT 14325002, ChID, 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM inserted i


End
GO

EXEC sp_settriggerorder N'dbo.TRel2_Upd_b_LRecD', N'Last', N'UPDATE'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRel3_Del_b_LRecD] ON [b_LRecD]
FOR DELETE AS
/* b_LRecD - Зарплата: Начисление (Данные) - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON

/* Проверка открытого периода */
  DECLARE @OurID int, @ADate datetime, @Err varchar(200)
  DECLARE @GetDate datetime
  DECLARE @OpenAges table(OurID int, BDate datetime, EDate datetime, isIns bit, isDel bit)

  SET @GetDate = GETDATE()

  INSERT INTO @OpenAges(OurID, isIns)
  SELECT DISTINCT OurID, 1 FROM  b_LRec a, inserted b  WHERE (b.ChID = a.ChID)

  INSERT INTO @OpenAges(OurID, isDel)
  SELECT DISTINCT OurID, 1 FROM  b_LRec a, deleted b  WHERE (b.ChID = a.ChID)

  UPDATE t
  SET BDate = o.BDate, EDate = o.EDate
  FROM @OpenAges t, dbo.zf_GetOpenAges(@GetDate) o
  WHERE t.OurID = o.OurID
  SELECT @OurID = a.OurID, @ADate = t.BDate FROM  b_LRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate < t.BDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа меньше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

  SELECT @OurID = a.OurID, @ADate = t.EDate FROM  b_LRec a, deleted b , @OpenAges AS t WHERE (b.ChID = a.ChID) AND t.OurID = a.OurID AND t.isDel = 1 AND ((a.DocDate > t.EDate))
  IF (@ADate IS NOT NULL) 
    BEGIN
      SELECT @Err = 'Зарплата: Начисление (Данные) (b_LRecD):' + CHAR(13) + 'Дата или одна из дат изменяемого документа больше даты открытого периода ' + dbo.zf_DatetoStr(@ADate) + ' для фирмы с кодом ' + CAST(@OurID as varchar(10))
      RAISERROR (@Err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Возможно ли редактирование документа */
  IF EXISTS(SELECT * FROM b_LRec a, deleted b WHERE (b.ChID = a.ChID) AND dbo.zf_CanChangeDoc(14325, a.ChID, a.StateCode) = 0)
    BEGIN
      RAISERROR ('Изменение документа ''Зарплата: Начисление'' в данном статусе запрещено.', 18, 1)
      ROLLBACK TRAN
      RETURN
    END

/* Удаление проводок */
  DELETE FROM b_GTran WHERE GTranID IN (SELECT GTranID FROM deleted)

/* Удаление регистрации создания записи */
  DELETE z_LogCreate FROM z_LogCreate m, deleted i
  WHERE m.TableCode = 14325002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Удаление регистрации изменения записи */
  DELETE z_LogUpdate FROM z_LogUpdate m, deleted i
  WHERE m.TableCode = 14325002 AND m.PKValue = 
    '[' + cast(i.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(i.SrcPosID as varchar(200)) + ']'

/* Регистрация удаления записи */
  INSERT INTO z_LogDelete (TableCode, ChID, PKValue, UserCode)
  SELECT 14325002, -ChID, 
    '[' + cast(d.ChID as varchar(200)) + ']' + ' \ ' + 
    '[' + cast(d.SrcPosID as varchar(200)) + ']'
          , dbo.zf_GetUserCode() FROM deleted d

END
GO

EXEC sp_settriggerorder N'dbo.TRel3_Del_b_LRecD', N'Last', N'DELETE'
GO