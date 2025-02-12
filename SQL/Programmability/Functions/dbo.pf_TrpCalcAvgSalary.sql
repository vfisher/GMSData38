SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_TrpCalcAvgSalary](@DocCode INT, @DocChID BIGINT, @DocAChID BIGINT, @DocDate datetime, @EmpID int, @OurID int)
/* Возвращает среднюю зарплату за последние 2 месяца для расчета среднего заработка за дни командировки. */
RETURNS @tmp TABLE(SrcDate datetime, FactHours int, FactDays int, FactSalary numeric(21,9), AvrSalary numeric(21,9), AvrSalaryDay numeric(21,9))
AS
BEGIN
  DECLARE @tmpGivDate datetime, @tmpEDate datetime, @tmpBDate DATETIME, 
          @AvgWorkOneHour numeric(21,9), @AvgWorkOneDay numeric(21,9), 
          @SalaryType int

  SET @tmpGivDate = dbo.pf_GetEmpGivDate(@DocDate - 1, @EmpID, @OurID)
  IF @tmpGivDate = '20790101' RETURN

  SET @tmpEDate = DATEADD(day, -1, dbo.zf_GetMonthFirstDay(@DocDate))
  SET @AvgWorkOneHour = 0
  SET @AvgWorkOneDay = 0
  SET @SalaryType = (SELECT TOP 1 SalaryType FROM r_EmpMPst r
WHERE r.OurID = @OurID AND r.EmpID = @EmpID AND @DocDate BETWEEN r.BDate AND r.EDate AND r.IsDisDoc <> 1)   

IF DATEDIFF(m, @tmpGivDate, @tmpEDate) <= 2
  BEGIN
    SET @tmpBDate = dbo.zf_GetMonthFirstDay(@tmpGivDate)
    IF @tmpBDate < @tmpGivDate SET @tmpBDate = DATEADD(MONTH, 1, @tmpBDate)
  END
  ELSE
  BEGIN
    IF  ((YEAR(@tmpEDate)-1)%4 = 0 AND (YEAR(@tmpEDate)-1)%100 <> 0) OR (YEAR(@tmpEDate)-1)%400 = 0 /*проверка на високосность*/
        AND DAY(@tmpEDate) = 28 AND MONTH(@tmpEDate) = 2

      SET @tmpBDate = DATEADD(d, 2, DATEADD(month, -2, @tmpEDate))
    ELSE
      SET @tmpBDate = DATEADD(d, 1, dbo.zf_GetMonthLastDay(DATEADD(month, -2, @tmpEDate)))
  END

INSERT INTO @tmp(SrcDate, FactHours, FactDays, FactSalary)
SELECT MIN(DocDate) SrcDate, 0 FactHours, 0 FactDays, SUM(dd.SumCC) 
FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes p 
  WHERE LRecType = 0 AND m.ChID = d.ChID AND d.AChID = dd.AChID AND dd.PayTypeID = p.PayTypeID AND OurID = @OurID AND EmpID = @EmpID AND DocDate BETWEEN @tmpBDate AND @tmpEDate AND p.UseInTrn = 1
GROUP BY MONTH(DocDate), EmpID, OurID 

/* Если нет данных о начислении ЗП, то попытаться загрузить их из входящих */
  INSERT INTO @tmp(SrcDate, FactHours, FactDays, FactSalary)
  SELECT MIN(AccDate) SrcDate, 0 FactHours, 0 FactDays, SUM(LRecSumCC)
  FROM p_EmpIn m JOIN p_EmpInLRec d ON m.ChID = d.ChID
  WHERE WorkAppDate = @tmpGivDate AND OurID = @OurID AND EmpID = @EmpID AND AccDate BETWEEN @tmpBDate AND @tmpEDate AND NOT EXISTS (SELECT TOP 1 1 FROM @tmp WHERE MONTH(SrcDate) = MONTH(AccDate))
  GROUP BY MONTH(AccDate)

  UPDATE t SET
    SrcDate = dbo.zf_GetMonthLastDay(SrcDate), 
    FactHours = t1.SumWorkHours,
    FactDays = CountDayPayFactor
  FROM @tmp t 
  INNER JOIN (
  SELECT m.DocDate, SUM(dd.WorkHours) AS SumWorkHours, COUNT(dd.DayPayFactor) AS CountDayPayFactor 
  FROM p_CWTimeD d
    Inner Join p_CWTime m on m.ChID = d.ChID
    Inner Join p_CWTimeDD dd on dd.AChID = d.AChID 
  WHERE m.OurID = @OurID AND d.EmpID = @EmpID AND m.CWTimeType = 0 AND dd.WTSignID IN (1,106)
  GROUP BY  m.DocDate
  ) t1 ON t1.DocDate BETWEEN dbo.zf_GetMonthFirstDay(SrcDate) AND dbo.zf_GetMonthLastDay(SrcDate)



  UPDATE @tmp SET
  FactSalary = FactSalary - ISNULL((SELECT SUM(dd.DaySaleSumCC)
  FROM p_CWTimeD d
    Inner Join p_CWTime m on m.ChID = d.ChID
    Inner Join p_CWTimeDD dd on dd.AChID = d.AChID 
  WHERE m.OurID = @OurID AND d.EmpID = @EmpID AND m.CWTimeType = 0 AND m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(SrcDate) AND dbo.zf_GetMonthLastDay(SrcDate) AND dd.WTSignID IN (7)),0)  


