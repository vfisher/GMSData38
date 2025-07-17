SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetRetChequeSumCC_wt](@ChID bigint)
 /* Возвращает сумму возвратного чека */
 RETURNS numeric(21, 9)
 BEGIN
   DECLARE @SumCC_wt numeric(21, 9)
 
   SELECT @SumCC_wt = SUM(dbo.zf_Round(RealPrice * Qty, 0.01))
   FROM t_CRRetD WITH(NOLOCK)
   WHERE ChID = @ChID AND Qty <> 0
 
   SELECT @SumCC_wt =  @SumCC_wt + ISNULL((SELECT p.RetRndSum FROM t_CRRet p WITH(NOLOCK) WHERE p.ChID = @ChID), 0)

   RETURN @SumCC_wt
 END
GO