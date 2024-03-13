SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_DocTotals]
AS
  UPDATE b_Acc
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_ARepA
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TSumMC = 0, 
    TTaxSum = 0

  UPDATE b_CInv
  SET
    TSumAC = 0, 
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_CRepA
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_CRet
  SET
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_Cst
  SET
    TTaxSum = 0

  UPDATE b_Exp
  SET
    TLevySum = 0, 
    TRealSum = 0, 
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_Inv
  SET
    TLevySum = 0, 
    TRealSum = 0, 
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_LExp
  SET
    TSumCC = 0

  UPDATE b_LRec
  SET
    TAdvanceCC = 0, 
    TAlimonyCC = 0, 
    TChargeCC = 0, 
    TCRateCC = 0, 
    TEmpTaxCC = 0, 
    TIncomeTaxCC = 0, 
    TInsureCC = 0, 
    TInsureTaxCC = 0, 
    TLeaveCC = 0, 
    TLoanCC = 0, 
    TMChargeCC = 0, 
    TMChargeCC1 = 0, 
    TMChargeCC2 = 0, 
    TMHelpCC = 0, 
    TMoreCC = 0, 
    TMoreCC1 = 0, 
    TMoreCC2 = 0, 
    TNLeaveCC = 0, 
    TPensionTaxCC = 0, 
    TPregCC = 0, 
    TSickCC = 0, 
    TUnionCC = 0

  UPDATE b_PAcc
  SET
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_PCost
  SET
    TExpCostCC = 0, 
    TExpPosCostCC = 0, 
    TExpPosProdCostCC = 0, 
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0

  UPDATE b_PCostD
  SET
    ExpPosCostCC = 0, 
    ExpPosProdCostCC = 0

  UPDATE b_PEst
  SET
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_PExc
  SET
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_PVen
  SET
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_Rec
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_RepA
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_Ret
  SET
    TLevySum = 0, 
    TRealSum = 0, 
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SDep
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SExc
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SExp
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SInv
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SPut
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SRec
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SRep
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SVen
  SET
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_SWer
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE b_WBill
  SET
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0
/* Счет на оплату  (Данные) */
  UPDATE b_Acc
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_AccD.SumCC_nt),0) FROM b_AccD WITH(NOLOCK)  WHERE b_Acc.ChID = b_AccD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_AccD.TaxSum),0) FROM b_AccD WITH(NOLOCK)  WHERE b_Acc.ChID = b_AccD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_AccD.SumCC_wt),0) FROM b_AccD WITH(NOLOCK)  WHERE b_Acc.ChID = b_AccD.ChID)
  FROM b_Acc

/* Авансовый отчет валютный (ТМЦ) */
  UPDATE b_ARepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_ARepADP.SumCC_nt),0) FROM b_ARepADP WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADP.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_ARepADP.TaxSum),0) FROM b_ARepADP WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADP.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_ARepADP.SumCC_wt),0) FROM b_ARepADP WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADP.ChID),
    TSumMC = TSumMC + (SELECT ISNULL(SUM(b_ARepADP.SumAC_In / b_ARepADP.PKursMC),0) FROM b_ARepADP WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADP.ChID)
  FROM b_ARepA

/* Авансовый отчет валютный (Основные средства) */
  UPDATE b_ARepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_ARepADS.SumCC_nt),0) FROM b_ARepADS WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADS.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_ARepADS.TaxSum),0) FROM b_ARepADS WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADS.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_ARepADS.SumCC_wt),0) FROM b_ARepADS WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADS.ChID),
    TSumMC = TSumMC + (SELECT ISNULL(SUM(b_ARepADS.ASumAC / b_ARepADS.AKursMC),0) FROM b_ARepADS WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADS.ChID)
  FROM b_ARepA

