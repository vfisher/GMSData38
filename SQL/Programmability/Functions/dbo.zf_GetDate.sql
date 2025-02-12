SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetDate](@Date datetime)
/* Возвращает дату без времени */
RETURNS datetime
Begin
  SET @Date = CAST(@Date AS smalldatetime)
  RETURN DATEADD(minute, - DATEPART(minute, @Date), DATEADD(hour, - DATEPART(hour, @Date), @Date))
End 
GO