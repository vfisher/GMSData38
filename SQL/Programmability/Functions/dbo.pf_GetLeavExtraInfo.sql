SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetLeavExtraInfo](@DocDate datetime, @EmpID int, @OurID int, @AddToUsed int, @LeavType int)
/* Возвращает информацию о количестве дней дополнительного отпуска в разрезе календарных периодов сотрудника */
RETURNS @tmpLeavCalc TABLE (WYear int, LeavDaysExtra int, UsedLeavDaysExtra int)
AS
BEGIN
/* дата приема на работу */
DECLARE @tmpBDate datetime, @DisDate datetime, @UsedLeavDaysExtra int, @yearBDate int, @yearEDate int, @tmpyearBDate int, @i numeric(21,9)

SET @tmpBDate = dbo.pf_GetEmpGivDate(@DocDate - 1, @EmpID, @OurID)
IF @tmpBDate = '20790101' RETURN

/* Дата увольнения */
SET @DisDate = dbo.pf_GetEmpDisDate(@DocDate, @EmpID, @OurID)
SET @UsedLeavDaysExtra = 0 

DECLARE @tmpDocSched TABLE(ChID bigint, OurID INT, EmpID INT, BDate DATETIME, EDate DATETIME)
/* Расчет периодов предоставления отпусков*/

INSERT INTO @tmpDocSched
SELECT 
  m1.ChID,
  m1.OurID,
  m1.EmpID,
  m1.AppDate AS BDate,
  ISNULL(
         (SELECT TOP 1
           m.AppDate - 1 AS EDate
         FROM 
           p_LeaveSched m
         WHERE m.OurID = @OurID AND m.EmpID = @EmpID AND m1.AppDate < m.AppDate 
         ORDER BY m.AppDate), CAST('20790101' AS DATETIME)) 
FROM 
  p_LeaveSched m1
WHERE m1.OurID = @OurID AND m1.EmpID = @EmpID 

SET @yearBDate = (SELECT MIN(year(BDate)) FROM @tmpDocSched WHERE OurID = @OurID and EmpID = @EmpID)
SET @tmpyearBDate = @yearBDate

SET @yearEDate = (SELECT MAX(year(EDate)) FROM @tmpDocSched WHERE OurID = @OurID and EmpID = @EmpID)
IF @yearEDate = 2079 Set @yearEDate = YEAR(@DocDate)

DECLARE @years table(year int)
WHILE @tmpyearBDate <=  @yearEDate
BEGIN
  INSERT INTO @years(year)
  SELECT @tmpyearBDate
SET @tmpyearBDate = @tmpyearBDate + 1
END

SET @tmpyearBDate = @yearBDate
WHILE @tmpyearBDate <= @yearEDate
BEGIN
  INSERT INTO  @tmpLeavCalc(WYear, LeavDaysExtra, UsedLeavDaysExtra)
  SELECT
    @tmpyearBDate,
    ISNULL((SELECT MAX(t1.LeavDaysExtra) AS LeavDaysExtra FROM @years y,
             (SELECT
                YEAR(t.BDate) AS YearBDate,
                YEAR(t.EDate) AS YearEDate,
                t.LeavDays AS LeavDaysExtra
              FROM (
                    SELECT m.BDate, m.EDate, d.LeavDays
                    FROM 
                      @tmpDocSched m,
                      p_LeaveSchedD d
                    WHERE m.ChID = d.ChID AND d.LeavType = @LeavType AND
                      m.OurID = @OurID and m.EmpID = @EmpID and m.EDate >= dbo.pf_GetEmpGivDate(@DocDate - 1, @EmpID, @OurID) AND m.BDate <= @DocDate
                   ) t
             ) t1
            WHERE y.year between t1.YearBDate and t1.YearEDate and y.year = @tmpyearBDate
            GROUP BY y.year),0) AS LeavDaysExtra,
    0 AS UsedLeavDays

 SET @UsedLeavdaysExtra = ISNULL(@UsedLeavdaysExtra,0) + 

/* Приказ: Отпуск: использованные дни основного отпуска */
ISNULL(( SELECT SUM(LeavDays) FROM p_ELeav JOIN p_ELeavD ON p_ELeav.ChID = p_ELeavD.ChID
WHERE OurID = @OurID AND EmpID = @EmpID AND ((LeavType = @LeavType) OR (LeavType = 1000 + @LeavType))  AND YEAR(AgeBDate) = @tmpyearBDate),0) 
/* Конец: Приказ: Отпуск: использованные дни основного отпуска */

/* Входящие данные по служащим: использованных дней основного отпуска */
SET @UsedLeavdaysExtra = @UsedLeavdaysExtra + ISNULL((SELECT SUM(LeavDays)
FROM p_EmpIn m JOIN p_EmpInLeavs d ON m.ChID = d.ChID
WHERE WorkAppDate >= dbo.pf_GetEmpGivDate(@DocDate - 1, @EmpID, @OurID) AND OurID = @OurID AND EmpID = @EmpID AND LeavType = @LeavType AND YEAR(AgeBDate)
= @tmpyearBDate  AND YEAR(AgeEDate) = @yearEDate),0)
/* Конец: Входящие данные по служащим: использованных дней основного отпуска */


UPDATE @tmpLeavCalc SET UsedLeavDaysExtra = ROUND(CASE WHEN @UsedLeavDaysExtra > @i THEN @i ELSE @UsedLeavDaysExtra END, 0) WHERE WYear = @tmpyearBDate

IF @UsedLeavDaysExtra > 0 SET @UsedLeavDaysExtra = @UsedLeavDaysExtra - @i /* обновить остаток использованных дней основного отпуска */
IF @UsedLeavDaysExtra < 0 SET @UsedLeavDaysExtra = 0

  SET @tmpyearBDate = @tmpyearBDate + 1
END
UPDATE  @tmpLeavCalc SET UsedLeavDaysExtra = UsedLeavDaysExtra + @AddToUsed WHERE WYear = @tmpyearBDate - 1
RETURN
END
GO