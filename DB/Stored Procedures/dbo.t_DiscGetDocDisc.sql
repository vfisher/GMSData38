SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscGetDocDisc](@DocCode int, @ChID bigint, @DiscSumCC numeric(21, 9) OUTPUT)
/* Возвращает сумму чековой скидки по документу */
AS
BEGIN
  DECLARE @ASumBonus numeric(21, 9)
  DECLARE @ADiscount numeric(21, 9)
  DECLARE @Sum numeric(21, 9)
  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @TDiscount numeric(21, 9)
  DECLARE @TSumBonus numeric(21, 9)
  DECLARE @SumDiscountMethod int

  SELECT
    @SumCC_wt = SUM(SumCC_wt) 
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)

  IF @SumCC_wt = 0 
    BEGIN
      SET @DiscSumCC = 0
      RETURN
    END
  SET @Sum = @SumCC_wt
  SET @TDiscount = 0
  SET @TSumBonus = 0

  SET @SumDiscountMethod = dbo.zf_Var('t_SumDiscountMethod')

  DECLARE DiscCursor CURSOR  FAST_FORWARD FOR
  SELECT ISNULL(SumBonus, 0), ISNULL(Discount, 0) FROM t_LogDiscExp WITH(NOLOCK) WHERE DocCode = @DocCode AND ChID = @ChID AND SrcPosID IS NULL ORDER BY LogID

  OPEN DiscCursor
  FETCH NEXT FROM DiscCursor
  INTO @ASumBonus, @ADiscount

  WHILE @@FETCH_STATUS = 0
  BEGIN
    IF @SumDiscountMethod = 0
      BEGIN
        SET @Sum = @Sum - @ASumBonus
        SET @Sum = dbo.zf_GetPriceWithDiscountNoRound(@Sum, @ADiscount)
      END
    ELSE
      BEGIN
        SET @TDiscount = @TDiscount + @ADiscount
        SET @TSumBonus = @TSumBonus + @ASumBonus
      END

    FETCH NEXT FROM DiscCursor
    INTO @ASumBonus, @ADiscount
  END

  CLOSE DiscCursor
  DEALLOCATE DiscCursor

  IF @SumDiscountMethod = 1
    BEGIN
      SET @Sum = dbo.zf_GetPriceWithDiscountNoRound(@Sum, @TDiscount)
      SET @Sum = @Sum - @TSumBonus
    END
  IF @Sum < 0 SET @Sum = 0
  SET @DiscSumCC = @SumCC_wt - @Sum
END
GO