/* Авансовый отчет валютный (Общие) */
  UPDATE b_ARepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_ARepADV.SumCC_nt),0) FROM b_ARepADV WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADV.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_ARepADV.TaxSum),0) FROM b_ARepADV WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADV.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_ARepADV.SumCC_wt),0) FROM b_ARepADV WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADV.ChID),
    TSumMC = TSumMC + (SELECT ISNULL(SUM(b_ARepADV.VSumAC / b_ARepADV.VKursMC),0) FROM b_ARepADV WITH(NOLOCK)  WHERE b_ARepA.ChID = b_ARepADV.ChID)
  FROM b_ARepA

/* ТМЦ: Расход по ГТД (ТМЦ) */
  UPDATE b_CInv
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_CInvD.SumCC_nt),0) FROM b_CInvD WITH(NOLOCK)  WHERE b_CInv.ChID = b_CInvD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_CInvD.TaxSum),0) FROM b_CInvD WITH(NOLOCK)  WHERE b_CInv.ChID = b_CInvD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_CInvD.SumCC_wt),0) FROM b_CInvD WITH(NOLOCK)  WHERE b_CInv.ChID = b_CInvD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_CInvD.SumCC_In),0) FROM b_CInvD WITH(NOLOCK)  WHERE b_CInv.ChID = b_CInvD.ChID),
    TSumAC = TSumAC + (SELECT ISNULL(SUM(b_CInvD.SumAC),0) FROM b_CInvD WITH(NOLOCK)  WHERE b_CInv.ChID = b_CInvD.ChID)
  FROM b_CInv

/* Авансовый отчет с признаками (ТМЦ) */
  UPDATE b_CRepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_CRepADP.SumCC_nt),0) FROM b_CRepADP WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADP.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_CRepADP.TaxSum),0) FROM b_CRepADP WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADP.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_CRepADP.SumCC_wt),0) FROM b_CRepADP WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADP.ChID)
  FROM b_CRepA

/* Авансовый отчет с признаками (Основные средства) */
  UPDATE b_CRepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_CRepADS.SumCC_nt),0) FROM b_CRepADS WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADS.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_CRepADS.TaxSum),0) FROM b_CRepADS WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADS.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_CRepADS.SumCC_wt),0) FROM b_CRepADS WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADS.ChID)
  FROM b_CRepA

/* Авансовый отчет с признаками (Общие) */
  UPDATE b_CRepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_CRepADV.SumCC_nt),0) FROM b_CRepADV WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADV.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_CRepADV.TaxSum),0) FROM b_CRepADV WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADV.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_CRepADV.SumCC_wt),0) FROM b_CRepADV WITH(NOLOCK)  WHERE b_CRepA.ChID = b_CRepADV.ChID)
  FROM b_CRepA

/* ТМЦ: Возврат поставщику (ТМЦ) */
  UPDATE b_CRet
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_CRetD.SumCC_nt),0) FROM b_CRetD WITH(NOLOCK)  WHERE b_CRet.ChID = b_CRetD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_CRetD.TaxSum),0) FROM b_CRetD WITH(NOLOCK)  WHERE b_CRet.ChID = b_CRetD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_CRetD.SumCC_wt),0) FROM b_CRetD WITH(NOLOCK)  WHERE b_CRet.ChID = b_CRetD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_CRetD.SumCC_In),0) FROM b_CRetD WITH(NOLOCK)  WHERE b_CRet.ChID = b_CRetD.ChID)
  FROM b_CRet

/* ТМЦ: Приход по ГТД (ТМЦ) */
  UPDATE b_Cst
  SET 
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_CstD.TaxSum),0) FROM b_CstD WITH(NOLOCK)  WHERE b_Cst.ChID = b_CstD.ChID)
  FROM b_Cst

