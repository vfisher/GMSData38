SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetSaleCParams](
        @ChID bigint,
        @BarCode varchar(42),
        @RealBarCode varchar (42),
        @Qty numeric(21,9) OUTPUT,
        @PriceChanged bit,
        @PriceCC_wt numeric(21,9) OUTPUT,
        @PurPriceCC_wt numeric(21,9) OUTPUT,
        @PLID int OUTPUT,
        @CSrcPosID int OUTPUT,
        @SrcPosID int,
        @EmpID int OUTPUT,
        @EmpName varchar(200) OUTPUT,
        @MarkCode int,
        @LevyMark varchar(20),
        @Result int OUTPUT)
/* Возвращает параметры отмены продажи товара для торговых модулей */
AS
BEGIN
  SET @Result = 1
  IF @PriceChanged = CAST(1 AS bit) RETURN
  DECLARE @NeedCorrectQty bit
  SELECT @NeedCorrectQty = CASE WHEN @CSrcPosID IS NULL THEN 1 ELSE 0 END
  SELECT @PriceCC_wt = NULL
  DECLARE @NewCSrcPosID int

  /* DEV-2847. Сначала проверим, есть ли товар, у которого совпадает остаток кол-ва.
     Для весовых товаров и отмены по ШК нужно отменять именно ту позицию, что добавили, а не первую подходящую по кол-ву */
  IF @CSrcPosID IS NULL AND (@BarCode <> @RealBarCode)
    SELECT TOP 1 @NewCSrcPosID = CSrcPosID 
    FROM t_SaleTempD 
    WHERE ChID = @ChID AND RealBarCode = @RealBarCode AND CSrcPosID = ISNULL(@CSrcPosID, CSrcPosID) AND SrcPosID <> @SrcPosID AND RealBarCode <> BarCode
         AND (LevyMark = @LevyMark OR @LevyMark = '' OR @LevyMark IS NULL)
    GROUP BY CSrcPosID, PriceCC_wt, PLID, PurPriceCC_wt 
    HAVING SUM(Qty) = -@Qty 
    ORDER BY CSrcPosID, PriceCC_wt DESC

  IF @NeedCorrectQty = CAST(1 AS bit) SET @Qty = -0.001
  IF @NewCSrcPosID IS NULL  
    SELECT TOP 1 @NewCSrcPosID = CSrcPosID 
    FROM t_SaleTempD 
    WHERE ChID = @ChID AND RealBarCode = @RealBarCode AND MarkCode = @MarkCode AND CSrcPosID = ISNULL(@CSrcPosID, CSrcPosID) AND SrcPosID <> @SrcPosID 
          AND (LevyMark = @LevyMark OR @LevyMark = '' OR @LevyMark IS NULL)
    GROUP BY CSrcPosID, PriceCC_wt, PLID, PurPriceCC_wt 
    HAVING SUM(Qty) >= -@Qty 
    ORDER BY CSrcPosID, PriceCC_wt DESC

  SELECT @CSrcPosID = @NewCSrcPosID
  IF @NeedCorrectQty = CAST(1 AS bit) SELECT @Qty = -SUM(Qty)
  FROM t_SaleTempD 
  WHERE ChID = @ChID AND CSrcPosID = @CSrcPosID

  SELECT TOP 1 @PriceCC_wt = PriceCC_wt, @PLID = PLID, @PurPriceCC_wt = PurPriceCC_wt, @EmpID = EmpID, @EmpName = EmpName
  FROM t_SaleTempD 
  WHERE ChID = @ChID AND SrcPosID = @CSrcPosID

  IF @PriceCC_wt IS NULL SET @Result = 0 ELSE SET @Result = 1
END
GO