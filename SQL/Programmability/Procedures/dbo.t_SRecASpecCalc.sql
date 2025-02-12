SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SRecASpecCalc] 
( 
  @OurID int, @StockID int, @SubStockID int,  
  @DocDate smalldatetime, @KursMC numeric(21,9),  
  @AChID bigint, @ProdID int, @PPID int OUTPUT,  
  @Qty numeric(21,9), @CurrID int 
) 
AS 
/* Расчет позици документа Комплектация товара по Калькуляционной карте */ 
BEGIN 
  DECLARE @PriceCC numeric(21,9), @CompID int, @DocPriceCC numeric(21, 9), @PLID INT, @VarValue bigint  
 
  SELECT @VarValue = CAST(REPLACE(ISNULL(VarValue, 0),'.','') AS BIGINT) FROM z_Vars WHERE VarName = 'GMS_DBVersion' 
 
  SELECT @PLID = ISNULL(VarValue, 0) FROM z_UserVars WHERE VarName = 'z_LastUsedPlID' AND UserCode = dbo.zf_GetUserCode() 
 
  IF @VarValue < 31600 
    SELECT @CurrID = dbo.zf_GetCurrMC() 
  SELECT @CompID = 0 
 
  DELETE t_SRecD WHERE AChID = @AChID 
 
  EXECUTE t_SRecDSpecCalc 
    @OurID = @OurID, @StockID = @StockID, @SubStockID = @SubStockID,  
    @DocDate = @DocDate, @KursMC = @KursMC, @AChID = @AChID, @ProdID = @ProdID,  
    @Qty = @Qty 
 
  /* Обновление Суммы для комплекта */ 
  UPDATE sa 
  SET 
    sa.PriceCC_nt = sd.SumCC_nt / sa.Qty, 
    sa.SumCC_nt = sd.SumCC_nt, 
    sa.Tax = sd.TaxSum / sa.Qty,  
    sa.TaxSum = sd.TaxSum, 
    sa.PriceCC_wt = sd.SumCC_wt / sa.Qty, 
    sa.SumCC_wt = sd.SumCC_wt, 
    sa.NewPriceCC_nt = sd.SumCC_nt / sa.Qty, 
    sa.NewSumCC_nt = sd.SumCC_nt, 
    sa.NewTax = sd.TaxSum / sa.Qty,  
    sa.NewTaxSum = sd.TaxSum, 
    sa.NewPriceCC_wt = sd.SumCC_wt / sa.Qty, 
    sa.NewSumCC_wt = sd.SumCC_wt,  
    sa.PriceCC = CASE mp.PriceMC WHEN 0 THEN sd.SumCC_wt / sa.Qty ELSE mp.PriceMC END, 
    sa.Extra =  
    CASE  
      WHEN sd.SumCC_wt > 0 THEN (CASE mp.PriceMC WHEN 0 THEN sd.SumCC_wt / sa.Qty ELSE mp.PriceMC END * sa.Qty / sd.SumCC_wt - 1) * 100  
      ELSE 0 
    END 
  FROM t_SRecA sa WITH (NOLOCK)  
  JOIN r_ProdMP mp WITH (NOLOCK) ON sa.ProdID = mp.ProdID /*AND mp.PLID = @PLID  */
  CROSS JOIN 
  ( 
    SELECT  
      CAST(ISNULL(SUM(SubSumCC_nt), 0) AS float) SumCC_nt,  
      CAST(ISNULL(SUM(SubTaxSum), 0) AS float) TaxSum,  
      CAST(ISNULL(SUM(SubSumCC_wt), 0) AS float) SumCC_wt 
    FROM t_SRecD WITH (NOLOCK) 
    WHERE AChID = @AChID 
  ) sd  
  WHERE sa.AChID = @AChID AND sa.Qty > 0 
 
  SELECT @PriceCC = PriceCC_wt 
  FROM t_SRecA WITH (NOLOCK) 
  WHERE AChID = @AChID 
 
  /* Формирование и обновление партии комплекта */ 
  IF @PPID =  0 
    BEGIN 
      SELECT TOP 1 @PPID = PPID 
      FROM t_PInP tp 
      INNER JOIN dbo.zf_PPIDRange() r ON 1=1 
      WHERE tp.ProdID = @ProdID AND 
          tp.PPID <> 0 AND 
          tp.CompID = @CompID AND 
          tp.PPID BETWEEN r.PPIDStart AND r.PPIDEnd AND  
          tp.ProdDate = @DocDate AND 
          dbo.tf_CanChangePP(ProdID, PPID) = 1 
      ORDER BY PPID 
    END 
 
  IF ISNULL(@PPID, 0) = 0 
    BEGIN 
      SELECT @PPID = dbo.tf_NewPPID(@ProdID)   
 
      INSERT INTO t_PInP 
      ( 
        ProdID, PPID, PPDesc, PriceMC_In, PriceMC,  
        Priority, ProdDate, CurrID, CompID, Article,  
        CostAC, PPWeight, File1, File2, File3,  
        PriceCC_In, CostCC, PPDelay,  
        ProdPPDate, IsCommission 
      ) 
      SELECT  
        @ProdID, @PPID, '', @PriceCC / @KursMC, 0,  
        0, @DocDate, @CurrID, @CompID, '',  
        @PriceCC / @KursMC, 0, '', '', '',  
        @PriceCC, @PriceCC, 0,  
        @DocDate, 0 
 
      UPDATE  
        t_SRecA 
      SET 
        PPID = @PPID 
      WHERE AChID = @AChID AND PPID <> @PPID 
    END 
  ELSE  
    BEGIN 
      UPDATE  
        t_SRecA 
      SET 
        PPID = @PPID 
      WHERE AChID = @AChID AND 
        PPID <> @PPID 
 
      UPDATE t_PInP 
      SET 
        PriceMC_In = @PriceCC / @KursMC,  
        ProdDate = @DocDate, 
        CurrID = @CurrID,  
        CompID = @CompID,  
        CostAC = @PriceCC / @KursMC,  
        PriceCC_In = @PriceCC,  
        CostCC = @PriceCC, 
        ProdPPDate = @DocDate 
      WHERE  
        ProdID = @ProdID AND PPID = @PPID  
    END 
END
GO