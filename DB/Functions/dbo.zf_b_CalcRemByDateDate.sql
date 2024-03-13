SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_b_CalcRemByDateDate](@BDate smalldatetime, @EDate smalldatetime)
RETURNS @out table(OurID int NULL, StockID int NULL, ProdID int NULL, PPID int NULL, Qty numeric(21, 9) NULL)
AS
BEGIN
  IF @BDate IS NULL SET @BDate = '1900-01-01'
  IF @EDate IS NULL SET @EDate = '2079-06-06'

  INSERT @out
  SELECT OurID, StockID, ProdID, PPID, SUM(Qty) FROM (

/* Авансовый отчет (Заголовок) */
    SELECT DISTINCT b_RepA.OurID OurID, b_RepADP.StockID StockID, b_RepADP.ProdID ProdID, b_RepADP.PPID PPID, SUM(b_RepADP.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_RepADP WITH (NOLOCK), b_RepA WITH(NOLOCK)
     WHERE b_RepADP.ProdID = r_Prods.ProdID AND b_RepA.ChID = b_RepADP.ChID AND (r_Prods.InRems <> 0) AND (b_RepA.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_RepA.OurID, b_RepADP.StockID, b_RepADP.ProdID, b_RepADP.PPID

  UNION ALL

/* Авансовый отчет валютный (Заголовок) */
    SELECT DISTINCT b_ARepA.OurID OurID, b_ARepADP.StockID StockID, b_ARepADP.ProdID ProdID, b_ARepADP.PPID PPID, SUM(b_ARepADP.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_ARepADP WITH (NOLOCK), b_ARepA WITH(NOLOCK)
     WHERE b_ARepADP.ProdID = r_Prods.ProdID AND b_ARepA.ChID = b_ARepADP.ChID AND (r_Prods.InRems <> 0) AND (b_ARepA.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_ARepA.OurID, b_ARepADP.StockID, b_ARepADP.ProdID, b_ARepADP.PPID

  UNION ALL

/* Авансовый отчет с признаками (Заголовок) */
    SELECT DISTINCT b_CRepA.OurID OurID, b_CRepADP.StockID StockID, b_CRepADP.ProdID ProdID, b_CRepADP.PPID PPID, SUM(b_CRepADP.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_CRepADP WITH (NOLOCK), b_CRepA WITH(NOLOCK)
     WHERE b_CRepADP.ProdID = r_Prods.ProdID AND b_CRepA.ChID = b_CRepADP.ChID AND (r_Prods.InRems <> 0) AND (b_CRepA.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_CRepA.OurID, b_CRepADP.StockID, b_CRepADP.ProdID, b_CRepADP.PPID

  UNION ALL

/* Входящий баланс: ТМЦ */
    SELECT DISTINCT b_zInP.OurID OurID, b_zInP.StockID StockID, b_zInP.ProdID ProdID, b_zInP.PPID PPID, SUM(b_zInP.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_zInP WITH(NOLOCK)
     WHERE b_zInP.ProdID = r_Prods.ProdID AND (r_Prods.InRems <> 0)
    GROUP BY b_zInP.OurID, b_zInP.StockID, b_zInP.ProdID, b_zInP.PPID

  UNION ALL

/* ТМЦ: Внутренний расход (Заголовок) */
    SELECT DISTINCT b_Exp.OurID OurID, b_Exp.StockID StockID, b_ExpD.ProdID ProdID, b_ExpD.PPID PPID, -SUM(b_ExpD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_ExpD WITH (NOLOCK), b_Exp WITH(NOLOCK)
     WHERE b_ExpD.ProdID = r_Prods.ProdID AND b_Exp.ChID = b_ExpD.ChID AND (r_Prods.InRems <> 0) AND (b_Exp.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_Exp.OurID, b_Exp.StockID, b_ExpD.ProdID, b_ExpD.PPID

  UNION ALL

/* ТМЦ: Возврат от получателя (Заголовок) */
    SELECT DISTINCT b_Ret.OurID OurID, b_Ret.StockID StockID, b_RetD.ProdID ProdID, b_RetD.PPID PPID, SUM(b_RetD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_RetD WITH (NOLOCK), b_Ret WITH(NOLOCK)
     WHERE b_RetD.ProdID = r_Prods.ProdID AND b_Ret.ChID = b_RetD.ChID AND (r_Prods.InRems <> 0) AND (b_Ret.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_Ret.OurID, b_Ret.StockID, b_RetD.ProdID, b_RetD.PPID

  UNION ALL

/* ТМЦ: Возврат поставщику (Заголовок) */
    SELECT DISTINCT b_CRet.OurID OurID, b_CRet.StockID StockID, b_CRetD.ProdID ProdID, b_CRetD.PPID PPID, -SUM(b_CRetD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_CRetD WITH (NOLOCK), b_CRet WITH(NOLOCK)
     WHERE b_CRetD.ProdID = r_Prods.ProdID AND b_CRet.ChID = b_CRetD.ChID AND (r_Prods.InRems <> 0) AND (b_CRet.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_CRet.OurID, b_CRet.StockID, b_CRetD.ProdID, b_CRetD.PPID

  UNION ALL

/* ТМЦ: Инвентаризация (Заголовок) */
    SELECT DISTINCT b_PVen.OurID OurID, b_PVen.StockID StockID, b_PVenD.DetProdID ProdID, b_PVenD.PPID PPID, -SUM(b_PVenD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), b_PVen WITH(NOLOCK)
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID
     AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0) AND (b_PVen.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PVen.OurID, b_PVen.StockID, b_PVenD.DetProdID, b_PVenD.PPID

  UNION ALL

/* ТМЦ: Инвентаризация (Заголовок) */
    SELECT DISTINCT b_PVen.OurID OurID, b_PVen.StockID StockID, b_PVenD.DetProdID ProdID, b_PVenD.PPID PPID, SUM(b_PVenD.NewQty) Qty
    FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), b_PVenA WITH (NOLOCK), b_PVenD WITH (NOLOCK), b_PVen WITH(NOLOCK)
     WHERE t_PInP.ProdID = r_Prods.ProdID AND b_PVenD.DetProdID = t_PInP.ProdID AND b_PVenD.PPID = t_PInP.PPID AND b_PVen.ChID = b_PVenA.ChID AND b_PVenA.ChID = b_PVenD.ChID
     AND b_PVenA.ProdID = b_PVenD.DetProdID AND (r_Prods.InRems <> 0) AND (b_PVen.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PVen.OurID, b_PVen.StockID, b_PVenD.DetProdID, b_PVenD.PPID

  UNION ALL

/* ТМЦ: Перемещение (Заголовок) */
    SELECT DISTINCT b_PExc.OurID OurID, b_PExc.StockID StockID, b_PExcD.ProdID ProdID, b_PExcD.PPID PPID, -SUM(b_PExcD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_PExcD WITH (NOLOCK), b_PExc WITH(NOLOCK)
     WHERE b_PExcD.ProdID = r_Prods.ProdID AND b_PExc.ChID = b_PExcD.ChID AND (r_Prods.InRems <> 0) AND (b_PExc.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PExc.OurID, b_PExc.StockID, b_PExcD.ProdID, b_PExcD.PPID

  UNION ALL

/* ТМЦ: Перемещение (Заголовок) */
    SELECT DISTINCT b_PExc.OurID OurID, b_PExc.NewStockID StockID, b_PExcD.ProdID ProdID, b_PExcD.PPID PPID, SUM(b_PExcD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_PExcD WITH (NOLOCK), b_PExc WITH(NOLOCK)
     WHERE b_PExcD.ProdID = r_Prods.ProdID AND b_PExc.ChID = b_PExcD.ChID AND (r_Prods.InRems <> 0) AND (b_PExc.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PExc.OurID, b_PExc.NewStockID, b_PExcD.ProdID, b_PExcD.PPID

  UNION ALL

/* ТМЦ: Переоценка партий (Заголовок) */
    SELECT DISTINCT b_PEst.OurID OurID, b_PEst.StockID StockID, b_PEstD.ProdID ProdID, b_PEstD.PPID PPID, -SUM(b_PEstD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_PEstD WITH (NOLOCK), b_PEst WITH(NOLOCK)
     WHERE b_PEstD.ProdID = r_Prods.ProdID AND b_PEst.ChID = b_PEstD.ChID AND (r_Prods.InRems <> 0) AND (b_PEst.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PEst.OurID, b_PEst.StockID, b_PEstD.ProdID, b_PEstD.PPID

  UNION ALL

/* ТМЦ: Переоценка партий (Заголовок) */
    SELECT DISTINCT b_PEst.OurID OurID, b_PEst.StockID StockID, b_PEstD.ProdID ProdID, b_PEstD.NewPPID PPID, SUM(b_PEstD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_PEstD WITH (NOLOCK), b_PEst WITH(NOLOCK)
     WHERE b_PEstD.ProdID = r_Prods.ProdID AND b_PEst.ChID = b_PEstD.ChID AND (r_Prods.InRems <> 0) AND (b_PEst.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PEst.OurID, b_PEst.StockID, b_PEstD.ProdID, b_PEstD.NewPPID

  UNION ALL

/* ТМЦ: Приход по ГТД (Заголовок) */
    SELECT DISTINCT b_Cst.OurID OurID, b_Cst.StockID StockID, b_CstD.ProdID ProdID, b_CstD.PPID PPID, SUM(b_CstD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_CstD WITH (NOLOCK), b_Cst WITH(NOLOCK)
     WHERE b_CstD.ProdID = r_Prods.ProdID AND b_Cst.ChID = b_CstD.ChID AND (r_Prods.InRems <> 0) AND (b_Cst.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_Cst.OurID, b_Cst.StockID, b_CstD.ProdID, b_CstD.PPID

  UNION ALL

/* ТМЦ: Приход по накладной (Заголовок) */
    SELECT DISTINCT b_Rec.OurID OurID, b_Rec.StockID StockID, b_RecD.ProdID ProdID, b_RecD.PPID PPID, SUM(b_RecD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_RecD WITH (NOLOCK), b_Rec WITH(NOLOCK)
     WHERE b_RecD.ProdID = r_Prods.ProdID AND b_Rec.ChID = b_RecD.ChID AND (r_Prods.InRems <> 0) AND (b_Rec.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_Rec.OurID, b_Rec.StockID, b_RecD.ProdID, b_RecD.PPID

  UNION ALL

/* ТМЦ: Расход по ГТД (Заголовок) */
    SELECT DISTINCT b_CInv.OurID OurID, b_CInv.StockID StockID, b_CInvD.ProdID ProdID, b_CInvD.PPID PPID, -SUM(b_CInvD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_CInvD WITH (NOLOCK), b_CInv WITH(NOLOCK)
     WHERE b_CInvD.ProdID = r_Prods.ProdID AND b_CInv.ChID = b_CInvD.ChID AND (r_Prods.InRems <> 0) AND (b_CInv.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_CInv.OurID, b_CInv.StockID, b_CInvD.ProdID, b_CInvD.PPID

  UNION ALL

/* ТМЦ: Расходная накладная (Заголовок) */
    SELECT DISTINCT b_Inv.OurID OurID, b_Inv.StockID StockID, b_InvD.ProdID ProdID, b_InvD.PPID PPID, -SUM(b_InvD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_InvD WITH (NOLOCK), b_Inv WITH(NOLOCK)
     WHERE b_InvD.ProdID = r_Prods.ProdID AND b_Inv.ChID = b_InvD.ChID AND (r_Prods.InRems <> 0) AND (b_Inv.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_Inv.OurID, b_Inv.StockID, b_InvD.ProdID, b_InvD.PPID

  UNION ALL

/* ТМЦ: Формирование себестоимости (Заголовок) */
    SELECT DISTINCT b_PCost.OurID OurID, b_PCost.StockID StockID, b_PCostD.ProdID ProdID, b_PCostD.NewPPID PPID, SUM(b_PCostD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), b_PCost WITH(NOLOCK)
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCost.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PCost.OurID, b_PCost.StockID, b_PCostD.ProdID, b_PCostD.NewPPID

  UNION ALL

/* ТМЦ: Формирование себестоимости (Заголовок) */
    SELECT DISTINCT b_PCost.OurID OurID, b_PCost.StockID StockID, b_PCostD.ProdID ProdID, b_PCostD.PPID PPID, -SUM(b_PCostD.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_PCostD WITH (NOLOCK), b_PCost WITH(NOLOCK)
     WHERE b_PCostD.ProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND (r_Prods.InRems <> 0) AND (b_PCostD.PPID <> 0) AND (b_PCost.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_PCost.OurID, b_PCost.StockID, b_PCostD.ProdID, b_PCostD.PPID

  UNION ALL

/* ТМЦ: Формирование себестоимости (Списание ТМЦ по позиции) */
    SELECT DISTINCT b_PCost.OurID OurID, b_PCost.StockID StockID, b_PCostDDExpProds.DetProdID ProdID, b_PCostDDExpProds.DetPPID PPID, -SUM(b_PCostDDExpProds.DetQty) Qty
    FROM r_Prods WITH (NOLOCK), b_PCost WITH (NOLOCK), b_PCostD WITH (NOLOCK), b_PCostDDExpProds WITH(NOLOCK)
     WHERE b_PCostDDExpProds.DetProdID = r_Prods.ProdID AND b_PCost.ChID = b_PCostD.ChID AND b_PCostD.AChID = b_PCostDDExpProds.AChID AND (r_Prods.InRems <> 0)
    GROUP BY b_PCost.OurID, b_PCost.StockID, b_PCostDDExpProds.DetProdID, b_PCostDDExpProds.DetPPID

  UNION ALL

/* Основные средства: Ремонт (ТМЦ) b_SRepDP */
    SELECT DISTINCT b_SRep.OurID OurID, b_SRepDP.StockID StockID, b_SRepDP.ProdID ProdID, b_SRepDP.PPID PPID, -SUM(b_SRepDP.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_SRepDP WITH (NOLOCK), b_SRep WITH(NOLOCK)
     WHERE b_SRepDP.ProdID = r_Prods.ProdID AND b_SRep.ChID = b_SRepDP.ChID AND (r_Prods.InRems <> 0) AND (b_SRep.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_SRep.OurID, b_SRepDP.StockID, b_SRepDP.ProdID, b_SRepDP.PPID

  UNION ALL

/* Путевой лист (ТМЦ) */
    SELECT DISTINCT b_WBill.OurID OurID, b_WBillA.StockID StockID, b_WBillA.ProdID ProdID, b_WBillA.PPID PPID, -SUM(b_WBillA.Qty) Qty
    FROM r_Prods WITH (NOLOCK), b_WBillA WITH (NOLOCK), b_WBill WITH(NOLOCK)
     WHERE b_WBillA.ProdID = r_Prods.ProdID AND b_WBill.ChID = b_WBillA.ChID AND (r_Prods.InRems <> 0) AND (b_WBill.DocDate BETWEEN @BDate AND @EDate)
    GROUP BY b_WBill.OurID, b_WBillA.StockID, b_WBillA.ProdID, b_WBillA.PPID

) q
GROUP BY OurID,StockID,ProdID,PPID
RETURN
END
GO
