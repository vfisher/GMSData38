SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetChequePurSumCC_wt](@ChID bigint)
/* Возвращает сумму чека без скидки*/
RETURNS numeric(21, 9)
BEGIN
  DECLARE @SumCC_wt numeric(21, 9)

  SELECT @SumCC_wt = SUM(PosSum)
  FROM
    (
	  SELECT
		dbo.zf_Round(Min(PurPriceCC_wt) * SUM(Qty), 0.01) PosSum
	  FROM t_SaleTempD WITH(NOLOCK)
	  WHERE ChID = @ChID
	  GROUP BY CSrcPosID
    ) a

  RETURN @SumCC_wt
END
GO
