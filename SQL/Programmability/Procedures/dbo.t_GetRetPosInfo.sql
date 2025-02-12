SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetRetPosInfo](@ChID bigint, @SrcPosID int,
        @ProdID int OUTPUT,
        @ProdName varchar(255) OUTPUT,
        @TaxTypeID int OUTPUT,
        @UM varchar(50) OUTPUT,
        @Qty numeric(21,9) OUTPUT,
        @IsDecQty bit OUTPUT, 
        @PriceCC_wt numeric(21,9) OUTPUT,
        @SumCC_wt numeric(21,9) OUTPUT,
        @BarCode varchar(42) OUTPUT,
        @RealBarCode varchar(42) OUTPUT,
        @Notes varchar(200) OUTPUT,
        @EmpID int OUTPUT,
        @EmpName varchar(200) OUTPUT,
        @CReasonID int OUTPUT,
        @RequireLevyMark bit OUTPUT,
        @LevyMark varchar(20) OUTPUT,
        @Result int OUTPUT)
/* Возвращает информацию о позиции возвратного чека */
AS
BEGIN
  IF (@SrcPosID < 0) SELECT @SrcPosID = MAX(SrcPosID) FROM t_CRRetD WHERE ChID = @ChID
  SELECT @ProdID = d.ProdID, @ProdName = p.ProdName, @TaxTypeID = d.TaxTypeID, @UM = d.UM, @Qty = d.Qty, @IsDecQty = p.IsDecQty,
    @PriceCC_wt = d.RealPrice, @SumCC_wt = d.RealSum, @BarCode = d.BarCode, @Notes = p.Notes, @EmpID = d.EmpID, @EmpName = e.EmpName
    , @CReasonID = d.CReasonID
    , @RequireLevyMark = p.RequireLevyMark
    , @LevyMark = d.LevyMark
  FROM r_Prods p, t_CRRetD d, r_Emps e
  WHERE d.ProdID = p.ProdID AND d.ChID = @ChID AND d.SrcPosID = @SrcPosID AND d.EmpID = e.EmpID

  IF @@ROWCOUNT = 0 SELECT @Result = 0
  ELSE SELECT @Result = 1 

  SELECT @RealBarCode = @BarCode
END
GO