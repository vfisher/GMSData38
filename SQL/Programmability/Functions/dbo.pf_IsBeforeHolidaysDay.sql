SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[pf_IsBeforeHolidaysDay](@Date datetime, @CheckDecWTime bit)
/* День является предпраздничным */ 
RETURNS bit AS 
BEGIN  
  RETURN ISNULL((SELECT 1 FROM r_Holidays WHERE HolidayDate = @Date + 1  AND ((@CheckDecWTime = 0) OR (@CheckDecWTime = 1 AND DecWTime = 1))),0)
END
GO