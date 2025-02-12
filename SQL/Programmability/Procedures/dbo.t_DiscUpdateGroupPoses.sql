SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DiscUpdateGroupPoses](@DocCode int, @ChID bigint, @DiscCode int)
/* Процедура предоставления скидки на группу позиций */
AS
BEGIN
  DECLARE @SrcPosID int
  DECLARE @CSrcPosID int
  DECLARE @DCardChID bigint
  DECLARE @SumBonus numeric(21, 9)
  DECLARE @GroupSumBonus numeric(21, 9)
  DECLARE @Discount numeric(21, 9)
  DECLARE @DiscSumCC numeric(21, 9)
  DECLARE @DocSumCC numeric(21, 9)
  DECLARE @PosDiscSumCCReal numeric(21, 9)
  DECLARE @DiscSumCCReal numeric(21, 9)
  DECLARE @PriceCC_wt numeric(21, 9)
  DECLARE @SumCC_wt numeric(21, 9)
  DECLARE @PriceCC_wt1 numeric(21, 9)
  DECLARE @SumCC_wt1 numeric(21, 9)
  DECLARE @Qty numeric(21, 9)
  DECLARE @RateMC numeric(21, 9)
  DECLARE @ProdID int
  DECLARE @AllowZeroPrice bit

  DECLARE @discs table(SrcPosID int, SumBonus numeric(21, 9))

  IF NOT EXISTS(SELECT TOP 1 1 FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode) RETURN

  UPDATE t_LogDiscExp SET SumBonus = 0, Discount = 0 WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode

  DECLARE UpdateGroupCursor CURSOR FAST_FORWARD FOR
  SELECT DISTINCT m.SrcPosID, m.CSrcPosID
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m, t_LogDiscExp d
  WHERE m.SrcPosID = d.SrcPosID AND d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID
    END

  CLOSE UpdateGroupCursor
  DEALLOCATE UpdateGroupCursor

  SELECT TOP 1 @SumBonus = SUM(ISNULL(GroupSumBonus, 0)), @Discount = MAX(ISNULL(GroupDiscount, 0)) 
  FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode GROUP BY SrcPosID

  SELECT
    @DocSumCC = SUM(SumCC_wt),
    @PosDiscSumCCReal = SUM(PurSumCC_wt - SumCC_wt)
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE CSrcPosID IN (SELECT SrcPosID FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)

  SET @DiscSumCC = @DocSumCC - dbo.zf_GetPriceWithDiscountNoRound(@DocSumCC - @SumBonus, @Discount)
  SET @Discount = @DiscSumCC / @DocSumCC * 100

  DECLARE UpdateGroupCursor CURSOR LOCAL FAST_FORWARD FOR

  SELECT m.SrcPosID, m.CSrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, d.DCardChID, d.GroupSumBonus, t.AllowZeroPrice
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m
  JOIN t_LogDiscExp d ON m.SrcPosID = d.SrcPosID
  JOIN t_SaleTempD t ON t.ChID = @ChID AND t.SrcPosID = m.SrcPosID  
  WHERE d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus, @AllowZeroPrice

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @PriceCC_wt1 = dbo.zf_GetPriceWithDiscount(@PriceCC_wt, @Discount)
      EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
      SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, 0.01)

      SET @SumCC_wt1 = @SumCC_wt - @SumCC_wt1
      IF @SumBonus <> 0 SET @SumCC_wt1 = dbo.zf_Round(@SumCC_wt1 * @GroupSumBonus / @SumBonus, 0.01)

      IF @SumCC_wt1 >= 0
      BEGIN
        UPDATE t_LogDiscExp
        SET SumBonus = @SumCC_wt1
        WHERE DCardChID = @DCardChID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

      /* BEGIN Сохранение скидок для расчета по позициям */  
      INSERT INTO @discs(SrcPosID, SumBonus)
      SELECT SrcPosID, dbo.zf_Round(dbo.zf_Round(@SumCC_wt1 / @Qty, 0.01) * Qty, 0.01) 
      FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
      WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID
      /* END Сохранение скидок для расчета по позициям */

        EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID
      END

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus, @AllowZeroPrice
    END

  CLOSE UpdateGroupCursor

  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
  WHERE CSrcPosID IN (SELECT SrcPosID FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)

  /* Если фактически предоставленная сумма скидки не равна расчетной, изменяем цены начиная с первой позиции пока не достигнем необходимой суммы скидки */
  IF @DiscSumCCReal <> @DiscSumCC
    BEGIN
      OPEN UpdateGroupCursor

      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus, @AllowZeroPrice

      WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal <> @DiscSumCC)
        BEGIN
            /* Не используем полностью отмененные позиции */
            IF (SELECT ISNULL(SUM(Qty), 0)
                FROM dbo.tf_DiscDoc(1011, @ChID) t
                WHERE CSrcPosID = @CSrcPosID) <> 0
            BEGIN     
              SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC)
              IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
              SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
              EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
              SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, 0.01)

              IF (SELECT SumBonus + @SumCC_wt - @SumCC_wt1 FROM t_LogDiscExp
                  WHERE DCardChID = @DCardChID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode) >= 0
                BEGIN  
                  UPDATE t_LogDiscExp
                  SET SumBonus = SumBonus + @SumCC_wt - @SumCC_wt1
                  WHERE DCardChID = @DCardChID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

                  /* BEGIN Сохранение скидок для расчета по позициям */  
                  INSERT INTO @discs(SrcPosID, SumBonus)
                  SELECT SrcPosID, dbo.zf_Round(dbo.zf_Round((@SumCC_wt - @SumCC_wt1) / @Qty, 0.01) * Qty, 0.01) 
                  FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
                  WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID
                  /* END Сохранение скидок для расчета по позициям */

                  EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

                  SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
                  FROM dbo.tf_DiscDoc(@DocCode, @ChID)
                  WHERE CSrcPosID IN (SELECT SrcPosID FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)
                END
            END

          FETCH NEXT FROM UpdateGroupCursor
          INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus, @AllowZeroPrice
        END
      CLOSE UpdateGroupCursor
    END

  /* Если фактически предоставленная сумма скидки оказалась больше расчетной, начинаем ее уменьшать, пока не войдем в пределы бонуса */
  IF @DiscSumCCReal > @DiscSumCC
    BEGIN
      DECLARE @DiscOffset numeric(21, 9)
      SET @DiscOffset = 0

      WHILE (@DiscSumCCReal > @DiscSumCC) AND (@DiscSumCCReal > 0)
        BEGIN
          OPEN UpdateGroupCursor

          FETCH NEXT FROM UpdateGroupCursor
          INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus, @AllowZeroPrice

          WHILE (@@FETCH_STATUS = 0) AND (@DiscSumCCReal > @DiscSumCC)
            BEGIN
                /* Не используем полностью отмененные позиции */
                IF (SELECT ISNULL(SUM(Qty), 0)
                    FROM dbo.tf_DiscDoc(1011, @ChID) t
                    WHERE CSrcPosID = @CSrcPosID) <> 0
                BEGIN             
                  SET @SumCC_wt1 = @SumCC_wt + (@DiscSumCCReal - @DiscSumCC) + @DiscOffset
                  IF @SumCC_wt1 < 0 SET @SumCC_wt1 = 0
                  SET @PriceCC_wt1 = dbo.zf_RoundPriceSale(@SumCC_wt1 / @Qty)
                  EXEC t_CorrectSalePrice @DocCode, @ChID, @ProdID, @RateMC, @Qty, @AllowZeroPrice, @PriceCC_wt1 OUTPUT
                  SET @SumCC_wt1 = dbo.zf_Round(@PriceCC_wt1 * @Qty, 0.01)

                  IF (SELECT SumBonus + @SumCC_wt - @SumCC_wt1 FROM t_LogDiscExp
                      WHERE DCardChID = @DCardChID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode) >= 0
                    BEGIN  
                      UPDATE t_LogDiscExp
                      SET SumBonus = SumBonus + @SumCC_wt - @SumCC_wt1
                      WHERE DCardChID = @DCardChID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

                      /* BEGIN Сохранение скидок для расчета по позициям */  
                      INSERT INTO @discs(SrcPosID, SumBonus)
                      SELECT SrcPosID, dbo.zf_Round(dbo.zf_Round((@SumCC_wt - @SumCC_wt1) / @Qty, 0.01) * Qty, 0.01) 
                      FROM dbo.tf_DiscDoc(@DocCode, @ChID) 
                      WHERE CSrcPosID = @SrcPosID AND SrcPosID <> @SrcPosID
                      /* END Сохранение скидок для расчета по позициям */

                      EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID

                      SELECT @DiscSumCCReal = ISNULL(SUM(PurSumCC_wt - SumCC_wt), 0) - @PosDiscSumCCReal
                      FROM dbo.tf_DiscDoc(@DocCode, @ChID)
                      WHERE CSrcPosID IN (SELECT SrcPosID FROM t_LogDiscExp WHERE DocCode = @DocCode AND ChID = @ChID AND DiscCode = @DiscCode)
                    END
                END

              FETCH NEXT FROM UpdateGroupCursor
              INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus, @AllowZeroPrice
            END
          CLOSE UpdateGroupCursor
          SET @DiscOffset = @DiscOffset + 0.01
        END
    END

  DEALLOCATE UpdateGroupCursor

  DECLARE UpdateGroupCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT m.SrcPosID, m.CSrcPosID, m.ProdID, m.PriceCC_wt, m.Qty, m.SumCC_wt, m.RateMC, d.DCardChID, d.GroupSumBonus
  FROM dbo.tf_DiscDoc(@DocCode, @ChID) m, t_LogDiscExp d
  WHERE m.SrcPosID = d.SrcPosID AND d.DocCode = @DocCode AND d.ChID = @ChID AND d.DiscCode = @DiscCode AND m.Qty < 0
  ORDER BY m.SrcPosID, m.CSrcPosID

  OPEN UpdateGroupCursor

  FETCH NEXT FROM UpdateGroupCursor
  INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus

  WHILE @@FETCH_STATUS = 0
    BEGIN
        /* Не используем полностью отмененные позиции */
        IF (SELECT ISNULL(SUM(Qty), 0)
            FROM dbo.tf_DiscDoc(1011, @ChID) t
            WHERE CSrcPosID = @CSrcPosID) <> 0
        BEGIN    
          SELECT @SumBonus = dbo.zf_Round(e.SumBonus / t.Qty * @Qty, 0.01)
          FROM t_LogDiscExp e
          INNER JOIN dbo.tf_DiscDoc(1011, @ChID) t ON t.SrcPosID = e.SrcPosID
          WHERE e.DocCode = 1011 AND e.ChID = @ChID AND e.DiscCode = @DiscCode AND
          e.SrcPosID = @CSrcPosID

          UPDATE t_LogDiscExp
          SET SumBonus = @SumBonus
          WHERE DCardChID = @DCardChID AND DocCode = @DocCode AND ChID = @ChID AND SrcPosID = @SrcPosID AND DiscCode = @DiscCode

          EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID, @DiscCode, @DCardChID, @SumBonus
          EXEC t_DiscUpdateDocPos @DocCode, @ChID, @SrcPosID, @CSrcPosID
        END
      FETCH NEXT FROM UpdateGroupCursor
      INTO @SrcPosID, @CSrcPosID, @ProdID, @PriceCC_wt, @Qty, @SumCC_wt, @RateMC, @DCardChID, @GroupSumBonus
    END

  CLOSE UpdateGroupCursor
  DEALLOCATE UpdateGroupCursor

  /* Отмены - сохранение сумм скидок begin */
  SELECT SrcPosID, SUM(SumBonus)
  FROM @discs
  GROUP BY SrcPosID 

  DECLARE CancelsCursor CURSOR FAST_FORWARD FOR
  SELECT SrcPosID, SUM(SumBonus)
  FROM @discs
  GROUP BY SrcPosID 

  OPEN CancelsCursor
  FETCH NEXT FROM CancelsCursor
  INTO @SrcPosID, @SumBonus

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC t_DiscSavePosSum @DocCode, @ChID, @SrcPosID, @DiscCode, @DCardChID, @SumBonus

      FETCH NEXT FROM CancelsCursor
      INTO @SrcPosID, @SumBonus
    END
  CLOSE CancelsCursor
  DEALLOCATE CancelsCursor    
  /* Отмены end */
END
GO