/* ТМЦ: Внутренний расход (ТМЦ) */
  UPDATE b_Exp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_ExpD.SumCC_nt),0) FROM b_ExpD WITH(NOLOCK)  WHERE b_Exp.ChID = b_ExpD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_ExpD.TaxSum),0) FROM b_ExpD WITH(NOLOCK)  WHERE b_Exp.ChID = b_ExpD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_ExpD.SumCC_wt),0) FROM b_ExpD WITH(NOLOCK)  WHERE b_Exp.ChID = b_ExpD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_ExpD.SumCC_In),0) FROM b_ExpD WITH(NOLOCK)  WHERE b_Exp.ChID = b_ExpD.ChID),
    TRealSum = TRealSum + (SELECT ISNULL(SUM(b_ExpD.RealSum),0) FROM b_ExpD WITH(NOLOCK)  WHERE b_Exp.ChID = b_ExpD.ChID)
  FROM b_Exp

/* ТМЦ: Расходная накладная (ТМЦ) */
  UPDATE b_Inv
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_InvD.SumCC_nt),0) FROM b_InvD WITH(NOLOCK)  WHERE b_Inv.ChID = b_InvD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_InvD.TaxSum),0) FROM b_InvD WITH(NOLOCK)  WHERE b_Inv.ChID = b_InvD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_InvD.SumCC_wt),0) FROM b_InvD WITH(NOLOCK)  WHERE b_Inv.ChID = b_InvD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_InvD.SumCC_In),0) FROM b_InvD WITH(NOLOCK)  WHERE b_Inv.ChID = b_InvD.ChID),
    TRealSum = TRealSum + (SELECT ISNULL(SUM(b_InvD.RealSum),0) FROM b_InvD WITH(NOLOCK)  WHERE b_Inv.ChID = b_InvD.ChID)
  FROM b_Inv

/* ТМЦ: Счет на оплату (ТМЦ) */
  UPDATE b_PAcc
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_PAccD.SumCC_nt),0) FROM b_PAccD WITH(NOLOCK)  WHERE b_PAcc.ChID = b_PAccD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_PAccD.TaxSum),0) FROM b_PAccD WITH(NOLOCK)  WHERE b_PAcc.ChID = b_PAccD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_PAccD.SumCC_wt),0) FROM b_PAccD WITH(NOLOCK)  WHERE b_PAcc.ChID = b_PAccD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_PAccD.SumCC_In),0) FROM b_PAccD WITH(NOLOCK)  WHERE b_PAcc.ChID = b_PAccD.ChID)
  FROM b_PAcc

/* ТМЦ: Переоценка партий (ТМЦ) */
  UPDATE b_PEst
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_PEstD.SumCC_nt),0) FROM b_PEstD WITH(NOLOCK)  WHERE b_PEst.ChID = b_PEstD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_PEstD.TaxSum),0) FROM b_PEstD WITH(NOLOCK)  WHERE b_PEst.ChID = b_PEstD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_PEstD.SumCC_wt),0) FROM b_PEstD WITH(NOLOCK)  WHERE b_PEst.ChID = b_PEstD.ChID),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(b_PEstD.NewSumCC_nt),0) FROM b_PEstD WITH(NOLOCK)  WHERE b_PEst.ChID = b_PEstD.ChID),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(b_PEstD.NewTaxSum),0) FROM b_PEstD WITH(NOLOCK)  WHERE b_PEst.ChID = b_PEstD.ChID),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(b_PEstD.NewSumCC_wt),0) FROM b_PEstD WITH(NOLOCK)  WHERE b_PEst.ChID = b_PEstD.ChID)
  FROM b_PEst

/* ТМЦ: Перемещение (ТМЦ) */
  UPDATE b_PExc
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_PExcD.SumCC_nt),0) FROM b_PExcD WITH(NOLOCK)  WHERE b_PExc.ChID = b_PExcD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_PExcD.TaxSum),0) FROM b_PExcD WITH(NOLOCK)  WHERE b_PExc.ChID = b_PExcD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_PExcD.SumCC_wt),0) FROM b_PExcD WITH(NOLOCK)  WHERE b_PExc.ChID = b_PExcD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_PExcD.SumCC_In),0) FROM b_PExcD WITH(NOLOCK)  WHERE b_PExc.ChID = b_PExcD.ChID)
  FROM b_PExc

