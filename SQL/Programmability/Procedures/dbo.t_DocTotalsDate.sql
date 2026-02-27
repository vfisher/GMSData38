SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DocTotalsDate](@BDate datetime, @EDate datetime)
AS
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

  UPDATE b_Ret
  SET
    TLevySum = 0, 
    TRealSum = 0, 
    TSumCC_In = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_Acc
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Cos
  SET
    TSpendSumCC = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_CRet
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_CRRet
  SET
    TLevySum = 0, 
    TRealSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_Cst
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumCC_In = 0, 
    TTaxSum = 0

  UPDATE t_Dis
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0

  UPDATE t_EOExp
  SET
    TNewSumAC = 0, 
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC = 0

  UPDATE t_EORec
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC = 0

  UPDATE t_Epp
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Est
  SET
    TNewSumAC_nt = 0, 
    TNewSumAC_wt = 0, 
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TNewTaxSumAC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Exc
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Exp
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Inv
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_IOExp
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_IORec
  SET
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_Rec
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Ret
  SET
    TRouteSumCC = 0, 
    TSpendSumCC = 0, 
    TSumAC_nt = 0, 
    TSumAC_wt = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0, 
    TTaxSumAC = 0

  UPDATE t_Sale
  SET
    TLevySum = 0, 
    TPurSumCC_nt = 0, 
    TPurSumCC_wt = 0, 
    TPurTaxSum = 0, 
    TRealSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_SExp
  SET
    TCostSumCC = 0, 
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSetSumCC = 0, 
    TSubNewSumCC_nt = 0, 
    TSubNewSumCC_wt = 0, 
    TSubNewTaxSum = 0, 
    TSubSumCC_nt = 0, 
    TSubSumCC_wt = 0, 
    TSubTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_SPExp
  SET
    TCostSumCC = 0, 
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSetSumCC = 0, 
    TSubNewSumCC_nt = 0, 
    TSubNewSumCC_wt = 0, 
    TSubNewTaxSum = 0, 
    TSubSumCC_nt = 0, 
    TSubSumCC_wt = 0, 
    TSubTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_SPRec
  SET
    TCostSumCC = 0, 
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSetSumCC = 0, 
    TSubNewSumCC_nt = 0, 
    TSubNewSumCC_wt = 0, 
    TSubNewTaxSum = 0, 
    TSubSumCC_nt = 0, 
    TSubSumCC_wt = 0, 
    TSubTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_SRec
  SET
    TCostSumCC = 0, 
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSetSumCC = 0, 
    TSubNewSumCC_nt = 0, 
    TSubNewSumCC_wt = 0, 
    TSubNewTaxSum = 0, 
    TSubSumCC_nt = 0, 
    TSubSumCC_wt = 0, 
    TSubTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0

  UPDATE t_Ven
  SET
    TNewSumCC_nt = 0, 
    TNewSumCC_wt = 0, 
    TNewTaxSum = 0, 
    TSumCC_nt = 0, 
    TSumCC_wt = 0, 
    TTaxSum = 0
/* Счет на оплату товара: Затраты */
  UPDATE t_Acc
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_AccSpends.SpendSumCC),0) FROM t_AccSpends WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccSpends.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Acc

/* Счет на оплату товара: Маршрут */
  UPDATE t_Acc
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_AccRoutes.RouteSumCC),0) FROM t_AccRoutes WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccRoutes.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Acc

/* Приход товара: Затраты */
  UPDATE t_Rec
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_RecSpends.SpendSumCC),0) FROM t_RecSpends WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecSpends.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Rec

/* Приход товара: Маршрут */
  UPDATE t_Rec
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_RecRoutes.RouteSumCC),0) FROM t_RecRoutes WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecRoutes.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Rec

/* Возврат товара от получателя: Затраты */
  UPDATE t_Ret
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_RetSpends.SpendSumCC),0) FROM t_RetSpends WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetSpends.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Ret

/* Возврат товара от получателя: Маршрут */
  UPDATE t_Ret
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_RetRoutes.RouteSumCC),0) FROM t_RetRoutes WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetRoutes.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Ret

