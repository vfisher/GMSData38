SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleInsertProd]( 
  @ASrcPosID int OUTPUT, 
  @ProdID int, 
  @ATaxTypeID int, 
  @Qty numeric(21, 9), 
  @APriceCC_wt numeric(21, 9), 
  @ASumCC_wt numeric(21, 9), 
  @APurPriceCC_wt numeric(21, 9), 
  @APurSumCC_wt numeric(21, 9), 
  @BarCode varChar(255), 
  @AUM varchar(40), 
  @AChID bigint, 
  @appOurID int, 
  @appStockID int, 
  @appSecID int, 
  @appCRID int, 
  @InsertLevel int, 
  @APLID int, 
  @ARealQty numeric(21, 9), 
  @ATIntQty numeric(21, 9), 
  @EmpID int, 
  @CreateTime datetime, 
  @ModifyTime DATETIME, 
  @MarkCode INT,
  @LevyMark varchar(20)) 
AS 
BEGIN 
  DECLARE @FlStatus int, @ResStatus int 
  DECLARE @AErrorSumCC_wt numeric(21, 9) 
  DECLARE @ASumCC_nt numeric(21, 9) 
  DECLARE @ATax numeric(21, 9) 
  DECLARE @ATaxSum numeric(21, 9) 
  DECLARE @APriceCC_nt numeric(21, 9) 
  DECLARE @ADate datetime 
  DECLARE @PPID int 
  DECLARE @RemQty numeric(21, 9) 
  DECLARE @ARemSumCC_wt numeric(21, 9) 
  DECLARE @TempQty numeric(21, 9) 
  DECLARE @SrcPosID int 
  DECLARE @APurTax numeric(21, 9) 
  DECLARE @APurPriceCC_nt numeric(21, 9) 
  DECLARE @AProdTax numeric (21, 9) 
  DECLARE @appPP int 
  DECLARE @appSPP int 
  DECLARE @APriorPP int 

  SET @appPP = dbo.zf_Var('t_PP') 
  SET @appSPP = dbo.zf_Var('t_SPP') 
  SET @APriorPP = dbo.zf_Var('t_PriorityPP') 

  SELECT @ASumCC_wt = dbo.zf_RoundPriceSale(@APriceCC_wt * @Qty) 

  Start: 
  BEGIN TRAN 
  SELECT @AProdTax = dbo.zf_GetProdExpTax(@ProdID, @appOurID, dbo.zf_GetDate(GETDATE())) /* Ставка НДС товара с учетом внутр. фирмы */ 
  SET @AErrorSumCC_wt = @ASumCC_wt 

  /* Для проверки отрицательного остатка по всем партиям товара раскомментировать следующие 2 строки */ 
  /* 
  UPDATE t_Rem SET Qty = Qty WHERE ProdID = @ProdID 
  IF @@ERROR <> 0 GOTO Error 
  */ 

  SELECT 
    @APriceCC_nt = dbo.zf_GetPrice_nt(@APriceCC_wt, @AProdTax), 
    @ASumCC_nt = dbo.zf_GetPrice_nt(@ASumCC_wt, @AProdTax), 
    @APurPriceCC_nt = dbo.zf_GetPrice_nt(@APurPriceCC_wt, @AProdTax) 

  SELECT 
    @ATax = @APriceCC_wt - @APriceCC_nt, 
    @APurTax = @APurPriceCC_wt - @APurPriceCC_nt 

  DECLARE appPPQuery CURSOR LOCAL FAST_FORWARD FOR 
  SELECT * FROM dbo.tf_GetPPIDRems(@appPP, @appOurID, @appStockID, @appSecID, @ProdID) 

  OPEN appPPQuery 
  IF @@ERROR <> 0 GOTO Error 
  /* Цикл по количеству */ 

  FETCH NEXT FROM appPPQuery 
  INTO @SrcPosID, @ADate, @PPID, @RemQty, @RemQty 
  IF @@ERROR <> 0 GOTO Error 

  SELECT @FlStatus = @@FETCH_STATUS 
  WHILE @Qty > 0 
    BEGIN 
      IF @FlStatus <> 0 BREAK 

      /*Анализ приоритета*/ 
      IF @appPP = 4 
        BEGIN 
          EXECUTE @ResStatus = t_GetPriorityPPID @appOurID, @appStockID, @ProdID, @appSecID, @PPID, '', @APriorPP, @PPID OUTPUT 
          IF (@@ERROR <> 0) OR (@ResStatus <> 0) GOTO Error 

          SELECT @RemQty = SUM(Qty) - ISNULL(SUM(AccQty), 0) 
          FROM t_Rem 
          WHERE OurID = @appOurID AND StockID = @appStockID AND SecID = @appSecID AND ProdID = @ProdID AND PPID = @PPID 
          IF (@@ERROR <> 0) GOTO Error 
        END 

      SELECT @RemQty = ISNULL(@RemQty, 0) 
      IF (@appPP = 0) OR (@appPP = 1) 
        BEGIN 
          EXECUTE @ResStatus = t_GetRet @appOurID, @appStockID, @appSecID, @PPID, @ProdID, @ADate, 1, @RemQty OUTPUT 
          IF (@@ERROR <> 0) OR (@ResStatus <> 1) GOTO Error 

          EXECUTE @ResStatus = t_GetRet @appOurID, @appStockID, @appSecID, @PPID, @ProdID, @ADate, 0, @TempQty OUTPUT 
          IF (@@ERROR <> 0) OR (@ResStatus <> 1) GOTO Error 

          SELECT @RemQty = @RemQty - @TempQty 
          SELECT @RemQty = @RemQty + ISNULL(SUM(Qty), 0) - ISNULL(SUM(AccQty), 0) 
          FROM t_Rem WITH (HOLDLOCK) 
          WHERE OurID = @appOurID AND StockID = @appStockID AND SecID = @appSecID AND ProdID = @ProdID AND PPID = @PPID 
          IF @@ERROR <> 0 GOTO Error 
        END 

      IF @RemQty <= 0 
        BEGIN 
          FETCH NEXT FROM appPPQuery 
          INTO @SrcPosID, @ADate, @PPID, @RemQty, @RemQty 

          IF @@ERROR <> 0 GOTO Error 
          SELECT @FlStatus = @@FETCH_STATUS 
          CONTINUE 
        END 

      IF @RemQty >= @Qty 
        SELECT @RemQty = @Qty, @ARemSumCC_wt = @ASumCC_wt 
      ELSE 
        SELECT @ARemSumCC_wt = ROUND(@RemQty * @APriceCC_wt, 2) 
      /* Ниже идет разрушение ASumCC_wt */ 

      SELECT @ASumCC_nt = dbo.zf_GetPrice_nt(@ARemSumCC_wt, @AProdTax) 
      SELECT @ATaxSum = @ARemSumCC_wt - @ASumCC_nt 

      SELECT 
        @Qty = @Qty - @RemQty, 
        @ASumCC_wt = @ASumCC_wt - @ARemSumCC_wt 
      SELECT 
        @ASumCC_nt = ROUND(@ASumCC_nt, 5) 

      EXECUTE @ResStatus = t_Insert_Sales @ASrcPosID, @AChID, @ProdID, @PPID, @appSecID, @BarCode, 
        @ATaxTypeID, @AUM, @RemQty, @APriceCC_nt, @ASumCC_nt, @ATax, @ATaxSum, @APriceCC_wt, @ARemSumCC_wt, 
        @APurPriceCC_nt, @APurTax, @APurPriceCC_wt, @InsertLevel, @APLID, @EmpID, @CreateTime, @ModifyTime, @APriceCC_wt, @ARemSumCC_wt, @MarkCode, @LevyMark 
      IF (@@ERROR<>0) OR (@ResStatus <> 1) GOTO Error 
      EXEC z_CorrectProdLV 11035, @AChID, @ASrcPosID, 1 

      FETCH NEXT FROM appPPQuery 
      INTO @SrcPosID, @ADate, @PPID, @RemQty, @RemQty 
      SELECT @FlStatus = @@FETCH_STATUS, @ASrcPosID = @ASrcPosID + 1 
    END /* END к циклу по количеству */ 

  /* Обработка остатка на нулевую КЦП */ 
  IF @Qty > 0 
    BEGIN 
      IF @AProdTax = 0 
        SELECT @ATaxSum = 0 
      ELSE 
        SELECT @ATaxSum = @ASumCC_wt / ((100 + @AProdTax) / @AProdTax) 

      EXEC @ResStatus = t_GetSPPID @appOurID, @appStockID, @ProdID, @appSecID, @appSPP, @PPID OUTPUT 
      IF (@@ERROR <> 0) OR (@ResStatus <> 1) GOTO Error 

      SELECT @RemQty = @Qty, @ARemSumCC_wt = @ASumCC_wt 
      SELECT @ASumCC_nt = ROUND(@ASumCC_wt - @ATaxSum, 5) 

      EXECUTE @ResStatus = t_Insert_Sales @ASrcPosID, @AChID, @ProdID, @PPID, @appSecID, @BarCode, 
        @ATaxTypeID, @AUM, @RemQty, @APriceCC_nt, @ASumCC_nt, @ATax, @ATaxSum, @APriceCC_wt, @ARemSumCC_wt, 
        @APurPriceCC_nt, @APurTax, @APurPriceCC_wt, @InsertLevel, @APLID, @EmpID, @CreateTime, @ModifyTime, @APriceCC_wt, @ARemSumCC_wt, @MarkCode, @LevyMark 
      IF (@@ERROR <> 0) OR (@ResStatus <> 1) GOTO Error 
      EXEC z_CorrectProdLV 11035, @AChID, @ASrcPosID, 1 
      SELECT @ASrcPosID = @ASrcPosID + 1 
    END 

  COMMIT TRAN /* Подтверждение транзакции по товару */ 
  CLOSE appPPQuery 
  DEALLOCATE appPPQuery 

  RETURN 1 

  Error: 
  ROLLBACK TRAN 
  CLOSE appPPQuery 
  DEALLOCATE appPPQuery 
  RETURN 0 
END
GO
