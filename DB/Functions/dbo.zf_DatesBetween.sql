SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_DatesBetween](@BDate smalldatetime, @EDate smalldatetime, @IncludeHolidays bit)
/* Возвращает все даты в указанном диапазоне включая/не включая выходные */
RETURNS @out TABLE (ADate smalldatetime) AS
BEGIN
  WHILE @BDate <= @EDate
    BEGIN
      IF NOT ((@IncludeHolidays = 0) AND (DATEPART(dw, @BDate) IN (CASE WHEN @@DATEFIRST / 7 = 1 THEN 7 ELSE 7 - @@DATEFIRST END, 8 - @@DATEFIRST)))
        INSERT @out VALUES (@BDate)		
      SELECT @BDate = DATEADD(DAY, 1, @BDate)
    END
  RETURN	
END
GO
