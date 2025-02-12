SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_Insert_Sales](@ASrcPosID int, @AChID bigint, @AProdID int, @APPID int, @appSecID int, @ABarCode varchar(255), 
                               @ATaxTypeID int, @AUM varchar(255), @RemQty numeric(21,9), @APriceCC_nt numeric(21,9), 
                               @ASumCC_nt numeric(21,9), @ATax numeric(21,9), @ATaxSum numeric(21,9), 
                               @APriceCC_wt numeric(21,9), @ARemSumCC_wt numeric(21,9), 
                               @APurPriceCC_nt numeric(21,9), @APurTax numeric(21,9), @APurPriceCC_wt numeric(21,9), 
                               @InsertLevel int, @PLID int, @EmpID int, @CreateTime datetime, @ModifyTime datetime, @RealPrice numeric(21, 9),
			       @RealSum numeric(21, 9), @MarkCode int, @LevyMark varchar(20)) AS 
BEGIN 
  SELECT @APriceCC_nt = Round(@APriceCC_nt, 5), @ATaxSum = Round(@ATaxSum, 5), @ATax = Round(@ATax, 5) 

  IF @InsertLevel = 0 
    BEGIN 
      INSERT INTO t_SaleD(SrcPosID, ChID, ProdID, PPID, SecID, BarCode, TaxTypeID, UM, Qty, 
                       PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, EmpID,
		       CreateTime, ModifyTime, RealPrice, RealSum, MarkCode, LevyMark) VALUES ( 
                       @ASrcPosID, 
                       @AChID, 
                       @AProdID, 
                       @APPID, 
                       @appSecID, 
                       @ABarCode, 
                       @ATaxTypeID, 
                       @AUM, 
                       @RemQty, 
                       @APriceCC_nt, 
                       @ASumCC_nt, 
                       @ATax, 
                       @ATaxSum, 
                       @APriceCC_wt, 
                       @ARemSumCC_wt, 
                       @APurPriceCC_nt, 
                       @APurTax, 
                       @APurPriceCC_wt, 
                       @PLID, 
                       @EmpID, 
                       @CreateTime, 
                       @ModifyTime,  
                       @RealPrice, 
                       @RealSum, 
		       @MarkCode,
		       @LevyMark) 
      IF @@ERROR <> 0 GOTO Error 
    END 
  ELSE 
    BEGIN 
      BEGIN
 
      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('t_Insert_Sales: Данный режим больше не поддерживается')
 
      RAISERROR (@Error_msg1, 18, 1)  
      END

      IF @@ERROR <> 0 GOTO Error 
    END 

  RETURN 1 
  ERROR: 
    RETURN 0 
END
GO