/* Возврат товара по чеку: Товар */
  UPDATE t_CRRet
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_CRRetD.SumCC_nt),0) FROM t_CRRetD WITH(NOLOCK)  WHERE t_CRRet.ChID = t_CRRetD.ChID AND (t_CRRet.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_CRRetD.TaxSum),0) FROM t_CRRetD WITH(NOLOCK)  WHERE t_CRRet.ChID = t_CRRetD.ChID AND (t_CRRet.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_CRRetD.SumCC_wt),0) FROM t_CRRetD WITH(NOLOCK)  WHERE t_CRRet.ChID = t_CRRetD.ChID AND (t_CRRet.DocDate BETWEEN @BDate AND @EDate)),
    TRealSum = TRealSum + (SELECT ISNULL(SUM(t_CRRetD.RealSum),0) FROM t_CRRetD WITH(NOLOCK)  WHERE t_CRRet.ChID = t_CRRetD.ChID AND (t_CRRet.DocDate BETWEEN @BDate AND @EDate))
  FROM t_CRRet

/* Возврат товара поставщику: Затраты */
  UPDATE t_CRet
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_CRetSpends.SpendSumCC),0) FROM t_CRetSpends WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetSpends.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate))
  FROM t_CRet

/* Возврат товара поставщику: Маршрут */
  UPDATE t_CRet
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_CRetRoutes.RouteSumCC),0) FROM t_CRetRoutes WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetRoutes.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate))
  FROM t_CRet

/* Расходная накладная: Затраты */
  UPDATE t_Inv
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_InvSpends.SpendSumCC),0) FROM t_InvSpends WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvSpends.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Inv

/* Расходная накладная: Маршрут */
  UPDATE t_Inv
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_InvRoutes.RouteSumCC),0) FROM t_InvRoutes WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvRoutes.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Inv

/* Расходный документ: Затраты */
  UPDATE t_Exp
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_ExpSpends.SpendSumCC),0) FROM t_ExpSpends WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpSpends.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Exp

/* Расходный документ: Маршрут */
  UPDATE t_Exp
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_ExpRoutes.RouteSumCC),0) FROM t_ExpRoutes WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpRoutes.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Exp

/* Расходный документ в ценах прихода: Затраты */
  UPDATE t_Epp
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_EppSpends.SpendSumCC),0) FROM t_EppSpends WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppSpends.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Epp

/* Расходный документ в ценах прихода: Маршрут */
  UPDATE t_Epp
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_EppRoutes.RouteSumCC),0) FROM t_EppRoutes WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppRoutes.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Epp

/* Перемещение товара: Затраты */
  UPDATE t_Exc
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_ExcSpends.SpendSumCC),0) FROM t_ExcSpends WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcSpends.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Exc

/* Перемещение товара: Маршрут */
  UPDATE t_Exc
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_ExcRoutes.RouteSumCC),0) FROM t_ExcRoutes WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcRoutes.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Exc