/* ТМЦ: Инвентаризация (Итоги) */
  UPDATE b_PVen
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_PVenA.TSumCC_nt),0) FROM b_PVenA WITH(NOLOCK)  WHERE b_PVen.ChID = b_PVenA.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_PVenA.TTaxSum),0) FROM b_PVenA WITH(NOLOCK)  WHERE b_PVen.ChID = b_PVenA.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_PVenA.TSumCC_wt),0) FROM b_PVenA WITH(NOLOCK)  WHERE b_PVen.ChID = b_PVenA.ChID),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(b_PVenA.TNewSumCC_nt),0) FROM b_PVenA WITH(NOLOCK)  WHERE b_PVen.ChID = b_PVenA.ChID),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(b_PVenA.TNewTaxSum),0) FROM b_PVenA WITH(NOLOCK)  WHERE b_PVen.ChID = b_PVenA.ChID),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(b_PVenA.TNewSumCC_wt),0) FROM b_PVenA WITH(NOLOCK)  WHERE b_PVen.ChID = b_PVenA.ChID)
  FROM b_PVen

/* ТМЦ: Приход по накладной (ТМЦ) */
  UPDATE b_Rec
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_RecD.SumCC_nt),0) FROM b_RecD WITH(NOLOCK)  WHERE b_Rec.ChID = b_RecD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_RecD.TaxSum),0) FROM b_RecD WITH(NOLOCK)  WHERE b_Rec.ChID = b_RecD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_RecD.SumCC_wt),0) FROM b_RecD WITH(NOLOCK)  WHERE b_Rec.ChID = b_RecD.ChID)
  FROM b_Rec

/* Авансовый отчет (ТМЦ) */
  UPDATE b_RepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_RepADP.SumCC_nt),0) FROM b_RepADP WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADP.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_RepADP.TaxSum),0) FROM b_RepADP WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADP.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_RepADP.SumCC_wt),0) FROM b_RepADP WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADP.ChID)
  FROM b_RepA

/* Авансовый отчет (Основные средства) */
  UPDATE b_RepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_RepADS.SumCC_nt),0) FROM b_RepADS WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADS.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_RepADS.TaxSum),0) FROM b_RepADS WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADS.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_RepADS.SumCC_wt),0) FROM b_RepADS WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADS.ChID)
  FROM b_RepA

/* Авансовый отчет (Общие) */
  UPDATE b_RepA
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_RepADV.SumCC_nt),0) FROM b_RepADV WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADV.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_RepADV.TaxSum),0) FROM b_RepADV WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADV.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_RepADV.SumCC_wt),0) FROM b_RepADV WITH(NOLOCK)  WHERE b_RepA.ChID = b_RepADV.ChID)
  FROM b_RepA

/* ТМЦ: Возврат от получателя (ТМЦ) */
  UPDATE b_Ret
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_RetD.SumCC_nt),0) FROM b_RetD WITH(NOLOCK)  WHERE b_Ret.ChID = b_RetD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_RetD.TaxSum),0) FROM b_RetD WITH(NOLOCK)  WHERE b_Ret.ChID = b_RetD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_RetD.SumCC_wt),0) FROM b_RetD WITH(NOLOCK)  WHERE b_Ret.ChID = b_RetD.ChID),
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(b_RetD.SumCC_In),0) FROM b_RetD WITH(NOLOCK)  WHERE b_Ret.ChID = b_RetD.ChID),
    TRealSum = TRealSum + (SELECT ISNULL(SUM(b_RetD.RealSum),0) FROM b_RetD WITH(NOLOCK)  WHERE b_Ret.ChID = b_RetD.ChID)
  FROM b_Ret

