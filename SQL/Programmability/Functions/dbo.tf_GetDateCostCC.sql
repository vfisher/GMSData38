SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetDateCostCC] (@OurID int, @StockID int, @ProdDate smalldatetime, @ProdID int, @UseSubItems bit)
/* Возвращает себестоимость ВС товара на указанную дату */
RETURNS numeric(21,9)
BEGIN
  DECLARE @CostCC numeric(21,9)
  IF @UseSubItems = 0
    SELECT @CostCC = CostCC    
    FROM t_PInP WITH (NOLOCK)   
    WHERE   
      ProdID = @ProdID 
      AND PPID = dbo.tf_GetLastSPPID(@OurID, @StockID, @ProdDate, @ProdID)
  ELSE
    BEGIN
      DECLARE @ChID bigint

      SELECT TOP 1 @ChID = ChID 
      FROM t_Spec WITH (NOLOCK)
      WHERE 
        /* OurID = @OurID AND */ /* Убран контроль за привязкой блюда к фирме, указанной в Кальк.К. */
        DocDate <= @ProdDate AND
        ProdID = @ProdID
      ORDER BY 
        DocDate DESC, DocID DESC

      IF @ChID IS NOT NULL
        SELECT @CostCC = SUM(Qty * dbo.tf_GetDateCostCC(@OurID, @StockID, @ProdDate, ProdID, UseSubItems)) 
        FROM t_SpecD
        WHERE ChID = @ChID
      ELSE
       SELECT @CostCC = dbo.tf_GetDateCostCC(@OurID, @StockID, @ProdDate, @ProdID, 0)  
    END  

  RETURN @CostCC
END
GO