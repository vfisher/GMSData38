SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscUpdateDocPoses](@DocCode int, @ChID bigint, @UseDocDisc bit)
/* Изменяет позиции документа с учетом предоставленных позиционных скидок */
AS
BEGIN
  DECLARE @SrcPosID int, @CSrcPosID int
  DECLARE @AllowZeroPrice bit
  DECLARE @TotalQty NUMERIC(21, 9)

  DECLARE DocCursor CURSOR FAST_FORWARD FOR
  SELECT SrcPosID, CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE Qty > 0 
  ORDER BY SrcPosID

  OPEN DocCursor

  FETCH NEXT FROM DocCursor
  INTO @SrcPosID, @CSrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

      FETCH NEXT FROM DocCursor
      INTO @SrcPosID, @CSrcPosID
    END

  CLOSE DocCursor
  DEALLOCATE DocCursor

  IF @UseDocDisc = 0 RETURN

  /* Применение скидки по чеку */

  DECLARE @Discount numeric(21, 9)
  DECLARE @DiscSumCC numeric(21, 9)
  DECLARE @DocSumCC numeric(21, 9)
  DECLARE @PosDiscSumCCReal numeric(21, 9)
  DECLARE @DELTA numeric(21, 9)
  DECLARE @discs table(SrcPosID int, SumBonus numeric(21, 9))

  /* Получаем суммовой эквивалент для всех чековых скидок */
  EXEC t_DiscGetDocDisc @DocCode, @ChID, @DiscSumCC OUTPUT
  SELECT
    @DocSumCC = SUM(SumCC_wt),
    @PosDiscSumCCReal = SUM(PurSumCC_wt - SumCC_wt),
    @TotalQty = SUM(Qty)
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)

  /* Рассчитываем базовую скидку, которую в дальнейшем будем уточнять */
  IF @DocSumCC <> 0
    SELECT @Discount = @DiscSumCC / @DocSumCC * 100
  ELSE IF @TotalQty = 0
    SET @Discount = 0
  ELSE  
    SET @Discount = 100

  DECLARE @DiscSumCCReal numeric(21, 9)
  DECLARE @PriceCC_wt numeric(21, 9)
  DECLARE @PurPriceCC_wt numeric(21, 9)
  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @PriceCC_wt1 numeric(21, 9)
  DECLARE @SumCC_wt1 numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @RateMC numeric(21, 9)
  DECLARE @ProdID int

  DECLARE DocCursor1 CURSOR LOCAL FAST_FORWARD FOR
  SELECT m.SrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, t.AllowZeroPrice, t.PurPriceCC_wt
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID
  WHERE m.Qty > 0 
  ORDER BY m.SumCC_wt DESC, m.SrcPosID

  OPEN DocCursor1

  FETCH NEXT FROM DocCursor1
  INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice, @PurPriceCC_wt

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @PriceCC_wt1 = dbo.zf_GetPriceWithDiscount(@PriceCC_wt, @Discount)
      EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
      SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, 0.01)

      EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1

      /* BEGIN Сохранение скидок для расчета по позициям */  
      INSERT INTO @discs(SrcPosID, SumBonus)
      SELECT SrcPosID, dbo.zf_Round(PriceCC_wt * Qty, 0.01) - dbo.zf_Round(@PriceCC_wt1 * Qty, 0.01) 
      FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
      WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID
      /* END Сохранение скидок для расчета по позициям */

      EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1

      /* BEGIN Сохранение скидок для расчета по позициям */
      SELECT @DELTA = @SumCC_wt - @SumCC_wt1
      /* SELECT @SrcPosID, @DELTA, @PriceCC_wt1, @SumCC_wt1 -- debug*/
      IF @DELTA <> 0
        INSERT INTO @discs(SrcPosID, SumBonus)
        VALUES            (@SrcPosID, @DELTA)
      /* END Сохранение скидок для расчета по позициям */

      FETCH NEXT FROM DocCursor1
      INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice, @PurPriceCC_wt
    END

  CLOSE DocCursor1

  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal FROM dbo.tf_DiscDoc(@DocCode, @ChID)

