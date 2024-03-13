SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetSpecSubs](@OurID int, @SubStockID int, @DocDate smalldatetime, @ProdID int, @Qty numeric(21,9))
RETURNS @SpecOut TABLE (ProdID int, Qty numeric(21,9))
/* Возвращает состав блюда по калькуляционной карте */
BEGIN
  DECLARE @Spec TABLE (ProdID int, Qty numeric(21,9))
  DECLARE @SpecChID bigint, @RemQty numeric(21,9), @UseSubItems bit

  SELECT TOP 1 @SpecChID = ChID
  FROM t_Spec WITH (NOLOCK)
  WHERE 
    /* OurID = @OurID AND */ /*Убран контроль за привязкой блюда к фирме, указанной в Кальк.К.*/
   DocDate <= @DocDate AND 
   ProdID = @ProdID
  ORDER BY 
    DocDate DESC, DocID DESC

  IF @SpecChID IS NULL 
    INSERT INTO @Spec(ProdID, Qty)
    SELECT @ProdID, @Qty
  ELSE
  /* Вычисление остатка товара-параметра */
    BEGIN 
      SELECT @RemQty = ISNULL(SUM(r.Qty - r.AccQty), 0)
      FROM t_Rem r WITH (NOLOCK)
      WHERE r.OurID = @OurID AND r.StockID = @SubStockID AND r.ProdID = @ProdID

      IF @RemQty > @Qty
        SELECT @RemQty = @Qty 

      SELECT @Qty = @Qty - @RemQty 

      IF @RemQty > 0
        INSERT INTO @Spec(ProdID, Qty)
        SELECT @ProdID, @RemQty
      IF @Qty > 0
        BEGIN
          /* Раскрутка на составляющие по Калькуляционной карте */
          DECLARE SRecD CURSOR LOCAL FAST_FORWARD
          FOR 
          SELECT ProdID, @Qty * SUM(Qty) Qty, UseSubItems
          FROM t_SpecD d WITH (NOLOCK)
          WHERE ChID = @SpecChID
          GROUP BY ProdID, UseSubItems 

          OPEN SRecD
            FETCH NEXT FROM SRecD 
            INTO @ProdID, @Qty, @UseSubItems
          WHILE @@FETCH_STATUS = 0
            BEGIN
              IF @UseSubItems = 0
                INSERT INTO @Spec(ProdID, Qty)
                SELECT @ProdID, @Qty
              ELSE
                INSERT INTO @Spec(ProdID, Qty)  
                SELECT ProdID, Qty
                FROM tf_GetSpecSubs(@OurID, @SubStockID, @DocDate, @ProdID, @Qty)     

              FETCH NEXT FROM SRecD 
              INTO @ProdID, @Qty, @UseSubItems
            END
          CLOSE SRecD
          DEALLOCATE SRecD
        END

      INSERT INTO @SpecOut(ProdID, Qty)
      SELECT ProdID, SUM(Qty)
      FROM @Spec
      GROUP BY ProdID
    END
  RETURN
END
GO
