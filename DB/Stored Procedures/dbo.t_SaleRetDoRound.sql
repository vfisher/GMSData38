SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleRetDoRound](@ChID bigint, @NeedRound BIT) 
AS 
BEGIN 
DECLARE @SalePriceCC_nt NUMERIC(21 ,9) 
DECLARE @SalePriceCC_wt NUMERIC(21 ,9) 
DECLARE @SrcDocID BIGINT 
DECLARE @OurID INT 
DECLARE @SaleSrcPosID INT 

/* ХП создавалась для клиента EVA-136 Округление в возвратах
* Логика округления - отобразить в возвратном чеке товары на общую сумму, равную округленной общей сумме товаров из продажи
* (на стадии утверждения решение о том, в большую или меньшую сторону выполнять округление). */
RETURN
 SELECT @SrcDocID = SrcDocID, @OurID = cm.OurID, @SaleSrcPosID = tcd.SaleSrcPosid FROM t_CRRet cm WITH(NOLOCK), t_CRRetD AS tcd WITH(NOLOCK) 
      WHERE cm.ChID = @ChID AND cm.ChID=tcd.ChID  AND tcd.SrcPosID =1 


SELECT @SalePriceCC_wt= sd.RealPrice * mq.Qty, @SalePriceCC_nt = sd.PriceCC_nt * mq.Qty  
 FROM t_Sale s, t_SaleD sd, r_ProdMQ mq, r_Prods p, r_Emps e 
 WHERE s.ChID = sd.ChID AND sd.ProdID = mq.ProdID AND sd.BarCode = mq.BarCode AND 
   sd.ProdID = p.ProdID AND sd.EmpID = e.EmpID AND s.OurID = @OurID AND s.DocID = @SrcDocID 
   AND NOT EXISTS(SELECT TOP 1 1 FROM t_SaleM sm WHERE sm.ChID = s.ChID AND sd.SrcPosID = sm.SaleSrcPosID) AND sd.SrcPosID=@SaleSrcPosID 

