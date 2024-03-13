SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetChequeSumCC_wt](@ChID bigint)
/* Возвращает сумму чека */
RETURNS numeric(21, 9)
BEGIN
  DECLARE @SumCC_wt numeric(21, 9)

  SELECT @SumCC_wt = SUM(PosSum)
  FROM
    (
	     SELECT
	       dbo.zf_Round(PriceCC_wt * SUM(Qty), 0.01) PosSum
      FROM t_SaleTempD WITH(NOLOCK)
      WHERE ChID = @ChID
      GROUP BY CSrcPosID, PriceCC_wt
    ) a

  RETURN @SumCC_wt
END
GO
