SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetTimeNorm](@DocDate datetime, @WWeekType int)
/* Норма рабочего времени в часах за месяц */ 
RETURNS NUMERIC(21,9) AS 
BEGIN 
  RETURN ISNULL((SELECT HoursNorm FROM r_NormMH WHERE YearID = DATEPART(yy,@DocDate) AND MonthID = DATEPART(mm,@DocDate) AND WWeekTypeID = @WWeekType),0) 
END
GO
