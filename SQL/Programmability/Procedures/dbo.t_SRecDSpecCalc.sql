SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SRecDSpecCalc]  
( 
  @OurID int, @StockID int, @SubStockID int,  
  @DocDate smalldatetime, @KursMC numeric(21,9), @AChID bigint, @ProdID int,  
  @Qty numeric(21,9), @UseSubItems bit = 1 
) 
AS 
/* Расчет составляющих для позиции документа Комплектация по Калькуляционной карте */ 
BEGIN 
  DECLARE 
    @SubSrcPosID int, @SubPPID int, @PLID int, 
    @SubPPQty numeric(21,9), @SubBarCode varchar(42),  
    @SubUM varchar(10), @SubPriceCC numeric(21,9),  
    @SubSecID int, @SpecChID bigint, @AProdID int 
 
  SELECT @SubUM = UM 
  FROM r_Prods WITH (NOLOCK) 
  WHERE ProdID = @ProdID 
 
  SELECT @SubBarCode = BarCode 
  FROM r_ProdMQ WITH (NOLOCK) 
  WHERE ProdID = @ProdID AND UM = @SubUM 
 
  SELECT @PLID = ISNULL(VarValue, 0) FROM z_UserVars WHERE VarName = 'z_LastUsedPlID' AND UserCode = dbo.zf_GetUserCode() 
 
  IF @SubBarCode IS NULL OR @SubBarCode = '' 
    BEGIN  
      BEGIN
  
      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Для товара-комплектующего %u невозможно получить штрихкод основной единицы измерения "%s".')
  
      RAISERROR (@Error_msg1, 18, 1, @ProdID, @SubUM)   
      END

      RETURN 1  
    END 
 
  SELECT @AProdID = ProdID 
  FROM t_SRecA WITH (NOLOCK) 
  WHERE AChID = @AChID AND ProdID = @ProdID AND @StockID = @SubStockID 
 
  IF @UseSubItems = 1 
    SELECT TOP 1 
      @SpecChID = ChID 
    FROM t_Spec WITH (NOLOCK) 
    WHERE  
      /*OurID = @OurID  /*Убран контроль за привязкой проданного блюда к фирме, указанной в Кальк.К.*/ 
      AND */DocDate <= @DocDate  
      AND ProdID = @ProdID 
    ORDER BY DocDate DESC, DocID DESC 
 
  IF @SpecChID IS NULL 
    SELECT @UseSubItems = 0 
 
  /* Списание товара по FIFO и последней партии прихода */ 
  WHILE @Qty > 0  
    BEGIN  
      SELECT @SubPPQty = NULL  
      SELECT TOP 1  
        @SubPPID = r.PPID,  
        @SubPPQty = (r.Qty - r.AccQty),  
        @SubSecID = r.SecID 
      FROM t_Rem r WITH (NOLOCK) 
          INNER JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = r.ProdID AND tp.PPID = r.PPID 
          LEFT JOIN t_SRecA sra WITH(NOLOCK) ON sra.ProdID = r.ProdID /*Отнимается остаток, сформированый этим же документом*/ 
                              AND sra.PPID = r.PPID  
                              AND sra.ChID = (SELECT ChID FROM t_SRecA WHERE AChID = @AChID)   
      WHERE  
        r.OurID = @OurID AND r.StockID = @SubStockID  
        AND r.ProdID = @ProdID 
        AND (r.Qty - r.AccQty) - ISNULL(sra.Qty,0) > 0 
        AND (r.ProdID <> @AProdID OR @AProdID IS NULL) 
        AND tp.ProdDate <= @DocDate 
      ORDER BY  
        r.PPID, r.SecID  
 
      IF @SubPPQty > @Qty 
        SELECT @SubPPQty = @Qty  
      SELECT @Qty = @Qty - ISNULL(@SubPPQty, 0)  
 
      IF @SubPPQty IS NULL 
        BEGIN 
          IF @UseSubItems = 0 
            SELECT  
              @SubPPID = dbo.tf_GetLastSPPID(@OurID, @SubStockID, @DocDate, @ProdID),  
              @SubSecID = 1,  
              @SubPPQty = @Qty, @Qty = 0  
          ELSE 
            BEGIN 
              /* Раскрутка на составляющие по Калькуляционной карте */ 
              DECLARE SRecD CURSOR LOCAL FAST_FORWARD 
              FOR  
              SELECT 
                ProdID, @Qty * SUM(Qty) Qty, UseSubItems 
              FROM t_SpecD d WITH (NOLOCK) 
              WHERE ChID = @SpecChID 
              GROUP BY ProdID, UseSubItems  
 
              OPEN SRecD 
                FETCH NEXT FROM SRecD  
                INTO @ProdID, @Qty, @UseSubItems 
              WHILE @@FETCH_STATUS = 0 
              BEGIN 
                EXECUTE t_SRecDSpecCalc 
                  @OurID = @OurID, @StockID = @SubStockID, @SubStockID = @SubStockID,  
                  @DocDate = @DocDate, @KursMC = @KursMC, @AChID = @AChID, @ProdID = @ProdID,  
                  @Qty = @Qty, @UseSubItems = @UseSubItems 
 
                FETCH NEXT FROM SRecD  
                INTO @ProdID, @Qty, @UseSubItems 
              END 
              CLOSE SRecD 
              DEALLOCATE SRecD 
 
              SELECT @Qty = 0 
            END 
        END 
      IF @SubPPQty IS NOT NULL 
        BEGIN    
          SELECT @SubPriceCC = CostCC 
          FROM t_PInP WITH (NOLOCK) 
          WHERE ProdID = @ProdID AND PPID = @SubPPID  
 
          SELECT @SubSrcPosID = ISNULL(MAX(SubSrcPosID), 0) + 1  
          FROM t_SRecD WITH (NOLOCK) WHERE AChID = @AChID  
 
          INSERT INTO t_SRecD 
          ( 
            AChID, SubSrcPosID, SubProdID,  
            SubPPID, SubUM, SubQty,  
            SubPriceCC_nt, SubSumCC_nt,  
            SubTax, SubTaxSum,  
            SubPriceCC_wt, SubSumCC_wt,  
            SubNewPriceCC_nt, SubNewSumCC_nt,  
            SubNewTax, SubNewTaxSum,  
            SubNewPriceCC_wt, SubNewSumCC_wt,  
            SubSecID, SubBarCode 
          ) 
          SELECT 
            @AChID, @SubSrcPosID, @ProdID,  
            @SubPPID, @SubUM, @SubPPQty,  
            @SubPriceCC, @SubPriceCC * @SubPPQty,  
            0, 0,  
            @SubPriceCC, @SubPriceCC * @SubPPQty,  
            @SubPriceCC, @SubPriceCC * @SubPPQty,  
            0, 0,  
            @SubPriceCC, @SubPriceCC * @SubPPQty,  
            @SubSecID, @SubBarCode 
        END 
  END 
END
GO