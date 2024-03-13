SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetProcessingProds](@DocCode int, @DocChID bigint)
/* Формирует список товаров для отправки на процессинг */
AS
BEGIN
  DECLARE @Prod_Table table(SrcPosID int NOT NULL, ProdID int NOT NULL, BarCode varchar(42), Qty numeric(21,9), PriceCC_wt numeric(21,9), SaleSrcPosID int, PurPriceCC_wt numeric(21,9))
  DECLARE @DCardChID bigint

  SELECT @DCardChID = c.DCardChID
  FROM z_DocDC c, r_DCards r, r_DCTypes t, r_DCTypeG g
  WHERE r.DCTypeCode = t.DCTypeCode AND t.DCTypeGCode = g.DCTypeGCode AND r.ChID = c.DCardChID AND
        ProcessingID > 0 AND c.DocCode = @DocCode AND c.ChID = @DocChID

  If @DocCode = 1011
    BEGIN
      INSERT INTO @Prod_Table
      SELECT CSrcPosID, ProdID, BarCode, SUM(Qty) AS Qty, PriceCC_wt, NULL, PurPriceCC_wt
      FROM t_SaleTempD WITH(NOLOCK)
      WHERE ChID = @DocChID
      GROUP BY CSrcPosID, ProdID, BarCode, PriceCC_wt, PurPriceCC_wt
      HAVING SUM(Qty) > 0
    END
  ELSE IF @DocCode = 11035
    BEGIN
      INSERT INTO @Prod_Table
      SELECT SrcPosID, ProdID, BarCode, Qty, RealPrice, NULL, PurPriceCC_wt
      FROM t_SaleD WITH(NOLOCK)
      WHERE ChID = @DocChID AND Qty > 0
    END
  ELSE IF @DocCode = 11004
    BEGIN
      INSERT INTO @Prod_Table
      SELECT SrcPosID, ProdID, BarCode, Qty, RealPrice, SaleSrcPosID, RealPrice
      FROM t_CRRetD WITH(NOLOCK)
      WHERE ChID = @DocChID
    END

  IF (@DocCode = 11035) AND @DCardChID IS NOT NULL
    UPDATE p
    SET PriceCC_wt = p.PriceCC_wt + ISNULL((SELECT SUM(SumBonus) 
                                            FROM z_LogDiscExp z WITH(NOLOCK) 
                                            WHERE p.SrcPosID = z.SrcPosID AND DocCode = @DocCode AND ChID = @DocChID AND DCardChID = @DCardChID), 0) / Qty
    FROM @Prod_Table p

  IF (@DocCode = 1011) AND @DCardChID IS NOT NULL
    UPDATE p
    SET PriceCC_wt = p.PriceCC_wt + ISNULL((SELECT SUM(SumBonus) 
                                            FROM t_LogDiscExp z WITH(NOLOCK) 
                                            WHERE p.SrcPosID = z.SrcPosID AND DocCode = @DocCode AND ChID = @DocChID AND DCardChID = @DCardChID), 0) / Qty
    FROM @Prod_Table p

  SELECT * FROM @Prod_Table
END
GO
