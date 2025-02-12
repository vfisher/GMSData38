SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetUserWorkAgeBegin](@AppPrefix char(1))
RETURNS smalldatetime AS
/* Возвращает начальную дату рабочего периода */
BEGIN
  Declare @ADate smalldatetime
  IF (SELECT dbo.zf_UserVar(@AppPrefix + '_WorkAgeOnly')) <> 0 
    SELECT @ADate = dbo.zf_UserVar(@AppPrefix + '_WorkAgeBegin')
  ELSE 
     SELECT @ADate = Cast('1900-01-01 00:00:00.000' AS smalldatetime)			
  RETURN(@ADate)   
END
GO