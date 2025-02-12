SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetExpPeriod] (@EmpID int)
/* Возвращает количество дней, месяцев, лет общего трудового стажа из вкладки Трудовая деятельность (Справочник служащих) */
RETURNS @tmp TABLE(Days INT, Months int, Years int)
AS
BEGIN
DECLARE @ExpPeriod TABLE(BDate datetime, EDate datetime, tempDate DATETIME, tempDateDay DATETIME, years INT DEFAULT 0, months INT DEFAULT 0, DAYS INT DEFAULT 0)

INSERT INTO @ExpPeriod(BDate, EDate, tempDate, tempDateDay)
SELECT
  BDate,
  EDate,
  DATEADD(year, DATEDIFF (year, BDate , EDate), BDate),
  DATEADD (month, DATEDIFF (month, DATEADD(year, DATEDIFF (year, BDate , EDate), BDate), EDate), DATEADD(year, DATEDIFF (year, BDate , EDate), BDate))
FROM r_EmpAct
WHERE EmpID = @EmpID

UPDATE @ExpPeriod
SET years = DATEDIFF(year, BDate , EDate),
    months = DATEDIFF(month, tempDate, EDate),
    days = DATEDIFF(day, tempDateDay, EDate) + 1

UPDATE @ExpPeriod
SET years = CASE WHEN months < 0 THEN years - 1 ELSE years END,
    months = CASE WHEN (CASE WHEN days < 0 THEN (months - 1) ELSE months END) < 0
                               THEN (12 + (CASE WHEN days < 0 THEN (months - 1) ELSE months END))
                             ELSE (CASE WHEN days < 0 THEN (months - 1)
                                        ELSE months END) END,
    days = CASE WHEN days < 0 THEN (30 + days) ELSE days END

INSERT INTO @tmp
SELECT
  ISNULL(S.DAYS, 0),
  ISNULL(CASE WHEN S.months > 12 THEN S.months % 12 ELSE S.months END, 0) months,
  ISNULL(CASE WHEN S.months > 12 THEN S.years + (S.months / 12) ELSE S.years END, 0) years
FROM (
  SELECT
    CASE WHEN (SUM(days) > 30) THEN (SUM(days) % 30) ELSE SUM(days) END DAYS,
    CASE WHEN (SUM(days) > 30) THEN SUM(months) + SUM(days) / 30 ELSE SUM(months) END months,
    SUM(Years) years
  FROM @ExpPeriod) S
RETURN
END
GO