/* Инвентаризация товара: Товар */
  UPDATE t_Ven
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_VenA.TSumCC_nt),0) FROM t_VenA WITH(NOLOCK)  WHERE t_Ven.ChID = t_VenA.ChID AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_VenA.TTaxSum),0) FROM t_VenA WITH(NOLOCK)  WHERE t_Ven.ChID = t_VenA.ChID AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_VenA.TSumCC_wt),0) FROM t_VenA WITH(NOLOCK)  WHERE t_Ven.ChID = t_VenA.ChID AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_VenA.TNewSumCC_nt),0) FROM t_VenA WITH(NOLOCK)  WHERE t_Ven.ChID = t_VenA.ChID AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_VenA.TNewTaxSum),0) FROM t_VenA WITH(NOLOCK)  WHERE t_Ven.ChID = t_VenA.ChID AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_VenA.TNewSumCC_wt),0) FROM t_VenA WITH(NOLOCK)  WHERE t_Ven.ChID = t_VenA.ChID AND (t_Ven.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Ven

/* Продажа товара оператором: Продажи товара */
  UPDATE t_Sale
  SET 
    TPurSumCC_nt = TPurSumCC_nt + (SELECT ISNULL(SUM(t_SaleD.PurPriceCC_nt * t_SaleD.Qty),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)),
    TPurTaxSum = TPurTaxSum + (SELECT ISNULL(SUM(t_SaleD.PurTax * t_SaleD.Qty),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)),
    TPurSumCC_wt = TPurSumCC_wt + (SELECT ISNULL(SUM(t_SaleD.PurPriceCC_wt * t_SaleD.Qty),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_SaleD.SumCC_nt),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_SaleD.TaxSum),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_SaleD.SumCC_wt),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)),
    TRealSum = TRealSum + (SELECT ISNULL(SUM(t_SaleD.RealSum),0) FROM t_SaleD WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleD.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Sale

/* Формирование себестоимости: Товар */
  UPDATE t_Cos
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_CosD.SumCC_nt),0) FROM t_CosD WITH(NOLOCK)  WHERE t_Cos.ChID = t_CosD.ChID AND (t_Cos.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_CosD.TaxSum),0) FROM t_CosD WITH(NOLOCK)  WHERE t_Cos.ChID = t_CosD.ChID AND (t_Cos.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_CosD.SumCC_wt),0) FROM t_CosD WITH(NOLOCK)  WHERE t_Cos.ChID = t_CosD.ChID AND (t_Cos.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Cos

/* Заказ внешний: Формирование: Товар */
  UPDATE t_EOExp
  SET 
    TSumAC = TSumAC + (SELECT ISNULL(SUM(t_EOExpD.SumAC),0) FROM t_EOExpD WITH(NOLOCK)  WHERE t_EOExp.ChID = t_EOExpD.ChID AND (t_EOExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumAC = TNewSumAC + (SELECT ISNULL(SUM(t_EOExpD.NewSumAC),0) FROM t_EOExpD WITH(NOLOCK)  WHERE t_EOExp.ChID = t_EOExpD.ChID AND (t_EOExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_EOExp

/* Заказ внешний: Формирование: Затраты */
  UPDATE t_EOExp
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_EOExpSpends.SpendSumCC),0) FROM t_EOExpSpends WITH(NOLOCK)  WHERE t_EOExp.ChID = t_EOExpSpends.ChID AND (t_EOExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_EOExp

/* Заказ внешний: Формирование: Маршрут */
  UPDATE t_EOExp
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_EOExpRoutes.RouteSumCC),0) FROM t_EOExpRoutes WITH(NOLOCK)  WHERE t_EOExp.ChID = t_EOExpRoutes.ChID AND (t_EOExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_EOExp

/* Заказ внешний: Обработка: Товар */
  UPDATE t_EORec
  SET 
    TSumAC = TSumAC + (SELECT ISNULL(SUM(t_EORecD.SumAC),0) FROM t_EORecD WITH(NOLOCK)  WHERE t_EORec.ChID = t_EORecD.ChID AND (t_EORec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_EORec

/* Заказ внешний: Обработка: Затраты */
  UPDATE t_EORec
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_EORecSpends.SpendSumCC),0) FROM t_EORecSpends WITH(NOLOCK)  WHERE t_EORec.ChID = t_EORecSpends.ChID AND (t_EORec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_EORec

/* Заказ внешний: Обработка: Маршрут */
  UPDATE t_EORec
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_EORecRoutes.RouteSumCC),0) FROM t_EORecRoutes WITH(NOLOCK)  WHERE t_EORec.ChID = t_EORecRoutes.ChID AND (t_EORec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_EORec

/* Заказ внутренний: Формирование: Товар */
  UPDATE t_IORec
  SET 
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_IORecD.NewSumCC_nt),0) FROM t_IORecD WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecD.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_IORecD.NewTaxSum),0) FROM t_IORecD WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecD.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_IORecD.NewSumCC_wt),0) FROM t_IORecD WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecD.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_IORecD.SumCC_nt),0) FROM t_IORecD WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecD.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_IORecD.TaxSum),0) FROM t_IORecD WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecD.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_IORecD.SumCC_wt),0) FROM t_IORecD WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecD.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_IORec

/* Заказ внутренний: Формирование: Затраты */
  UPDATE t_IORec
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_IORecSpends.SpendSumCC),0) FROM t_IORecSpends WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecSpends.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_IORec

