SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetRetTotals](
  @ChID bigint,
  @PureSumCC_wt numeric(21,9) OUTPUT,
  @PureASum numeric(21,9) OUTPUT,
  @PureBSum numeric(21,9) OUTPUT,
  @SumCC_wt numeric(21,9) OUTPUT,
  @ASum numeric(21,9) OUTPUT,
  @BSum numeric(21,9) OUTPUT,
  @Disc numeric(21,9) OUTPUT,
  @DiscSum numeric(21,9) OUTPUT,
  @ADiscSum numeric(21,9) OUTPUT,
  @BDiscSum numeric(21,9) OUTPUT)
AS
BEGIN
  DECLARE @ASum1 numeric(21, 9), @ASum2 numeric(21, 9), @TaxTypeID int, @ChequeDisc numeric(21, 9)

  SELECT @Disc = Discount FROM t_CRRet WHERE ChID = @ChID

  DECLARE ChequeCursor CURSOR FOR
  SELECT SumCC_wt, SumCC_wt, TaxTypeID
  FROM t_CRRetD
  WHERE ChID = @ChID

  SELECT
    @PureSumCC_wt = 0,
    @PureASum = 0,
    @PureBSum = 0,
    @SumCC_wt = 0,
    @ASum = 0,
    @BSum = 0

  OPEN ChequeCursor
  FETCH NEXT FROM ChequeCursor
  INTO @ASum1, @ASum2, @TaxTypeID

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @PureSumCC_wt = @PureSumCC_wt + @ASum1
    SET @SumCC_wt = @SumCC_wt + @ASum2
    IF @TaxTypeID = 0
    BEGIN
      SET @PureASum = @PureASum + @ASum1
      SET @ASum = @ASum + @ASum2
    END
    ELSE
    BEGIN
      SET @PureBSum = @PureBSum + @ASum1
      SET @BSum = @BSum + @ASum2
    END

    FETCH NEXT FROM ChequeCursor
    INTO @ASum1, @ASum2, @TaxTypeID
  END

  CLOSE ChequeCursor
  DEALLOCATE ChequeCursor

  SET @DiscSum = @PureSumCC_wt - @SumCC_wt
  SET @ADiscSum = @PureASum - @ASum
  SET @BDiscSum = @PureBSum - @BSum
END
GO