/*SELECT * FROM @discs ORDER BY SrcPosID --*/
/*SELECT @DiscSumCCReal, @DiscSumCC*/
  /* Если фактически предоставленная сумма скидки меньше расчетной, снижаем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */
  IF @DiscSumCCReal < @DiscSumCC
    BEGIN
      OPEN DocCursor1

      FETCH NEXT FROM DocCursor1
      INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice, @PurPriceCC_wt

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal < @DiscSumCC)
        BEGIN
          SET @SumCC_wt1 = @SumCC_wt - (@DiscSumCC - @DiscSumCCReal)
          IF @SumCC_wt1 < 0
            SELECT @SumCC_wt1 = 0
          SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
          /*
          IF @PriceCC_wt1 > @PurPriceCC_wt SELECT @PriceCC_wt1 = @PurPriceCC_wt
          */
          EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
          SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, 0.01)

          EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1

          /* BEGIN Сохранение скидок для расчета по позициям */  
          INSERT INTO @discs(SrcPosID, SumBonus)
          SELECT SrcPosID, dbo.zf_Round(PriceCC_wt * Qty, 0.01) - dbo.zf_Round(@PriceCC_wt1 * Qty, 0.01) 
          FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
          WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID
          /* END Сохранение скидок для расчета по позициям */

          EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1
          SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal FROM dbo.tf_DiscDoc(@DocCode, @ChID)

          /* BEGIN Сохранение скидок для расчета по позициям */          
          SELECT @DELTA = @SumCC_wt - @SumCC_wt1
          IF @DELTA <> 0
            INSERT INTO @discs(SrcPosID, SumBonus)
            VALUES            (@SrcPosID, @DELTA)
          /* END Сохранение скидок для расчета по позициям */

          FETCH NEXT FROM DocCursor1
          INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice, @PurPriceCC_wt
        END

      CLOSE DocCursor1
    END

  DEALLOCATE DocCursor1

  /* Если фактически предоставленная сумма скидки больше расчетной, увеличиваем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */

  DECLARE DocCursor1 CURSOR LOCAL FAST_FORWARD FOR
  SELECT m.SrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, t.AllowZeroPrice, t.PurPriceCC_wt
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID
  WHERE m.Qty > 0 
  ORDER BY m.Qty ASC, m.SumCC_wt ASC, m.SrcPosID

  IF @DiscSumCCReal > @DiscSumCC
    BEGIN
      OPEN DocCursor1

      FETCH NEXT FROM DocCursor1
      INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice, @PurPriceCC_wt

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal > @DiscSumCC)
        BEGIN
          SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC)
          SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
          /*
          IF @Discount >= 0
            BEGIN
              IF @PriceCC_wt1 > @PurPriceCC_wt SELECT @PriceCC_wt1 = @PurPriceCC_wt
            END
          */
          EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
          SELECT @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, 0.01)

          EXEC t_DiscUpdateDocPosInt @DocCode, @ChID, @SrcPosID, @PriceCC_wt1, @SumCC_wt1

          /* BEGIN Сохранение скидок для расчета по позициям */  
          INSERT INTO @discs(SrcPosID, SumBonus)
          SELECT SrcPosID, dbo.zf_Round(PriceCC_wt * Qty, 0.01) - dbo.zf_Round(@PriceCC_wt1 * Qty, 0.01) 
          FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
          WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID
          /* END Сохранение скидок для расчета по позициям */

          EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosID, @PriceCC_wt1
          SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal FROM dbo.tf_DiscDoc(@DocCode, @ChID)

          /* BEGIN Сохранение скидок для расчета по позициям */
          SELECT @DELTA = @SumCC_wt - @SumCC_wt1
          IF @DELTA <> 0
            INSERT INTO @discs(SrcPosID, SumBonus)
            VALUES            (@SrcPosID, @DELTA)
          /* END Сохранение скидок для расчета по позициям */

          FETCH NEXT FROM DocCursor1
          INTO @SrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @AllowZeroPrice, @PurPriceCC_wt
        END

      CLOSE DocCursor1
    END

  DEALLOCATE DocCursor1

  /* SELECT * FROM @discs ORDER BY SrcPosID --*/
  /*SELECT SUM(SumBonus) FROM @discs */
  /*SELECT 1, dbo.zf_Round(@DiscSumCC, 0.01), @DiscSumCCReal*/

  /* Подчистка копейки методом диофантовых уравнений BEGIN*/
  DECLARE @DiscountDelta numeric(21,9)  
  SELECT @DiscountDelta = -(dbo.zf_Round(@DiscSumCC, 0.01) - @DiscSumCCReal)
  IF @DiscountDelta <> 0
    BEGIN
      DECLARE @SrcPosIDFrom int
      DECLARE @SrcPosIDTo   int
      DECLARE @QtyFrom numeric(21,9)
      DECLARE @QtyTo   numeric(21,9)
      DECLARE @y numeric(21,9)
      DECLARE @x numeric(21,9)
      DECLARE @i int

      SELECT @QtyTo = MIN(Qty) FROM t_SaleTempD WHERE ChID = @ChID AND PriceCC_wt <> 0.01 AND Qty > 0 HAVING MIN(Qty) = dbo.zf_Round(MIN(Qty), 1.00) /*целое*/
      SELECT @SrcPosIDTo = (SELECT TOP 1 SrcPosID FROM t_SaleTempD WHERE ChID = @ChID AND Qty = @QtyTo ORDER BY PriceCC_wt DESC)     
      SELECT @SrcPosIDFrom = (SELECT TOP 1 SrcPosID FROM t_SaleTempD WHERE ChID = @ChID AND Qty > @QtyTo AND Qty = dbo.zf_Round(Qty, 1.00) AND Qty > 0 /*целое*/
                                                                           AND PriceCC_wt <> 0.01 ORDER BY Qty ASC, PriceCC_wt DESC)
      SELECT @QtyFrom = Qty FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosIDFrom

      IF (@QtyFrom <> @QtyTo) 
        BEGIN
          SELECT @i = 1, @x = null, @y = NULL
          WHILE (@i <= @QtyFrom) AND @x IS NULL  
            BEGIN
              IF CAST((@QtyTo*@i + dbo.zf_Round(@DiscountDelta*100, 1))AS INT) % CAST(@QtyFrom AS INT) = 0
                BEGIN
                  SELECT @x = -@i, @y = CAST((@QtyTo*@i + dbo.zf_Round(@DiscountDelta*100, 1)) / @QtyFrom AS INT)
                  SELECT @i = @QtyFrom
                END
              SELECT @i = @i + 1
            END           
          IF @x is null
            BEGIN
              SELECT @i = 1, @x = null, @y = null
              WHILE (@i <= @QtyTo) AND @x IS NULL 
                BEGIN
                  IF CAST((@QtyFrom*@i + dbo.zf_Round(@DiscountDelta*100, 1)) AS INT) % CAST(@QtyTo AS INT) = 0              
                    BEGIN
                      SELECT @x = @i, @y = -CAST((@QtyFrom*@i - dbo.zf_Round(@DiscountDelta*100, 1)) / @QtyTo AS INT)
                      SELECT @i = @QtyTo
                    END
                  SELECT @i = @i + 1
                END
            END

          IF @x IS NOT NULL
            BEGIN
              /* Проверка цены */
              SELECT @ProdID = m.ProdID, @PriceCC_wt = m.PriceCC_wt, @PriceCC_wt1 = m.PriceCC_wt + @x/100, @Qty = m.Qty, @RateMC = m.RateMC, @AllowZeroPrice = t.AllowZeroPrice,
                     @i = CASE WHEN m.PriceCC_wt + @x/100 > m.PurPriceCC_wt THEN 1 ELSE 0 END
              FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
              JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID
              WHERE m.SrcPosID = @SrcPosIDTo
              EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT

              DECLARE @PriceCC_wt2 numeric(21,9)
              SELECT @ProdID = m.ProdID, @PriceCC_wt = m.PriceCC_wt, @PriceCC_wt2 = m.PriceCC_wt + @y/100, @Qty = m.Qty, @RateMC = m.RateMC, @AllowZeroPrice = t.AllowZeroPrice,
                     @i = CASE WHEN (m.PriceCC_wt + @y/100 > m.PurPriceCC_wt) OR (@i = 1) THEN 1 ELSE 0 END
              FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
              JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID
              WHERE m.SrcPosID = @SrcPosIDFrom
              EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt2 OUTPUT

              IF @i = 0 /* Мы нигде не увеличим цену товара*/
                BEGIN
                  /* BEGIN Сохранение скидок для расчета по позициям */
                  SELECT @DELTA = dbo.zf_Round(@PriceCC_wt1 * Qty, 0.01) - dbo.zf_Round(PriceCC_wt * Qty, 0.01)              
                  FROM t_SaleTempD
                  WHERE ChID = @ChID AND SrcPosID = @SrcPosIDTo

                  INSERT INTO @discs(SrcPosID, SumBonus)
                  VALUES            (@SrcPosIDTo, -@DELTA)

                  SELECT @DELTA = dbo.zf_Round(@PriceCC_wt2 * Qty, 0.01) - dbo.zf_Round(PriceCC_wt * Qty, 0.01)
                  FROM t_SaleTempD
                  WHERE ChID = @ChID AND SrcPosID = @SrcPosIDFrom

                  INSERT INTO @discs(SrcPosID, SumBonus)
                  VALUES            (@SrcPosIDFrom, -@DELTA)

                  /* Отмены */
                  INSERT INTO @discs(SrcPosID, SumBonus)
                  SELECT SrcPosID, dbo.zf_Round(PriceCC_wt * Qty, 0.01) - dbo.zf_Round(@PriceCC_wt1 * Qty, 0.01) 
                  FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
                  WHERE CSrcPosID = @SrcPosIDTo AND SrcPosID <> @SrcPosIDTo

                  INSERT INTO @discs(SrcPosID, SumBonus)
                  SELECT SrcPosID, dbo.zf_Round(PriceCC_wt * Qty, 0.01) - dbo.zf_Round(@PriceCC_wt2 * Qty, 0.01) 
                  FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
                  WHERE CSrcPosID = @SrcPosIDFrom AND SrcPosID <> @SrcPosIDFrom                  
                  /* END Сохранение скидок для расчета по позициям */

                  UPDATE t_SaleTempD
                  SET PriceCC_wt = @PriceCC_wt1
                  WHERE ChID = @ChID AND SrcPosID = @SrcPosIDTo

                  EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosIDTo, @PriceCC_wt1

                  UPDATE t_SaleTempD
                  SET PriceCC_wt = @PriceCC_wt2
                  WHERE ChID = @ChID AND SrcPosID = @SrcPosIDFrom

                  EXEC t_DiscUpdateCancels @DocCode, @ChID, @SrcPosIDFrom, @PriceCC_wt2

                  UPDATE t_SaleTempD
                  SET SumCC_wt = dbo.zf_Round(PriceCC_wt * Qty, 0.01)
                  WHERE ChID = @ChID AND CSrcPosID IN (@SrcPosIDFrom, @SrcPosIDTo)
                END
            END
        END
    END
    /* Подчистка копейки END */    

  /*SELECT * FROM @discs ORDER BY SrcPosID --*/
  /*SELECT SUM(SumBonus) FROM @discs */

  /* Подсчет скидок попозиционно */  

  /* У нас есть сумма по каждой позиции всех чековых скидок. Необходимо пройтись по каждой позиции и 
     каждой скидке и вычислить суммовой эквивалент с учетом корректировки */

  /* @DocSumCC = сумма чека до чековых скидок */
  /* Получим сумму всех чековых скидок */
  SELECT @DiscSumCC = SUM(SumBonus) 
  FROM @discs  

  /* Посчитаем сумму всех чековых скидок индивидуально по каждой акции */ 
  DECLARE @cheque table(DiscCode Int, SumCC_wt numeric(21, 9), IsBonus bit)
  DECLARE @NewSumCC_wt numeric(21, 9)
  DECLARE @OldSumCC_wt numeric(21, 9)  
  DECLARE @TDiscount numeric(21, 9)
  DECLARE @SumBonus numeric(21, 9)  
  DECLARE @DiscCode int 
  DECLARE @IsBonus bit

  SELECT @SumCC_wt = @DocSumCC, @NewSumCC_wt = @DocSumCC, @OldSumCC_wt = @DocSumCC 
  SELECT @TDiscount = 0

  DECLARE AllCursor CURSOR FAST_FORWARD FOR 
  SELECT ISNULL(SumBonus, 0), ISNULL(Discount, 0), DiscCode, CASE WHEN ISNULL(SumBonus, 0) = 0 THEN 0 ELSE 1 END
  FROM t_LogDiscExp WITH(NOLOCK) 
  WHERE DocCode = 1011 AND ChID = @ChID AND SrcPosID IS NULL 
  ORDER BY LogID 

  OPEN AllCursor
  FETCH NEXT FROM AllCursor INTO @SumBonus, @Discount, @DiscCode, @IsBonus
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @NewSumCC_wt = @NewSumCC_wt - @SumBonus
    SET @NewSumCC_wt = dbo.zf_GetPriceWithDiscountNoRound(@NewSumCC_wt, @Discount)

    IF @NewSumCC_wt < 0 SET @NewSumCC_wt = 0
    SET @TDiscount = @TDiscount + dbo.zf_Round(@OldSumCC_wt - @NewSumCC_wt, 0.01)

    INSERT INTO @cheque (DiscCode, SumCC_wt, IsBonus)
    VALUES (@DiscCode, dbo.zf_Round(@OldSumCC_wt - @NewSumCC_wt, 0.01), @IsBonus)

    SELECT @OldSumCC_wt = @NewSumCC_wt

    FETCH NEXT FROM AllCursor INTO @SumBonus, @Discount, @DiscCode, @IsBonus
  END
  CLOSE AllCursor
  DEALLOCATE AllCursor 

  /* Корректировка на случай разбежности сумм из-за разных методик алгоритмов расчета */
  /*SELECT @DiscSumCC, @TDiscount -- debug*/
  SELECT @SumCC_wt = @DiscSumCC - @TDiscount
  IF @SumCC_wt <> 0
    BEGIN
      SELECT @DiscCode = (SELECT TOP 1 DiscCode FROM @cheque WHERE IsBonus = 0 ORDER BY SumCC_wt DESC)
      IF @DiscCode IS NULL
        SELECT @DiscCode = (SELECT TOP 1 DiscCode FROM @cheque ORDER BY SumCC_wt DESC)
      INSERT INTO @cheque (DiscCode, SumCC_wt)
      VALUES (@DiscCode, @SumCC_wt)
    END  

  /*---------------------------------------------------------------------------*/
  /* Имеем @discs - суммы скидок по позициям, @cheque - суммы скидок по акциям */
  /*---------------------------------------------------------------------------*/

 /* SELECT * FROM @cheque -- debug все чековые скидки*/
  /*  SELECT * FROM @discs ORDER BY SrcPosID --*/