/* Заказ внутренний: Формирование: Маршрут */
  UPDATE t_IORec
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_IORecRoutes.RouteSumCC),0) FROM t_IORecRoutes WITH(NOLOCK)  WHERE t_IORec.ChID = t_IORecRoutes.ChID AND (t_IORec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_IORec

/* Заказ внутренний: Обработка: Товар */
  UPDATE t_IOExp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_IOExpD.SumCC_nt),0) FROM t_IOExpD WITH(NOLOCK)  WHERE t_IOExp.ChID = t_IOExpD.ChID AND (t_IOExp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_IOExpD.TaxSum),0) FROM t_IOExpD WITH(NOLOCK)  WHERE t_IOExp.ChID = t_IOExpD.ChID AND (t_IOExp.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_IOExpD.SumCC_wt),0) FROM t_IOExpD WITH(NOLOCK)  WHERE t_IOExp.ChID = t_IOExpD.ChID AND (t_IOExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_IOExp

/* Заказ внутренний: Обработка: Затраты */
  UPDATE t_IOExp
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_IOExpSpends.SpendSumCC),0) FROM t_IOExpSpends WITH(NOLOCK)  WHERE t_IOExp.ChID = t_IOExpSpends.ChID AND (t_IOExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_IOExp

/* Заказ внутренний: Обработка: Маршрут */
  UPDATE t_IOExp
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_IOExpRoutes.RouteSumCC),0) FROM t_IOExpRoutes WITH(NOLOCK)  WHERE t_IOExp.ChID = t_IOExpRoutes.ChID AND (t_IOExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_IOExp

/* Распределение товара: Затраты */
  UPDATE t_Dis
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_DisSpends.SpendSumCC),0) FROM t_DisSpends WITH(NOLOCK)  WHERE t_Dis.ChID = t_DisSpends.ChID AND (t_Dis.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Dis

/* Распределение товара: Маршрут */
  UPDATE t_Dis
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_DisRoutes.RouteSumCC),0) FROM t_DisRoutes WITH(NOLOCK)  WHERE t_Dis.ChID = t_DisRoutes.ChID AND (t_Dis.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Dis

/* Планирование: Комплектация: Общие Затраты */
  UPDATE t_SPRec
  SET 
    TCostSumCC = TCostSumCC + (SELECT ISNULL(SUM(t_SPRecM.CostSumCC),0) FROM t_SPRecM WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecM.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPRec

/* Планирование: Комплектация: Комплекты */
  UPDATE t_SPRec
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_SPRecA.SumCC_nt),0) FROM t_SPRecA WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_SPRecA.TaxSum),0) FROM t_SPRecA WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_SPRecA.SumCC_wt),0) FROM t_SPRecA WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_SPRecA.NewSumCC_nt),0) FROM t_SPRecA WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_SPRecA.NewTaxSum),0) FROM t_SPRecA WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_SPRecA.NewSumCC_wt),0) FROM t_SPRecA WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPRec

