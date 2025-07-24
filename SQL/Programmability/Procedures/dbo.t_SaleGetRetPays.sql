SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetRetPays](@DocChID bigint, @PayFormCode int) AS
/* Возвращает оплаты для возвратного чека */
BEGIN
  DECLARE @DocID bigint
  DECLARE @OurID int
  DECLARE @CRRetPays TABLE (PayFormCode int NOT NULL, SumCC_wt numeric(21,9) NOT NULL)

  SELECT @OurID = OurID, @DocID = SrcDocID FROM t_CRRet WHERE ChID = @DocChID

  INSERT INTO @CRRetPays (PayFormCode, SumCC_wt) 
  SELECT 
      PayFormCode
    , SUM(SumCC_wt)
  FROM t_CRRet m
  JOIN t_CRRetPays d ON m.ChID = d.ChID
  WHERE m.SrcDocID = @DocID AND m.ChID <> @DocChID
  GROUP BY PayFormCode

  SELECT *
  FROM (
    SELECT d.SrcPosID, d.PayFormCode, d.Notes, d.POSPayDocID, d.POSPayRRN, d.POSPayID,
      CASE
        WHEN @PayFormCode = 1 THEN
            d.SumCC_wt -
           (SELECT ISNULL(SUM(d1.SumCC_wt), 0)
            FROM t_CRRet m1 INNER JOIN t_CRRetPays d1 ON m1.ChID = d1.ChID
            WHERE m1.OurID = @OurID AND m1.SrcDocID = @DocID AND d1.PayFormCode = 1 AND m1.ChID <> @DocChID) +
           (SELECT ISNULL(SUM(u.SumCC_wt), 0)
            FROM t_SalePays u
            WHERE u.ChID = m.ChID AND u.PayFormCode = 1 AND u.SumCC_wt < 0)
        WHEN @PayFormCode = 11 THEN
            0
        ELSE
            d.SumCC_wt -
           (SELECT ISNULL(SUM(d2.SumCC_wt), 0)
            FROM t_CRRet m2 INNER JOIN t_CRRetPays d2 ON m2.ChID = d2.ChID
            WHERE m2.OurID = @OurID AND m2.SrcDocID = @DocID AND d2.SrcPayPosID = d.SrcPosID AND m2.ChID <> @DocChID) - ISNULL(p.SumCC_wt, 0) /* минус сумма по всем возвратам этого дока */
      END AS SumCC_wt
    FROM t_Sale m
    INNER JOIN t_SalePays d ON m.ChID = d.ChID
    LEFT OUTER JOIN @CRRetPays p ON p.PayFormCode = d.PayFormCode
    WHERE m.OurID = @OurID AND m.DocID = @DocID AND (d.PayFormCode = @PayFormCode) OR (@PayFormCode = 0)) q
  WHERE q.SumCC_wt > 0
  ORDER BY q.SrcPosID
END
GO