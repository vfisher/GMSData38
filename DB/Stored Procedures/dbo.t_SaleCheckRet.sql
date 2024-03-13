SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleCheckRet](@ChID bigint, @SrcPosID int, @SaleSrcPosID int,
  @BarCode varchar(42), @Qty numeric(21, 9), @Price numeric(21, 9), @IsFreeRet bit, @Msg varchar(200) OUTPUT, @Continue bit OUTPUT)
/* Проверяет корректность позиции возвратного чека */
AS
BEGIN
  DECLARE @RealQty numeric(21, 9)
  DECLARE @oddMoneyProdID integer

  SET @Msg = ''
  SET @Continue = 1 

  SELECT @RealQty = Qty FROM r_ProdMQ WHERE BarCode = @BarCode
  SELECT @oddMoneyProdID = VarValue FROM z_Vars WHERE VarName = 't_SaleProcessingOddMoneyProdID'

  IF @oddMoneyProdID IS NOT NULL
    IF EXISTS (SELECT * FROM dbo.r_ProdMQ WHERE ProdID = @oddMoneyProdID AND BarCode = @BarCode)
      BEGIN
        SET @Msg = 'Товар-копейку для копилки вернуть невозможно.'
        SET @Continue = 0
        RETURN
      END

  IF @IsFreeRet = 1
    RETURN
  IF
    ISNULL((
      SELECT SUM(d.Qty)
      FROM t_Sale m WITH(NOLOCK), t_SaleD d WITH(NOLOCK), t_CRRet cm WITH(NOLOCK)
      WHERE cm.ChID = @ChID AND m.ChID = d.ChID AND m.DocID = cm.SrcDocID AND m.OurID = cm.OurID AND
        d.BarCode = @BarCode AND (d.RealPrice * @RealQty) = @Price AND (d.SrcPosID = @SaleSrcPosID OR @SaleSrcPosID <= 0)), 0) / @RealQty 
    -
    ISNULL((
      SELECT SUM(cd.Qty)
      FROM t_CRRet cm WITH(NOLOCK), t_CRRetD cd WITH(NOLOCK), t_CRRet m WITH(NOLOCK)
      WHERE m.ChID = @ChID AND m.SrcDocID = cm.SrcDocID AND m.OurID = cm.OurID AND cm.ChID = cd.ChID AND cd.BarCode = @BarCode AND
        cd.RealPrice = @Price AND cd.SrcPosID <> @SrcPosID AND (cd.SaleSrcPosID = @SaleSrcPosID OR @SaleSrcPosID <= 0)), 0) - @Qty < 0
  BEGIN
    SET @Msg = 'Попытка вернуть количество товара больше, чем было продано по соответствующей цене.'
    SET @Continue = 0
    RETURN
  END
END
GO