/* Планирование: Комплектация: Составляющие */
  UPDATE t_SPRec
  SET 
    TSubSumCC_nt = TSubSumCC_nt + (SELECT ISNULL(SUM(t_SPRecD.SubSumCC_nt),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecD WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecD.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubTaxSum = TSubTaxSum + (SELECT ISNULL(SUM(t_SPRecD.SubTaxSum),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecD WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecD.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubSumCC_wt = TSubSumCC_wt + (SELECT ISNULL(SUM(t_SPRecD.SubSumCC_wt),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecD WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecD.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_nt = TSubNewSumCC_nt + (SELECT ISNULL(SUM(t_SPRecD.SubNewSumCC_nt),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecD WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecD.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewTaxSum = TSubNewTaxSum + (SELECT ISNULL(SUM(t_SPRecD.SubNewTaxSum),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecD WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecD.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_wt = TSubNewSumCC_wt + (SELECT ISNULL(SUM(t_SPRecD.SubNewSumCC_wt),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecD WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecD.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPRec

/* Планирование: Комплектация: Затраты на комплекты */
  UPDATE t_SPRec
  SET 
    TSetSumCC = TSetSumCC + (SELECT ISNULL(SUM(t_SPRecE.SetSumCC),0) FROM t_SPRecA WITH (NOLOCK), t_SPRecE WITH(NOLOCK)  WHERE t_SPRec.ChID = t_SPRecA.ChID AND t_SPRecA.AChID = t_SPRecE.AChID AND (t_SPRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPRec

/* Планирование: Разукомплектация: Общие Затраты */
  UPDATE t_SPExp
  SET 
    TCostSumCC = TCostSumCC + (SELECT ISNULL(SUM(t_SPExpM.CostSumCC),0) FROM t_SPExpM WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpM.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPExp

/* Планирование: Разукомплектация: Комплекты */
  UPDATE t_SPExp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_SPExpA.SumCC_nt),0) FROM t_SPExpA WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_SPExpA.TaxSum),0) FROM t_SPExpA WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_SPExpA.SumCC_wt),0) FROM t_SPExpA WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_SPExpA.NewSumCC_nt),0) FROM t_SPExpA WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_SPExpA.NewTaxSum),0) FROM t_SPExpA WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_SPExpA.NewSumCC_wt),0) FROM t_SPExpA WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPExp

/* Планирование: Разукомплектация: Составляющие */
  UPDATE t_SPExp
  SET 
    TSubSumCC_nt = TSubSumCC_nt + (SELECT ISNULL(SUM(t_SPExpD.SubSumCC_nt),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpD WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpD.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubTaxSum = TSubTaxSum + (SELECT ISNULL(SUM(t_SPExpD.SubTaxSum),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpD WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpD.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubSumCC_wt = TSubSumCC_wt + (SELECT ISNULL(SUM(t_SPExpD.SubSumCC_wt),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpD WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpD.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_nt = TSubNewSumCC_nt + (SELECT ISNULL(SUM(t_SPExpD.SubNewSumCC_nt),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpD WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpD.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewTaxSum = TSubNewTaxSum + (SELECT ISNULL(SUM(t_SPExpD.SubNewTaxSum),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpD WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpD.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_wt = TSubNewSumCC_wt + (SELECT ISNULL(SUM(t_SPExpD.SubNewSumCC_wt),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpD WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpD.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPExp

/* Планирование: Разукомплектация: Затраты на комплекты */
  UPDATE t_SPExp
  SET 
    TSetSumCC = TSetSumCC + (SELECT ISNULL(SUM(t_SPExpE.SetSumCC),0) FROM t_SPExpA WITH (NOLOCK), t_SPExpE WITH(NOLOCK)  WHERE t_SPExp.ChID = t_SPExpA.ChID AND t_SPExpA.AChID = t_SPExpE.AChID AND (t_SPExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SPExp

/* Комплектация товара: Общие Затраты */
  UPDATE t_SRec
  SET 
    TCostSumCC = TCostSumCC + (SELECT ISNULL(SUM(t_SRecM.CostSumCC),0) FROM t_SRecM WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecM.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SRec

/* Комплектация товара: Комплекты */
  UPDATE t_SRec
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_SRecA.SumCC_nt),0) FROM t_SRecA WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_SRecA.TaxSum),0) FROM t_SRecA WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_SRecA.SumCC_wt),0) FROM t_SRecA WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_SRecA.NewSumCC_nt),0) FROM t_SRecA WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_SRecA.NewTaxSum),0) FROM t_SRecA WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_SRecA.NewSumCC_wt),0) FROM t_SRecA WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SRec

/* Комплектация товара: Составляющие */
  UPDATE t_SRec
  SET 
    TSubSumCC_nt = TSubSumCC_nt + (SELECT ISNULL(SUM(t_SRecD.SubSumCC_nt),0) FROM t_SRecA WITH (NOLOCK), t_SRecD WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubTaxSum = TSubTaxSum + (SELECT ISNULL(SUM(t_SRecD.SubTaxSum),0) FROM t_SRecA WITH (NOLOCK), t_SRecD WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubSumCC_wt = TSubSumCC_wt + (SELECT ISNULL(SUM(t_SRecD.SubSumCC_wt),0) FROM t_SRecA WITH (NOLOCK), t_SRecD WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_nt = TSubNewSumCC_nt + (SELECT ISNULL(SUM(t_SRecD.SubNewSumCC_nt),0) FROM t_SRecA WITH (NOLOCK), t_SRecD WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewTaxSum = TSubNewTaxSum + (SELECT ISNULL(SUM(t_SRecD.SubNewTaxSum),0) FROM t_SRecA WITH (NOLOCK), t_SRecD WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_wt = TSubNewSumCC_wt + (SELECT ISNULL(SUM(t_SRecD.SubNewSumCC_wt),0) FROM t_SRecA WITH (NOLOCK), t_SRecD WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SRec

/* Комплектация товара: Затраты на комплекты */
  UPDATE t_SRec
  SET 
    TSetSumCC = TSetSumCC + (SELECT ISNULL(SUM(t_SRecE.SetSumCC),0) FROM t_SRecA WITH (NOLOCK), t_SRecE WITH(NOLOCK)  WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecE.AChID AND (t_SRec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SRec

/* Разукомплектация товара: Общие Затраты */
  UPDATE t_SExp
  SET 
    TCostSumCC = TCostSumCC + (SELECT ISNULL(SUM(t_SExpM.CostSumCC),0) FROM t_SExpM WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpM.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SExp

/* Разукомплектация товара: Комплекты */
  UPDATE t_SExp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_SExpA.SumCC_nt),0) FROM t_SExpA WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_SExpA.TaxSum),0) FROM t_SExpA WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_SExpA.SumCC_wt),0) FROM t_SExpA WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_SExpA.NewSumCC_nt),0) FROM t_SExpA WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_SExpA.NewTaxSum),0) FROM t_SExpA WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_SExpA.NewSumCC_wt),0) FROM t_SExpA WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SExp

/* Разукомплектация товара: Составляющие */
  UPDATE t_SExp
  SET 
    TSubSumCC_nt = TSubSumCC_nt + (SELECT ISNULL(SUM(t_SExpD.SubSumCC_nt),0) FROM t_SExpA WITH (NOLOCK), t_SExpD WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubTaxSum = TSubTaxSum + (SELECT ISNULL(SUM(t_SExpD.SubTaxSum),0) FROM t_SExpA WITH (NOLOCK), t_SExpD WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubSumCC_wt = TSubSumCC_wt + (SELECT ISNULL(SUM(t_SExpD.SubSumCC_wt),0) FROM t_SExpA WITH (NOLOCK), t_SExpD WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_nt = TSubNewSumCC_nt + (SELECT ISNULL(SUM(t_SExpD.SubNewSumCC_nt),0) FROM t_SExpA WITH (NOLOCK), t_SExpD WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewTaxSum = TSubNewTaxSum + (SELECT ISNULL(SUM(t_SExpD.SubNewTaxSum),0) FROM t_SExpA WITH (NOLOCK), t_SExpD WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)),
    TSubNewSumCC_wt = TSubNewSumCC_wt + (SELECT ISNULL(SUM(t_SExpD.SubNewSumCC_wt),0) FROM t_SExpA WITH (NOLOCK), t_SExpD WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SExp

/* Разукомплектация товара: Затраты на комплекты */
  UPDATE t_SExp
  SET 
    TSetSumCC = TSetSumCC + (SELECT ISNULL(SUM(t_SExpE.SetSumCC),0) FROM t_SExpA WITH (NOLOCK), t_SExpE WITH(NOLOCK)  WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpE.AChID AND (t_SExp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_SExp

/* Приход товара по ГТД: Товар */
  UPDATE t_Cst
  SET 
    TSumCC_In = TSumCC_In + (SELECT ISNULL(SUM(t_CstD.SumCC_In),0) FROM t_CstD WITH(NOLOCK)  WHERE t_Cst.ChID = t_CstD.ChID AND (t_Cst.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_CstD.TaxSum),0) FROM t_CstD WITH(NOLOCK)  WHERE t_Cst.ChID = t_CstD.ChID AND (t_Cst.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Cst

/* Приход товара по ГТД: Маршрут */
  UPDATE t_Cst
  SET 
    TRouteSumCC = TRouteSumCC + (SELECT ISNULL(SUM(t_CstRoutes.RouteSumCC),0) FROM t_CstRoutes WITH(NOLOCK)  WHERE t_Cst.ChID = t_CstRoutes.ChID AND (t_Cst.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Cst

/* Приход товара по ГТД: Затраты */
  UPDATE t_Cst
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_CstSpends.SpendSumCC),0) FROM t_CstSpends WITH(NOLOCK)  WHERE t_Cst.ChID = t_CstSpends.ChID AND (t_Cst.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Cst

/* Формирование себестоимости: Затраты */
  UPDATE t_Cos
  SET 
    TSpendSumCC = TSpendSumCC + (SELECT ISNULL(SUM(t_CosSpends.SpendSumCC),0) FROM t_CosSpends WITH(NOLOCK)  WHERE t_Cos.ChID = t_CosSpends.ChID AND (t_Cos.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Cos

/* Продажа товара оператором: Сборы по товару */
  UPDATE t_Sale
  SET 
    TLevySum = TLevySum + (SELECT ISNULL(SUM(t_SaleDLV.LevySum),0) FROM t_SaleDLV WITH(NOLOCK)  WHERE t_Sale.ChID = t_SaleDLV.ChID AND (t_Sale.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Sale

/* Возврат товара по чеку: Сборы по товару */
  UPDATE t_CRRet
  SET 
    TLevySum = TLevySum + (SELECT ISNULL(SUM(t_CRRetDLV.LevySum),0) FROM t_CRRetDLV WITH(NOLOCK)  WHERE t_CRRet.ChID = t_CRRetDLV.ChID AND (t_CRRet.DocDate BETWEEN @BDate AND @EDate))
  FROM t_CRRet

/* ТМЦ: Расходная накладная (Сборы по товару) */
  UPDATE b_Inv
  SET 
    TLevySum = TLevySum + (SELECT ISNULL(SUM(b_InvDLV.LevySum),0) FROM b_InvDLV WITH(NOLOCK)  WHERE b_Inv.ChID = b_InvDLV.ChID AND (b_Inv.DocDate BETWEEN @BDate AND @EDate))
  FROM b_Inv

/* ТМЦ: Внутренний расход (Сборы по товару) */
  UPDATE b_Exp
  SET 
    TLevySum = TLevySum + (SELECT ISNULL(SUM(b_ExpDLV.LevySum),0) FROM b_ExpDLV WITH(NOLOCK)  WHERE b_Exp.ChID = b_ExpDLV.ChID AND (b_Exp.DocDate BETWEEN @BDate AND @EDate))
  FROM b_Exp

/* ТМЦ: Возврат от получателя (Сборы по товару) */
  UPDATE b_Ret
  SET 
    TLevySum = TLevySum + (SELECT ISNULL(SUM(b_RetDLV.LevySum),0) FROM b_RetDLV WITH(NOLOCK)  WHERE b_Ret.ChID = b_RetDLV.ChID AND (b_Ret.DocDate BETWEEN @BDate AND @EDate))
  FROM b_Ret

/* Приход товара: Товар */
  UPDATE t_Rec
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_RecD.SumCC_nt),0) FROM t_RecD WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecD.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_RecD.TaxSum),0) FROM t_RecD WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecD.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_RecD.SumCC_wt),0) FROM t_RecD WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecD.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_RecD.SumAC_nt),0) FROM t_RecD WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecD.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_RecD.TaxSumAC),0) FROM t_RecD WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecD.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_RecD.SumAC_wt),0) FROM t_RecD WITH(NOLOCK)  WHERE t_Rec.ChID = t_RecD.ChID AND (t_Rec.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Rec

/* Возврат товара от получателя: Товар */
  UPDATE t_Ret
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_RetD.SumCC_nt),0) FROM t_RetD WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetD.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_RetD.TaxSum),0) FROM t_RetD WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetD.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_RetD.SumCC_wt),0) FROM t_RetD WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetD.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_RetD.SumAC_nt),0) FROM t_RetD WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetD.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_RetD.TaxSumAC),0) FROM t_RetD WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetD.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_RetD.SumAC_wt),0) FROM t_RetD WITH(NOLOCK)  WHERE t_Ret.ChID = t_RetD.ChID AND (t_Ret.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Ret

/* Возврат товара поставщику: Товары */
  UPDATE t_CRet
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_CRetD.SumCC_nt),0) FROM t_CRetD WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetD.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_CRetD.TaxSum),0) FROM t_CRetD WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetD.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_CRetD.SumCC_wt),0) FROM t_CRetD WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetD.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_CRetD.SumAC_nt),0) FROM t_CRetD WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetD.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_CRetD.TaxSumAC),0) FROM t_CRetD WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetD.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_CRetD.SumAC_wt),0) FROM t_CRetD WITH(NOLOCK)  WHERE t_CRet.ChID = t_CRetD.ChID AND (t_CRet.DocDate BETWEEN @BDate AND @EDate))
  FROM t_CRet

