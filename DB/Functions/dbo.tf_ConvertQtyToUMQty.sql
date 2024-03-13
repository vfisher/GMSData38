SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_ConvertQtyToUMQty]
(
  @ProdID INT, 
  @Qty NUMERIC(21, 9), 
  @UM VARCHAR(50)
)
RETURNS numeric(21, 9) AS
BEGIN
  DECLARE 
    @RESULT numeric(21, 9)

  SELECT @RESULT = @Qty * Qty 
  FROM r_ProdMQ q
  INNER JOIN r_Prods p ON q.ProdID = p.ProdID
  WHERE p.ProdID = @ProdID AND q.UM = @UM

  RETURN @RESULT 
END
GO
