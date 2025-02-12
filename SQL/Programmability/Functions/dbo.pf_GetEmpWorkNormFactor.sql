SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetEmpWorkNormFactor](@Date datetime, @EmpID int, @OurID int, @LimitMaxTo numeric(21,9))
/* Возвращает коэффициент выработки нормы рабочего времени (отношение фактически отработанного времени к норме) */
RETURNS numeric(21,9)
AS
BEGIN
  DECLARE  @WorkNorm int,
           @WorkFact int,
           @TimeNormType int,
           @tmpMonth int, @tmpYear int,
           @r numeric(21,9)
  IF dbo.pf_GetEmpGivDate(@Date, @EmpID, @OurID) = '20790101' RETURN 0
  SET @tmpMonth = MONTH(@Date)
  SET @tmpYear = YEAR(@Date)
  -- норма и в чем она измеряется
  SELECT @WorkNorm = CASE m.TimeNormType WHEN 0 THEN dd.HoursNorm ELSE dd.DaysNorm END, @TimeNormType = m.TimeNormType
  FROM r_EmpMPst m LEFT JOIN r_Sheds d ON m.ShedID = d.ShedID LEFT JOIN r_NormMH dd ON d.WWeekTypeID = dd.WWeekTypeID AND dd.MonthID = @tmpMonth AND dd.YearID = @tmpYear
  WHERE m.OurID = @OurID AND m.EmpID = @EmpID AND @Date BETWEEN m.BDate AND m.EDate
  -- фактически отработанное время
  SELECT @WorkFact = CASE @TimeNormType WHEN 0 THEN SUM(TWorkHours) ELSE SUM(TWorkDays) END
  FROM p_CWTime m JOIN p_CWTimeD d ON m.ChID = d.ChID
  WHERE OurID = @OurID AND EmpID = @EmpID AND YEAR(DocDate) = @tmpYear AND  MONTH(DocDate) = @tmpMonth
  SET @r = @WorkFact * 1.0 / @WorkNorm
  IF @LimitMaxTo > 0 AND @r > @LimitMaxTo SET @r = @LimitMaxTo
  RETURN @r
END
GO