/* Основные средства: Амортизация: Данные */
  UPDATE b_SDep
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SDepD.SumCC_nt),0) FROM b_SDepD WITH(NOLOCK)  WHERE b_SDep.ChID = b_SDepD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SDepD.TaxSum),0) FROM b_SDepD WITH(NOLOCK)  WHERE b_SDep.ChID = b_SDepD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SDepD.SumCC_wt),0) FROM b_SDepD WITH(NOLOCK)  WHERE b_SDep.ChID = b_SDepD.ChID)
  FROM b_SDep

/* Основные средства: Перемещение (Данные) */
  UPDATE b_SExc
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SExcD.SumCC_nt),0) FROM b_SExcD WITH(NOLOCK)  WHERE b_SExc.ChID = b_SExcD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SExcD.TaxSum),0) FROM b_SExcD WITH(NOLOCK)  WHERE b_SExc.ChID = b_SExcD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SExcD.SumCC_wt),0) FROM b_SExcD WITH(NOLOCK)  WHERE b_SExc.ChID = b_SExcD.ChID)
  FROM b_SExc

/* Основные средства: Списание (Данные) */
  UPDATE b_SExp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SExpD.SumCC_nt),0) FROM b_SExpD WITH(NOLOCK)  WHERE b_SExp.ChID = b_SExpD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SExpD.TaxSum),0) FROM b_SExpD WITH(NOLOCK)  WHERE b_SExp.ChID = b_SExpD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SExpD.SumCC_wt),0) FROM b_SExpD WITH(NOLOCK)  WHERE b_SExp.ChID = b_SExpD.ChID)
  FROM b_SExp

/* Основные средства: Продажа (Данные) */
  UPDATE b_SInv
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SInvD.SumCC_nt),0) FROM b_SInvD WITH(NOLOCK)  WHERE b_SInv.ChID = b_SInvD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SInvD.TaxSum),0) FROM b_SInvD WITH(NOLOCK)  WHERE b_SInv.ChID = b_SInvD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SInvD.SumCC_wt),0) FROM b_SInvD WITH(NOLOCK)  WHERE b_SInv.ChID = b_SInvD.ChID)
  FROM b_SInv

/* Основные средства: Ввод в эксплуатацию (Данные) */
  UPDATE b_SPut
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SPutD.SumCC_nt),0) FROM b_SPutD WITH(NOLOCK)  WHERE b_SPut.ChID = b_SPutD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SPutD.TaxSum),0) FROM b_SPutD WITH(NOLOCK)  WHERE b_SPut.ChID = b_SPutD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SPutD.SumCC_wt),0) FROM b_SPutD WITH(NOLOCK)  WHERE b_SPut.ChID = b_SPutD.ChID)
  FROM b_SPut

/* Основные средства: Приход (Данные) */
  UPDATE b_SRec
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SRecD.SumCC_nt),0) FROM b_SRecD WITH(NOLOCK)  WHERE b_SRec.ChID = b_SRecD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SRecD.TaxSum),0) FROM b_SRecD WITH(NOLOCK)  WHERE b_SRec.ChID = b_SRecD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SRecD.SumCC_wt),0) FROM b_SRecD WITH(NOLOCK)  WHERE b_SRec.ChID = b_SRecD.ChID)
  FROM b_SRec

/* Основные средства: Ремонт (ТМЦ) */
  UPDATE b_SRep
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SRepDP.SumCC_nt),0) FROM b_SRepDP WITH(NOLOCK)  WHERE b_SRep.ChID = b_SRepDP.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SRepDP.TaxSum),0) FROM b_SRepDP WITH(NOLOCK)  WHERE b_SRep.ChID = b_SRepDP.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SRepDP.SumCC_wt),0) FROM b_SRepDP WITH(NOLOCK)  WHERE b_SRep.ChID = b_SRepDP.ChID)
  FROM b_SRep

