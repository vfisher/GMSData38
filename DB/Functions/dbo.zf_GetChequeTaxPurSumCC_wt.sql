SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetChequeTaxPurSumCC_wt](@ChID bigint, @TaxTypeID int)
/* Возвращает сумму чека по указанной налоговой группе */
RETURNS numeric(21, 9)
BEGIN
  DECLARE @SumCC_wt numeric(21, 9)

  SELECT @SumCC_wt = SUM(PosSum)
  FROM
    (
	  SELECT
		dbo.zf_Round(Min(PurPriceCC_wt) * SUM(Qty), 0.01) PosSum
	  FROM t_SaleTempD WITH(NOLOCK)
	  WHERE ChID = @ChID AND TaxTypeID = @TaxTypeID
	  GROUP BY CSrcPosID
    ) a

  RETURN @SumCC_wt
END
GO
