SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetLeavInfo](@ChID BIGINT, @SrcPosID int, @DocDate datetime, @EmpID int, @OurID int, @AddToUsed int, @LeavType int)
/* Возвращает информацию о количестве дней основного отпуска в разрезе рабочих периодов сотрудника с учетом отпусков по уходу за ребенком */
RETURNS @tmpLeavCalc TABLE (WYear int, WDays int, BDate datetime, EDate datetime, LeavDays NUMERIC(21,9), UsedLeavDays int, HolidaysCount int, ChildCareDays int)
AS
BEGIN
DECLARE @tmpBDate datetime, @tmpEDate datetime, @tmpEDate2 datetime, @tmpBDateDecree datetime, @tmpBDate22 DATETIME, @tmpEDate22 DATETIME, 
@DisDate datetime,            /* дата увольнения если есть */
@UsedLeavDays numeric(21,9),  /* общее колво использованных дней основого отпуска за все РП */
@WYear int,                   /* идентификатор рабочего периода (РП). равен году даты начала РП */
@WDays int,                   /* календарных дней в текущем РП  */
@WDaysNoHolidays int,         /* календарных дней в текущем РП без праздников */
@CCDays int,                  /* дней отпуска по уходу на ребенком  в текущем РП за вычитом праздничных дней */
@HDays int,                   /* праздничных дней в текущем РП */
@y int, @tmpWDays2 int, @tmpHDays2 int, @i numeric(21,9),
@AgeBDate datetime
DECLARE @DecreePeriod TABLE (BDate datetime, EDate DATETIME, VarCor bit default(0))
/* дата приема на работу */
SET @tmpBDate = dbo.pf_GetEmpGivDate(@DocDate - 1, @EmpID, @OurID)
IF @tmpBDate = '20790101' RETURN
SET @DisDate = dbo.pf_GetEmpDisDate(@DocDate, @EmpID, @OurID)
/* входящие: использованных дней основного отпуска + компенсация */

SET @UsedLeavDays = 0

SET @AgeBDate = (SELECT d.AgeBDate FROM p_ELeav m,
     p_ELeavD d
WHERE m.ChID = d.ChID AND m.OurID = @OurID AND m.ChID = @ChID AND d.SrcPosID = @SrcPosID AND d.LeavType = @LeavType)

IF (SELECT dbo.zf_Var('p_UseLeaveSched')) = '1'
BEGIN
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
END

SET @WYear = 1900
WHILE (1 = 1) /* проход по всем РП сотрудника начиная с даты приема на работу */
BEGIN
  IF (@tmpBDate > @DisDate) OR (@tmpBDate > @DocDate)  BREAK
  SET @tmpEDate = DATEADD(dd, -1, DATEADD(yy, 1, @tmpBDate))
  IF @tmpEDate > @DisDate
    BEGIN
      SET @tmpEDate2 = @DisDate
    END
  ELSE SET @tmpEDate2 = '19000101'
SET @WYear = DATEPART(yy, @tmpBDate)
SET @WDays = DATEDIFF(day, @tmpBDate, @tmpEDate) + 1
SET @HDays = dbo.pf_GetHolidaysCount(@tmpBDate, @tmpEDate, 1)

IF @AgeBDate = @tmpBDate 
  SET @UsedLeavDays = @AddToUsed 


