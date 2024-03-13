SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_VenFillFromInput]
(
  @ChID bigint
)
AS
BEGIN
  /* Заполнение инвентаризации из таблицы ввода превичных данных */
  DECLARE @OurID int, 
          @StockID int, 
          @DocDate smalldatetime, 
          @ProdID int, 
          @PGrID int, 
          @PGrID1 int, 
          @PGrID2 int, 
          @PGrID3 int,
          @TSrcPosID int, 
          @TQty numeric(21,9), 
          @TNewQty numeric(21,9),
          @UM varchar(50), 
          @BarCode varchar(250), 
          @Norma1 decimal(21,9) 

  /* Фильтруем товары */
  SELECT 
    ProdID, PCatID, PGrID, Norma1, UM
  INTO #PF
  FROM r_Prods WITH (NOLOCK)
  WHERE ProdID IN (
                    SELECT ProdID FROM t_VenI WITH (NOLOCK)
                    WHERE ChID = @ChID
                  )

  SELECT 
    @OurID = OurID, @StockID = StockID, @DocDate = DocDate
  FROM t_Ven WHERE ChID = @ChID

  SELECT
    *
  INTO #RemD
  FROM dbo.zf_t_CalcRemByDateDate(NULL, @DocDate)

  /* Курсор по товарам, удовлетворяющим условиям расчета */
  DECLARE ProdsCursor CURSOR FAST_FORWARD 
  FOR
  SELECT 
    f.ProdID,
    ISNULL(SUM(r.Qty), 0) TQty, 
    f.Norma1, f.UM 
  FROM #PF f 
  LEFT JOIN #RemD r ON r.ProdID = f.ProdID AND r.OurID = @OurID AND r.StockID = @StockID
  GROUP BY 
    r.OurID, r.StockID, f.PGrID, 
    f.PCatID, f.ProdID, 
    f.Norma1, f.UM
  ORDER BY f.PCatID, f.PGrID

  OPEN ProdsCursor
  FETCH NEXT FROM ProdsCursor
  INTO @ProdID, @TQty, @Norma1, @UM

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT @TSrcPosID = NULL

    SELECT 
      @TSrcPosID = TSrcPosID
    FROM t_VenA
    WHERE ChID = @ChID AND ProdID = @ProdID

    SELECT @TNewQty = SUM(CASE IsQty WHEN 1 THEN dbo.tf_ConvertQtyToUMQty(ProdID, Qty, UM) ELSE Qty END) /* вес учитываем напрямую, кол-во преобразуем */
    FROM t_VenI
    WHERE ChID = @ChID And ProdID = @ProdID

    IF @TSrcPosID IS NOT NULL /* Если товар уже есть в первом уровне документа */
      BEGIN 
        IF NOT EXISTS
                      (
                        SELECT 
                          *
                        FROM t_VenD WITH (NOLOCK)
                        WHERE ChID = @ChID AND DetProdID = @ProdID
                      )
          BEGIN            
            UPDATE t_VenA
            SET 
              TQty = @TQty,
              TNewQty = @TNewQty
            WHERE ChID = @ChID AND TSrcPosID = @TSrcPosID

            /* Заполнение t_VenD_UM */    
            UPDATE t_VenD_UM
            SET
              Qty = s.Qty,
              TQty = s.TNewQty
            FROM
              t_VenD_UM t
            INNER JOIN
              ( SELECT 
                  ChID, ProdID, SUM(Qty) Qty, SUM(CASE IsQty WHEN 1 THEN dbo.tf_ConvertQtyToUMQty(ProdID, Qty, UM) ELSE Qty END) AS TNewQty, UM /* вес учитываем напрямую, кол-во преобразуем */
                FROM t_VenI
                WHERE ChID = @ChID AND ProdID = @ProdID
                GROUP BY ChID, ProdID, UM
              ) s
            ON
              t.ChID = s.ChID AND t.DetProdID = s.ProdID AND t.DetUM = s.UM
            WHERE
              s.ProdID = @ProdID AND s.ChID = @ChID

            INSERT INTO t_VenD_UM(ChID, DetProdID, DetUM, QtyUM, Qty, TQty)     
            SELECT ChID, ProdID, UM, (SELECT Qty FROM r_ProdMQ q WHERE q.ProdID = @ProdID AND q.UM = i.UM), SUM(Qty), SUM(CASE IsQty WHEN 1 THEN dbo.tf_ConvertQtyToUMQty(ProdID, Qty, UM) ELSE Qty END)
            FROM t_VenI i
            WHERE ChID = @ChID AND ProdID = @ProdID AND NOT EXISTS(SELECT * FROM t_VenD_UM WHERE ChID = @ChID AND DetProdID = @ProdID AND DetUM = i.UM)
            GROUP BY ChID, ProdID, UM
          END
      END
    ELSE /* Если товара нет в первом уровне документа */
      BEGIN
        SELECT 
          @BarCode = BarCode 
        FROM r_ProdMQ 
        WHERE ProdID = @ProdID AND UM = @UM

        SELECT 
          @TSrcPosID = ISNULL(MAX(TSrcPosID), 0) + 1
        FROM t_VenA WHERE ChID = @ChID

        INSERT INTO t_VenA
         (
          ChID, ProdID, UM, TQty, TNewQty, TSumCC_nt, TTaxSum, 
          TSumCC_wt, TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, 
          BarCode, Norma1, TSrcPosID
         )
        SELECT 
          @ChID, @ProdID, @UM, @TQty, @TNewQty, 0, 0, 
          0, 0, 0, 0, 
          @BarCode, @Norma1, @TSrcPosID

        /* Заполнение t_VenD_UM */    
        INSERT INTO t_VenD_UM(ChID, DetProdID, DetUM, QtyUM, Qty, TQty)     
        SELECT ChID, ProdID, UM, (SELECT Qty FROM r_ProdMQ q WHERE q.ProdID = @ProdID AND q.UM = i.UM), SUM(Qty), SUM(CASE IsQty WHEN 1 THEN dbo.tf_ConvertQtyToUMQty(ProdID, Qty, UM) ELSE Qty END)
        FROM t_VenI i
        WHERE ChID = @ChID AND ProdID = @ProdID 
        GROUP BY ChID, ProdID, UM    
      END

    FETCH NEXT FROM ProdsCursor
    INTO @ProdID, @TQty, @Norma1, @UM
  END 

  CLOSE ProdsCursor
  DEALLOCATE ProdsCursor  
END
GO
