SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscGetPosPrice](@DocCode int, @ChID bigint, @SrcPosID int, @SaveDiscInfo bit, @PriceCC_wt numeric(21, 9) OUTPUT, @SumCC_wt numeric (21, 9) OUTPUT)
/* Возвращает цену и сумму по позиции с учетом предоставленных скидок */
AS
BEGIN
  DECLARE @ProdID int
  DECLARE @DiscCode int
  DECLARE @RateMC numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @CSrcPosID int
  DECLARE @SumBonus numeric(21, 9)
  DECLARE @Discount numeric(21, 9)
  DECLARE @PrevSumCC_wt numeric(21, 9)  
  DECLARE @AllowZeroPrice bit
  DECLARE @DCardChID bigint
  DECLARE @DELTA numeric(21, 9)

  SELECT
    @ProdID = ProdID,
    @PriceCC_wt = PurPriceCC_wt,
    @SumCC_wt = PurPriceCC_wt * Qty,
    @Qty = Qty,
    @RateMC = RateMC,
    @CSrcPosID = CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE SrcPosID = @SrcPosID

  IF (@Qty < 0)
    BEGIN
      /* В случае отмены берем цену из оригинальной позиции (с учетом скидки), вычисляем сумму и больше ничего не пересчитываем */
      SELECT
        @PriceCC_wt = PriceCC_wt
      FROM dbo.tf_DiscDoc(@DocCode, @ChID) WHERE SrcPosID = @CSrcPosID

      SET @SumCC_wt = dbo.zf_Round(@PriceCC_wt * @Qty, 0.01)
      RETURN
    END

  SELECT @AllowZeroPrice = AllowZeroPrice FROM t_SaleTempD WHERE ChID = @ChID And SrcPosID = @SrcPosID

  IF dbo.zf_Var('t_SumDiscountMethod') = 0
    BEGIN
      DECLARE SumCursor CURSOR LOCAL FAST_FORWARD FOR 
      SELECT e.DiscCode, e.DCardChID, SUM(ISNULL(SumBonus, 0)), MAX(ISNULL(Discount, 0))
      FROM t_LogDiscExp e 
      JOIN r_Discs d ON e.DiscCode = d.DiscCode 
      WHERE e.DocCode = @DocCode AND e.ChID = @ChID AND e.SrcPosID = @SrcPosID 
      GROUP BY d.GroupDisc, e.DiscCode, e.DCardChID, d.Priority 
      ORDER BY d.GroupDisc, d.Priority

      OPEN SumCursor
      FETCH NEXT FROM SumCursor INTO @DiscCode, @DCardChID, @SumBonus, @Discount 
      WHILE @@FETCH_STATUS = 0
        BEGIN
          SELECT @PrevSumCC_wt = @SumCC_wt 
          /*SELECT @SumCC_wt = dbo.zf_GetPriceWithDiscountNoRound(@SumCC_wt - @SumBonus, @Discount)*/
          SELECT @SumCC_wt = dbo.zf_GetPriceWithDiscount(@SumCC_wt - @SumBonus, @Discount)


          SET @PriceCC_wt = dbo.zf_RoundPriceSale(@SumCC_wt / @Qty)
          EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt OUTPUT
           SET @SumCC_wt = @PriceCC_wt*@Qty

          /* Сохранение суммового эквивалента скидки */
          IF @SaveDiscInfo = 1
            Begin
              SELECT @DELTA = @PrevSumCC_wt - @SumCC_wt
              EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID, @DiscCode, @DCardChID, @DELTA
            End

          FETCH NEXT FROM SumCursor INTO @DiscCode, @DCardChID, @SumBonus, @Discount 
        END

      CLOSE SumCursor
      DEALLOCATE SumCursor 
    END
  ELSE
    BEGIN
      DECLARE SumCursor CURSOR LOCAL FAST_FORWARD FOR 
      SELECT e.DiscCode, e.DCardChID, SUM(ISNULL(SumBonus, 0)), MAX(ISNULL(Discount, 0))
      FROM t_LogDiscExp e 
      JOIN r_Discs d ON e.DiscCode = d.DiscCode 
      WHERE e.DocCode = @DocCode AND e.ChID = @ChID AND e.SrcPosID = @SrcPosID 
      GROUP BY d.GroupDisc, e.DiscCode, e.DCardChID, d.Priority 
      ORDER BY d.GroupDisc, d.Priority

      SELECT @PrevSumCC_wt = @SumCC_wt 

      OPEN SumCursor
      FETCH NEXT FROM SumCursor INTO @DiscCode, @DCardChID, @SumBonus, @Discount 
      WHILE @@FETCH_STATUS = 0
        BEGIN
          SELECT @SumCC_wt = dbo.zf_GetPriceWithDiscountNoRound(@PrevSumCC_wt, @Discount) - @SumBonus

          SET @PriceCC_wt = dbo.zf_RoundPriceSale(@SumCC_wt / @Qty)
          EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt OUTPUT
          SET @SumCC_wt = @PriceCC_wt*@Qty

          /* Сохранение суммового эквивалента скидки */
          IF @SaveDiscInfo = 1
            Begin
              SELECT @DELTA = @PrevSumCC_wt - @SumCC_wt
              EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID, @DiscCode, @DCardChID, @DELTA
            End

          FETCH NEXT FROM SumCursor INTO @DiscCode, @DCardChID, @SumBonus, @Discount 
        END

      CLOSE SumCursor
      DEALLOCATE SumCursor 

      SELECT @SumCC_wt = dbo.zf_GetPriceWithDiscountNoRound(@PrevSumCC_wt, ISNULL(SUM(Discount), 0)) - ISNULL(SUM(SumBonus), 0) 
      FROM t_LogDiscExp WITH(NOLOCK) 
      WHERE DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID
    END

  IF @Qty <> 0
    SET @PriceCC_wt = dbo.zf_RoundPriceSale(@SumCC_wt / @Qty)

  EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt OUTPUT

  SELECT @PrevSumCC_wt = @SumCC_wt  
  SET @SumCC_wt = dbo.zf_Round(@PriceCC_wt * @Qty, 0.01)

  IF @SaveDiscInfo = 1
      Begin
        /* Корректировка сумм по акциям в соотв. с изменением цены в t_CorrectSalePrice */
        IF dbo.zf_RoundPriceSale(@SumCC_wt) <> dbo.zf_RoundPriceSale(@PrevSumCC_wt)
          BEGIN
            SELECT @DELTA = @SumCC_wt - @PrevSumCC_wt
            SELECT @DiscCode = NULL

            /* Сначала смотрим, может там пол-копейки гуляет */
            SELECT TOP 1 @DiscCode = DiscCode, @DCardChID = DCardChID , @PrevSumCC_wt = SumBonus
            FROM t_LogDiscExpP
            WHERE DBiID = dbo.zf_Var('OT_DBiID') AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND 
                  ABS(SumBonus - dbo.zf_Round(SumBonus, 0.01)) = ABS(@DELTA)
            /* Если не нашли */
            /* Получаем DiscCode с максимальной % скидки и отнимаем разницу */
            IF @DiscCode IS NULL
              SELECT TOP 1 @DiscCode = p.DiscCode, @DCardChID = p.DCardChID, @PrevSumCC_wt = p.SumBonus
              FROM t_LogDiscExpP p
              JOIN t_LogDiscExp e ON e.DBiID = p.DBiID AND e.DocCode = p.DocCode AND e.ChID = p.ChID AND e.SrcPosID = p.SrcPosID AND
                                     p.DiscCode = e.DiscCode AND p.DCardChID = e.DCardChID
              WHERE p.DBiID = dbo.zf_Var('OT_DBiID') AND p.DocCode = @DocCode AND p.ChID = @ChID AND p.SrcPosID = @SrcPosID AND
                    e.Discount = (SELECT MAX(Discount) FROM t_LogDiscExp
                                WHERE DBiID = dbo.zf_Var('OT_DBiID') AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DCardChID = @DCardChID
                               )
            /* Если не нашли */
            /* Получаем DiscCode с максимальной суммой скидки и отнимаем разницу */
            IF @DiscCode IS NULL
              SELECT TOP 1 @DiscCode = DiscCode, @DCardChID = DCardChID, @PrevSumCC_wt = SumBonus
              FROM t_LogDiscExpP
              WHERE DBiID = dbo.zf_Var('OT_DBiID') AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND
                    SumBonus = (SELECT MAX(SumBonus) FROM t_LogDiscExpP
                                WHERE DBiID = dbo.zf_Var('OT_DBiID') AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID
                               )

            SELECT @PrevSumCC_wt = @PrevSumCC_wt - @DELTA
            EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID, @DiscCode, @DCardChID, @PrevSumCC_wt 
          END
        End
END
GO