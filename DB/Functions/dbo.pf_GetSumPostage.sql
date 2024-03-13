SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetSumPostage](@Date datetime, @SumCC numeric(21, 9))
/* Возвращает размер почтового сбора от суммы на дату */
RETURNS numeric(21, 9) AS
BEGIN
  DECLARE @SumLimit1 numeric(21, 9), @SumLimit2 numeric(21, 9),
          @SumPostage1 numeric(21, 9), @SumPostage2 numeric(21, 9), @SumPostage3 numeric(21, 9) 
  IF @Date >= '20160101'
  BEGIN 
    SET @SumLimit1 = 500
    SET @SumLimit2 = 2000
    SET @SumPostage1 = 10
    SET @SumPostage2 = @SumCC * 0.02
    SET @SumPostage3 = @SumCC * 0.01
  END 

  SET @SumLimit1 = ISNULL(@SumLimit1,0)
  SET @SumLimit2 = ISNULL(@SumLimit2,0)
  SET @SumPostage1 = ISNULL(@SumPostage1,0)
  SET @SumPostage2 = ISNULL(@SumPostage2,0)
  SET @SumPostage3 = ISNULL(@SumPostage3,0)

  RETURN 
  CASE 
     WHEN @SumCC <= @SumLimit1 THEN @SumPostage1 
     WHEN (@SumCC > @SumLimit1 AND @SumCC <= @SumLimit2) THEN @SumPostage2  
     WHEN @SumCC > @SumLimit2 THEN @SumPostage3
  END 
END
GO
