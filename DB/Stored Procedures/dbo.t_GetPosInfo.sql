SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetPosInfo](@ChID bigint, @SrcPosID int,
        @ProdID int OUTPUT,
        @ProdName varchar(255) OUTPUT,
        @TaxTypeID int OUTPUT,
        @UM varchar(50) OUTPUT,
        @Qty numeric(21,9) OUTPUT,
        @RealQty numeric (21,9) OUTPUT,
        @FactQty numeric (21,9) OUTPUT,   
        @IsDecQty bit OUTPUT,     
        @PriceCC_wt numeric(21,9) OUTPUT,
        @SumCC_wt numeric(21,9) OUTPUT,
        @PurPriceCC_wt numeric(21,9) OUTPUT,
        @PurSumCC_wt numeric(21,9) OUTPUT,
        @BarCode varchar(42) OUTPUT,
        @RealBarCode varchar(42) OUTPUT,
        @PLID int OUTPUT,
        @CSrcPosID int OUTPUT,
        @PosStatus int OUTPUT,
        @ServingTime smalldatetime OUTPUT,
        @ServingID int OUTPUT,
        @CReasonID int OUTPUT,
        @CanEditQty bit OUTPUT,
        @Notes varchar(200) OUTPUT,
        @EmpID int OUTPUT,
        @EmpName varchar(200) OUTPUT,
        @RequireLevyMark bit OUTPUT,
        @LevyMark varchar(20) OUTPUT,
        @Result int OUTPUT)
/* Возвращает информацию о позиции чека во временной таблице */
AS
BEGIN
  IF (@SrcPosID < 0) SELECT @SrcPosID = MAX(SrcPosID) FROM t_SaleTempD WHERE ChID = @ChID
  DECLARE @ACSrcPosIDInt int
  SELECT @ACSrcPosIDInt = CSrcPosID FROM t_SaleTempD WHERE ChID = @ChID AND SrcPosID = @SrcPosID

  SELECT @ProdID = d.ProdID, @ProdName = p.ProdName, @TaxTypeID = d.TaxTypeID, @UM = d.UM, @Qty = d.Qty, @RealQty = d.RealQty, 
         @IsDecQty = p.IsDecQty, @PriceCC_wt = d.PriceCC_wt, @SumCC_wt = d.SumCC_wt, @PurPriceCC_wt = d.PurPriceCC_wt, @PurSumCC_wt = d.PurSumCC_wt,
         @BarCode = d.BarCode, @RealBarCode = d.RealBarCode, @PLID = d.PLID, @CSrcPosID = d.CSrcPosID, @PosStatus = d.PosStatus, 
         @ServingTime = d.ServingTime, @ServingID = d.ServingID, @CReasonID = d.CReasonID, @CanEditQty = d.CanEditQty, @Notes = p.Notes, 
         @EmpID = d.EmpID, @EmpName = d.EmpName,
         @FactQty = (SELECT SUM(i.Qty) FROM t_SaleTempD i WHERE i.ChID = @ChID AND i.CSrcPosID = @ACSrcPosIDInt)
       , @RequireLevyMark = p.RequireLevyMark
       , @LevyMark = d.LevyMark
  FROM r_Prods p, t_SaleTempD d
  WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @SrcPosID

  IF @@ROWCOUNT = 0 SELECT @Result = 0
  ELSE SELECT @Result = 1
END
GO