/* Расходная накладная: Товар */
  UPDATE t_Inv
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_InvD.SumCC_nt),0) FROM t_InvD WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvD.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_InvD.TaxSum),0) FROM t_InvD WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvD.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_InvD.SumCC_wt),0) FROM t_InvD WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvD.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_InvD.SumAC_nt),0) FROM t_InvD WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvD.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_InvD.TaxSumAC),0) FROM t_InvD WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvD.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_InvD.SumAC_wt),0) FROM t_InvD WITH(NOLOCK)  WHERE t_Inv.ChID = t_InvD.ChID AND (t_Inv.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Inv

/* Расходный документ: Товар */
  UPDATE t_Exp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_ExpD.SumCC_nt),0) FROM t_ExpD WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpD.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_ExpD.TaxSum),0) FROM t_ExpD WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpD.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_ExpD.SumCC_wt),0) FROM t_ExpD WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpD.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_ExpD.SumAC_nt),0) FROM t_ExpD WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpD.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_ExpD.TaxSumAC),0) FROM t_ExpD WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpD.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_ExpD.SumAC_wt),0) FROM t_ExpD WITH(NOLOCK)  WHERE t_Exp.ChID = t_ExpD.ChID AND (t_Exp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Exp

/* Расходный документ в ценах прихода: Товары */
  UPDATE t_Epp
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_EppD.SumCC_nt),0) FROM t_EppD WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppD.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_EppD.TaxSum),0) FROM t_EppD WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppD.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_EppD.SumCC_wt),0) FROM t_EppD WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppD.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_EppD.SumAC_nt),0) FROM t_EppD WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppD.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_EppD.TaxSumAC),0) FROM t_EppD WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppD.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_EppD.SumAC_wt),0) FROM t_EppD WITH(NOLOCK)  WHERE t_Epp.ChID = t_EppD.ChID AND (t_Epp.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Epp

/* Счет на оплату товара: Товар */
  UPDATE t_Acc
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_AccD.SumCC_nt),0) FROM t_AccD WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccD.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_AccD.TaxSum),0) FROM t_AccD WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccD.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_AccD.SumCC_wt),0) FROM t_AccD WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccD.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_AccD.SumAC_nt),0) FROM t_AccD WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccD.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_AccD.TaxSumAC),0) FROM t_AccD WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccD.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_AccD.SumAC_wt),0) FROM t_AccD WITH(NOLOCK)  WHERE t_Acc.ChID = t_AccD.ChID AND (t_Acc.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Acc

/* Переоценка цен прихода: Товар */
  UPDATE t_Est
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_EstD.SumCC_nt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_EstD.TaxSum),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_EstD.SumCC_wt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_EstD.SumAC_nt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_EstD.TaxSumAC),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_EstD.SumAC_wt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumAC_nt = TNewSumAC_nt + (SELECT ISNULL(SUM(t_EstD.NewSumAC_nt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSumAC = TNewTaxSumAC + (SELECT ISNULL(SUM(t_EstD.NewTaxSumAC),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumAC_wt = TNewSumAC_wt + (SELECT ISNULL(SUM(t_EstD.NewSumAC_wt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_nt = TNewSumCC_nt + (SELECT ISNULL(SUM(t_EstD.NewSumCC_nt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TNewTaxSum = TNewTaxSum + (SELECT ISNULL(SUM(t_EstD.NewTaxSum),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate)),
    TNewSumCC_wt = TNewSumCC_wt + (SELECT ISNULL(SUM(t_EstD.NewSumCC_wt),0) FROM t_EstD WITH(NOLOCK)  WHERE t_Est.ChID = t_EstD.ChID AND (t_Est.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Est

/* Перемещение товара: Товар */
  UPDATE t_Exc
  SET 
    TSumCC_nt = TSumCC_nt + (SELECT ISNULL(SUM(t_ExcD.SumCC_nt),0) FROM t_ExcD WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcD.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSum = TTaxSum + (SELECT ISNULL(SUM(t_ExcD.TaxSum),0) FROM t_ExcD WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcD.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)),
    TSumCC_wt = TSumCC_wt + (SELECT ISNULL(SUM(t_ExcD.SumCC_wt),0) FROM t_ExcD WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcD.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_nt = TSumAC_nt + (SELECT ISNULL(SUM(t_ExcD.SumAC_nt),0) FROM t_ExcD WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcD.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)),
    TTaxSumAC = TTaxSumAC + (SELECT ISNULL(SUM(t_ExcD.TaxSumAC),0) FROM t_ExcD WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcD.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)),
    TSumAC_wt = TSumAC_wt + (SELECT ISNULL(SUM(t_ExcD.SumAC_wt),0) FROM t_ExcD WITH(NOLOCK)  WHERE t_Exc.ChID = t_ExcD.ChID AND (t_Exc.DocDate BETWEEN @BDate AND @EDate))
  FROM t_Exc


  /* Логирование расчета */
  INSERT z_LogAU (AUGroupCode, BDate, EDate, UserCode)
  VALUES  (2, @BDate, @EDate, dbo.zf_GetUserCode())
GO