SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_RestRes2Bill](
  @ResChID bigint,
  @BillChID bigint,
  @Result int OUTPUT,
  @Msg varchar(200) OUTPUT)
/* Переносит позиции из меню резерва в счет */
AS
BEGIN
  SET @Result = 0
  SET @Msg = ''

  BEGIN TRANSACTION

  INSERT INTO t_SaleTempD (
    ChID, SrcPosID, ProdID, TaxTypeID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt,
    BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, CSrcPosID, ServingID, CReasonID)
    SELECT
      @BillChID, d.SrcPosID, d.ProdID, p.TaxTypeID, d.UM, d.Qty, 1, d.PriceCC_wt, d.SumCC_wt, d.PriceCC_wt, d.SumCC_wt,
      d.BarCode, d.BarCode, d.PLID, 0, 0, d.SrcPosID, d.ServingID, 0
    FROM t_DeskResD d JOIN r_Prods p ON d.ProdID = p.ProdID
    WHERE d.ChID = @ResChID AND d.PriceCC_wt > 0
    ORDER BY d.SrcPosID
  IF @@ERROR <> 0
    BEGIN
      SET @Msg = 'Ошибка при переносе позиций из счета в меню'
      GOTO EndError
    END

  UPDATE t_SaleTemp SET Visitors = (SELECT Visitors FROM t_DeskRes WHERE ChID = @ResChID) WHERE ChID = @BillChID

  COMMIT TRANSACTION
  SET @Result = 1
  RETURN

EndError:
  ROLLBACK TRANSACTION
END
GO
