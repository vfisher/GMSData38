SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetWorkHoursForSchedID](@BDate datetime, @EDate datetime, @SchedID INT)
/* Возвращает количество рабочих часов по коду графика работ за указанный период */
RETURNS INT AS
BEGIN
  DECLARE @tmpBDate DATETIME, @SchedDayID INT, @SchedDayCount INT, @WorkHours INT, @HoursInDay INT, @SlidingShed INT, @DecWTime INT, @IsHoliday INT, @SchedCreatDate DATETIME, @ConHolDays bit
  SET @tmpBDate = @BDate

  SET @ConHolDays = (SELECT ConHolDays FROM r_Sheds WHERE ShedID = @SchedID)
  SET @SlidingShed = (SELECT SlidingShed FROM r_Sheds WHERE ShedID = @SchedID)                   
  SET @SchedDayCount = ISNULL((SELECT ShedDaysQty FROM r_Sheds WHERE ShedID = @SchedID), 0)
  SET @SchedCreatDate = (SELECT ShedBDate FROM r_Sheds WHERE ShedID = @SchedID)
  SET @WorkHours = 0
  WHILE (1 = 1) /* проход по всему РП сотрудника */
  BEGIN
    IF (@SchedDayCount = 0) OR (@tmpBDate > @EDate) BREAK
    SET @SchedDayID = DATEDIFF(DAY, @SchedCreatDate, @tmpBDate) -
    FLOOR((DATEDIFF(DAY, @SchedCreatDate, @tmpBDate))/@SchedDayCount) * @SchedDayCount + 1

    SET @HoursInDay = (SELECT DISTINCT d.HoursInDay FROM r_Sheds m
                       INNER JOIN r_ShedMD d ON m.ShedID = d.ShedID AND d.ShedID = @SchedID AND d.HoursInDay <> 0 AND d.DayPosID = @SchedDayID)               

    SET @IsHoliday = ISNULL((SELECT TOP 1 IsHoliday FROM dbo.r_Holidays WHERE HolidayDate = (@tmpBDate + 1)),0)

    IF (@ConHolDays = 1) AND (@IsHoliday = 1) /* уменьшать рабочий день на 1 час */
      SET @DecWTime = ISNULL((SELECT TOP 1 DecWTime FROM dbo.r_Holidays WHERE HolidayDate = (@tmpBDate + 1)),0)
    ELSE 
      SET @DecWTime = 0

    IF @SchedDayID IN (SELECT DISTINCT d.DayPosID FROM r_Sheds m
    INNER JOIN r_ShedMD d ON m.ShedID = d.ShedID AND d.ShedID = @SchedID AND d.HoursInDay <> 0)
    IF @SlidingShed = 1  /* скользящий график */
      SET @WorkHours = @WorkHours + @HoursInDay
    ELSE
      IF dbo.pf_GetHolidaysCount(@tmpBDate,@tmpBDate,0) = 1 /* если праздничный день */
        IF (@ConHolDays = 1)  /* учитывать нерабочие дни (отнимать праздничные дни)  */
          SET @WorkHours = @WorkHours
        ELSE
          SET @WorkHours = @WorkHours + @HoursInDay - @DecWTime 
      ELSE
        SET @WorkHours = @WorkHours + @HoursInDay - @DecWTime                                                                                           

    SET @tmpBDate = DATEADD(DAY,1,@tmpBDate) /* следующий РП */
  END  
RETURN @WorkHours
END
GO
