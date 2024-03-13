SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_RestBill2Res](
  @BillChID bigint,
  @ResChID bigint,
  @Result int OUTPUT,
  @Msg varchar(200) OUTPUT)
/* Переносит позиции из счета в меню резерва */
AS
BEGIN

  SET @Result = 0
  SET @Msg = ''

  IF EXISTS(SELECT SrcPosID FROM t_SaleTempD WHERE ChID = @BillChID AND (PosStatus <> 0 OR ServingTime IS NOT NULL))
    BEGIN
      SET @Msg = 'Счет-источник должен состоять только из новых блюд без времени подачи'
      RETURN
    END

  BEGIN TRANSACTION

  DELETE FROM t_DeskResD WHERE ChID = @ResChID
  IF @@ERROR <> 0
    BEGIN
      SET @Msg = 'Ошибка при удалении позиций из меню резерва'
      GOTO EndError
    END

  INSERT INTO t_DeskResD (
    ChID, SrcPosID, ProdID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, PLID, ServingID)
    SELECT
      @ResChID, MIN(d.SrcPosID), d.ProdID, d.UM, SUM(d.Qty) AS Qty,
      dbo.zf_GetPrice_nt(d.PurPriceCC_wt / d.RealQty, dbo.zf_GetTaxPercent(p.TaxTypeID)) AS PriceCC_nt,
      dbo.zf_GetPrice_nt(SUM(d.PurSumCC_wt), dbo.zf_GetTaxPercent(p.TaxTypeID)) AS SumCC_nt,
      dbo.zf_GetIncludedTax(d.PurPriceCC_wt / d.RealQty, dbo.zf_GetTaxPercent(p.TaxTypeID)) AS Tax,
      dbo.zf_GetIncludedTax(SUM(d.PurSumCC_wt), dbo.zf_GetTaxPercent(p.TaxTypeID)) AS TaxSum,
      d.PurPriceCC_wt AS PriceCC_wt, SUM(d.PurSumCC_wt) AS SumCC_wt, d.BarCode, d.PLID, d.ServingID
    FROM t_SaleTempD d, r_Prods p WITH(NOLOCK)
    WHERE p.ProdID = d.ProdID AND d.ChID = @BillChID
    GROUP BY d.ProdID, d.BarCode, d.UM, d.PurPriceCC_wt, d.RealQty, p.TaxTypeID, d.PLID, d.ServingID
    HAVING SUM(d.Qty) > 0
  IF @@ERROR <> 0
    BEGIN
      SET @Msg = 'Ошибка при переносе позиций из счета в меню'
      GOTO EndError
    END

  DELETE FROM t_SaleTemp WHERE ChID = @BillChID
  IF @@ERROR <> 0
    BEGIN
      SET @Msg = 'Ошибка при удалении счета'
      GOTO EndError
    END

  COMMIT TRANSACTION
  SET @Result = 1
  RETURN

EndError:
  ROLLBACK TRANSACTION
END
GO
