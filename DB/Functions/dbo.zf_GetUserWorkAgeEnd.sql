SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetUserWorkAgeEnd](@AppPrefix char(1))
RETURNS smalldatetime AS
/* Возвращает дату окончания рабочего периода */
BEGIN
  Declare @ADate smalldatetime
  IF (SELECT dbo.zf_UserVar(@AppPrefix + '_WorkAgeOnly')) <> 0 
    SELECT @ADate = dbo.zf_UserVar(@AppPrefix + '_WorkAgeEnd')
  ELSE 
     SELECT @ADate = Cast('2079-06-06 00:00:00.000' AS smalldatetime)			
  RETURN(@ADate)   
END
GO