SELECT RealSum, @SalePriceCC_wt, @SalePriceCC_nt FROM t_CRRetD WHERE ChID = @ChID AND SrcPosID = 1     
	IF   @NeedRound=0 AND (SELECT PriceCC_wt-@SalePriceCC_wt FROM t_CRRetD WHERE ChID = @ChID AND SrcPosID = 1) <> 0  
    BEGIN /*отменяем округление  */
      UPDATE t_CRRetD 
      SET PriceCC_nt = @SalePriceCC_nt, 
          PriceCC_wt = @SalePriceCC_wt, 
          RealPrice = @SalePriceCC_wt 
      WHERE ChID = @ChID AND SrcPosID=1 

      UPDATE t_CRRetD 
        SET    SumCC_wt         = dbo.zf_RoundPriceSale(PriceCC_wt*Qty) 
              ,SumCC_nt         = dbo.zf_RoundPriceSale(PriceCC_nt*Qty) 
              ,RealSum          = dbo.zf_RoundPriceSale(RealPrice*Qty) 
        WHERE  ChID             = @ChID 
               AND SrcPosID     = 1 

     RETURN           
    END 

  IF @NeedRound=0 
    RETURN 

    /******************************************* 
    * округление 
    *******************************************/     
    DECLARE @ChequeSum NUMERIC(21 ,9) 
    DECLARE @RoundSum NUMERIC(21 ,9) 
    DECLARE @RoundPrice NUMERIC(21 ,9) 
    DECLARE @SrcPosID INT 
    DECLARE @NewSrcPosID INT 
    DECLARE @Qty NUMERIC(21 ,9) 
    DECLARE @NewQty NUMERIC(21 ,9)   


    SELECT @ChequeSum = SUM(SumCC_wt) 
    FROM   t_CRRetD 
    WHERE  ChID = @ChID 

    /*SELECT @RoundSum = (ROUND(@ChequeSum ,2) % 0.10)  */
    /* для SQL2000  */
    DECLARE @Temp INT 
    SELECT @Temp = ROUND(@ChequeSum,2)*100 
    SELECT @RoundSum=(@Temp % 10)/100.00 

    /*разбивка весовых позиций на 1 ед + остаток  */
    IF @RoundSum>0 
       AND @RoundSum<0.1 
    BEGIN 
        IF OBJECT_ID('tempdb..#RetD') IS NOT NULL 
            DROP TABLE #RetD 

        SELECT * INTO #RetD FROM t_CRRetD WHERE 0 = 1 

        SELECT @Qty = Qty 
              ,@NewQty          = Qty- 1 
              ,@SrcPosID        = SrcPosID 
        FROM   t_CRRetD 
        WHERE  ChID             = @ChID 
               AND SrcPosID     = 1 
               AND Qty>0 

        IF @NewQty>0 /* Есть что разделять */ 
        BEGIN 
            INSERT INTO #RetD 
            SELECT * 
            FROM   t_CRRetD 
            WHERE  ChID             = @ChID 
                   AND SrcPosID     = 1 

            UPDATE t_CRRetD 
            SET    Qty = 1 
                  ,SumCC_wt = PriceCC_wt 
                  ,SumCC_nt = PriceCC_nt 
                  ,RealSum = RealPrice 
            WHERE  SrcPosID = 1 
                   AND ChID = @ChID      

            SELECT @NewSrcPosID = MAX(SrcPosID) 
            FROM   t_CRRetD d 
            WHERE  ChID = @ChID           

            SELECT @NewSrcPosID = CASE  
                                       WHEN @NewSrcPosID>MAX(d.SrcPosID) THEN @NewSrcPosID+1 
                                       ELSE MAX(d.SrcPosID)+1 
                                  END 
            FROM   #RetD d 
            WHERE  ChID = @ChID  

            PRINT @NewSrcPosID 

            UPDATE #RetD 
            SET    Qty = @NewQty 
                  ,SrcPosID = @NewSrcPosID 
                  ,SumCC_nt = dbo.zf_RoundPriceSale((Qty- 1)*PriceCC_nt) 
                  ,SumCC_wt = dbo.zf_RoundPriceSale((Qty- 1)*PriceCC_wt) 
                  ,RealSum = dbo.zf_RoundPriceSale((Qty- 1)*RealPrice) 
            WHERE  SrcPosID = 1 

            INSERT INTO t_CRRetD 
            SELECT * 
            FROM   #RetD 
        END 

    /*само округление      */
        SELECT @Qty = Qty 
        FROM   t_CRRetD AS tcd 
        WHERE  ChID             = @ChID 
               AND SrcPosID     = 1 

        IF @RoundSum<0.05 AND @ChequeSum > 0.1
            UPDATE t_CRRetD 
            SET    PriceCC_nt       = PriceCC_nt-@RoundSum/@Qty 
                  ,PriceCC_wt       = PriceCC_wt-@RoundSum/@Qty 
                  ,RealPrice        = PriceCC_wt-@RoundSum/@Qty 
            WHERE  ChID             = @ChID 
                   AND SrcPosID     = 1 
        ELSE 
            UPDATE t_CRRetD 
            SET    PriceCC_nt = PriceCC_nt+(0.1-@RoundSum)/Qty 
                  ,PriceCC_wt = PriceCC_wt+(0.1-@RoundSum)/Qty 
                  ,RealPrice = PriceCC_wt+(0.1-@RoundSum)/Qty 
            WHERE  ChID = @ChID 
                   AND SrcPosID = 1  

        UPDATE t_CRRetD 
        SET    SumCC_wt         = dbo.zf_RoundPriceSale(PriceCC_wt*Qty) 
              ,SumCC_nt         = dbo.zf_RoundPriceSale(PriceCC_nt*Qty) 
              ,RealSum          = dbo.zf_RoundPriceSale(RealPrice*Qty) 
        WHERE  ChID             = @ChID 
               AND SrcPosID     = 1 
    END 
END
GO
