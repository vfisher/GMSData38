SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetCalcAvgSalary](@Date datetime, @OurID int)
/* Возвращает:
- среднемесячную базу начисления единого взноса для плательщика за предыдущий год в расчете на одно застрахованное лицо (AvgSumCC);
- среднемесячное количество застрахованных лиц плательщика за предыдущий год (AvgMonth);
- среднемесячный платеж на одно застрахованное лицо за предыдущий год (AvgUniSocChargeСС). */
RETURNS @tmpAvgSalary TABLE(AvgSumCC numeric(21,9), AvgEmpMonth numeric(21,9), AvgUniSocChargeСС numeric(21,9))
AS
BEGIN
  DECLARE @Year int
  SET @Year = YEAR(@Date) - 1
  BEGIN
    INSERT INTO @tmpAvgSalary(AvgSumCC, AvgEmpMonth, AvgUniSocChargeСС)

  SELECT
      ROUND(SUM(BSumCC - BSumCCInvalid)/12/ROUND(SUM(COUNT - InvalidCount)/12,0),2) AS AvgSumCC,
      ROUND(SUM(Count - InvalidCount)/12,0) AS AvgEmpMonth,
      ROUND(SUM(UniSocChargeСС - UniSocChargeССInvalid)/12/ROUND(SUM(COUNT - InvalidCount)/12,0),3) AS AvgUniSocChargeСС
    FROM (
   SELECT 
     t1.ChID,
     t1.DocDate,
     SUM(t1.Count) AS Count,
     SUM(t1.Invalid) AS InvalidCount,
     SUM(t1.BSumCC) AS BSumCC,
     SUM(CASE WHEN t1.Invalid = 1 THEN t1.BSumCC ELSE 0 END) AS BSumCCInvalid,
     SUM(t1.UniSocChargeСС) AS UniSocChargeСС,
     SUM(CASE WHEN t1.Invalid = 1 THEN t1.UniSocChargeСС ELSE 0 END) AS UniSocChargeССInvalid
   FROM (
     SELECT
        m.DocDate,
        d.ChID, 
        d.EmpID,
        1 AS COUNT, 
        d.MainSumCC + d.ExtraSumCC + d.MoreSumCC + d.NeglibleSumCC AS BSumCC,
        d.UniSocChargeСС AS UniSocChargeСС,
        ISNULL((SELECT TOP 1 1
          FROM r_EmpMP mp
          WHERE mp.IsInvalid = 1 AND m.DocDate BETWEEN mp.BDate AND mp.EDate AND mp.OurID = m.OurID AND EmpID = d.EmpID),0) AS Invalid
     FROM
        p_LRecD d
      INNER JOIN p_LRec m ON d.ChID = m.ChID
      WHERE m.OurID = @OurID AND m.LRecType = 0 AND YEAR(m.DocDate) = @Year AND d.MainSumCC + d.ExtraSumCC + d.MoreSumCC + d.NeglibleSumCC <> 0
        ) t1
GROUP BY
        t1.ChID, t1.DocDate
) t
  END
RETURN
END
GO
