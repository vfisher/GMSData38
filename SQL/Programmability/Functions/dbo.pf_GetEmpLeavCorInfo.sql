SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetEmpLeavCorInfo](@OurID int, @EmpID int, @LeavCorType int)
/* Возвращает информацию о корректировке отпуска по сотруднику */
RETURNS @tmpLeavPeriod table (EmpID int, LeavType int, AgeBDate datetime, AgeEDate datetime, BDate datetime, EDate datetime, CorBDate datetime, CorEDate datetime, NewBDate datetime, NewEDate datetime, CorDays int, LeavCorDays int)
AS
BEGIN
INSERT INTO @tmpLeavPeriod
SELECT TOP 1
d.EmpID,
d.LeavType,
d.AgeBDate,
d.AgeEDate,
d.BDate,
d.EDate,
null,
null,
null,
null,
0,
0
FROM p_ELeavD d, p_ELeav m
WHERE m.ChID  = d.ChID AND m.OurID = @OurID AND d.EmpID = @EmpID AND d.LeavType <> 21
ORDER BY d.ChID DESC, d.SrcPosID DESC

DECLARE @BDate datetime, @EDate datetime
SET @BDate = (SELECT BDate FROM @tmpLeavPeriod)
SET @EDate = (SELECT EDate FROM @tmpLeavPeriod)

/* Период корректировки по документу: Больничный лист */
UPDATE @tmpLeavPeriod
SET CorBDate = (SELECT SickBDate FROM p_ESic WHERE EmpID = @EmpID AND SickBDate BETWEEN @BDate AND @EDate)
UPDATE @tmpLeavPeriod
SET CorEDate = (SELECT SickEDate FROM p_ESic WHERE EmpID = @EmpID AND SickBDate BETWEEN @BDate AND @EDate)

/* Период корректировки по документу: Приказ: Отпуск (Дополнительный отпуск в связи с учебой - 21 код типа отпуска) */
IF  Exists (SELECT * FROM p_ELeav m, p_ELeavD d WHERE m.ChID = d.ChID and m.OurID = @OurID and d.EmpID = @EmpID and BDate BETWEEN @BDate AND @EDate and d.LeavType = 21)
BEGIN
UPDATE @tmpLeavPeriod
SET CorBDate = CorBDate + ISNULL((SELECT BDATE FROM p_ELeav m, p_ELeavD d WHERE m.ChID = d.ChID and m.OurID = @OurID and d.EmpID = @EmpID and BDate BETWEEN @BDate AND @EDate and d.LeavType = 21),0)
UPDATE @tmpLeavPeriod
SET CorEDate = CorEDate + ISNULL((SELECT EDATE FROM p_ELeav m, p_ELeavD d WHERE m.ChID = d.ChID and m.OurID = @OurID and d.EmpID = @EmpID and BDate BETWEEN @BDate AND @EDate and d.LeavType = 21),0)
END

UPDATE @tmpLeavPeriod
SET CorDays = ISNULL(CONVERT(INT,CorEDate - CorBDate + 1),0)

UPDATE @tmpLeavPeriod
SET NewBDate = ISNULL((SELECT
                       CASE
                         WHEN @LeavCorType = 3  THEN BDate
                         WHEN @LeavCorType IN (1,2) AND (CorEDate <= EDate) THEN EDate + 1
                         WHEN @LeavCorType IN (1,2) AND (CorEDate > EDate) THEN CorEDate + 1
                       END), BDate)

UPDATE @tmpLeavPeriod
SET LeavCorDays = ISNULL((SELECT
                          CASE
                            WHEN (@LeavCorType = 1) OR (@LeavCorType = 2) THEN  CONVERT(INT,EDate - CorBDate + 1)
                            WHEN @LeavCorType = 3 THEN CONVERT(INT,EDate - BDate + 1)
                          END),0)

UPDATE @tmpLeavPeriod
SET CorDays = (CASE WHEN CorDays = 0 THEN CorDays
                    ELSE ISNULL((SELECT
                                 CASE
                                 WHEN @LeavCorType <> 0 THEN
                                   CASE
                                     WHEN (CorBDate <= BDate) AND (CorEDate <= EDate) THEN CONVERT(INT,CorEDate - BDate) + 1
                                     WHEN (CorBDate <= BDate) AND (CorEDate >= EDate) THEN CONVERT(INT,EDate - BDate) + 1
                                     WHEN (CorBDate >= BDate) AND (CorEDate >= EDate) THEN CONVERT(INT,EDate - CorBDate) + 1
                                     WHEN (CorBDate >= BDate) AND (CorEDate <= EDate) THEN CONVERT(INT,CorEDate - CorBDate) + 1
                                   END
                                 END),0)
               END)

UPDATE @tmpLeavPeriod
SET NewEDate =
CASE
  WHEN @LeavCorType in (0,3) THEN EDate
  WHEN CorDays = 0 THEN EDate
  ELSE NewBDate + CorDays - 1
END

UPDATE @tmpLeavPeriod
SET LeavCorDays = CASE WHEN LeavType IN (11,100) THEN  CONVERT(INT,NewEDate - NewBDate) + 1 - (SELECT dbo.pf_GetHolidaysCount(NewBDate, NewEDate,1))
                       ELSE CONVERT(INT,NewEDate - NewBDate) + 1
                  END

RETURN
END
GO