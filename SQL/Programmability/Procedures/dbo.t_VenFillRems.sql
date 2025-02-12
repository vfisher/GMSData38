SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_VenFillRems]
(
    @ChID bigint, 
    @ProdFilter varchar(8000), 
    @PCatFilter varchar(8000), 
    @PGrFilter  varchar(8000), 
    @PGr1Filter varchar(8000), 
    @PGr2Filter varchar(8000), 
    @PGr3Filter varchar(8000),         
    @OnlyNegative bit = 0, 
    @UseStopList  bit = 1, 
    @SetFact      bit = 1
)
AS
BEGIN
  /* Заполнение инвентаризации остатками */
  DECLARE @FilterListSeparator varchar(10),
          @OurID int, 
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

  SELECT @FilterListSeparator = dbo.zf_Var('z_FilterListSeparator')

  /* Фильтруем товары */
  SELECT 
    ProdID, PCatID, PGrID, Norma1, UM
  INTO #PF
  FROM r_Prods WITH (NOLOCK)
  WHERE (@UseStopList = 0 OR InStopList = 0) AND
        dbo.zf_MatchFilterInt(ProdID, @ProdFilter, @FilterListSeparator) = 1 AND
        dbo.zf_MatchFilterInt(PCatID, @PCatFilter, @FilterListSeparator) = 1 AND
        dbo.zf_MatchFilterInt(PGrID,  @PGrFilter,  @FilterListSeparator) = 1 AND
        dbo.zf_MatchFilterInt(PGrID1, @PGr1Filter, @FilterListSeparator) = 1 AND
        dbo.zf_MatchFilterInt(PGrID2, @PGr2Filter, @FilterListSeparator) = 1 AND
        dbo.zf_MatchFilterInt(PGrID3, @PGr3Filter, @FilterListSeparator) = 1

  SELECT 
    @OurID = OurID, @StockID = StockID, @DocDate = DocDate
  FROM t_Ven WHERE ChID = @ChID

  SELECT
    *
  INTO #RemD
  FROM dbo.zf_t_CalcRemByDateDate(NULL, @DocDate)

  /* Курсор по товарам, удовлетворяющим условиям расчета */
  DECLARE ProdsCursor CURSOR LOCAL FAST_FORWARD 
  FOR
  SELECT 
    f.ProdID,
    ISNULL(SUM(r.Qty), 0) TQty, 
    f.Norma1, f.UM 
  FROM #PF f 
  LEFT JOIN #RemD r ON r.ProdID = f.ProdID AND r.OurID = @OurID AND r.StockID = @StockID
  WHERE @OnlyNegative = 0 OR f.ProdID IN
    (
       SELECT 
         ProdID
       FROM #RemD
       WHERE 
         OurID = @OurID AND 
         StockID = @StockID AND
         Qty - AccQty < 0
    )
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

    IF @TSrcPosID IS NOT NULL /* Если товар уже есть в первом уровне документа */
      BEGIN 
        IF NOT EXISTS
        (
            SELECT 
              *
            FROM t_VenD WITH (NOLOCK)
            WHERE ChID = @ChID AND DetProdID = @ProdID
        )
          UPDATE t_VenA
          SET 
            TQty = @TQty 
          WHERE ChID = @ChID AND TSrcPosID = @TSrcPosID
      END
    ELSE /* Если товара нет в первом уровне документа */
      IF @TQty <> 0
        BEGIN
          SELECT
            @TNewQty = CASE 
                         WHEN @TQty < 0 OR @SetFact = 0 
                         THEN 0
                         ELSE @TQty
                       END
          SELECT 
            @BarCode = BarCode 
          FROM r_ProdMQ WHERE ProdID = @ProdID AND UM = @UM

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
        END

    FETCH NEXT FROM ProdsCursor
    INTO @ProdID, @TQty, @Norma1, @UM
  END 

  CLOSE ProdsCursor
  DEALLOCATE ProdsCursor    
END
GO