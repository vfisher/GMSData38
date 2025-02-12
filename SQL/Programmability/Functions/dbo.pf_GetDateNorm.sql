SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetDateNorm](@DocDate datetime, @WWeekType int)
/* Норма рабочего времени в днях за месяц */ 
RETURNS NUMERIC(21,9) AS 
BEGIN 
  RETURN ISNULL((SELECT DaysNorm FROM r_NormMH WHERE YearID = DATEPART(yy,@DocDate) AND MonthID = DATEPART(mm,@DocDate) AND WWeekTypeID = @WWeekType),0) 
END
GO