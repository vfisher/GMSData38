SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_MinsToTime](@Mins int)
/* Конвертирует минуты  в формат hh:mm */
RETURNS varchar(200) 
BEGIN
  DECLARE @AHours int
  DECLARE @AMins int
  DECLARE @Result varchar(200)
  SELECT @AHours = @Mins / 60
  SELECT @AMins = @Mins - @AHours * 60
  SELECT @Result = RIGHT('00' + CAST(@AHours AS varchar(10)), 2) + ':' + RIGHT('00' + CAST(@AMins AS varchar(10)), 2)
  RETURN @Result 
END
GO