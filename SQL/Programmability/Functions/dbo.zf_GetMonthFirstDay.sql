SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetMonthFirstDay] (@BDate datetime) 
/* Возвращает дату первого дня месяца */
RETURNS datetime AS 
BEGIN  
  RETURN DATEADD(DAY, 1 - DAY(@BDate), @BDate)   
END
GO