SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_SickCalcAvgSalary](@DocCode int, @DocChID bigint, @Date datetime, @EmpID int, @OurID int)
/* Возвращает среднюю зарплату за последние 12 месяцев для расчета больничных c 04.07.2015 г. */
RETURNS @out TABLE(SrcDate datetime, FactDays int, FactHours numeric(21,9), FactSalary numeric(21,9), AvrSalaryByDays numeric(21,9), AvrSalaryByHours numeric(21,9))
AS
BEGIN
 DECLARE @GivDate datetime, @EDate datetime, @BDate datetime, @SickType int
 SET @GivDate = dbo.pf_GetEmpGivDate(@Date, @EmpID, @OurID)
 IF @GivDate = '20790101' RETURN
 /* если день приема на работу первый рабочий в месяце учитываем этот месяц в расчете */
 IF dbo.pf_FirstMonthWorkDay(@GivDate) = 1 SET @GivDate = dbo.zf_GetMonthFirstDay(@GivDate)
 SET @SickType = (SELECT SickType FROM p_ESic WHERE ChID = @DocChID)
 /* 6 полных предыдущих месяцев с 1го числа текущего месяца */
 SET @EDate = DATEADD(day, -1, dbo.zf_GetMonthFirstDay(@Date))
 SET @BDate = DATEADD(month, -6, DATEADD(day, 1, @EDate))

 IF @Date  >= CAST('20150704' AS DATETIME)
   SET @BDate = DATEADD(month, -12, DATEADD(day, 1, @EDate))

  /* служащий принят меньше чем 6 (12) месяцев назад */
 WHILE @BDate < @GivDate SET @BDate = DATEADD(MONTH, 1, @BDate)
  /* служащий работает менее 1го месяца */
 IF (DATEDIFF(month, DATEADD(day, -1, @BDate), @EDate) < 1)
   BEGIN
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary, AvrSalaryByDays, AvrSalaryByHours)
     SELECT 1, DaysNorm, HoursNorm, BSalary,
            AvrSalaryByDays  = CASE WHEN DaysNorm > 0 THEN ROUND(BSalary / DaysNorm, 2) ELSE 0 END,
            AvrSalaryByHours = CASE WHEN HoursNorm > 0 THEN ROUND(BSalary / HoursNorm, 2) ELSE 0 END
     FROM ( SELECT  BSalary, CASE m.TimeNormType WHEN 0 THEN dd.HoursNorm ELSE dd.DaysNorm END AS WorkNorm , dd.HoursNorm, dd.DaysNorm
            FROM r_EmpMPst m LEFT JOIN r_Sheds d ON m.ShedID = d.ShedID LEFT JOIN r_NormMH dd ON d.WWeekTypeID = dd.WWeekTypeID AND dd.MonthID = MONTH(@Date) AND dd.YearID = YEAR(@Date)
            WHERE m.OurID = @OurID AND m.EmpID = @EmpID AND @Date BETWEEN m.BDate AND m.EDate) t
     RETURN
   END
 IF @Date  < CAST('20150704' AS DATETIME)
 BEGIN
 IF @SickType <> 8 /* Все типы больничных кроме Расчет пособия по беременности и родам */
   BEGIN
     /* получить данные по зарплате по справочнику выплат */
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary)
     SELECT MIN(DocDate), NULL, NULL, SUM(SumCC)
     FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes r
     WHERE LRecType = 0 AND m.ChID = d.ChID AND d.AChID = dd.AChID AND dd.PayTypeID = r.PayTypeID AND dd.IsDeduction = 0 AND OurID = @OurID AND EmpID = @EmpID AND r.UseInSick <> 0 AND DocDate BETWEEN @BDate AND @EDate
     GROUP BY MONTH(DocDate), EmpID, OurID
     /* если нет данных о начислении ЗП, то попытаться загрузить их из входящих */
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary)
     SELECT MIN(AccDate), NULL, NULL, SUM(LRecSumCC)
     FROM p_EmpIn m JOIN p_EmpInLRec d ON m.ChID = d.ChID JOIN r_PayTypes r ON d.PayTypeID = r.PayTypeID
     WHERE OurID = @OurID AND EmpID = @EmpID AND r.UseInSick <> 0 AND r.IsDeduction = 0 AND AccDate BETWEEN @BDate AND @EDate AND NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE MONTH(SrcDate) = MONTH(AccDate))
     GROUP BY MONTH(AccDate)
     UPDATE @out SET SrcDate = dbo.zf_GetMonthLastDay(SrcDate) WHERE @Date <> 0
     /* загрузить информацию об отработанном времени из табеля */
     UPDATE t SET FactDays = (SELECT SUM(TWorkDays) FROM p_CWTime m JOIN p_CWTimeD d ON m.ChID=d.ChID WHERE m.CWTimeType = 0 AND OurID= @OurID AND EmpID= @EmpID AND DocDate BETWEEN dbo.zf_GetMonthFirstDay(t.SrcDate) AND t.SrcDate),
                  FactHours = (SELECT SUM(TWorkHours) FROM p_CWTime m JOIN p_CWTimeD d ON m.ChID=d.ChID WHERE m.CWTimeType = 0 AND OurID= @OurID AND EmpID= @EmpID AND DocDate BETWEEN dbo.zf_GetMonthFirstDay(t.SrcDate) AND t.SrcDate)
     FROM @out t
     /* попытка загрузить данные отработанном времени из входящих если их нет в табеле */
     UPDATE t SET FactDays = (SELECT SUM(TWorkDays) FROM p_EmpInWTime d WHERE SrcDate  BETWEEN dbo.zf_GetMonthFirstDay(t.SrcDate) AND t.SrcDate)
     FROM @out t
     WHERE FactDays IS NULL
     UPDATE t SET FactHours = (SELECT SUM(TWorkHours) FROM p_EmpInWTime d WHERE SrcDate BETWEEN dbo.zf_GetMonthFirstDay(t.SrcDate) AND t.SrcDate)
     FROM @out t
     WHERE FactHours IS NULL
   END
 ELSE
 IF @SickType = 8 /* Расчет пособия по беременности и родам */
   BEGIN
     /* получить данные по зарплате по справочнику выплат */
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary)
     SELECT MIN(DocDate), NULL, NULL, SUM(SumCC)
     FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes r
     WHERE LRecType = 0 AND m.ChID = d.ChID AND d.AChID = dd.AChID AND dd.PayTypeID = r.PayTypeID AND dd.IsDeduction = 0 AND OurID = @OurID AND EmpID = @EmpID AND r.UseInPregSick <> 0 AND DocDate BETWEEN @BDate AND @EDate
     GROUP BY MONTH(DocDate), EmpID, OurID
     /* если нет данных о начислении ЗП, то попытаться загрузить их из входящих */
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary)
     SELECT MIN(AccDate), NULL, NULL, SUM(LRecSumCC)
     FROM p_EmpIn m JOIN p_EmpInLRec d ON m.ChID = d.ChID JOIN r_PayTypes r ON d.PayTypeID = r.PayTypeID
     WHERE OurID = @OurID AND EmpID = @EmpID AND r.UseInPregSick <> 0 AND r.IsDeduction = 0 AND AccDate BETWEEN @BDate AND @EDate AND NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE MONTH(SrcDate) = MONTH(AccDate))
     GROUP BY MONTH(AccDate)
     UPDATE @out SET SrcDate = dbo.zf_GetMonthLastDay(SrcDate) WHERE @Date <> 0
     /* Расчитать количество календарных дней, исключая кол-во дней больничных, по беременности и родам, уход за ребенком */
     UPDATE t SET FactDays = DATEDIFF(DAY, dbo.zf_GetMonthFirstDay(t.SrcDate), t.SrcDate) + 1 - ISNULL((SELECT COUNT(DayShiftCount) FROM p_CWTime m, p_CWTimeD d, p_CWTimeDD dd WHERE m.CWTimeType = 0 AND m.ChID =  d.ChID AND d.AChID = dd.AChID AND OurID = @OurID AND EmpID = @EmpID AND DocDate BETWEEN dbo.zf_GetMonthFirstDay(t.SrcDate) AND t.SrcDate AND WTSignID IN (16, 17, 18, 26)),0)
     FROM @out t
     WHERE FactDays IS NULL
   END
 END
 ELSE
 BEGIN
     /* получить данные по зарплате по справочнику выплат */
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary)
     SELECT MIN(DocDate), NULL, NULL, SUM(SumCC)
     FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes r
     WHERE LRecType = 0 AND m.ChID = d.ChID AND d.AChID = dd.AChID AND dd.PayTypeID = r.PayTypeID AND dd.IsDeduction = 0 AND OurID = @OurID AND EmpID = @EmpID 
       AND (r.UseInPregSick <> 0 or r.UseInSick <> 0) AND DocDate BETWEEN @BDate AND @EDate
     GROUP BY MONTH(DocDate), EmpID, OurID
     /* если нет данных о начислении ЗП, то попытаться загрузить их из входящих */
     INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary)
     SELECT MIN(AccDate), NULL, NULL, SUM(LRecSumCC)
     FROM p_EmpIn m JOIN p_EmpInLRec d ON m.ChID = d.ChID JOIN r_PayTypes r ON d.PayTypeID = r.PayTypeID
     WHERE OurID = @OurID AND EmpID = @EmpID AND r.UseInPregSick <> 0 AND r.IsDeduction = 0 AND AccDate BETWEEN @BDate AND @EDate AND NOT EXISTS (SELECT TOP 1 1 FROM @out WHERE MONTH(SrcDate) = MONTH(AccDate))
     GROUP BY MONTH(AccDate)
     UPDATE @out SET SrcDate = dbo.zf_GetMonthLastDay(SrcDate) WHERE @Date <> 0
     /* Расчитать количество календарных дней, исключая кол-во дней больничных, по беременности и родам, уход за ребенком */
     UPDATE t SET FactDays = DATEDIFF(DAY, dbo.zf_GetMonthFirstDay(t.SrcDate), t.SrcDate) + 1 - ISNULL((SELECT COUNT(DayShiftCount) FROM p_CWTime m, p_CWTimeD d, p_CWTimeDD dd WHERE m.CWTimeType = 0 AND m.ChID =  d.ChID AND d.AChID = dd.AChID AND OurID = @OurID AND EmpID = @EmpID AND DocDate BETWEEN dbo.zf_GetMonthFirstDay(t.SrcDate) AND t.SrcDate AND WTSignID IN (16, 17, 18, 26)),0)
     FROM @out t
     WHERE FactDays IS NULL
 END
  /* сформировать строку с итогами */
  INSERT INTO @out (SrcDate, FactDays, FactHours, FactSalary) SELECT 0, SUM(FactDays), SUM(FactHours), SUM(FactSalary) FROM @out
  /* расчет среднедневной и среднечасой заработной платы */
  UPDATE @out SET AvrSalaryByDays  = CASE WHEN FactDays > 0 THEN ROUND(FactSalary / FactDays, 2) ELSE 0 END, AvrSalaryByHours = CASE WHEN FactHours > 0 THEN ROUND(FactSalary / FactHours, 2) ELSE 0 END
  RETURN
END
GO
