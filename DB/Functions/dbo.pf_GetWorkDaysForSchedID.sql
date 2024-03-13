SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetWorkDaysForSchedID] (@BDate datetime, @EDate datetime, @SchedID INT)
/* Возвращает количество рабочих дней по коду графика работ за указанный период */
RETURNS INT AS
BEGIN
  DECLARE @tmpBDate DATETIME, @SchedDayID INT, @SchedDayCount INT, @WorkDays INT, @SchedCreatDate DATETIME, @ConHolDays BIT, @SlidingShed INT
  SET @tmpBDate = @BDate

  SET @ConHolDays = (SELECT ConHolDays FROM r_Sheds WHERE ShedID = @SchedID)
  SET @SlidingShed = (SELECT SlidingShed FROM r_Sheds WHERE ShedID = @SchedID)                     
  SET @SchedDayCount = ISNULL((SELECT ShedDaysQty FROM r_Sheds WHERE ShedID = @SchedID), 0)
  SET @SchedCreatDate = (SELECT ShedBDate FROM r_Sheds WHERE ShedID = @SchedID)
  SET @WorkDays = 0
  WHILE (1 = 1) /* проход по всему РП сотрудника */
  BEGIN
    IF (@SchedDayCount = 0) OR (@tmpBDate > @EDate) BREAK

    SET @SchedDayID = DATEDIFF(DAY, @SchedCreatDate, @tmpBDate) -
    FLOOR((DATEDIFF(DAY, @SchedCreatDate, @tmpBDate))/@SchedDayCount) * @SchedDayCount + 1

    IF @SchedDayID IN (SELECT DISTINCT d.DayPosID FROM r_Sheds m
    INNER JOIN r_ShedMD d ON m.ShedID = d.ShedID AND d.ShedID = @SchedID AND d.HoursInDay <> 0)

    IF @SlidingShed = 1  /* скользящий график */
      SET @WorkDays = @WorkDays + 1 
    ELSE
      IF dbo.pf_GetHolidaysCount(@tmpBDate,@tmpBDate,0) = 1 /* если праздничный день */
        IF (@ConHolDays = 1) /* учитывать нерабочие дни (отнимать праздничные дни) */ 
          SET @WorkDays = @WorkDays
        ELSE
          SET @WorkDays = @WorkDays + 1
      ELSE
        SET @WorkDays = @WorkDays + 1

    SET @tmpBDate = DATEADD(DAY,1,@tmpBDate) /* следующий РП */
  END
RETURN @WorkDays
END
GO
