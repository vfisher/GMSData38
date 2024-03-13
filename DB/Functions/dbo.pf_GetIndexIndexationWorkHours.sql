SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetIndexIndexationWorkHours](@Date datetime, @OurID INT, @EmpID INT)
/* Возвращает коэффициент пропорционально отработанных часов для начисления индексации ЗП */
RETURNS NUMERIC(21,9) AS
BEGIN
  DECLARE @IndexWorkHours NUMERIC(21,9), @BDate DATETIME, @EDate DATETIME 
  SET @BDate = dbo.zf_GetMonthFirstDay(@Date)
  SET @EDate = dbo.zf_GetMonthLastDay(@Date)   
  SET @IndexWorkHours = ISNULL(
  (SELECT (SELECT SUM(TWorkHours) FROM 
   (SELECT 
    d.TWorkHours - SUM(CASE WHEN dd.WTSignID = 7 THEN dd.WorkHours ELSE 0 END) /*WorkHoursVD*/ 
                 - SUM(CASE WHEN dd.WTSignID = 8 THEN dd.WorkHours ELSE 0 END) /*WorkHoursV*/
                 - SUM(CASE WHEN dd.WTSignID = 26 THEN dd.WorkHours ELSE 0 END) /*WorkHoursTN*/
    AS TWorkHours 
  FROM dbo.p_CWTime m 
  INNER JOIN p_CWTimeD d ON m.ChID = d.ChID
  INNER JOIN p_CWTimeDD dd ON d.AChID = dd.AChID
  WHERE m.OurID = @OurID AND d.EmpID = @EmpID AND m.DocDate BETWEEN @BDate AND @EDate AND m.CWTimeType = 0
  GROUP BY d.EmpID,  d.TWorkHours ) t ) / ( 
  SELECT SUM(dbo.pf_GetWorkHoursForSchedID(t.BDate, t.EDate, t.ShedID) /** t.SalaryQty*/)
  FROM (
  SELECT 
    CASE WHEN (BDate <= @BDate) OR (IsGivDoc = 1) THEN @BDate ELSE BDate END AS BDate,
    CASE WHEN (EDate >= @EDate) OR EXISTS(SELECT TOP 1 1 FROM r_EmpMPst WHERE OurID = r.OurID AND EmpID = r.EmpID AND (@BDate <= EDate) AND (@EDate >= BDate) AND IsDisDoc = 1) THEN @EDate ELSE EDate END AS EDate,
    ShedID,
    SalaryQty  
  FROM dbo.r_EmpMPst r
  WHERE OurID = @OurID AND EmpID = @EmpID AND  (@BDate <= EDate) AND (@EDate >= BDate) and IsDisDoc = 0
  ) t )), 1) 
  IF @IndexWorkHours > 1
    SET @IndexWorkHours = 1
  RETURN @IndexWorkHours
END
GO
