SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetProdPrice](@DocCode int, @ChID bigint, @CRID int, @BarCode varchar(42), @PriceCC_wt numeric (21,9) OUTPUT, @PLID int OUTPUT)
/* Возвращает цену продажи и прайс-лист товара */
AS
BEGIN
  DECLARE @ProdID int, @RealQty numeric(19,9), @RateMC numeric(19,9), @UseStockPL bit, @Qty numeric(21,9)

  SELECT @UseStockPL = UseStockPL FROM r_CRs WHERE CRID = @CRID
  SELECT @ProdID = ProdID, @RealQty = Qty, @PLID = PLID FROM r_ProdMQ WHERE BarCode = @BarCode
  IF @UseStockPL = 1
    SELECT @PLID = PLID FROM r_Stocks s, r_CRs r WHERE s.StockID = r.StockID AND CRID = @CRID
  ELSE
    IF dbo.zf_Var('t_UseNotBarCodePL') = 1
      BEGIN
        SET @Qty = @Qty * @RealQty
        SELECT TOP 1 @PLID = ISNULL(PLID, @PLID) FROM r_ProdMQ WHERE ProdID = @ProdID AND Qty > @RealQty AND Qty < @Qty ORDER BY Qty DESC
      END
  IF @ChID = -1
    SELECT @RateMC = dbo.zf_GetRateMC(dbo.zf_GetCurrCC())
  ELSE
    SELECT @RateMC = RateMC FROM t_SaleTemp WITH(NOLOCK) WHERE ChID = @ChID

  EXEC t_GetPriceCCPL @ProdID, @RateMC, 0, @PLID, @PriceCC_wt OUTPUT

  /* Корректировка цены в соответствии с минимальной и максимальной ценой продажи */
  IF @PriceCC_wt <> 0 AND @DocCode = 1011
    EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, 0, @PriceCC_wt OUTPUT

  SELECT @PriceCC_wt = dbo.zf_RoundAs(@RealQty * dbo.zf_GetProdPrice_wt(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GetDate())), 'z_RoundPriceSale')
END
GO