/* Основные средства: Инвентаризация (Данные) */
  UPDATE b_SVen
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SVenD.SumCC_nt),0) FROM b_SVenD WITH(NOLOCK)  WHERE b_SVen.ChID = b_SVenD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SVenD.TaxSum),0) FROM b_SVenD WITH(NOLOCK)  WHERE b_SVen.ChID = b_SVenD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SVenD.SumCC_wt),0) FROM b_SVenD WITH(NOLOCK)  WHERE b_SVen.ChID = b_SVenD.ChID),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(b_SVenD.NewSumCC_nt),0) FROM b_SVenD WITH(NOLOCK)  WHERE b_SVen.ChID = b_SVenD.ChID),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(b_SVenD.NewTaxSum),0) FROM b_SVenD WITH(NOLOCK)  WHERE b_SVen.ChID = b_SVenD.ChID),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(b_SVenD.NewSumCC_wt),0) FROM b_SVenD WITH(NOLOCK)  WHERE b_SVen.ChID = b_SVenD.ChID)
  FROM b_SVen

/* Основные средства: Износ (Данные) */
  UPDATE b_SWer
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_SWerD.SumCC_nt),0) FROM b_SWerD WITH(NOLOCK)  WHERE b_SWer.ChID = b_SWerD.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_SWerD.TaxSum),0) FROM b_SWerD WITH(NOLOCK)  WHERE b_SWer.ChID = b_SWerD.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_SWerD.SumCC_wt),0) FROM b_SWerD WITH(NOLOCK)  WHERE b_SWer.ChID = b_SWerD.ChID)
  FROM b_SWer

/* Путевой лист (ТМЦ) */
  UPDATE b_WBill
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(b_WBillA.SumCC_nt),0) FROM b_WBillA WITH(NOLOCK)  WHERE b_WBill.ChID = b_WBillA.ChID),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(b_WBillA.TaxSum),0) FROM b_WBillA WITH(NOLOCK)  WHERE b_WBill.ChID = b_WBillA.ChID),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(b_WBillA.SumCC_wt),0) FROM b_WBillA WITH(NOLOCK)  WHERE b_WBill.ChID = b_WBillA.ChID)
  FROM b_WBill

/* Зарплата: Выплата (Данные) */
  UPDATE b_LExp
  SET 
    TSumCC = TSumCC + (SELECT ISNULL(SUM(b_LExpD.SumCC),0) FROM b_LExpD WITH(NOLOCK)  WHERE b_LExp.ChID = b_LExpD.ChID)
  FROM b_LExp

