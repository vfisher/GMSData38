SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetWorkPeriodDate](@Date datetime, @EmpID int, @OurID int)
/* Возвращает даты начала и конца рабочего периода в который входит дата */
RETURNS @tmp TABLE(BDate datetime, EDate datetime)
AS
BEGIN
 DECLARE @tmpDate datetime
 SET @tmpDate = dbo.pf_GetEmpGivDate(@Date, @EmpID, @OurID)
 DECLARE @i int
 IF DATEPART(dy, @tmpDate) > DATEPART(dy, @Date) SET @i = 1 ELSE SET @i = 0
 SET @tmpDate = CASE WHEN @tmpDate <> '20790101' THEN CAST(DATEPART(yy, @Date) - @i AS varchar) + RIGHT('0' + CAST(DATEPART(mm, @tmpDate) AS varchar), 2) + RIGHT('0' + CAST(DATEPART(dd, @tmpDate) AS varchar), 2) ELSE '20790101' END
 INSERT INTO @tmp(BDate, EDate) VALUES (@tmpDate, DATEADD(dd, -1, DATEADD(yy, 1, @tmpDate)))
 RETURN
END
GO