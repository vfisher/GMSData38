SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_GetClosedCheques](@CRIDs varchar(500), @CompletedChequesCount int)
/* Формирует список закрытых чеков */
RETURNS @out table(ChID bigint, OperID int, DocID bigint, StateCode int, SumCC_wt numeric(21, 9))
BEGIN
  DECLARE @ClosedChequeState int
  DECLARE @CompletedChequeState int

  SELECT @ClosedChequeState= CAST(dbo.zf_Var('t_ChequeStateCode') AS int)
  SELECT @CompletedChequeState= CAST(dbo.zf_Var('t_CompletedChequeStateCode') AS int)

  /* Оплаченные заказы */ 
  INSERT INTO @Out(ChID, OperID, DocID, StateCode, SumCC_wt)
  SELECT m.ChID, m.OperID, m.DocID, m.StateCode, SUM(d.RealSum)
  FROM t_Sale m JOIN t_SaleD d ON m.ChID = d.ChID
  WHERE m.StateCode = @ClosedChequeState AND (dbo.zf_MatchFilterInt(m.CRID, @CRIDs, ',') = 1)
  GROUP BY m.ChID, m.OperID, m.DocID, m.StateCode
  ORDER BY MIN(m.DocTime) DESC

  /* Оплаченные и выданные заказы */
  INSERT INTO @Out(ChID, OperID, DocID, StateCode, SumCC_wt)
  SELECT TOP (@CompletedChequesCount) m.ChID, m.OperID, m.DocID, m.StateCode, SUM(d.RealSum)
  FROM t_Sale m JOIN t_SaleD d ON m.ChID = d.ChID
  WHERE m.StateCode = @CompletedChequeState AND (dbo.zf_MatchFilterInt(m.CRID, @CRIDs, ',') = 1)
  GROUP BY m.ChID, m.OperID, m.DocID, m.StateCode
  ORDER BY MIN(m.ChID) DESC

  RETURN
END
GO