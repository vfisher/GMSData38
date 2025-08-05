SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetChequeSumCC_wt](@ChID bigint)
/* Возвращает сумму чека */
RETURNS numeric(21, 9)
BEGIN
  DECLARE @SumCC_wt numeric(21, 9)

  SELECT @SumCC_wt = SUM(a.PosSum) + ISNULL((SELECT p.SaleRndSum FROM t_SaleTemp p WITH(NOLOCK) WHERE p.ChID = @ChID), 0)
  FROM
    (
	  SELECT dbo.zf_Round(PriceCC_wt * SUM(Qty), 0.01) PosSum
      FROM t_SaleTempD WITH(NOLOCK)
      WHERE ChID = @ChID
      GROUP BY CSrcPosID, PriceCC_wt
    ) a

  RETURN @SumCC_wt
END
GO