/* Зарплата: Начисление (Данные) */
  UPDATE b_LRec
  SET 
    TAdvanceCC = TAdvanceCC + (SELECT ISNULL(SUM(b_LRecD.AdvanceCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TAlimonyCC = TAlimonyCC + (SELECT ISNULL(SUM(b_LRecD.AlimonyCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TChargeCC = TChargeCC + (SELECT ISNULL(SUM(b_LRecD.ChargeCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TCRateCC = TCRateCC + (SELECT ISNULL(SUM(b_LRecD.CRateCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TEmpTaxCC = TEmpTaxCC + (SELECT ISNULL(SUM(b_LRecD.EmpTaxCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TIncomeTaxCC = TIncomeTaxCC + (SELECT ISNULL(SUM(b_LRecD.IncomeTaxCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TInsureCC = TInsureCC + (SELECT ISNULL(SUM(b_LRecD.InsureCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TInsureTaxCC = TInsureTaxCC + (SELECT ISNULL(SUM(b_LRecD.InsureTaxCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TLeaveCC = TLeaveCC + (SELECT ISNULL(SUM(b_LRecD.LeaveCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TLoanCC = TLoanCC + (SELECT ISNULL(SUM(b_LRecD.LoanCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMChargeCC = TMChargeCC + (SELECT ISNULL(SUM(b_LRecD.MChargeCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMChargeCC1 = TMChargeCC1 + (SELECT ISNULL(SUM(b_LRecD.MChargeCC1),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMChargeCC2 = TMChargeCC2 + (SELECT ISNULL(SUM(b_LRecD.MChargeCC2),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMHelpCC = TMHelpCC + (SELECT ISNULL(SUM(b_LRecD.MHelpCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMoreCC = TMoreCC + (SELECT ISNULL(SUM(b_LRecD.MoreCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMoreCC1 = TMoreCC1 + (SELECT ISNULL(SUM(b_LRecD.MoreCC1),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TMoreCC2 = TMoreCC2 + (SELECT ISNULL(SUM(b_LRecD.MoreCC2),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TNLeaveCC = TNLeaveCC + (SELECT ISNULL(SUM(b_LRecD.NLeaveCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TPensionTaxCC = TPensionTaxCC + (SELECT ISNULL(SUM(b_LRecD.PensionTaxCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TPregCC = TPregCC + (SELECT ISNULL(SUM(b_LRecD.PregCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TSickCC = TSickCC + (SELECT ISNULL(SUM(b_LRecD.SickCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID),
    TUnionCC = TUnionCC + (SELECT ISNULL(SUM(b_LRecD.UnionCC),0) FROM b_LRecD WITH(NOLOCK)  WHERE b_LRec.ChID = b_LRecD.ChID)
  FROM b_LRec

/* ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
  UPDATE b_PCostD
  SET 
    ExpPosProdCostCC = ExpPosProdCostCC + (SELECT ISNULL(SUM(b_PCostDDExpProds.DetSumCC_nt),0) FROM b_PCostDDExpProds WITH(NOLOCK)  WHERE b_PCostD.AChID = b_PCostDDExpProds.AChID)
  FROM b_PCostD

/* ТМЦ: Формирование себестоимости (Прочие расходы по позиции) */
  UPDATE b_PCostD
  SET 
    ExpPosCostCC = ExpPosCostCC + (SELECT ISNULL(SUM(b_PCostDDExp.DetSumCC_nt),0) FROM b_PCostDDExp WITH(NOLOCK)  WHERE b_PCostD.AChID = b_PCostDDExp.AChID)
  FROM b_PCostD

/* ТМЦ: Формирование себестоимости (Прочие расходы) */
  UPDATE b_PCost
  SET 
    TExpCostCC = TExpCostCC + (SELECT ISNULL(SUM(b_PCostDExp.DetSumCC_nt),0) FROM b_PCostDExp WITH(NOLOCK)  WHERE b_PCost.ChID = b_PCostDExp.ChID)
  FROM b_PCost

/* ТМЦ: Формирование себестоимости (ТМЦ) */
  UPDATE b_PCost
  SET 
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(b_PCostD.NewSumCC_nt),0) FROM b_PCostD WITH(NOLOCK)  WHERE b_PCost.ChID = b_PCostD.ChID),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(b_PCostD.NewTaxSum),0) FROM b_PCostD WITH(NOLOCK)  WHERE b_PCost.ChID = b_PCostD.ChID),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(b_PCostD.NewSumCC_wt),0) FROM b_PCostD WITH(NOLOCK)  WHERE b_PCost.ChID = b_PCostD.ChID),
    TExpPosProdCostCC = TExpPosProdCostCC + (SELECT ISNULL(SUM(b_PCostD.ExpPosProdCostCC),0) FROM b_PCostD WITH(NOLOCK)  WHERE b_PCost.ChID = b_PCostD.ChID),
    TExpPosCostCC = TExpPosCostCC + (SELECT ISNULL(SUM(b_PCostD.ExpPosCostCC),0) FROM b_PCostD WITH(NOLOCK)  WHERE b_PCost.ChID = b_PCostD.ChID)
  FROM b_PCost


  /* Логирование расчета */
  INSERT z_LogAU (AUGroupCode, UserCode)
  VALUES  (4, dbo.zf_GetUserCode())
GO