IF (SELECT dbo.zf_Var('p_UseLeaveSched')) = '1'
BEGIN
  INSERT INTO @tmpLeavCalc(BDate, EDate, WYear, WDays, HolidaysCount, LeavDays, UsedLeavDays)
  SELECT
    @tmpBDate, 
    @tmpEDate,
    @WYear,
    @WDays,
    @HDays,
    SUM(CASE WHEN @LeavType IN(11,1011,12,13) THEN 
    ROUND(CASE
                     WHEN @WDays - @HDays <> 0 THEN (1.0 / (@WDays - @HDays) * ((DATEDIFF(day, BDate, EDate) + 1) - dbo.pf_GetHolidaysCount(BDate, EDate, 1)) * LeavDays)
                     ELSE 0
                   END,2) ELSE 0 END),              
    0
  FROM (
    SELECT 
      CASE WHEN @tmpBDate < m.BDate - 1 THEN m.BDate - 1 ELSE @tmpBDate END AS BDate,
      CASE WHEN @tmpEDate < m.EDate - 1 THEN @tmpEDate ELSE m.EDate - 1  END AS EDate,
      SUM(LeavDays) AS LeavDays
    FROM 
      @tmpDocSched m,
      p_LeaveSchedD d
    WHERE m.ChID = d.ChID AND d.LeavType = @LeavType AND m.EDate >= @tmpBDate AND m.BDate <= @tmpEDate AND m.EmpID = @EmpID AND m.OurID = @OurID
    GROUP BY CASE WHEN @tmpBDate < m.BDate - 1 THEN m.BDate - 1 ELSE @tmpBDate END, CASE WHEN @tmpEDate < m.EDate - 1 THEN @tmpEDate ELSE m.EDate - 1  END 
  ) s

  /* Обновление LeavDays при увольнении сотрудника */
  IF @tmpEDate > @DisDate
  BEGIN
    UPDATE @tmpLeavCalc SET WDays = DATEDIFF(day, BDate, @tmpEDate2) + 1 WHERE WYear = @WYear 
    UPDATE @tmpLeavCalc SET HolidaysCount = dbo.pf_GetHolidaysCount(BDate, @tmpEDate2, 1) WHERE WYear = @WYear  
    UPDATE @tmpLeavCalc
    SET LeavDays = (SELECT 
                     ROUND(CASE
                     WHEN @WDays - @HDays <> 0 THEN (1.0 / (@WDays - @HDays) * ((DATEDIFF(day, BDate, @tmpEDate2) + 1) - dbo.pf_GetHolidaysCount(BDate, @tmpEDate2, 1)) * LeavDays)
                     ELSE 0
                   END,2))            
    WHERE WYear = @WYear
  END     
END
ELSE
BEGIN
  INSERT INTO @tmpLeavCalc(BDate, EDate, WYear, WDays, HolidaysCount, LeavDays, UsedLeavDays)
  SELECT 
    @tmpBDate, 
    @tmpEDate,
    @WYear,
    @WDays,
    @HDays,
    SUM(CASE WHEN @LeavType IN(11,1011,12,13) THEN 
    ROUND(CASE
                     WHEN @WDays - @HDays <> 0 THEN (1.0 / (@WDays - @HDays) * ((DATEDIFF(day, CASE WHEN BDate < @tmpBDate THEN @tmpBDate ELSE BDate END, CASE WHEN EDate > @tmpEDate THEN @tmpEDate ELSE EDate END) + 1) - dbo.pf_GetHolidaysCount(CASE WHEN BDate < @tmpBDate THEN @tmpBDate ELSE BDate END, CASE WHEN EDate > @tmpEDate THEN @tmpEDate ELSE EDate END, 1)) * LeavDays)
                     ELSE 0
                   END,2) ELSE 0 END),
    0
    FROM  r_EmpMPst m
    WHERE m.EDate >= @tmpBDate AND m.BDate <= @tmpEDate AND m.EmpID = @EmpID AND m.OurID = @OurID AND m.IsDisDoc = 0  
END

/* период отпуска по уходу за ребенком в текущем РП */
DELETE FROM @DecreePeriod
INSERT INTO @DecreePeriod (BDate, EDate, VarCor)
SELECT 
  MIN(BDate) AS BDate,
  MAX(EDate) AS EDate,
  VarCor
FROM (
SELECT /*TOP 1*/
  CASE WHEN S.BDate < @tmpBDate THEN @tmpBDate ELSE S.BDate END BDate,
  CASE WHEN S.EDate > @tmpEDate THEN @tmpEDate ELSE S.EDate END EDate,
  S.VarCor
FROM (
SELECT
  CASE WHEN S2.NewBDate IS NOT NULL THEN S2.NewBDate ELSE S1.BDate END BDate,
  CASE WHEN S2.NewEDate IS NOT NULL THEN S2.NewEDate ELSE S1.EDate END EDate,
  CASE WHEN S1.LeavType IN (41, 42, 1042, 1043) THEN 1 END VarCor
FROM (SELECT d.EmpID, d.LeavType, d.LeavDays, d.BDate, d.EDate  FROM p_ELeav m, p_ELeavD d
      WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.LeavType IN (41, 42, 1042, 1043) AND d.EmpID  = @EmpID) S1
LEFT JOIN (SELECT d.EmpID, d.LeavCorType, d.LeavCorDays, d.BDate, d.EDate, d.NewBDate, d.NewEDate FROM p_ELeavCor m, p_ELeavCorD d
WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.EmpID  = @EmpID AND d.LeavCorType <> 4) S2 ON S1.BDate = S2.BDate AND S1.EDate = S2.EDate) S
WHERE (S.BDate BETWEEN @tmpBDate AND @tmpEDate) OR (S.EDate BETWEEN @tmpBDate AND @tmpEDate) OR (S.EDate > @tmpEDate AND S.BDate < @tmpBDate)) S1
GROUP BY VarCor  

