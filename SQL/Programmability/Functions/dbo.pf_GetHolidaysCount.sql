SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetHolidaysCount](@BDate datetime, @EDate datetime, @OnlyHolidays bit)
/* Количество праздничных и нерабочих дней в указанный период */
RETURNS int AS
BEGIN
  RETURN ISNULL((SELECT COUNT(*) FROM r_Holidays WHERE (IsHoliday = 1 OR @OnlyHolidays = 0) AND HolidayDate BETWEEN @BDate AND @EDate), 0)
END
GO