/*    SELECT SUM(SumBonus) SumBonus FROM @discs */
  /*SELECT 1, dbo.zf_Round(@DiscSumCC, 0.01), @DiscSumCCReal*/


  DECLARE PosCur CURSOR FAST_FORWARD FOR
  SELECT /*t.Qty, t.PurSumCC_wt, t.PurPriceCC_wt,*/ d.SrcPosID, SUM(d.SumBonus)
  FROM @discs d
  INNER JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = d.SrcPosID
  GROUP BY d.SrcPosID /* t.Qty, t.PurSumCC_wt, t.PurPriceCC_wt*/
  ORDER BY SUM(d.SumBonus) ASC

  DECLARE @result TABLE (SrcPosID int, DiscCode int, SumBonus numeric(21, 9))

  OPEN PosCur
                           /* позиция, сумма всех чековых скидок*/
  FETCH NEXT FROM PosCur INTO @SrcPosID, @PosDiscSumCCReal
  /* По каждой позиции */
  WHILE (@@FETCH_STATUS = 0)
    BEGIN
      DECLARE DiscCur CURSOR FAST_FORWARD FOR
      SELECT DiscCode, SUM(SumCC_wt)
      FROM @cheque
      GROUP BY DiscCode
      ORDER BY SUM(SumCC_wt) ASC

      OPEN DiscCur
      FETCH NEXT FROM DiscCur INTO @DiscCode, @SumBonus
      /* По каждой акции */
      WHILE (@@FETCH_STATUS = 0)
        BEGIN
          /* Пропорционально сумме позиции с коррекцией раскладываем */
          If @DiscSumCC <> 0
            INSERT INTO @result (SrcPosID, DiscCode, SumBonus)
            SELECT @SrcPosID, @DiscCode, dbo.zf_Round(@SumBonus * @PosDiscSumCCReal/@DiscSumCC, 0.01)

          FETCH NEXT FROM DiscCur INTO @DiscCode, @SumBonus
        END   
      CLOSE DiscCur
      DEALLOCATE DiscCur     

      FETCH NEXT FROM PosCur INTO @SrcPosID, @PosDiscSumCCReal      
    END

  CLOSE PosCur
  DEALLOCATE PosCur   

  /*SELECT * FROM @result ORDER BY 1*/

  /* После цикла у нас могут остаться копейки нераспределенные */  
  /* Курсор по неразмазанным остаткам по позициям */
  DECLARE PosCur CURSOR FAST_FORWARD FOR
  SELECT d.SrcPosID, SUM(d.SumBonus) - (SELECT SUM(r.SumBonus) FROM @result r WHERE r.SrcPosID = d.SrcPosID)
  FROM @discs d 
  GROUP BY d.SrcPosID
  ORDER BY 2 DESC

  OPEN PosCur
                           /* позиция, сумма всех чековых скидок*/
  FETCH NEXT FROM PosCur INTO @SrcPosID, @PosDiscSumCCReal
  /* По каждой позиции */
  WHILE (@@FETCH_STATUS = 0)
    BEGIN
      /* Курсор по неразмазанным остаткам скидок */
      DECLARE DiscCur CURSOR FAST_FORWARD FOR
      SELECT c.DiscCode, SUM(c.SumCC_wt) - (SELECT  SUM(r.SumBonus) FROM @result r WHERE r.DiscCode = c.DiscCode)
      FROM @cheque c 
      GROUP BY c.DiscCode
      ORDER BY 2 DESC

      OPEN DiscCur
      FETCH NEXT FROM DiscCur INTO @DiscCode, @SumBonus
      /* По каждой акции */
      WHILE (@@FETCH_STATUS = 0) AND (@PosDiscSumCCReal <> 0)
        BEGIN
          /* Разбрасываем копейки */        
          /* Если не хватает для позиции и есть лишнее до акции */
          IF ((@PosDiscSumCCReal > 0) AND (@SumBonus > 0))          
            BEGIN
              IF @PosDiscSumCCReal > ABS(@SumBonus)
                SELECT @Discount = ABS(@SumBonus)
              ELSE  
                SELECT @Discount = @PosDiscSumCCReal

              INSERT INTO @result (SrcPosID, DiscCode, SumBonus)
              SELECT @SrcPosID, @DiscCode, dbo.zf_Round(-@Discount, 0.01)

              SELECT @PosDiscSumCCReal = @PosDiscSumCCReal - @Discount 
            END
          /* Если перебор по позиции и не хватает по акции */
          ELSE IF ((@PosDiscSumCCReal < 0) AND (@SumBonus < 0))
            BEGIN
              IF ABS(@PosDiscSumCCReal) > @SumBonus
                SELECT @Discount = @SumBonus
              ELSE  
                SELECT @Discount = ABS(@PosDiscSumCCReal)

              INSERT INTO @result (SrcPosID, DiscCode, SumBonus)
              SELECT @SrcPosID, @DiscCode, dbo.zf_Round(@Discount, 0.01)

              SELECT @PosDiscSumCCReal = @PosDiscSumCCReal + @Discount   
            END
          /* По позициям все ок, а по скидкам не совпало */
          ELSE IF ((@PosDiscSumCCReal = 0) AND (@SumBonus <> 0))
            BEGIN
              INSERT INTO @result (SrcPosID, DiscCode, SumBonus)
              SELECT @SrcPosID, @DiscCode, @SumBonus
            END
          /* По скидкам все ок, а по позициям промахнулись */            
          ELSE IF ((@PosDiscSumCCReal <> 0) AND (@SumBonus = 0))
            BEGIN
              INSERT INTO @result (SrcPosID, DiscCode, SumBonus)
               SELECT @SrcPosID, @DiscCode, @SumBonus

              SELECT @PosDiscSumCCReal = @PosDiscSumCCReal + @SumBonus   
            END 
          FETCH NEXT FROM DiscCur INTO @DiscCode, @SumBonus
        END   
      CLOSE DiscCur
      DEALLOCATE DiscCur     

      FETCH NEXT FROM PosCur INTO @SrcPosID, @PosDiscSumCCReal      
    END

  CLOSE PosCur
  DEALLOCATE PosCur   

  DECLARE DiscCur CURSOR FAST_FORWARD FOR
  SELECT DiscCode, SrcPosID, SUM(SumBonus)
  FROM @result r
  GROUP BY DiscCode, SrcPosID

  OPEN DiscCur  
  FETCH NEXT FROM DiscCur INTO @DiscCode, @SrcPosID, @SumBonus

  WHILE @@FETCH_STATUS = 0
    BEGIN                                                /* чековые в разрезе ДС не раализованы*/  
      EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID, @DiscCode, 0, @SumBonus
      FETCH NEXT FROM DiscCur INTO @DiscCode, @SrcPosID, @SumBonus
    END   
  CLOSE DiscCur  
  DEALLOCATE DiscCur         
END
GO