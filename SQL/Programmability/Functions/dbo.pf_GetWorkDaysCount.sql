SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetWorkDaysCount] (@BDate datetime, @EmpID int, @OurID int, @ForLeavCalc bit) 
/* Количество учетных рабочих дней в указанный период. */
RETURNS int AS 
BEGIN  
DECLARE @tmpBDate datetime 
DECLARE @tmpEDate datetime  
SET @tmpBDate = dbo.zf_GetMonthFirstDay(@BDate)
SET @tmpEDate = dbo.zf_GetMonthLastDay(@BDate)
RETURN DATEDIFF(DAY, @tmpBDate, @tmpEDate) + 1 - dbo.pf_GetHolidaysCount(@tmpBDate, @tmpEDate, @ForLeavCalc) - dbo.pf_GetLeavDaysCount(@tmpBDate, @tmpEDate, @EmpID, @OurID, 7)    
END
GO