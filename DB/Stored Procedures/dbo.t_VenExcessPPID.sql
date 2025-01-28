SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_VenExcessPPID](@DocCode int, @ChID bigint, @OurID int, @DocID bigint, @StockID int, @CompID int, @DocDate smalldatetime, @RateMC numeric(21, 9), @CurrID int, @ProdID int, @PPID int OUTPUT)
AS
/* Возвращает партию приходования излишка */
BEGIN
  DECLARE @VenExcessPP int, @VenExcessPPCost int
  DECLARE @LastPPID int
  SELECT @VenExcessPP = dbo.zf_Var('t_VenExcessPP')
  SELECT @VenExcessPPCost = dbo.zf_Var('t_VenExcessPPCost')

  IF @VenExcessPP > 2
    BEGIN
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Некорректный метод приходования излишков инвентаризации')

      RAISERROR (@Error_msg1, 18, 1)
      END

      RETURN
    END

  IF @VenExcessPP = 1 OR @VenExcessPP = 2 AND @VenExcessPPCost = 1
    SELECT TOP 1 @LastPPID = PPID FROM dbo.tf_ProdRecs(@OurID, @StockID, @ProdID)

  /* Максимальная партия с остатком */
  IF @VenExcessPP = 0
    BEGIN
      SELECT @PPID = MAX(PPID) FROM t_Rem WHERE OurID = @OurID AND StockID = @StockID AND ProdID = @ProdID AND Qty - AccQty > 0
      IF @PPID IS NULL OR @PPID = 0
        BEGIN
          SELECT @PPID = dbo.tf_NewPPID(@ProdID)
          IF @PPID IS NULL GOTO Error
        END
      RETURN
    END

  /* Партия последнего прихода */
  IF @VenExcessPP = 1
    BEGIN
      SELECT @PPID = ISNULL(MAX(PPID), 0) FROM dbo.tf_ProdRecs(@OurID, @StockID, @ProdID)
      WHERE DocDate <= @DocDate
      RETURN
    END

  /* Новая партия */
  DECLARE @CostCC numeric(21, 9), @CostAC numeric(21, 9)

  /* Нулевая себестоимость */
  IF @VenExcessPPCost = 0
    BEGIN
      SELECT
        @CostCC = 0,
        @CostAC = 0
    END
  /* Себестоимость последнего прихода */
  ELSE IF @VenExcessPPCost = 1
    BEGIN
      SELECT
        @CostAC = CostAC,
        @CostCC = CostCC,
        @CurrID = CurrID
      FROM
        t_pInP WITH(NOLOCK)
      WHERE
        ProdID = @ProdID AND PPID = @LastPPID
    END
  /* Средневзвешенная себестоимость */
  ELSE IF @VenExcessPPCost = 2
    BEGIN
      DECLARE @SumQty numeric(21, 9)
      SELECT
        @CostAC = SUM(CostAC * Qty),
        @CostCC = SUM(CostCC * Qty),
        @SumQty = SUM(Qty)
      FROM
        t_Rem r WITH(NOLOCK), t_pInP p WITH(NOLOCK)
      WHERE
        r.OurID = @OurID AND
        r.StockID = @StockID AND
        r.ProdID = @ProdID AND
        r.ProdID = p.ProdID AND
        r.PPID = p.PPID

      SELECT @SumQty = ISNULL(@SumQty, 0)
      IF @SumQty = 0
        SELECT @CostAC = 0, @CostCC = 0
      ELSE
        SELECT @CostAC = dbo.zf_RoundPriceRec(@CostAC / @SumQty), @CostCC = dbo.zf_RoundPriceRec(@CostCC / @SumQty)
    END

  SELECT @CostCC = ISNULL(@CostCC, 0), @CostAC = ISNULL(@CostAC, 0)

  SELECT @PPID = dbo.tf_NewPPID(@ProdID)
  IF @PPID IS NULL GOTO Error
  INSERT INTO t_PInP (ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, ProdDate, CurrID, CompID, Article, CostAC, PPWeight, PriceCC_In, CostCC, PPDelay, IsCommission)
  VALUES (@ProdID, @PPID, dbo.zf_Translate('Излишек инвентаризации'), @CostAC, 0, 0, @DocDate, @CurrID, @CompID, '', @CostAC, 0, @CostCC, @CostCC, 0, 0)
  RETURN

Error:
  SET @PPID = 0
  BEGIN

  DECLARE @Error_msg2 varchar(2000) = dbo.zf_Translate('Новый номер партии для таблицы t_pInP находится вне допустимого диапазона')

  RAISERROR(@Error_msg2, 18, 1)
  END

END

GO