IF ((SELECT VarCor FROM @DecreePeriod) = 1)
  BEGIN   /*----------------------------- 1*/
    SET @tmpBDate22 = @tmpBDate
    SET @tmpEDate22 = @tmpEDate

    /* Увольнение после декретного отпуска*/
    IF @DisDate >= (SELECT BDate FROM @DecreePeriod) AND @DisDate <= (SELECT EDate FROM @DecreePeriod)
      SET @tmpEDate22 = @DisDate

    IF @tmpBDate22 = (SELECT BDate FROM @DecreePeriod) AND @tmpEDate22 <> (SELECT EDate FROM @DecreePeriod)
      BEGIN   
        UPDATE @tmpLeavCalc  SET WDays = DATEDIFF(day, (SELECT EDate + 1 FROM @DecreePeriod), EDate) + 1 WHERE WYear = @WYear
        UPDATE @tmpLeavCalc  SET HolidaysCount = dbo.pf_GetHolidaysCount((SELECT EDate + 1 FROM @DecreePeriod), EDate, 1) WHERE WYear = @WYear 
        UPDATE @tmpLeavCalc SET LeavDays = ISNULL(ROUND((LeavDays * 1.0 / (@WDays - @HDays)) * ((DATEDIFF(day, (SELECT EDate + 1 FROM @DecreePeriod), EDate) + 1) - dbo.pf_GetHolidaysCount((SELECT EDate + 1 FROM @DecreePeriod), EDate, 1)), 2), 0) WHERE WYear = @WYear

      END

   IF @tmpEDate22 = (SELECT EDate FROM @DecreePeriod) AND @tmpBDate22 <> (SELECT BDate FROM @DecreePeriod)
      BEGIN
        UPDATE @tmpLeavCalc  SET WDays = DATEDIFF(day, BDate, (SELECT BDate - 1 FROM @DecreePeriod)) + 1 WHERE WYear = @WYear
        UPDATE @tmpLeavCalc  SET HolidaysCount = dbo.pf_GetHolidaysCount(BDate, (SELECT BDate - 1 FROM @DecreePeriod), 1) WHERE WYear = @WYear 
        UPDATE @tmpLeavCalc SET LeavDays = ISNULL(ROUND((LeavDays * 1.0 / (@WDays - @HDays)) * ((DATEDIFF(day, BDate, (SELECT BDate - 1 FROM @DecreePeriod)) + 1) - dbo.pf_GetHolidaysCount(BDate, (SELECT BDate - 1 FROM @DecreePeriod), 1)), 2), 0) WHERE WYear = @WYear
      END   

  /*IF (@tmpBDate22 = @tmpBDate) AND (@tmpEDate22 = @tmpEDate) */
    BEGIN  /*-----------------------------2*/      
      IF (@tmpBDate22 between (SELECT BDate FROM @DecreePeriod) AND (SELECT EDate FROM @DecreePeriod)) AND 
         (@tmpEDate22 between (SELECT BDate FROM @DecreePeriod) AND (SELECT EDate FROM @DecreePeriod))
      BEGIN  /*-----------------------------3*/
        UPDATE @tmpLeavCalc SET LeavDays = 0 WHERE WYear = @WYear 
        UPDATE @tmpLeavCalc SET WDays = 0 WHERE WYear = @WYear          

      /*-----------------------------*/
        IF (SELECT dbo.zf_Var('p_UseLeaveSched')) = '0'
          BEGIN
            SET @UsedLeavdays =  ISNULL(@UsedLeavdays,0) + 
            /* Приказ: Отпуск: использованные дни основного отпуска */
            ISNULL(( SELECT SUM(LeavDays) FROM p_ELeav JOIN p_ELeavD ON p_ELeav.ChID = p_ELeavD.ChID
            WHERE OurID = @OurID AND EmpID = @EmpID AND LeavType IN (11,12,13,1011) AND AgeBDate BETWEEN @tmpBDate AND @tmpEDate),0) 
            /* Конец: Приказ: Отпуск: использованные дни основного отпуска */
          END
        ELSE
          SET @UsedLeavdays =  ISNULL(@UsedLeavdays,0) + 

          /* Приказ: Отпуск: использованные дни основного отпуска */
          ISNULL(( SELECT SUM(LeavDays) FROM p_ELeav JOIN p_ELeavD ON p_ELeav.ChID = p_ELeavD.ChID
          WHERE OurID = @OurID AND EmpID = @EmpID AND ((LeavType = @LeavType) OR (LeavType = 1000 + @LeavType)) 
          AND AgeBDate BETWEEN @tmpBDate AND @tmpEDate),0) 
          /* Конец: Приказ: Отпуск: использованные дни основного отпуска */
      /*--------------------------*/

      END /*-----------------------------3*/
    END  /*-----------------------------2*/
  END  /*-----------------------------1*/