/* Если нет данных о начислении ЗП, то загрузить размер оклада (тарифа) из Справочника служащих  r_empmpst.bsalary */
  IF  DATEDIFF(m, @tmpGivDate, @DocDate) <= 1
  BEGIN
    INSERT INTO @tmp(SrcDate, FactHours, FactDays, FactSalary)
    SELECT 
      r.BDate SrcDate,
      s.FactHours,
      s.FactDays,
      r.BSalary FactSalary
    FROM r_EmpMPst r
    LEFT JOIN 
      (SELECT m.ShedID,d.HoursNorm AS FactHours, d.DaysNorm AS FactDays
       FROM 
         r_NormMH d,
         r_Sheds m  
       WHERE m.WWeekTypeID = d.WWeekTypeID AND d.YearId = YEAR(@DocDate) AND d.MonthID = MONTH(@DocDate)) s ON s.ShedID = r.ShedID
    WHERE r.OurID=@OurID and r.EmpID=@EmpID and @DocDate BETWEEN r.BDate AND r.EDate  
      AND NOT EXISTS (SELECT TOP 1 1 FROM @tmp WHERE FactSalary IS NOT NULL)

    UPDATE @tmp SET
    SrcDate = dbo.zf_GetMonthLastDay(SrcDate)
  END

  /* IF @DocCode = 15051
     SELECT
        @AvgWorkOneHour = CASE WHEN SUM(dd.WorkHours) <> 0 THEN SUM(dd.DaySaleSumCC)/ SUM(dd.WorkHours) END,
        @AvgWorkOneDay = CASE WHEN COUNT(dd.DayPayFactor) <> 0 THEN SUM(dd.DaySaleSumCC)/ COUNT(dd.DayPayFactor) END
      FROM 
        p_CWTime m,
        p_CWTimeD d,
        p_CWTimeDD dd
      WHERE m.ChID = d.ChID AND d.AChID = dd.AChID AND m.OurID = @OurID AND d.EmpID = @EmpID AND m.ChID = @DocChID AND dd.DayPosID < DAY(@DocDate) AND dd.WTSignID IN (1,106) */

  INSERT INTO @tmp (SrcDate, FactHours, FactDays, FactSalary)
  SELECT 0, SUM(FactHours), SUM(FactDays), SUM(FactSalary) FROM @tmp

  /* Сравнение с Дневная (часовая) заработная плата = Заработок в месяце командировки для расчета дневной (часовой) зарплаты : фактически отработанные дни (часы)  */
  UPDATE @tmp
    SET AvrSalary = CASE WHEN FactHours > 0 THEN 
  	  CASE WHEN @AvgWorkOneHour > ROUND(FactSalary / FactHours, 4) THEN @AvgWorkOneHour ELSE ROUND(FactSalary / FactHours, 4) END ELSE @AvgWorkOneHour END,
    AvrSalaryDay = CASE WHEN FactDays > 0 THEN 
  	  CASE WHEN @AvgWorkOneDay > ROUND(FactSalary / FactDays, 4) THEN @AvgWorkOneDay ELSE ROUND(FactSalary / FactDays, 4) END ELSE @AvgWorkOneDay END

RETURN
END
GO