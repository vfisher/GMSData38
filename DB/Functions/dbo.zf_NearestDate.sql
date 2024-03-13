SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_NearestDate](@Date smalldatetime, @NearestTo smalldatetime)/* Возвращает ближайшую дату к указанной */RETURNS smalldatetimeASBEGIN  DECLARE @Date1 smalldatetime   DECLARE @Date2 smalldatetime  DECLARE @Date3 smalldatetime  DECLARE @Diff1 int  DECLARE @Diff2 int  DECLARE @Diff3 int  SET @Date = dbo.zf_GetDate(@Date)  SET @NearestTo = dbo.zf_GetDate(@NearestTo)  SET @Date1 = DATEADD(year, DATEPART(year, @NearestTo) - DATEPART(year, @Date) - 1, @Date)  SET @Date2 = DATEADD(year, DATEPART(year, @NearestTo) - DATEPART(year, @Date), @Date)  SET @Date3 = DATEADD(year, DATEPART(year, @NearestTo) - DATEPART(year, @Date) + 1, @Date)  SET @Diff1 = ABS(DATEDIFF(day, @Date1, @NearestTo))  SET @Diff2 = ABS(DATEDIFF(day, @Date2, @NearestTo))  SET @Diff3 = ABS(DATEDIFF(day, @Date3, @NearestTo))  RETURN (CASE    WHEN @Diff1 <= @Diff2 AND @Diff1 <= @Diff3 THEN @Date1    WHEN @Diff2 <= @Diff1 AND @Diff2 <= @Diff3 THEN @Date2    WHEN @Diff3 <= @Diff1 AND @Diff3 <= @Diff2 THEN @Date3    END)END
GO
