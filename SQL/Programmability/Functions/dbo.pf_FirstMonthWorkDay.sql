SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_FirstMonthWorkDay](@Date datetime)
/* Является ли дата первым рабочим днем месяца */
RETURNS BIT AS
BEGIN
  DECLARE @FirstMonthWorkDay bit, @tmpDate datetime, @i int, @j int
  SET @FirstMonthWorkDay = 1
  SET @i = 1
  SET @tmpDate = DATEADD(DAY, - DAY(@Date), @Date)
  SET @j = DATEPART (d, @Date)
  WHILE @i < @j
    BEGIN
      SET @tmpDate = DATEADD(DAY, 1, @tmpDate)
  	  IF (NOT DATEPART(DW, @tmpDate) IN (1, 7)) AND NOT EXISTS (SELECT 1 FROM r_Holidays WHERE HolidayDate = @tmpDate) SET @FirstMonthWorkDay = 0
  	  IF @FirstMonthWorkDay = 0 BREAK
  	  SET @i = @i + 1
    END
  RETURN @FirstMonthWorkDay
END
GO