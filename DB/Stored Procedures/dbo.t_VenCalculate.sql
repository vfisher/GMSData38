SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_VenCalculate] 
(
    @ChID BIGINT,
    @SrcPosID INT 
)
AS
BEGIN
  DECLARE 
    @OurID int, @StockID int, @DocDate smalldatetime, 
    @ProdID int, @TQty decimal(21,9), @KursMC decimal(21,9),  
    @TNewQty decimal(21,9), @PPID int, @CurrID int, 
    @UM varchar(50), @Qty decimal(21,9), @TZQty decimal(21,9),
    @DSrcPosID INT, @DSum decimal(21,9), @PPQty decimal(21,9), 
    @TSumCC decimal(21,9), @TSumMC decimal(21,9), 
    @CostCC decimal(21,9), @CostMC decimal(21,9), 
    @KursCC decimal(21,9), @TPQty decimal(21,9), 
    @TPSumCC decimal(21,9), @TPSumMC decimal(21,9), 
    @NewQty decimal(21,9), @TaxPercent decimal(21,9),
    @DocID bigint, @CompID int

  SELECT 
      @OurID = OurID, @StockID = StockID, 
      @DocDate = DocDate, @KursMC = KursMC,
      @DocID = DocID, @CompID = CompID
  FROM t_Ven WHERE ChID = @ChID
  SELECT
      @CurrID = dbo.zf_GetCurrMC()

  SELECT @ProdID = ProdID FROM t_VenA a WHERE a.TSrcPosID = @SrcPosID AND a.ChID = @ChID

  /* Сохранение ранее созданных партий */
  /* Это для того чтобы не плодить партии, если несколько раз запускается перерасчет */
  SELECT 
      pp.ProdID, pp.PPID
  INTO #PrevPPs
  FROM t_VenD d WITH (NOLOCK)
  INNER JOIN t_PInP pp WITH (NOLOCK) ON d.DetProdID = pp.ProdID AND d.PPID = pp.PPID
  WHERE ChID = @ChID AND 
        d.NewQty - d.Qty > 0 AND  
        pp.PPDesc = 'Излишек инвентаризации' AND 
        pp.ProdDate = @DocDate AND
        d.DetProdID = @ProdID

  /* Убираем старый расчет */
  DELETE FROM t_VenD
  WHERE ChID = @ChID AND DetProdID = @ProdID

  SELECT a.ProdID, r.PPID, r.Qty
  INTO #RemD
  FROM t_VenA a 
  INNER JOIN dbo.zf_t_CalcRemByDateDate(NULL, @DocDate) r
    ON a.ProdID = r.ProdID AND r.Qty <> 0 AND 
       r.OurID = @OurID AND r.StockID = @StockID
  WHERE a.ChID = @ChID AND a.TSrcPosID = @SrcPosID

  SELECT @TNewQty = TNewQty, @UM = UM
  FROM t_VenA WHERE ChID = @ChID AND TSrcPosID = @SrcPosID

  SELECT 
      @TQty = ISNULL(SUM(r.Qty), 0), 
      @TSumMC = ISNULL(SUM(r.Qty * pp.CostAC), 0), 
      @TSumCC = ISNULL(SUM(r.Qty * pp.CostCC), 0)
  FROM #RemD r 
  INNER JOIN t_PInP pp ON r.ProdID = pp.ProdID AND r.PPID = pp.PPID 
  WHERE r.ProdID = @ProdID

  SELECT 
      @TPQty = ISNULL(SUM(r.Qty), 0), 
      @TPSumMC = ISNULL(SUM(r.Qty * pp.CostAC), 0), 
      @TPSumCC = ISNULL(SUM(r.Qty * pp.CostCC), 0)
  FROM #RemD r 
  INNER JOIN t_PInP pp ON r.ProdID = pp.ProdID AND r.PPID = pp.PPID 
  WHERE r.ProdID = @ProdID AND r.Qty > 0    

  SELECT 
      @TZQty = /*ISNULL(SUM( - r.Qty), 0) 
  FROM #RemD r 
  WHERE r.ProdID = @ProdID AND r.Qty < 0
  AND r.PPID =*/ 0    

  SELECT  @Qty = @TPQty - @TNewQty
  IF @Qty < 0
    SELECT @Qty = 0

  SELECT @TaxPercent = dbo.zf_GetProdExpTax(@ProdID, @OurID, @DocDate)

  DECLARE VenDCursor CURSOR LOCAL FAST_FORWARD 
  FOR 
  SELECT 
      r.PPID, r.Qty, pp.CostCC
  FROM #RemD r 
  INNER JOIN t_PInP pp  ON r.ProdID = pp.ProdID AND r.PPID = pp.PPID 
  WHERE r.ProdID = @ProdID AND 
        (r.Qty > 0 OR (r.Qty < 0 /*AND r.PPID <> 0*/))
  ORDER BY SIGN(r.Qty), pp.ProdDate, pp.PPID

  OPEN VenDCursor
  FETCH NEXT FROM VenDCursor
  INTO @PPID, @PPQty, @CostCC
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT
        @NewQty = CASE 
                    WHEN @Qty < @PPQty 
                    THEN @PPQty - @Qty
                    ELSE 0
                  END  
      SELECT 
          @DSrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 
      FROM t_VenD 
      WHERE ChID = @ChID AND DetProdID = @ProdID 

      INSERT INTO t_VenD
        (
          ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, 
          PriceCC_nt, PriceCC_wt, Tax, TaxSum, 
          SumCC_nt, SumCC_wt, NewQty, 
          NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID 
        )
      SELECT 
          @ChID, @ProdID, @DSrcPosID, @PPID, @UM, @PPQty, 
          dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @CostCC, dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), @PPQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
          @PPQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @PPQty * @CostCC, @NewQty, 
          @NewQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @NewQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
          @NewQty * @CostCC, 1 

      IF @PPQty > 0
      SELECT 
          @Qty = @Qty + @NewQty - @PPQty

      FETCH NEXT FROM VenDCursor
      INTO @PPID, @PPQty, @CostCC        
    END
  CLOSE VenDCursor
  DEALLOCATE VenDCursor

    IF @TNewQty > @TPQty OR @TZQty > 0
      BEGIN
        SELECT 
            @CostCC = 0, 
            @CostMC = 0

        IF @TQty > 0
        SELECT 
            @CostMC = @TPSumMC / @TPQty, 
            @CostCC = @TPSumCC / @TPQty
        ELSE 
        SELECT TOP 1 
            @CostMC = CostAC, 
            @CostCC = CostCC
        FROM t_PInP 
        WHERE ProdID = @ProdID AND PPID = dbo.zf_GetSPPID(@OurID, @StockID, @DocDate, @ProdID)

        IF @CostCC = 0
        SELECT
            @CostCC = RecStdPriceCC, 
            @CostMC = RecStdPriceCC / @KursMC
        FROM r_Prods
        WHERE ProdID = @ProdID

        SELECT
            @PPID = NULL

        SELECT 
            @PPID = PPID
        FROM #PrevPPs
        WHERE ProdID = @ProdID

        IF @PPID IS NULL
          BEGIN         
              EXEC t_VenExcessPPID 11022, @ChID, @OurID, @DocID, @StockID, @CompID, @DocDate, 1, 980, @ProdID, @PPID OUTPUT
              SELECT @CostCC = CostCC FROM t_PInP WITH(NOLOCK) WHERE ProdID = @ProdID AND PPID = @PPID 
          END
        ELSE
          BEGIN
            UPDATE t_PInP
            SET
                PriceMC = @CostMC, 
                CostAC = @CostMC, 
                PriceCC_In = @CostCC, 
                CostCC = @CostCC            
            WHERE ProdID = @ProdID AND PPID = @PPID
          END

        SELECT 
            @Qty = 
            CASE WHEN @TNewQty > @TPQty
                THEN @TNewQty - @TPQty 
                ELSE 0
            END

        SELECT 
            @DSrcPosID = ISNULL(MAX(SrcPosID), 0) + 1 
        FROM t_VenD 
        WHERE ChID = @ChID AND DetProdID = @ProdID 


        INSERT INTO t_VenD
        (
            ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, 
            PriceCC_nt, PriceCC_wt, Tax, TaxSum, 
            SumCC_nt, SumCC_wt, NewQty, 
            NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID 
        )
        SELECT 
            @ChID, @ProdID, @DSrcPosID, @PPID, @UM, - @TZQty, 
            dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @CostCC, dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), - @TZQty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
            - @TZQty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), - @TZQty * @CostCC, @Qty, 
            @Qty * dbo.zf_GetPrice_nt(@CostCC, @TaxPercent), @Qty * dbo.zf_GetIncludedTax(@CostCC, @TaxPercent), 
            @Qty * @CostCC, 1 
      END

      SELECT 
          @DSum = ISNULL(SUM(NewSumCC_wt - SumCC_wt), 0) 
      FROM t_VenD
      WHERE ChID = @ChID AND DetProdID = @ProdID

      UPDATE t_VenA
      SET 
          TQty = @TQty, 
          TSumCC_nt = dbo.zf_GetPrice_nt(@TSumCC, @TaxPercent), 
          TTaxSum = dbo.zf_GetIncludedTax(@TSumCC, @TaxPercent), 
          TSumCC_wt = @TSumCC, 
          TNewSumCC_nt = dbo.zf_GetPrice_nt(@TSumCC + @DSum, @TaxPercent), 
          TNewTaxSum = dbo.zf_GetIncludedTax(@TSumCC + @DSum, @TaxPercent), 
          TNewSumCC_wt = @TSumCC + @DSum
      WHERE ChID = @ChID AND ProdID = @ProdID

END
GO
