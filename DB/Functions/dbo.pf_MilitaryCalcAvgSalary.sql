SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_MilitaryCalcAvgSalary] (@Date datetime, @EmpID int, @OurID int)
/* Возвращает среднюю зарплату за последние 2 месяца для расчета выплат на период прохождения военных сборов и мобилизации */
RETURNS @tmp TABLE(SrcDate datetime, WorkDays int, FactDays int, FactSalary numeric(21,9), AvrSalary numeric(21,9)) AS
BEGIN
DECLARE @tmpGivDate datetime, @tmpEDate datetime, @tmpBDate datetime, @Edate datetime

SET @tmpGivDate = dbo.pf_GetEmpGivDate(@Date, @EmpID, @OurID)
IF @tmpGivDate = '20790101' RETURN

SET @tmpEDate = DATEADD(day, -1, dbo.zf_GetMonthFirstDay(@Date))

IF DATEDIFF(m, @tmpGivDate, @tmpEDate) <= 2
  BEGIN
    SET @tmpBDate = dbo.zf_GetMonthFirstDay(@tmpGivDate)
    IF @tmpBDate < @tmpGivDate SET @tmpBDate = DATEADD(MONTH, 1, @tmpBDate)
  END
ELSE
  BEGIN
    IF ((YEAR(@tmpEDate)-1)%4 = 0 AND (YEAR(@tmpEDate)-1)%100 <> 0) OR (YEAR(@tmpEDate)-1)%400 = 0 /*проверка на високосность*/
        AND DAY(@tmpEDate) = 28 AND MONTH(@tmpEDate) = 2

      SET @tmpBDate = DATEADD(d, 2, DATEADD(month, -2, @tmpEDate))
    ELSE
      SET @tmpBDate = DATEADD(d, 1, DATEADD(month, -2, @tmpEDate))
  END

INSERT INTO @tmp(SrcDate, WorkDays, FactDays, FactSalary)
SELECT MIN(DocDate) SrcDate, 0 WorkDays, 0 DaysFact, SUM(SumCC)
FROM p_LRec m, p_LRecD d, p_LRecDD dd, r_PayTypes r
WHERE LRecType = 0 AND m.ChID = d.ChID AND d.AChID = dd.AChID AND dd.PayTypeID = r.PayTypeID AND dd.IsDeduction = 0 AND OurID = @OurID AND EmpID = @EmpID AND r.UseInLeav <> 0 AND DocDate BETWEEN @tmpBDate AND @tmpEDate
GROUP BY MONTH(DocDate), EmpID, OurID

/* если нет данных о начислении ЗП, то попытаться загрузить их из входящих */
INSERT INTO @tmp(SrcDate, WorkDays, FactDays, FactSalary)
SELECT MIN(AccDate) SrcDate, 0 WokrDays, 0 DaysFact, SUM(LRecSumCC)
FROM p_EmpIn m JOIN p_EmpInLRec d ON m.ChID = d.ChID
WHERE WorkAppDate = @tmpGivDate AND OurID = @OurID AND EmpID = @EmpID AND AccDate BETWEEN @tmpBDate AND @tmpEDate AND NOT EXISTS (SELECT TOP 1 1 FROM @tmp WHERE MONTH(SrcDate) = MONTH(AccDate))
GROUP BY MONTH(AccDate)

UPDATE @tmp SET
SrcDate = dbo.zf_GetMonthLastDay(SrcDate),
FactDays = DATEDIFF(day, dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate)) + 1 - dbo.pf_GetHolidaysCount(dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate), 1),
WorkDays =  DATEDIFF(DAY,dbo.zf_GetMonthFirstDay(SrcDate),dbo.zf_GetMonthLastDay(SrcDate))+1-
            (DATEDIFF(WEEK,dbo.zf_GetMonthFirstDay(SrcDate),dbo.zf_GetMonthLastDay(SrcDate))*2+
            (CASE WHEN (DATENAME(dw,dbo.zf_GetMonthFirstDay(SrcDate)) IN ('Sunday')) THEN 1 ELSE 0 END)+
            (CASE WHEN (DATENAME(dw,dbo.zf_GetMonthLastDay(SrcDate)) IN ('Saturday')) THEN 1 ELSE 0 END))- dbo.pf_GetHolidaysCount(dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate), 1)

/* если нет данных о начислении ЗП, то загрузить размер оклада (тарифа) из Справочника служащих  r_empmpst.bsalary */
IF  DATEDIFF(m, @tmpGivDate, @Date) <= 1
BEGIN
  INSERT INTO @tmp(SrcDate, WorkDays, FactDays, FactSalary)
  SELECT bdate SrcDate, 0 DaysWork, 0 DaysFact, bsalary FactSalary from r_empmpst where OurID=@OurID and EmpID=@EmpID and @Date between bdate and edate AND NOT EXISTS (SELECT TOP 1 1 FROM @tmp WHERE FactSalary is null)
  UPDATE @tmp SET
  SrcDate = dbo.zf_GetMonthLastDay(SrcDate),
  FactDays = DATEDIFF(day, dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate)) + 1 - dbo.pf_GetHolidaysCount(dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate), 1),
  WorkDays =  DATEDIFF(DAY,dbo.zf_GetMonthFirstDay(SrcDate),dbo.zf_GetMonthLastDay(SrcDate))+1-
              (DATEDIFF(WEEK,dbo.zf_GetMonthFirstDay(SrcDate),dbo.zf_GetMonthLastDay(SrcDate))*2+
              (CASE WHEN (DATENAME(dw,dbo.zf_GetMonthFirstDay(SrcDate)) IN ('Sunday')) THEN 1 ELSE 0 END)+
              (CASE WHEN (DATENAME(dw,dbo.zf_GetMonthLastDay(SrcDate)) IN ('Saturday')) THEN 1 ELSE 0 END))- dbo.pf_GetHolidaysCount(dbo.zf_GetMonthFirstDay(SrcDate), dbo.zf_GetMonthLastDay(SrcDate), 1)
END

INSERT INTO @tmp (SrcDate, WorkDays, FactDays, FactSalary)
SELECT 0, SUM(WorkDays), SUM(FactDays), SUM(FactSalary) FROM @tmp
UPDATE @tmp SET AvrSalary = CASE WHEN WorkDays > 0 THEN ROUND(FactSalary / WorkDays, 2) ELSE 0 END
RETURN
END
GO