IF (SELECT dbo.zf_Var('p_UseLeaveSched')) = '0'
BEGIN
  SET @UsedLeavdays = ISNULL(@UsedLeavdays,0) + 

  /* Приказ: Отпуск: использованные дни основного отпуска */
  ISNULL(( SELECT SUM(LeavDays) FROM p_ELeav JOIN p_ELeavD ON p_ELeav.ChID = p_ELeavD.ChID
  WHERE OurID = @OurID AND EmpID = @EmpID AND LeavType IN (11,12,13,1011) AND AgeBDate BETWEEN @tmpBDate AND @tmpEDate),0) 
  /* Конец: Приказ: Отпуск: использованные дни основного отпуска */
END
ELSE
  SET @UsedLeavdays = ISNULL(@UsedLeavdays,0) + 

  /* Приказ: Отпуск: использованные дни основного отпуска */
  ISNULL(( SELECT SUM(LeavDays) FROM p_ELeav JOIN p_ELeavD ON p_ELeav.ChID = p_ELeavD.ChID
  WHERE OurID = @OurID AND EmpID = @EmpID AND ((LeavType = @LeavType) OR (LeavType = 1000 + @LeavType)) AND AgeBDate BETWEEN @tmpBDate AND @tmpEDate),0) 
  /* Конец: Приказ: Отпуск: использованные дни основного отпуска */

/* Входящие данные по служащим: использованных дней основного отпуска */
SET @UsedLeavdays = @UsedLeavdays + ISNULL((SELECT SUM(LeavDays)
FROM p_EmpIn m JOIN p_EmpInLeavs d ON m.ChID = d.ChID
WHERE WorkAppDate >= dbo.pf_GetEmpGivDate(@DocDate - 1, @EmpID, @OurID) AND OurID = @OurID AND EmpID = @EmpID AND LeavType = @LeavType AND AgeBDate
BETWEEN @tmpBDate AND @tmpEDate AND AgeEDate BETWEEN @tmpBDate AND @tmpEDate),0)
/* Конец: Входящие данные по служащим: использованных дней основного отпуска */


IF @DisDate BETWEEN @tmpBDate AND @tmpEDate2 SET @i = @UsedLeavDays
ELSE SET @i = ISNULL((SELECT LeavDays FROM @tmpLeavCalc WHERE WYear = @WYear), 0)

UPDATE @tmpLeavCalc SET UsedLeavDays = ROUND(CASE WHEN @UsedLeavDays > @i THEN @i ELSE @UsedLeavDays END, 0) WHERE WYear = @WYear

IF @UsedLeavDays > 0 SET @UsedLeavDays = @UsedLeavDays - @i   /* обновить остаток использованных дней основного отпуска */
IF @UsedLeavDays < 0 SET @UsedLeavDays = 0

SET @tmpBDate = DATEADD(yy, 1, @tmpBDate) /* следующий РП */
END

IF @UsedLeavDays > 0 
UPDATE @tmpLeavCalc SET UsedLeavDays = UsedLeavDays + @UsedLeavDays WHERE WYear = @WYear

UPDATE @tmpLeavCalc SET LeavDays = 0, UsedLeavDays = 0 WHERE EDate < BDate AND WYear = @WYear  
RETURN
END
GO